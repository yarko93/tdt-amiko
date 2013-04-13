#
# INIT-SCRIPTS customized
#

DESCRIPTION_init_scripts_vdr = init scripts and rules for system start
init_scripts_initd_vdr_files = \
halt \
hostname \
inetd \
initmodules \
mountall \
mountsysfs \
networking \
reboot \
sendsigs \
telnetd \
syslogd \
lircd \
umountfs

define postinst_init_scripts_vdr
#!/bin/sh
$(foreach f,$(init_scripts_initd_vdr_files), initdconfig --add $f
)
endef

define prerm_init_scripts_vdr
#!/bin/sh
$(foreach f,$(init_scripts_initd_vdr_files), initdconfig --del $f
)
endef

$(DEPDIR)/init-scripts-vdr: $(DEPENDS_init_scripts_vdr)
	$(PREPARE_init_scripts_vdr)
	$(start_build)
	$(INSTALL_DIR) $(PKDIR)/etc/init.d

# select initmodules
	cd $(DIR_init_scripts_vdr) && \
	mv initmodules$(if $(SPARK),_vdr_$(SPARK))$(if $(SPARK7162),_vdr_$(SPARK7162))$(if $(HL101),_vdr_$(HL101)) initmodules
# select halt
	cd $(DIR_init_scripts_vdr) && \
	mv halt$(if $(HL101),_$(HL101))$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162)) halt
# init.d scripts
	cd $(DIR_init_scripts_vdr) && \
		$(INSTALL) inittab_vdr $(PKDIR)/etc/inittab && \
		$(INSTALL) -m 755 rc $(PKDIR)/etc/init.d/rc && \
		$(foreach f,$(init_scripts_initd_vdr_files), $(INSTALL) -m 755 $f $(PKDIR)/etc/init.d && ) true
	$(toflash_build)
	touch $@

release_vdr_spark:
	echo "spark" > $(prefix)/release/etc/hostname && \
	echo "src/gz AR-P http://alien.sat-universum.de" | cat - $(prefix)/release/etc/opkg/official-feed.conf > $(prefix)/release/etc/opkg/official-feed && \
	mv $(prefix)/release/etc/opkg/official-feed $(prefix)/release/etc/opkg/official-feed.conf && \
	cp $(buildprefix)/root/firmware/component_7111_mb618.fw $(prefix)/release/lib/firmware/component.fw
release_vdr_spark7162:
	echo "spark7162" > $(prefix)/release/etc/hostname && \
	echo "src/gz AR-P http://alien2.sat-universum.de" | cat - $(prefix)/release/etc/opkg/official-feed.conf > $(prefix)/release/etc/opkg/official-feed && \
	mv -f $(prefix)/release/etc/opkg/official-feed $(prefix)/release/etc/opkg/official-feed.conf
	cp $(buildprefix)/root/firmware/component_7105_pdk7105.fw $(prefix)/release/lib/firmware/component.fw
	rm -f $(prefix)/release/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7106.ko

release_vdr_hl101:
	echo "hl101" > $(prefix)/release/etc/hostname && \
	cp -f $(buildprefix)/root/release/fstab_hl101 $(prefix)/release/etc/fstab
	cp $(buildprefix)/root/firmware/dvb-fe-avl2108.fw $(prefix)/release/lib/firmware/ && \
	cp $(buildprefix)/root/firmware/dvb-fe-stv6306.fw $(prefix)/release/lib/firmware/


# The main target depends on the model.
# IMPORTANT: it is assumed that only one variable is set. Otherwise the target name won't be resolved.
#
$(DEPDIR)/release_vdr: $(DEPDIR)/%release_vdr:release_base release_common_utils release_$(HL101)$(SPARK)$(SPARK7162)
# Post tweaks
	depmod -b $(prefix)/release $(KERNELVERSION)
	touch $@

release-vdr_clean:
	rm -f $(DEPDIR)/release_vdr
	rm -f $(DEPDIR)/release_vdr_base
	rm -f $(DEPDIR)/release_vdr_$(HL101)$(SPARK)$(SPARK7162)
	rm -f $(DEPDIR)/release_vdr_common_utils 
