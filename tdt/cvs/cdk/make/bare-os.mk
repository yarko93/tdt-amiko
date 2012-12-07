#
# FILESYSTEM
#
$(DEPDIR)/min-filesystem $(DEPDIR)/std-filesystem $(DEPDIR)/max-filesystem \
$(DEPDIR)/filesystem: \
$(DEPDIR)/%filesystem: bootstrap-cross
	$(INSTALL) -d $(targetprefix)/{bin,boot,dev,dev.static,etc,home,lib,mnt,opt,proc,root,sbin,sys,tmp,usr,var}
	$(INSTALL) -d $(targetprefix)/etc/{default,opt}
	$(INSTALL) -d $(targetprefix)/usr/{bin,include,lib,local,sbin,share,src}
	$(INSTALL) -d $(targetprefix)/usr/lib/X11
	$(INSTALL) -d $(targetprefix)/usr/local/{bin,include,lib,man,sbin,share,src}
	$(INSTALL) -d $(targetprefix)/usr/local/man/{man1,man2,man3,man4,man5,man6,man7,man8}
	$(INSTALL) -d $(targetprefix)/usr/share/{aclocal,doc,info,locale,man,misc,nls}
	$(INSTALL) -d $(targetprefix)/usr/share/man/{man0p,man1,man1p,man2,man3,man3p,man4,man5,man6,man7,man8,man9}
	$(INSTALL) -d $(targetprefix)/var/{backups,cache,lib,local,lock,log,mail,opt,run,spool}
	ln -sf $(targetprefix)/lib $(targetprefix)/lib64
	ln -sf $(targetprefix)/usr/lib $(targetprefix)/usr/lib64
	$(INSTALL) -d $(targetprefix)/var/lib/misc
	$(INSTALL) -d $(targetprefix)/var/lock/subsys
	$(INSTALL) -d $(targetprefix)/etc/{init.d,rc.d,samba}
	$(INSTALL) -d $(targetprefix)/etc/rc.d/{rc3.d,rcS.d}
	ln -s ../init.d $(targetprefix)/etc/rc.d/init.d
	$(INSTALL) -d $(targetprefix)/etc/samba/private
	$(INSTALL) -d $(targetprefix)/media
	$(INSTALL) -d $(targetprefix)/var/bin
	[ "x$*" = "x" ] && touch $@ || true

#
# GLIBC
#
GLIBC := glibc
GLIBC_DEV := glibc-dev
FILES_glibc = /lib
FILES_glibc_dev = /lib /usr/lib
GLIBC_VERSION := 2.10.2-34
GLIBC_RAWVERSION := $(firstword $(subst -, ,$(GLIBC_VERSION)))
GLIBC_SPEC := stm-target-$(GLIBC).spec
GLIBC_SPEC_PATCH :=
GLIBC_PATCHES :=
GLIBC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(GLIBC)-$(GLIBC_VERSION).sh4.rpm
GLIBC_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(GLIBC_DEV)-$(GLIBC_VERSION).sh4.rpm

