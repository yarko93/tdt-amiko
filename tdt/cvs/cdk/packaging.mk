PARENT_PK = ''

PACKAGE_PARAMS_LIST := PKGV PKGR DESCRIPTION SECTION PRIORITY MAINTAINER LICENSE PACKAGE_ARCH HOMEPAGE RDEPENDS RREPLACES RCONFLICTS SRC_URI FILES NAME preinst postinst prerm postrm PACKAGES

EXPORT_ALLENV = $(shell echo '$(.VARIABLES)' | awk -v RS=' ' '/^[a-zA-Z0-9_]+$$/')
EXPORT_ENV = $(filter PARENT_PK, $(EXPORT_ALLENV))
EXPORT_ENV += $(filter $(addsuffix _%, $(PACKAGE_PARAMS_LIST)), $(EXPORT_ALLENV))
export $(EXPORT_ENV)

packagingtmpdir := $(buildprefix)/packagingtmpdir
ipkgbuilddir := $(buildprefix)/ipkgbuild
PKDIR := $(packagingtmpdir)

export packagingtmpdir
export ipkgbuilddir
IPKGBUILDDIR := $(ipkgbuilddir)
export IPKGBUILDDIR

ipkcdk := $(prefix)/ipkcdk
ipkprefix := $(prefix)/ipkbox

$(ipkcdk):
	$(INSTALL) -d $@

$(ipkprefix):
	$(INSTALL) -d $@

define extra_build
	rm -rf $(ipkgbuilddir)/*
	$(flash_prebuild)
	python split_packages.py
	$(call do_build_pkg,none,flash)
endef

define toflash_build
	rm -rf $(ipkgbuilddir)/*
	$(flash_prebuild)
	python split_packages.py
	$(call do_build_pkg,install,flash)
endef

define tocdk_build 
	rm -rf $(ipkgbuilddir)/*
	export FILES_$(PARENT_PK)="/" && \
	python split_packages.py
	$(rewrite_libtool)
	$(rewrite_pkgconfig)
	$(rewrite_dependency)
	$(call do_build_pkg,install,cdk)
endef

flash_ipkg_args = -f $(crossprefix)/etc/opkg.conf -o $(prefix)/release
cdk_ipkg_args = -f $(crossprefix)/etc/opkg-cdk.conf -o $(targetprefix)

define do_build_pkg
	@echo
	@echo "====> do_build_pkg $(1) $(2)"
	for pkg in `ls $(ipkgbuilddir)`; do \
		ipkg-build -o root -g root $(ipkgbuilddir)/$$pkg $(if $(filter cdk,$(2)),$(ipkcdk),$(ipkprefix)) |tee tmpname \
		$(if $(filter install,$(1)), && \
			pkgn=`cat tmpname |perl -ne 'if (m/Packaged contents/) { print ((split / /)[-1])}'` && \
			opkg install $(if $(filter cdk,$(2)),$(cdk_ipkg_args),$(flash_ipkg_args)) $$pkgn \
		); done
endef

define start_build
	@echo
	@echo "====> checking for PARENT_PK variable"
	$(eval $(if $(filter '',$(PARENT_PK)), $@: PARENT_PK = $(subst -,_,$(notdir $@))))
	$(eval export PARENT_PK)
	@echo "====> start_build $(PARENT_PK)"
	rm -rf $(PKDIR)
	mkdir $(PKDIR)
endef

define flash_prebuild
	$(remove_libs)
	$(remove_pkgconfigs)
	$(remove_includedir)
endef

define remove_libs
	rm -f $(PKDIR)/lib/*.{a,la}
	rm -f $(PKDIR)/usr/lib/*.{a,la}
endef

define remove_pkgconfigs
	rm -rf $(PKDIR)/usr/lib/pkgconfig
endef

define remove_includedir
	rm -rf $(PKDIR)/usr/include
endef


define prepare_pkginfo_for_flash
	export OPKG_OFFLINE_ROOT=$(flashprefix)/root/ \
	for i in $(flashprefix)/root/usr/lib/opkg/info/*.preinst; do \
		if [ -f $i ] && ! sh $i; then \
			opkg-cl $(flash_ipkg_args) flag unpacked `basename $i .preinst` \
		fi \
	done \
	for i in $(flashprefix)/root/usr/lib/opkg/info/*.postinst; do \
		if [ -f $i ] && ! sh $i configure; then \
			opkg-cl $(flash_ipkg_args) flag unpacked `basename $i .postinst` \
		fi \
	done
endef

define rewrite_libtool
	 find $(ipkgbuilddir)/* -name "*.la" -type f -exec perl -pi -e "s,^libdir=.*$$,libdir='$(targetprefix)/usr/lib'," {} \;
endef

define rewrite_pkgconfig
	 find $(ipkgbuilddir)/* -name "*.pc" -type f -exec perl -pi -e "s,^prefix=.*$$,prefix=$(targetprefix)/usr," {} \;
endef

define rewrite_dependency
	find $(ipkgbuilddir)/* -name "*.la" -type f -exec \
		perl -pi -e "s, /usr/lib, $(targetprefix)/usr/lib,g if /^dependency_libs/" {} \;
endef

define parent_pk
	$(eval $@: PARENT_PK = $1)
endef

git_version := git log -1 --format=%cd --date=short |sed s/-//g
get_git_version = $(eval export PKGV_$(PARENT_PK) = $(shell cd $(DIR_$(PARENT_PK)) && $(git_version)))