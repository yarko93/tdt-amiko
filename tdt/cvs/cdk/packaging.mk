PARENT_PK =

PACKAGE_PARAMS_LIST := PKGV PKGR DESCRIPTION SECTION PRIORITY MAINTAINER LICENSE PACKAGE_ARCH HOMEPAGE RDEPENDS RREPLACES RCONFLICTS SRC_URI FILES NAME PACKAGES

EXPORT_ALLENV = $(shell echo '$(.VARIABLES)' | awk -v RS=' ' '/^[a-zA-Z0-9_]+$$/')
EXPORT_ENV = $(filter PARENT_PK, $(EXPORT_ALLENV))
EXPORT_ENV += $(filter $(addsuffix _%, $(PACKAGE_PARAMS_LIST)), $(EXPORT_ALLENV))
export $(EXPORT_ENV)

packagingtmpdir := $(buildprefix)/packagingtmpdir
PKDIR := $(packagingtmpdir)

export packagingtmpdir