$(GLIBC_RPM) $(GLIBC_DEV_RPM): \
		$(if $(GLIBC_SPEC_PATCH),Patches/$(GLIBC_SPEC_PATCH)) \
		$(if $(GLIBC_PATCHES),$(GLIBC_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(GLIBC)-$(GLIBC_VERSION).src.rpm \
		| filesystem
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(GLIBC_SPEC_PATCH),( cd SPECS && patch -p1 $(GLIBC_SPEC) < $(buildprefix)/Patches/$(GLIBC_SPEC_PATCH) ) &&) \
	$(if $(GLIBC_PATCHES),cp $(GLIBC_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/$(GLIBC_SPEC)

$(DEPDIR)/min-$(GLIBC) $(DEPDIR)/std-$(GLIBC) $(DEPDIR)/max-$(GLIBC) \
$(DEPDIR)/$(GLIBC): \
$(DEPDIR)/%$(GLIBC): $(GLIBC_RPM) | $(DEPDIR)/%filesystem
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps  -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	[ "x$*" = "x" ] && touch $@ || true

$(DEPDIR)/min-$(GLIBC_DEV) $(DEPDIR)/std-$(GLIBC_DEV) $(DEPDIR)/max-$(GLIBC_DEV) \
$(DEPDIR)/$(GLIBC_DEV): \
$(DEPDIR)/%$(GLIBC_DEV): $(DEPDIR)/%$(GLIBC) $(GLIBC_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	[ "x$*" = "x" ] && touch $@ || true

#
# BINUTILS
#
BINUTILS := binutils
BINUTILS_DEV := binutils-dev
BINUTILS_VERSION := $(if $(OLDSTM24),2.19.1-41,2.22-64)
BINUTILS_SPEC := stm-target-$(BINUTILS).spec
BINUTILS_SPEC_PATCH := $(if $(OLDSTM24),,$(BINUTILS_SPEC).$(BINUTILS_VERSION).diff)
BINUTILS_PATCHES :=
BINUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BINUTILS)-$(BINUTILS_VERSION).sh4.rpm
BINUTILS_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BINUTILS_DEV)-$(BINUTILS_VERSION).sh4.rpm

$(BINUTILS_RPM) $(BINUTILS_DEV_RPM): \
		$(if $(BINUTILS_SPEC_PATCH),Patches/$(BINUTILS_SPEC_PATCH)) \
		$(if $(BINUTILS_PATCHES),$(BINUTILS_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(BINUTILS)-$(BINUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(BINUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(BINUTILS_SPEC) < $(buildprefix)/Patches/$(BINUTILS_SPEC_PATCH) ) &&) \
	$(if $(BINUTILS_PATCHES),cp $(BINUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(BINUTILS_SPEC)

$(BINUTILS): $(BINUTILS_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

$(BINUTILS_DEV): $(BINUTILS_DEV_RPM)
	@rpm $(DRPM) --ignorearch --nodeps --noscripts -Uhv $< && \
	touch .deps/$(notdir $@)

#
# GMP
#
GMP := gmp
GMP_VERSION := 5.0.1-5
GMP_SPEC := stm-target-$(GMP).spec
GMP_SPEC_PATCH :=
GMP_PATCHES :=
GMP_RPM := RPMS/sh4/$(STLINUX)-sh4-$(GMP)-$(GMP_VERSION).sh4.rpm

$(GMP_RPM): \
		$(addprefix Patches/,$(GMP_SPEC_PATCH) $(GMP_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(GMP)-$(GMP_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(GMP_SPEC_PATCH),( cd SPECS && patch -p1 $(GMP_SPEC) < $(buildprefix)/Patches/$(GMP_SPEC_PATCH) ) &&) \
	$(if $(GMP_PATCHES),cp $(addprefix Patches/,$(GMP_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(GMP_SPEC)

$(DEPDIR)/$(GMP): $(GMP_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $(lastword $^) && \
	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/libgmp.la
	sed -i "/^dependency_libs/s|-L/usr/lib -L/lib ||" $(targetprefix)/usr/lib/libgmp.la
	$(start_build)
	$(fromrpm_build)
	touch $@

#
# MPFR
#
MPFR := mpfr
MPFR_VERSION := 3.0.0-5
MPFR_SPEC := stm-target-$(MPFR).spec
MPFR_SPEC_PATCH :=
MPFR_PATCHES :=
MPFR_RPM := RPMS/sh4/$(STLINUX)-sh4-$(MPFR)-$(MPFR_VERSION).sh4.rpm

$(MPFR_RPM): \
		$(GMP) \
		$(addprefix Patches/,$(MPFR_SPEC_PATCH) $(MPFR_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(MPFR)-$(MPFR_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(MPFR_SPEC_PATCH),( cd SPECS && patch -p1 $(MPFR_SPEC) < $(buildprefix)/Patches/$(MPFR_SPEC_PATCH) ) &&) \
	$(if $(MPFR_PATCHES),cp $(addprefix Patches/,$(MPFR_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(MPFR_SPEC)

$(DEPDIR)/$(MPFR): $(MPFR_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $(lastword $^) && \
	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/libmpfr.la
	sed -i "/^dependency_libs/s|-L/usr/lib -L/lib ||" $(targetprefix)/usr/lib/libmpfr.la
	$(start_build)
	$(fromrpm_build)
	touch .deps/$(notdir $@)

#
# MPC
#
MPC := mpc
MPC_VERSION := 0.8.2-2
MPC_SPEC := stm-target-$(MPC).spec
MPC_SPEC_PATCH := $(MPC_SPEC).$(MPC_VERSION).diff
MPC_PATCHES := stm-target-$(MPC).$(MPC_VERSION).diff
MPC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(MPC)-$(MPC_VERSION).sh4.rpm

$(MPC_RPM): \
		$(MPFR) \
		$(addprefix Patches/,$(MPC_SPEC_PATCH) $(MPC_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(MPC)-$(MPC_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(MPC_SPEC_PATCH),( cd SPECS && patch -p1 $(MPC_SPEC) < $(buildprefix)/Patches/$(MPC_SPEC_PATCH) ) &&) \
	$(if $(MPC_PATCHES),cp $(addprefix Patches/,$(MPC_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(MPC_SPEC)

$(DEPDIR)/$(MPC): $(MPC_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $(lastword $^) && \
	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/libmpc.la
	sed -i "/^dependency_libs/s|-L/usr/lib -L/lib ||" $(targetprefix)/usr/lib/libmpc.la
	$(start_build)
	$(fromrpm_build)
	touch $@

#
# LIBELF
#
LIBELF := libelf
LIBELF_VERSION := 0.8.13-1
LIBELF_SPEC := stm-target-$(LIBELF).spec
LIBELF_SPEC_PATCH :=
LIBELF_PATCHES :=
LIBELF_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBELF)-$(LIBELF_VERSION).sh4.rpm

$(LIBELF_RPM): \
		$(addprefix Patches/,$(LIBELF_SPEC_PATCH) $(LIBELF_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(LIBELF)-$(LIBELF_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(LIBELF_SPEC_PATCH),( cd SPECS && patch -p1 $(LIBELF_SPEC) < $(buildprefix)/Patches/$(LIBELF_SPEC_PATCH) ) &&) \
	$(if $(LIBELF_PATCHES),cp $(addprefix Patches/,$(LIBELF_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(LIBELF_SPEC)

$(DEPDIR)/$(LIBELF): $(LIBELF_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $(lastword $^) && \
	touch $@

#
# GCC LIBSTDC++
#
GCC := gcc
LIBSTDC := libstdc++
LIBSTDC_DEV := libstdc++-dev
FILES_libstdc++ = \
/usr/lib/*.so \
/usr/lib/*.so*
FILES_libstdc++-dev = \
/usr/lib/*.so \
/usr/lib/*.so*

LIBGCC := libgcc
GCC_VERSION := 4.5.2-82
GCC_SPEC := stm-target-$(GCC).spec
GCC_SPEC_PATCH := $(GCC_SPEC).$(GCC_VERSION).diff
GCC_PATCHES :=
GCC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(GCC)-$(GCC_VERSION).sh4.rpm
LIBSTDC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBSTDC)-$(GCC_VERSION).sh4.rpm
LIBSTDC_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBSTDC_DEV)-$(GCC_VERSION).sh4.rpm
LIBGCC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBGCC)-$(GCC_VERSION).sh4.rpm

$(GCC_RPM) $(LIBSTDC_RPM) $(LIBSTDC_DEV_RPM) $(LIBGCC_RPM): \
		$(addprefix Patches/,$(GCC_SPEC_PATCH) $(GCC_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(GCC)-$(GCC_VERSION).src.rpm \
		| $(DEPDIR)/$(GLIBC_DEV) $(MPFR) $(MPC) $(LIBELF)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(GCC_SPEC_PATCH),( cd SPECS && patch -p1 $(GCC_SPEC) < $(buildprefix)/Patches/$(GCC_SPEC_PATCH) ) &&) \
	$(if $(GCC_PATCHES),cp $(addprefix Patches/,$(GCC_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb --clean --target=sh4-linux SPECS/$(GCC_SPEC)

$(DEPDIR)/min-$(GCC) $(DEPDIR)/std-$(GCC) $(DEPDIR)/max-$(GCC) $(DEPDIR)/$(GCC): \
$(DEPDIR)/%$(GCC): $(DEPDIR)/%$(GLIBC_DEV) $(GCC_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true

$(DEPDIR)/min-$(LIBSTDC) $(DEPDIR)/std-$(LIBSTDC) $(DEPDIR)/max-$(LIBSTDC) $(DEPDIR)/$(LIBSTDC): \
$(DEPDIR)/%$(LIBSTDC): $(DEPDIR)/%$(CROSS_LIBGCC) $(LIBSTDC_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	[ "x$*" = "x" ] && touch $@ || true

$(DEPDIR)/min-$(LIBSTDC_DEV) $(DEPDIR)/std-$(LIBSTDC_DEV) $(DEPDIR)/max-$(LIBSTDC_DEV) $(DEPDIR)/$(LIBSTDC_DEV): \
$(DEPDIR)/%$(LIBSTDC_DEV): $(DEPDIR)/%$(LIBSTDC) $(LIBSTDC_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	[ "x$*" = "x" ] && touch $@ || true
	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/lib{std,sup}c++.la
	sed -i "/^dependency_libs/s|-L/usr/lib -L/lib ||" $(targetprefix)/usr/lib/lib{std,sup}c++.la

$(DEPDIR)/min-$(LIBGCC) $(DEPDIR)/std-$(LIBGCC) $(DEPDIR)/max-$(LIBGCC) $(DEPDIR)/$(LIBGCC): \
$(DEPDIR)/%$(LIBGCC): $(LIBGCC_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	[ "x$*" = "x" ] && touch $@ || true

# END OF BOOTSTRAP

#
# LIBTERMCAP
#
LIBTERMCAP := libtermcap
LIBTERMCAP_DEV := libtermcap-dev
LIBTERMCAP_DOC := libtermcap-doc
FILES_libtermcap = \
/usr/lib/*.so \
/usr/lib/*.so*
FILES_libtermcap_dev = \
/usr/lib/*.so \
/usr/lib/*.so*

LIBTERMCAP_VERSION := 2.0.8-10
LIBTERMCAP_RAWVERSION := $(firstword $(subst -, ,$(LIBTERMCAP_VERSION)))
LIBTERMCAP_SPEC := stm-target-$(LIBTERMCAP).spec
LIBTERMCAP_SPEC_PATCH :=
LIBTERMCAP_PATCHES :=
LIBTERMCAP_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBTERMCAP)-$(LIBTERMCAP_VERSION).sh4.rpm
LIBTERMCAP_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBTERMCAP_DEV)-$(LIBTERMCAP_VERSION).sh4.rpm
LIBTERMCAP_DOC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBTERMCAP_DOC)-$(LIBTERMCAP_VERSION).sh4.rpm

$(LIBTERMCAP_RPM) $(LIBTERMCAP_DEV_RPM) $(LIBTERMCAP_DOC_RPM): \
		$(if $(LIBTERMCAP_SPEC_PATCH),Patches/$(LIBTERMCAP_SPEC_PATCH)) \
		$(if $(LIBTERMCAP_PATCHES),$(LIBTERMCAP_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STM_SRC)-target-$(LIBTERMCAP)-$(LIBTERMCAP_VERSION).src.rpm \
		| $(DEPDIR)/$(GLIBC_DEV)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(LIBTERMCAP_SPEC_PATCH),( cd SPECS && patch -p1 $(LIBTERMCAP_SPEC) < $(buildprefix)/Patches/$(LIBTERMCAP_SPEC_PATCH) ) &&) \
	$(if $(LIBTERMCAP_PATCHES),cp $(LIBTERMCAP_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(LIBTERMCAP_SPEC)

$(DEPDIR)/min-$(LIBTERMCAP) $(DEPDIR)/std-$(LIBTERMCAP) $(DEPDIR)/max-$(LIBTERMCAP) \
$(DEPDIR)/$(LIBTERMCAP): \
$(DEPDIR)/%$(LIBTERMCAP): bootstrap $(LIBTERMCAP_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	ln -sf libtermcap.so.2 $(prefix)/$*cdkroot/usr/lib/libtermcap.so && \
	$(INSTALL) -m 644 $(buildprefix)/root/etc/termcap $(prefix)/$*cdkroot/etc
	$(start_build)
	$(fromrpm_build)
	[ "x$*" = "x" ] && touch $@ || true
	

$(DEPDIR)/min-$(LIBTERMCAP_DEV) $(DEPDIR)/std-$(LIBTERMCAP_DEV) $(DEPDIR)/max-$(LIBTERMCAP_DEV) \
$(DEPDIR)/$(LIBTERMCAP_DEV): \
$(DEPDIR)/%$(LIBTERMCAP_DEV): $(DEPDIR)/%$(LIBTERMCAP) $(LIBTERMCAP_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	[ "x$*" = "x" ] && touch $@ || true
	

$(DEPDIR)/min-$(LIBTERMCAP_DOC) $(DEPDIR)/std-$(LIBTERMCAP_DOC) $(DEPDIR)/max-$(LIBTERMCAP_DOC) \
$(DEPDIR)/$(LIBTERMCAP_DOC): \
$(DEPDIR)/%$(LIBTERMCAP_DOC): $(LIBTERMCAP_DOC_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true
	

#
# NCURSES
#
NCURSES := ncurses
NCURSES_BASE := ncurses-base
NCURSES_DEV := ncurses-dev
NCURSES_VERSION := 5.5-10
NCURSES_SPEC := stm-target-$(NCURSES).spec
NCURSES_SPEC_PATCH :=
NCURSES_PATCHES :=
NCURSES_RPM := RPMS/sh4/$(STLINUX)-sh4-$(NCURSES)-$(NCURSES_VERSION).sh4.rpm
NCURSES_BASE_RPM := RPMS/sh4/$(STLINUX)-sh4-$(NCURSES_BASE)-$(NCURSES_VERSION).sh4.rpm
NCURSES_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(NCURSES_DEV)-$(NCURSES_VERSION).sh4.rpm

$(DEPDIR)/ncurses.do_compile \
$(NCURSES_RPM) $(NCURSES_BASE_RPM) $(NCURSES_DEV_RPM): \
		$(if $(NCURSES_SPEC_PATCH),Patches/$(NCURSES_SPEC_PATCH)) \
		$(if $(NCURSES_PATCHES),$(NCURSES_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STM_SRC)-target-$(NCURSES)-$(NCURSES_VERSION).src.rpm \
		| $(DEPDIR)/$(LIBSTDC_DEV)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(NCURSES_SPEC_PATCH),( cd SPECS && patch -p1 $(NCURSES_SPEC) < $(buildprefix)/Patches/$(NCURSES_SPEC_PATCH) ) &&) \
	$(if $(NCURSES_PATCHES),cp $(NCURSES_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(NCURSES_SPEC)
	touch $(DEPDIR)/ncurses.do_compile

$(DEPDIR)/min-$(NCURSES_BASE) $(DEPDIR)/std-$(NCURSES_BASE) $(DEPDIR)/max-$(NCURSES_BASE) \
$(DEPDIR)/$(NCURSES_BASE): \
$(DEPDIR)/%$(NCURSES_BASE): $(NCURSES_BASE_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $<)
	[ "x$*" = "x" ] && touch $@ || true
	

$(DEPDIR)/min-$(NCURSES) $(DEPDIR)/std-$(NCURSES) $(DEPDIR)/max-$(NCURSES) \
$(DEPDIR)/$(NCURSES): \
$(DEPDIR)/%$(NCURSES): $(DEPDIR)/%$(NCURSES_BASE) $(NCURSES_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	[ "x$*" = "x" ] && touch $@ || true
	

$(DEPDIR)/min-$(NCURSES_DEV) $(DEPDIR)/std-$(NCURSES_DEV) $(DEPDIR)/max-$(NCURSES_DEV) \
$(DEPDIR)/$(NCURSES_DEV): \
$(DEPDIR)/%$(NCURSES_DEV): $(DEPDIR)/%$(NCURSES_BASE) $(NCURSES_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	[ "x$*" = "x" ] && touch $@ || true
	

#
# BASE-PASSWD
#
BASE_PASSWD := base-passwd
BASE_PASSWD_VERSION := 3.5.9-9
BASE_PASSWD_SPEC := stm-target-$(BASE_PASSWD).spec
BASE_PASSWD_SPEC_PATCH :=
BASE_PASSWD_PATCHES :=
BASE_PASSWD_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BASE_PASSWD)-$(BASE_PASSWD_VERSION).sh4.rpm

$(BASE_PASSWD_RPM): \
		$(if $(BASE_PASSWD_SPEC_PATCH),Patches/$(BASE_PASSWD_SPEC_PATCH)) \
		$(if $(BASE_PASSWD_PATCHES),$(BASE_PASSWD_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(BASE_PASSWD)-$(BASE_PASSWD_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(BASE_PASSWD_SPEC_PATCH),( cd SPECS && patch -p1 $(BASE_PASSWD_SPEC) < $(buildprefix)/Patches/$(BASE_PASSWD_SPEC_PATCH) ) &&) \
	$(if $(BASE_PASSWD_PATCHES),cp $(BASE_PASSWD_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(BASE_PASSWD_SPEC)

$(DEPDIR)/min-$(BASE_PASSWD) $(DEPDIR)/std-$(BASE_PASSWD) $(DEPDIR)/max-$(BASE_PASSWD) \
$(DEPDIR)/$(BASE_PASSWD): \
$(DEPDIR)/%$(BASE_PASSWD): $(BASE_FILES_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(BASE_PASSWD_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps  --nopost -Uhv \
		--replacepkgs --badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
		$(hostprefix)/bin/update-passwd -L -p $(prefix)/$*cdkroot/usr/share/base-passwd/passwd.master \
			-g $(prefix)/$*cdkroot/usr/share/base-passwd/group.master -P $(prefix)/$*cdkroot/etc/passwd \
			-S $(prefix)/$*cdkroot/etc/shadow -G $(prefix)/$*cdkroot/etc/group && \
	chmod 600 $(prefix)/$*cdkroot/etc/shadow && \
	( cd $(prefix)/$*cdkroot/etc && sed -e "s|/bin/bash|/bin/sh|g" -i passwd ) && \
	rm -f $(prefix)/$*cdkroot/etc/shadow
	[ "x$*" = "x" ] && touch $@ || true
	

#
# MAKEDEV
#
MAKEDEV := makedev
MAKEDEV_VERSION := 2.3.1-26
MAKEDEV_SPEC := stm-target-$(MAKEDEV).spec
MAKEDEV_SPEC_PATCH :=
MAKEDEV_PATCHES :=
MAKEDEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(MAKEDEV)-$(MAKEDEV_VERSION).sh4.rpm

$(MAKEDEV_RPM): \
		$(if $(MAKEDEV_SPEC_PATCH),Patches/$(MAKEDEV_SPEC_PATCH)) \
		$(if $(MAKEDEV_PATCHES),$(MAKEDEV_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(MAKEDEV)-$(MAKEDEV_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(MAKEDEV_SPEC_PATCH),( cd SPECS && patch -p1 $(MAKEDEV_SPEC) < $(buildprefix)/Patches/$(MAKEDEV_SPEC_PATCH) ) &&) \
	$(if $(MAKEDEV_PATCHES),cp $(MAKEDEV_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(MAKEDEV_SPEC)

$(DEPDIR)/min-$(MAKEDEV) $(DEPDIR)/std-$(MAKEDEV) $(DEPDIR)/max-$(MAKEDEV) \
$(DEPDIR)/$(MAKEDEV): \
$(DEPDIR)/%$(MAKEDEV): root/sbin/MAKEDEV $(MAKEDEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --nopost -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(INSTALL) -m 755 root/sbin/MAKEDEV $(prefix)/$*cdkroot/sbin
	[ "x$*" = "x" ] && touch $@ || true
	

#
# BASE-FILES
#
BASE_FILES := base-files
BASE_FILES_VERSION := 2.0-8
BASE_FILES_SPEC := stm-target-$(BASE_FILES).spec
BASE_FILES_SPEC_PATCH :=
BASE_FILES_PATCHES :=
BASE_FILES_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BASE_FILES)-$(BASE_FILES_VERSION).sh4.rpm

$(BASE_FILES_RPM): \
		$(if $(BASE_FILES_SPEC_PATCH),Patches/$(BASE_FILES_SPEC_PATCH)) \
		$(if $(BASE_FILES_PATCHES),$(BASE_FILES_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(BASE_FILES)-$(BASE_FILES_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(BASE_FILES_SPEC_PATCH),( cd SPECS && patch -p1 $(BASE_FILES_SPEC) < $(buildprefix)/Patches/$(BASE_FILES_SPEC_PATCH) ) &&) \
	$(if $(BASE_FILES_PATCHES),cp $(BASE_FILES_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(BASE_FILES_SPEC)

$(DEPDIR)/min-$(BASE_FILES) $(DEPDIR)/std-$(BASE_FILES) $(DEPDIR)/max-$(BASE_FILES) $(DEPDIR)/$(BASE_FILES): \
$(DEPDIR)/%$(BASE_FILES): $(BASE_FILES_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(BASE_FILES_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--replacepkgs --badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	( cd root/etc && for i in $(BASE_FILES_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done ) && \
	echo "proc          /proc               proc    defaults                        0 0" >> $(prefix)/$*cdkroot/etc/fstab && \
	echo "tmpfs         /tmp                tmpfs   defaults                        0 0" >> $(prefix)/$*cdkroot/etc/fstab && \
	[ "x$*" = "x" ] && touch $@ || true
	

#
# LIBATTR
#
LIBATTR := libattr
LIBATTR_DEV := libattr-dev
LIBATTR_VERSION := 2.4.43-4
LIBATTR_SPEC := stm-target-$(LIBATTR).spec
LIBATTR_SPEC_PATCH :=
LIBATTR_PATCHES :=

LIBATTR_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBATTR)-$(LIBATTR_VERSION).sh4.rpm
LIBATTR_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBATTR_DEV)-$(LIBATTR_VERSION).sh4.rpm

$(LIBATTR_RPM) $(LIBATTR_DEV_RPM): \
		$(if $(LIBATTR_SPEC_PATCH),Patches/$(LIBATTR_SPEC_PATCH)) \
		$(if $(LIBATTR_PATCHES),$(LIBATTR_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(LIBATTR)-$(LIBATTR_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(LIBATTR_SPEC_PATCH),( cd SPECS && patch -p1 $(LIBATTR_SPEC) < $(buildprefix)/Patches/$(LIBATTR_SPEC_PATCH) ) &&) \
	$(if $(LIBATTR_PATCHES),cp $(LIBATTR_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(LIBATTR_SPEC)

$(DEPDIR)/min-$(LIBATTR) $(DEPDIR)/std-$(LIBATTR) $(DEPDIR)/max-$(LIBATTR) $(DEPDIR)/$(LIBATTR): \
$(DEPDIR)/%$(LIBATTR): $(LIBATTR_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	[ "x$*" = "x" ] && touch $@ || true
	

$(DEPDIR)/min-$(LIBATTR_DEV) $(DEPDIR)/std-$(LIBATTR_DEV) $(DEPDIR)/max-$(LIBATTR_DEV) $(DEPDIR)/$(LIBATTR_DEV): \
$(DEPDIR)/%$(LIBATTR_DEV): $(LIBATTR_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
#	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/libattr.la
#	sed -i "/^dependency_libs/s|-L/usr/lib -L/lib ||" $(targetprefix)/usr/lib/libattr.la
	$(REWRITE_LIBDIR)/libattr.la
	[ "x$*" = "x" ] && touch $@ || true
	


#
# LIBACL
#
LIBACL := libacl
LIBACL_DEV := libacl-dev
LIBACL_VERSION := 2.2.47-3
LIBACL_SPEC := stm-target-$(LIBACL).spec
LIBACL_SPEC_PATCH :=
LIBACL_PATCHES :=

LIBACL_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBACL)-$(LIBACL_VERSION).sh4.rpm
LIBACL_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBACL_DEV)-$(LIBACL_VERSION).sh4.rpm

$(LIBACL_RPM) $(LIBACL_DEV_RPM): \
		libattr libattr-dev \
		$(if $(LIBACL_SPEC_PATCH),Patches/$(LIBACL_SPEC_PATCH)) \
		$(if $(LIBACL_PATCHES),$(LIBACL_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(LIBACL)-$(LIBACL_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(LIBACL_SPEC_PATCH),( cd SPECS && patch -p1 $(LIBACL_SPEC) < $(buildprefix)/Patches/$(LIBACL_SPEC_PATCH) ) &&) \
	$(if $(LIBACL_PATCHES),cp $(LIBACL_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(LIBACL_SPEC)

$(DEPDIR)/min-$(LIBACL) $(DEPDIR)/std-$(LIBACL) $(DEPDIR)/max-$(LIBACL) $(DEPDIR)/$(LIBACL): \
$(DEPDIR)/%$(LIBACL): $(LIBACL_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true
	$(start_build)
	$(fromrpm_build)
	

$(DEPDIR)/min-$(LIBACL_DEV) $(DEPDIR)/std-$(LIBACL_DEV) $(DEPDIR)/max-$(LIBACL_DEV) $(DEPDIR)/$(LIBACL_DEV): \
$(DEPDIR)/%$(LIBACL_DEV): $(LIBACL_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(REWRITE_LIBDIR)/libacl.la
	$(REWRITE_LIBDEP)/libacl.la
	[ "x$*" = "x" ] && touch $@ || true
	


#
# USBUTILS
#
USBUTILS := usbutils
USBUTILS_VERSION := 0.86-10
USBUTILS_SPEC := stm-target-$(USBUTILS).spec
USBUTILS_SPEC_PATCH :=
USBUTILS_PATCHES :=
USBUTILS_usbutils = libusb
USBUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(USBUTILS)-$(USBUTILS_VERSION).sh4.rpm

$(USBUTILS_RPM): \
		$(if $(USBUTILS_SPEC_PATCH),Patches/$(USBUTILS_SPEC_PATCH)) \
		$(if $(USBUTILS_PATCHES),$(USBUTILS_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(USBUTILS)-$(USBUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(USBUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(USBUTILS_SPEC) < $(buildprefix)/Patches/$(USBUTILS_SPEC_PATCH) ) &&) \
	$(if $(USBUTILS_PATCHES),cp $(USBUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(USBUTILS_SPEC)

$(DEPDIR)/min-$(USBUTILS) $(DEPDIR)/std-$(USBUTILS) $(DEPDIR)/max-$(USBUTILS) $(DEPDIR)/$(USBUTILS): \
$(DEPDIR)/%$(USBUTILS): $(USBUTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true
	

#
# UDEV
#
UDEV := udev
UDEV_DEV := udev-dev
UDEV_VERSION := 162-32
PKGR_udev := r0
UDEV_SPEC := stm-target-$(UDEV).spec
UDEV_SPEC_PATCH := stm-target-udev.spec.diff
UDEV_PATCHES := usbhd-automount.rules
UDEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(UDEV)-$(UDEV_VERSION).sh4.rpm
UDEV_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(UDEV_DEV)-$(UDEV_VERSION).sh4.rpm

RDEPENDS_udev := libattr libacl

$(UDEV_RPM) $(UDEV_DEV_RPM): \
		glib2 libacl libacl-dev libusb usbutils \
		$(if $(UDEV_SPEC_PATCH),Patches/$(UDEV_SPEC_PATCH)) \
		$(if $(UDEV_PATCHES),$(UDEV_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(UDEV)-$(UDEV_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(UDEV_SPEC_PATCH),( cd SPECS && patch -p1 $(UDEV_SPEC) < $(buildprefix)/Patches/$(UDEV_SPEC_PATCH) ) &&) \
	$(if $(UDEV_PATCHES),cp $(UDEV_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(UDEV_SPEC)

$(DEPDIR)/min-$(UDEV_DEV) $(DEPDIR)/std-$(UDEV_DEV) $(DEPDIR)/max-$(UDEV_DEV) $(DEPDIR)/$(UDEV_DEV): \
$(DEPDIR)/%$(UDEV_DEV): $(UDEV_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true
	$(REWRITE_LIBDEP)/libgudev-1.0.la
	

$(DEPDIR)/min-$(UDEV) $(DEPDIR)/std-$(UDEV) $(DEPDIR)/max-$(UDEV) $(DEPDIR)/$(UDEV): \
$(DEPDIR)/%$(UDEV): @DEPENDS_udev@ $(UDEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in sysfs udev ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true )
	$(start_build)
	$(fromrpm_get)
# start udevadm earlier
	sed -i 's/# chkconfig: S 99 0/# chkconfig: S 6 0/' $(PKDIR)/etc/init.d/udevadm
	@INSTALL_udev@
	$(toflash_build)
	[ "x$*" = "x" ] && touch $@ || true
	
