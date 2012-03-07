PARENT_PK =

PACKAGE_PARAMS_LIST := PKGV PKGR DESCRIPTION SECTION PRIORITY MAINTAINER LICENSE PACKAGE_ARCH HOMEPAGE RDEPENDS RREPLACES RCONFLICTS SRC_URI FILES NAME preinst postinst prerm postrm PACKAGES

EXPORT_ALLENV = $(shell echo '$(.VARIABLES)' | awk -v RS=' ' '/^[a-zA-Z0-9_]+$$/')
EXPORT_ENV = $(filter PARENT_PK, $(EXPORT_ALLENV))
EXPORT_ENV += $(filter $(addsuffix _%, $(PACKAGE_PARAMS_LIST)), $(EXPORT_ALLENV))
export $(EXPORT_ENV)

packagingtmpdir := $(buildprefix)/packagingtmpdir
PKDIR := $(packagingtmpdir)

export packagingtmpdir

define extra_build
	python split_packages.py
	$(call do_build_pkg,none)
endef

define toimage_build
	python split_packages.py
	$(call do_build_pkg,install)
endef

define do_build_pkg
	for pkg in `ls $(ipkgbuilddir)`; do \
		ipkg-build -o root -g root $(ipkgbuilddir)/$$pkg $(ipkprefix) |tee tmpname \
		$(if $(filter install,$(1)), && \
			pkgn=`cat tmpname |perl -ne 'if (m/Packaged contents/) { print ((split / /)[-1])}'` && \
			ipkg install -f $(crossprefix)/etc/ipkg.conf $$pkgn \
		); done
endef

define start_build
	rm -rf $(PKDIR)
	rm -rf $(ipkgbuilddir)/*
	mkdir $(PKDIR)
endef

define prepare_pkginfo_for_flash
	perl -pi -e "s,$(flashprefix)/root,," $(flashprefix)/root/usr/lib/ipkg/info/*.list
endef

git_version := git log -1 --format=%cd --date=short |sed s/-//g
get_git_version = $(eval export PKGV_$(PARENT_PK) = $(shell cd $(DIR_$(PARENT_PK)) && $(git_version)))