PARENT_PK =

PACKAGE_PARAMS_LIST := PKGV PKGR DESCRIPTION SECTION PRIORITY MAINTAINER LICENSE PACKAGE_ARCH HOMEPAGE RDEPENDS RREPLACES RCONFLICTS SRC_URI FILES NAME preinst postinst prerm postrm PACKAGES

EXPORT_ALLENV = $(shell echo '$(.VARIABLES)' | awk -v RS=' ' '/^[a-zA-Z0-9_]+$$/')
EXPORT_ENV = $(filter PARENT_PK, $(EXPORT_ALLENV))
EXPORT_ENV += $(filter $(addsuffix _%, $(PACKAGE_PARAMS_LIST)), $(EXPORT_ALLENV))
export $(EXPORT_ENV)

packagingtmpdir := $(buildprefix)/packagingtmpdir
PKDIR := $(packagingtmpdir)

export packagingtmpdir

ipkcdk := $(prefix)/ipkcdk

$(ipkcdk):
	$(INSTALL) -d $@

define extra_build
	rm -rf $(ipkgbuilddir)/*
	python split_packages.py
	$(call do_build_pkg,none,flash)
endef

define toflash_build
	rm -rf $(ipkgbuilddir)/*
	python split_packages.py
	$(call do_build_pkg,install,flash)
endef

define tocdk_build
	rm -rf $(ipkgbuilddir)/*
	export FILES_$(PARENT_PK)="/"; \
	python split_packages.py
	$(call do_build_pkg,install,cdk)
endef

define do_build_pkg
	for pkg in `ls $(ipkgbuilddir)`; do \
		ipkg-build -o root -g root $(ipkgbuilddir)/$$pkg $(if $(filter cdk,$(2)),$(ipkcdk),$(ipkprefix)) |tee tmpname \
		$(if $(filter install,$(1)), && \
			pkgn=`cat tmpname |perl -ne 'if (m/Packaged contents/) { print ((split / /)[-1])}'` && \
			opkg install -f $(crossprefix)/etc/opkg$(if $(filter cdk,$(2)),-cdk).conf $$pkgn \
		); done
#FIXME: too frequent invokes
	$(if $(filter flash,$(2)),
		$(prepare_pkginfo_for_flash),
		$(rewrite_libtool)
		$(rewrite_pkgconfig)
	)
endef

define start_build
	rm -rf $(PKDIR)
	mkdir $(PKDIR)
endef

define prepare_pkginfo_for_flash
	perl -pi -e "s,$(flashprefix)/root,," $(flashprefix)/root/usr/lib/opkg/info/*.list
endef

define rewrite_libtool
	 find $(PKDIR) -name "*.la" -type f -exec perl -pi -e "s,^libdir=.*$$,libdir='$(targetprefix)/usr/lib'," {} \;
endef

define rewrite_pkgconfig
	 find $(PKDIR) -name "*.pc" -type f -exec perl -pi -e "s,^prefix=.*$$,prefix=$(targetprefix)/usr," {} \;
endef



git_version := git log -1 --format=%cd --date=short |sed s/-//g
get_git_version = $(eval export PKGV_$(PARENT_PK) = $(shell cd $(DIR_$(PARENT_PK)) && $(git_version)))