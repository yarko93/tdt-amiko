# These rules are smarter ;)
# rules are separated by line break
# all trailing white-spaces are ignored, use them for prettier indentation. Example:
#   megaproject
#     v2.0
#     file://hello_world.c;
# 
# double semicolon or semicolon + linebreak or double linebreak or even linebreak + semicolon
# can be used for separating packages
#
# first three rules are not exactly "rules" they are corresponding to package name, package version
# and build subdirectory.
#
# each next rule is in "command:argument" format
# for example
#   extract:http://someserver.com/pacakge-2.1.tar.gz
# by the way, extract is the default command, so you can type just
#   http://someserver.com/pacakge-2.1.tar.gz
# if you want only to copy a file to the build directory use
#   nothing:http://someserver/logo.png
# other available commands are
#   dirextract - first cd to build directory, than extract
#   patch - apply as patch
#   rpmbuild - building from rpm package
#
# install commands
#  install -.* - install file and pass (.*) arguments to install
#  install_file - install with -m644
#  install_bin - install with -m755
# destination file is the last argument
# for example
#  install_bin:ftp://megaupload.com/superscript.sh:/bin/script.sh
#
# these are most common tasks, see smart-rules.pl for details and feel free to add more..
# However, some special rules is better to write directly to .mk file
#
# To make rules quite you can use two special words, {PN} and {PV} which refers to package name and version.
# Note: in {PN} all "_" symbols replaced with "-"
#
# Now consider sources that are supported:
#  http:// - http wget download
#  ftp:// - ftp wget download
#  file:// - look for file in Patches directory
#  git://www.gitserver.com/gitrepo:r=revision:b=branch:sub=subdir_in_git_tree:protocol=http
#   revision, branch and subdirectory to use (arguments are optional).
#   and protocol which git should use. (replaces 'git://' while fetch)
#   use protocol=ssh to replace "git://" with "git@"
#  svn://www.svnserver.com/svnrepo:r=revision
#   only revision option
#
# if rule command doesn't match ones listed above, this is treated as install/uninstall rule.
# 
# below you can see mew lirc rule, which replaces corresponding entries in rules-make, rules-install and rules-archive
# It is much less complicated !
# lirc
#   0.9.0
#   {PN}-{PV}
#   extract:http://prdownloads.sourceforge.net/lirc/{PN}-{PV}.tar.gz
#   patch:file://{PN}-{PV}-try_first_last_remote.diff
#   make:install:DESTDIR=TARGETS
#   rewrite-libtool:TARGETS/usr/lib/liblirc_client.la
# ;
#
# Using smart-rules is optional, but smart-rules.pl generates macroses to make downloading, patching etc. tasks a bit easier.
# You can find the output of smart-rules.pl script in cdk/ruledir directory.
# These files are imported to Makefile after running ./configure (runs automaticaly).
#
# So for example for udpxy you'll have:
#   @DIR_ntpclient@ directory where sources are extracted (buid dir)
#   @DEPENDS_ntpclient@ is list of all files to built package from.
#     Place into target depends, so changing one of them invokes rebuild.
#   @PREPARE_ntpclient@ rules for download, extract and patch files above.
#   SOURCES_udpxy list of files above. Used later in package Control file.
#   VERSION_udpxy Used later in package Control file too.
#   AUTOPKGV_udpxy If there is svn or git repo in rules, this command will be generated and you can run it
#     to eval PKGV_udpxy based on git date or svn revision.
#   @INSTALL_udpxy@ command could be 'make install' and commands to copy other files to PKDIR.
BEGIN[[

ntpclient
  #second param is version
  2007_365
  #third is buid dir
  {PN}-2007
  #sources goes below
  http://doolittle.icarus.com/ntpclient/{PN}_{PV}.tar.gz
  nothing:file://{PN}-init.file
;

udpxy
  1.0.23-0
  {PN}-{PV}
  http://sourceforge.net/projects/udpxy/files/udpxy/Chipmunk-1.0/udpxy.{PV}-prod.tar.gz
  #for patch -p0 use the following
  patch-0:file://udpxy-makefile.patch
;

#opkg-host
opkg_host
  0.1.8
  {PN}
  dirextract:http://opkg.googlecode.com/files/opkg-{PV}.tar.gz
;
if ENABLE_P0207
linux
  2.6.32.28_stm24_0207
  linux-sh4-2.6.32.28_stm24_0207
  nothing:ftp://ftp.stlinux.com/pub/stlinux/2.4/updates/SRPMS/stlinux24-host-kernel-source-sh4-2.6.32.28_stm24_0207-207.src.rpm
;
endif
if ENABLE_P0209
linux
  2.6.32.46_stm24_0209
  linux-sh4-2.6.32.46_stm24_0209
  nothing:ftp://ftp.stlinux.com/pub/stlinux/2.4/updates/SRPMS/stlinux24-host-kernel-source-sh4-2.6.32.46_stm24_0209-209.src.rpm
;
endif
if ENABLE_P0210
linux
  2.6.32.57_stm24_0210
  linux-sh4-2.6.32.57_stm24_0210
  nothing:ftp://ftp.stlinux.com/pub/stlinux/2.4/updates/SRPMS/stlinux24-host-kernel-source-sh4-2.6.32.57_stm24_0210-210.src.rpm
;
endif
if ENABLE_P0211
linux
  2.6.32.59_stm24_0211
  linux-sh4-2.6.32.59_stm24_0211
  nothing:ftp://ftp.stlinux.com/pub/stlinux/2.4/updates/SRPMS/stlinux24-host-kernel-source-sh4-2.6.32.59_stm24_0211-211.src.rpm
;
endif

squashfs
  3.0
  mk{PN}
  pdircreate:mk{PN}
  extract:http://heanet.dl.sourceforge.net/sourceforge/sevenzip/lzma442.tar.bz2
  patch:file://lzma_zlib-stream.diff
  extract:http://heanet.dl.sourceforge.net/sourceforge/{PN}/{PN}{PV}.tar.gz
  patch:file://mk{PN}_lzma.diff
;
squashfs
  4.0
  mk{PN}
  pdircreate:mk{PN}
  extract:http://heanet.dl.sourceforge.net/sourceforge/sevenzip/lzma465.tar.bz2
  extract:http://heanet.dl.sourceforge.net/sourceforge/{PN}/{PN}{PV}.tar.gz
  patch:file://{PN}-tools-{PV}-lzma.patch
;
ccache
  2.4
  {PN}-{PV}
  extract:http://samba.org/ftp/{PN}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=HOST
;
cramfs
  1.1
  {PN}-{PV}
  extract:http://heanet.dl.sourceforge.net/sourceforge/{PN}/{PN}-{PV}.tar.gz
  install:mk{PN}:HOST/bin
;
ipkg_utils
  050831
  {PN}-{PV}
  extract:ftp://ftp.gwdg.de/linux/handhelds/packages/{PN}/{PN}-{PV}.tar.gz
  patch:file://{PN}.diff
  make:install
;
ipkg_host
  0.99.163
  {PN}
  dirextract:ftp://ftp.gwdg.de/linux/handhelds/packages/ipkg/ipkg-{PV}.tar.gz
  patch:file://{PN}.diff
;
if ENABLE_PY27
host_python
  2.7.3
  {PN}-{PV}
  extract:http://www.python.org/ftp/python/{PV}/Python-{PV}.tar.bz2
  pmove:Python-{PV}:{PN}-{PV}
  patch:file://python_{PV}.diff
  patch:file://python_{PV}-ctypes-libffi-fix-configure.diff
  patch:file://python_{PV}-pgettext.diff
else
host_python
  2.6.6
  {PN}-{PV}
  extract:http://www.python.org/ftp/python/{PV}/Python-{PV}.tar.bz2
  pmove:Python-{PV}:{PN}-{PV}
  patch:file://python_{PV}.diff
  patch:file://python_{PV}-ctypes-libffi-fix-configure.diff
  patch:file://python_{PV}-pgettext.diff
endif
;
libtool
  2.4.2
  {PN}-2.4.2
  extract:http://ftp.gnu.org/gnu/{PN}/{PN}-{PV}.tar.gz
  patch:file://{PN}-{PV}-duckbox-branding.patch
  make:install
;
busybox
  1.20.2
  {PN}-{PV}
  extract:http://www.{PN}.net/downloads/{PN}-{PV}.tar.bz2
  patch:file://{PN}-{PV}-kernel_ver.patch
  patch:file://{PN}-{PV}-ntpd.patch
  patch:file://{PN}-{PV}-pkg-config-selinux.patch
  patch:file://{PN}-{PV}-sys-resource.patch
  make:install:CONFIG_PREFIX=PKDIR
;
lsb
  3.2-28
  {PN}-3.2
  extract:http://www.emdebian.org/locale/pool/main/l/lsb/{PN}_{PV}.tar.gz
  install:-d:PKDIR/lib/{PN}
  install:-m644:init-functions:PKDIR/lib/{PN}
;
ipkg
  0.99.163
  {PN}-{PV}
  extract:ftp.gwdg.de/linux/handhelds/packages/{PN}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=TARGETS
;
module_init_tools
  3.16
  {PN}-{PV}
  extract:http://ftp.be.debian.org/pub/linux/utils/kernel/{PN}/{PN}-{PV}.tar.bz2
  patch:file://module-init-tools-no-man.patch
  make:INSTALL=install:install:sbin_PROGRAMS="depmod modinfo":bin_PROGRAMS=:mandir=/usr/share/man:DESTDIR=TARGETS
;
sysvinit
  2.86
  {PN}-{PV}
  extract:ftp://ftp.cistron.nl/pub/people/miquels/{PN}/{PN}-{PV}.tar.gz
  nothing:http://ftp.de.debian.org/debian/pool/main/s/{PN}/{PN}_{PV}.ds1-38.diff.gz
;
bzip2
  1.0.6
  {PN}-{PV}
  extract:http://www.bzip.org/{PV}/{PN}-{PV}.tar.gz
  patch:file://{PN}.diff
  make:install:PREFIX=PKDIR/usr
;
grep
  2.5.1
  {PN}-{PV}
  extract:ftp://mirrors.kernel.org/gnu/{PN}/{PN}-{PV}.tar.bz2
  nothing:http://64studio.hivelocity.net/apt/pool/main/g/{PN}/{PN}_{PV}.ds2-6.diff.gz
  make:install:DESTDIR=PKDIR
;
openrdate
  1.1.2
  {PN}-{PV}
  extract:http://downloads.sourceforge.net/project/openrdate/openrdate/{PN}-{PV}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
e2fsprogs
  1.42.4
  {PN}-{PV}
  extract:http://prdownloads.sourceforge.net/{PN}/{PN}-{PV}.tar.gz
  patch:file://{PN}-{PV}.patch
  make:install:DESTDIR=PKDIR
;
xfsprogs
  2.9.4-1
  {PN}-2.9.4
  extract:http://pkgs.fedoraproject.org/repo/pkgs/xfsprogs/xfsprogs_2.9.4-1.tar.gz/174683e3b86b587ed59823fdbbb96ea4/{PN}_{PV}.tar.gz
  patch:file://{PN}.diff
  make:install:prefix=/usr:DESTDIR=PKDIR
;
mc
  4.8.1.6
  {PN}-{PV}
  extract:http://www.midnight-commander.org/downloads/{PN}-{PV}.tar.bz2
#nothing:file://{PN}.diff
  make:install:DESTDIR=PKDIR
;
sdparm
  1.07
  {PN}-{PV}
  extract:http://sg.danny.cz/sg/p/{PN}-{PV}.tgz
  make:install:DESTDIR=PKDIR
;
sg3_utils
  1.24
  sg3_utils-{PV}
  extract:http://sg.torque.net/sg/p/sg3_utils-{PV}.tgz
  patch:file://sg3_utils.diff
  make:install:DESTDIR=TARGETS
;
console_data
  1.03
  {PN}-{PV}
  extract:ftp://ftp.debian.org/debian/pool/main/c/{PN}/{PN}_{PV}.orig.tar.gz
  make:install
;
nano
  2.0.6
  {PN}-{PV}
  extract:http://www.{PN}-editor.org/dist/v2.0/{PN}-{PV}.tar.gz
  make:install:DESTDIR=TARGETS
;
rsync
  2.6.9
  {PN}-{PV}
  extract:http://samba.anu.edu.au/ftp/{PN}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=TARGETS
;
ntfs_3g
  2012.1.15
  ntfs-3g_ntfsprogs-{PV}
  extract:http://tuxera.com/opensource/ntfs-3g_ntfsprogs-{PV}.tgz
  make:install:DESTDIR=PKDIR
;
lm_sensors
  2.9.2
  lm_sensors-{PV}
  extract:http://dl.{PN}.org/{PN}/releases/lm_sensors-{PV}.tar.gz
  make:user_install:MACHINE=sh:PREFIX=/usr:MANDIR=/usr/share/man:DESTDIR=PKDIR
;
fuse
  2.9.0
  {PN}-{PV}
  extract:http://dfn.dl.sourceforge.net/sourceforge/{PN}/{PN}-{PV}.tar.gz
  patch:file://{PN}.diff
  make:install:DESTDIR=PKDIR
;
curlftpfs
  0.9.2
  {PN}-{PV}
  extract:http://sourceforge.net/projects/{PN}/files/latest/download/{PN}-{PV}.tar.gz
  make:install:DESTDIR=TARGETS
;
fbset
  2.1
  {PN}-{PV}
  extract:http://ftp.de.debian.org/debian/pool/main/f/{PN}/{PN}_{PV}.orig.tar.gz
  patch:http://archive.debian.org/debian/dists/potato/main/source/admin/{PN}_{PV}-6.diff.gz
  patch:file://{PN}_{PV}-fb.modes-ST.patch
  install:-d:-m755:TARGETS/{usr/sbin,etc}
  install:-m755:{PN}:TARGETS/usr/sbin
  install:-m755:con2fbmap:TARGETS/usr/sbin
  install:-m644:etc/fb.modes.ATI:TARGETS/etc/fb.modes
;
util_linux
  2.12r
  {PN}-{PV}
  extract:ftp://debian.lcs.mit.edu/pub/linux/utils/{PN}/v2.12/{PN}-{PV}.tar.bz2
  patch:file://{PN}_{PV}-12.deb.diff.gz
  nothing:file://{PN}-stm.diff
;
pngquant
  1.1
  {PN}-{PV}
  extract:ftp://ftp.simplesystems.org/pub/libpng/png/applications/{PN}/{PN}-{PV}-src.tgz
  install:-m755:{PN}:TARGETS/usr/bin
;
mplayer
  1.0
  {PN}-export-*
  extract:ftp://ftp.{PN}hq.hu/MPlayer/releases/{PN}-export-snapshot.tar.bz2
  make:install INSTALLSTRIP="":DESTDIR=TARGETS
;
mencoder
  1.0
  mplayer-export-*
  extract:ftp://ftp.mplayerhq.hu/MPlayer/releases/mplayer-export-snapshot.tar.bz2
  make:install INSTALLSTRIP="":DESTDIR=TARGETS
;
jfsutils
  1.1.15
  {PN}-{PV}
  extract:http://jfs.sourceforge.net/project/pub/{PN}-{PV}.tar.gz
  make:install:mandir=/usr/share/man:DESTDIR=PKDIR
;
opkg
  0.1.8
  {PN}-{PV}
  extract:http://{PN}.googlecode.com/files/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
  link:/usr/bin/{PN}-cl:PKDIR/usr/bin/{PN}
;
pppd
  2.4.5
  ppp-{PV}
  extract:ftp://ftp.samba.org/pub/ppp/ppp-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
usb_modeswitch
  1.2.5
  {PN}-{PV}
  extract:http://www.draisberghof.de/usb_modeswitch/{PN}-{PV}.tar.bz2
  patch:file://{PN}.patch
  make:install:DESTDIR=PKDIR
;
usb_modeswitch_data
  20121109
  {PN}-{PV}
  extract:http://www.draisberghof.de/usb_modeswitch/{PN}-{PV}.tar.bz2
  patch:file://{PN}.patch
  make:install:DESTDIR=PKDIR
;
sysstat
  10.0.4
  {PN}-{PV}
  extract:http://pagesperso-orange.fr/sebastien.godard/{PN}-{PV}.tar.gz
  make:install:DESTDIR=TARGETS
;
hotplug_e2
  git
  {PN}-helper
  git://openpli.git.sourceforge.net/gitroot/openpli/hotplug-e2-helper
  patch:file://hotplug-e2-helper-support_fw_upload.patch
  make:install:prefix=/usr:DESTDIR=PKDIR
;
autofs
  4.1.4
  {PN}-{PV}
  extract:http://kernel.org/pub/linux/daemons/{PN}/v4/{PN}-{PV}.tar.gz
  patch:file://{PN}-{PV}-misc-fixes.patch
  patch:file://{PN}-{PV}-multi-parse-fix.patch
  patch:file://{PN}-{PV}-non-replicated-ping.patch
  patch:file://{PN}-{PV}-locking-fix-1.patch
  patch:file://{PN}-{PV}-cross.patch
  patch:file://{PN}-{PV}-Makefile.rules-cross.patch
  patch:file://{PN}-{PV}-install.patch
  patch:file://{PN}-{PV}-auto.net-sort-option-fix.patch
  patch:file://{PN}-{PV}-{PN}-additional-distros.patch
  patch:file://{PN}-{PV}-no-bash.patch
  patch:file://{PN}-{PV}-{PN}-add-hotplug.patch
  patch:file://{PN}-{PV}-no_man.patch
  make:install:INSTALLROOT=PKDIR
;
imagemagick
  6.8.0-4
  ImageMagick-{PV}
  extract:ftp://ftp.fifi.org/pub/ImageMagick/ImageMagick-{PV}.tar.bz2
  make:install:prefix=/usr:DESTDIR=PKDIR
;
ncurses
  5.5
  {PN}-{PV}
  extract:http://ftp.gnu.org/pub/gnu/{PN}/{PN}-{PV}.tar.gz
  
;
openssl
  1.0.1c
  {PN}-{PV}
  extract:ftp://ftp.{PN}.org/source/{PN}-{PV}.tar.gz
;
directfb
  1.4.11
  DirectFB-{PV}
  extract:http://{PN}.org/downloads/Core/DirectFB-1.4/DirectFB-{PV}.tar.gz
  patch:file://{PN}-{PV}+STM2010.12.15-4.diff
  patch:file://{PN}-{PV}+STM2010.12.15-4.no-vt.diff
  patch:file://{PN}-libpng.diff
  patch:file://{PN}-{PV}+STM2010.12.15-4.enigma2remote.diff
  make:install:DESTDIR=PKDIR:LD=sh4-linux-ld
;
dfbpp
  1.0.0
  DFB++-{PV}
  extract:http://www.directfb.org/downloads/Extras/DFB++-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
libstgles
  1.0
  {PN}-{PV}
  plink:../apps/misc/tools/{PN}:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
dvbdata
  0.6
  {PN}-{PV}
  extract:file://{PN}-{PV}.tar.gz
;
rfkill
  git
  {PN}-{PV}
  nothing:git://git.sipsolutions.net/rfkill.git
  make:install:DESTDIR=PKDIR
;
enigma2_networkbrowser
  git
  {PN}-{PV}
  nothing:git://openpli.git.sourceforge.net/gitroot/openpli/plugins-enigma2:sub=networkbrowser
  patch:file://{PN}-support_autofs.patch
  make:install:DESTDIR=PKDIR
;
enigma2_openwebif
  git
  e2openplugin-OpenWebif
  nothing:git://github.com/schpuntik/e2openplugin-OpenWebif.git
  make:install:DESTDIR=PKDIR
;
devinit
  0.1
  {PN}-{PV}
  plink:../apps/misc/tools/{PN}:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
evremote2
  0.1
  {PN}-{PV}
  plink:../apps/misc/tools/{PN}:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
fp_control
  0.1
  {PN}-{PV}
  plink:../apps/misc/tools/fp_control:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
gitVCInfo
  0.1
  {PN}-{PV}
  plink:../apps/misc/tools/{PN}:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
hotplug
  0.1
  {PN}-{PV}
  plink:../apps/misc/tools/{PN}:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
libeplayer3
  0.1
  {PN}-{PV}
  plink:../apps/misc/tools/{PN}:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
eplayer4
  0.1
  {PN}-{PV}
  plink:../apps/misc/tools/{PN}:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
libmme_host
  0.1
  {PN}-{PV}
  plink:../apps/misc/tools/libmme_host:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
libmmeimage
  0.1
  {PN}-{PV}
  plink:../apps/misc/tools/{PN}:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
showiframe
  0.1
  {PN}-{PV}
  plink:../apps/misc/tools/{PN}:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
stfbcontrol
  0.1
  {PN}-{PV}
  plink:../apps/misc/tools/{PN}:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
streamproxy
  0.1
  {PN}-{PV}
  plink:../apps/misc/tools/{PN}:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
ustslave
  0.1
  {PN}-{PV}
  plink:../apps/misc/tools/{PN}:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
portmap
  6.0
  {PN}_{PV}
  extract:http://fossies.org/unix/misc/{PN}-{PV}.tgz
  patch:file://{PN}_{PV}.diff
  nothing:http://debian.osuosl.org/debian/pool/main/p/{PN}/{PN}_{PV}.0-2.diff.gz
  make:install:BASEDIR=PKDIR
  install:-m755:debian/init.d:PKDIR/etc/init.d/{PN}
;
nfs_utils
  1.1.1
  {PN}-{PV}
  extract:ftp://ftp.piotrkosoft.net/pub/mirrors/ftp.kernel.org/linux/utils/nfs/{PN}-{PV}.tar.bz2
  patch:file://{PN}_{PV}-12.diff.gz
  make:install:DESTDIR=PKDIR
  install:-m644:debian/nfs-common.default:PKDIR/etc/default/nfs-common
  install:-m755:debian/nfs-common.init:PKDIR/etc/init.d/nfs-common
  install:-m644:debian/nfs-kernel-server.default:PKDIR/etc/default/nfs-kernel-server
  install:-m755:debian/nfs-kernel-server.init:PKDIR/etc/init.d/nfs-kernel-server
  install:-m644:debian/etc.exports:PKDIR/etc/exports
  remove:PKDIR/sbin/mount.nfs4:PKDIR/sbin/umount.nfs4
;
vsftpd
  3.0.2
  {PN}-{PV}
  extract:http://fossies.org/unix/misc/{PN}-{PV}.tar.gz
  patch:file://{PN}_{PV}.diff
  nothing:file://../root/release/vsftpd
  nothing:file://../root/etc/vsftpd.conf
  pmove:{PN}-{PV}/vsftpd:{PN}-{PV}/vsftpd.initscript
  make:install:PREFIX=PKDIR
  install:-m644:vsftpd.conf:PKDIR/etc
  install:-m755 -D:vsftpd.initscript:PKDIR/etc/init.d/vsftpd
;
netkit_ftp
  0.17
  {PN}-{PV}
  extract:http://ibiblio.org/pub/linux/system/network/netkit//{PN}-{PV}.tar.gz
#patch:file://{PN}.diff
  make:install:MANDIR=/usr/share/man:INSTALLROOT=TARGETS
;
samba
  3.6.10
  {PN}-{PV}
  extract:http://www.{PN}.org/{PN}/ftp/stable/{PN}-{PV}.tar.gz
  patch:file://{PN}-{PV}.diff
  make:install bin/smbd bin/nmbd:DESTDIR=PKDIR:prefix=./.
;
netio
  1.26
  {PN}126
  extract:http://bnsmb.de/files/public/windows/{PN}126.zip
  install:-m755:{PN}:PKDIR/usr/bin
  install:-m755:bin/linux-i386:HOST/bin/{PN}
;
lighttpd
  1.4.15
  {PN}-{PV}
  extract:http://www.{PN}.net/download/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
zd1211
  2_15_0_0
  ZD1211LnxDrv_2_15_0_0
  extract:http://www.lutec.eu/treiber/{PN}lnxdrv_2_15_0_0.tar.gz
  patch:file://{PN}.diff
;
wireless_tools
  29
  wireless_tools.{PV}
  extract:http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.{PV}.tar.gz
  make:install:INSTALL_MAN=PKDIR/usr/share/man:PREFIX=PKDIR/usr
;
wpa_supplicant
  1.0
  wpa_supplicant-{PV}
  extract:http://hostap.epitest.fi/releases/wpa_supplicant-{PV}.tar.gz
  nothing:file://wpa_supplicant.config
  make:install:DESTDIR=PKDIR:LIBDIR=/usr/lib:BINDIR=/usr/sbin
;
ethtool
  6
  {PN}-{PV}
  extract:http://downloads.openwrt.org/sources/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
init_scripts
  0.6
  {PN}-{PV}
  pdircreate:{PN}-{PV}
  nothing:file://../root/etc/inittab
  nothing:file://../root/release/hostname
  nothing:file://../root/release/inetd
# for 'nothing:' only 'cp' is executed so '*' is ok.
  nothing:file://../root/release/initmodules_*
  nothing:file://../root/release/halt_*
  nothing:file://../root/release/mountall
  nothing:file://../root/release/mountsysfs
  nothing:file://../root/release/networking
  nothing:file://../root/release/rc
  nothing:file://../root/release/reboot
  nothing:file://../root/release/sendsigs
  nothing:file://../root/release/telnetd
  nothing:file://../root/release/syslogd
  nothing:file://../root/release/crond
  nothing:file://../root/release/umountfs
  nothing:file://../root/release/lircd
;
  init_scripts_xbmc
  0.1
  {PN}-{PV}
  pdircreate:{PN}-{PV}
  nothing:file://../root/etc/inittab_xbmc
  nothing:file://../root/release/hostname
  nothing:file://../root/release/inetd
# for 'nothing:' only 'cp' is executed so '*' is ok.
  nothing:file://../root/release/initmodules_*
  nothing:file://../root/release/halt_*
  nothing:file://../root/release/mountall
  nothing:file://../root/release/mountsysfs
  nothing:file://../root/release/networking
  nothing:file://../root/release/rc
  nothing:file://../root/release/reboot
  nothing:file://../root/release/sendsigs
  nothing:file://../root/release/telnetd
  nothing:file://../root/release/syslogd
  nothing:file://../root/release/umountfs
  nothing:file://../root/release/lircd
;
e2plugin
  git
  {PN}
  git://github.com/schpuntik/enigma2-plugins-sh4.git
;
e2skin
  git
  {PN}
  git://github.com/schpuntik/enigma2-skins-sh4.git:b=master
;
modem_scripts
  0.3
  {PN}-{PV}
  pdircreate:{PN}-{PV}
  nothing:file://../root/etc/ppp/ip-*
  nothing:file://../root/usr/bin/modem.sh
  nothing:file://../root/usr/bin/modemctrl.sh
  nothing:file://../root/etc/modem.conf
  nothing:file://../root/etc/modem.list
  nothing:file://../root/etc/55-modem.rules
  nothing:file://../root/etc/30-modemswitcher.rules
;
grab
  git
  {PN}-{PV}
  git://github.com/technic/aio-grab.git
  make:install:DESTDIR=PKDIR
;
enigma2_plugin_cams_oscam
  svn
  {PN}-{PV}
  svn://www.streamboard.tv/svn/oscam/trunk/
  make:install:DESTDIR=PKDIR:OSCAM_BIN = OSCAM_BIN
;
parted
  3.1
  {PN}-{PV}
  extract:http://ftp.gnu.org/gnu/{PN}/{PN}-{PV}.tar.xz
  patch:file://{PN}_{PV}.patch
  make:install:DESTDIR=PKDIR
;
gettext
  0.18
  {PN}-{PV}
  extract:ftp://ftp.gnu.org/gnu/{PN}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
udev_rules
  0.2
  {PN}-{PV}
  pdircreate:{PN}-{PV}
  nothing:file://../root/etc/60-dvb-ca.rules
  nothing:file://../root/etc/90-cec_aotom.rules
;
enigma2_pli
  git
  $(appsdir)/{PN}-nightly

if ENABLE_E2PD0
  git://openpli.git.sourceforge.net/gitroot/openpli/enigma2:r=945aeb939308b3652b56bc6c577853369d54a537
  patch:file://enigma2-pli-nightly.0.diff
endif

if ENABLE_E2PD1
  git://openpli.git.sourceforge.net/gitroot/openpli/enigma2:r=945aeb939308b3652b56bc6c577853369d54a537
  patch:file://enigma2-pli-nightly.1.diff
  patch:file://enigma2-pli-nightly.1.gstreamer.diff
  patch:file://enigma2-pli-nightly.1.graphlcd.diff
endif

if ENABLE_E2PD2
  git://openpli.git.sourceforge.net/gitroot/openpli/enigma2:r=839e96b79600aba73f743fd39628f32bc1628f4c
  patch:file://enigma2-pli-nightly.2.diff
  patch:file://enigma2-pli-nightly.2.graphlcd.diff
endif

if ENABLE_E2PD3
  git://openpli.git.sourceforge.net/gitroot/openpli/enigma2:r=51a7b9349070830b5c75feddc52e97a1109e381e
  patch:file://enigma2-pli-nightly.3.diff
endif

if ENABLE_E2PD4
  git://openpli.git.sourceforge.net/gitroot/openpli/enigma2:r=002b85aa8350e9d8e88f75af48c3eb8a6cdfb880
  patch:file://enigma2-pli-nightly.4.diff
endif

if ENABLE_E2PD5
  git://github.com:schpuntik/enigma2-pli.git;b=master;protocol=ssh
endif

if ENABLE_E2PD6
    git://github.com/technic/amiko-e2-pli.git:b=testing
endif

if ENABLE_E2PD7
  git://github.com/technic/amiko-e2-pli.git:b=last
endif

if ENABLE_E2PD8
  git://github.com/technic/amiko-e2-pli.git:b=master
endif
;
enigma2
  git
  $(appsdir)/{PN}-nightly
if ENABLE_E2D0
  git://gitorious.org/open-duckbox-project-sh4/guigit.git:r=945aeb939308b3652b56bc6c577853369d54a537
  patch:file://enigma2-nightly.0.diff
  patch:file://enigma2-nightly.0.eplayer3.diff
  patch:file://enigma2-nightly.0.gstreamer.diff
  patch:file://enigma2-nightly.0.graphlcd.diff
endif

if ENABLE_E2D1
  git://gitorious.org/open-duckbox-project-sh4/guigit.git:r=945aeb939308b3652b56bc6c577853369d54a537
  patch:file://enigma2-nightly.1.diff
endif

if ENABLE_E2D2
  git://gitorious.org/open-duckbox-project-sh4/guigit.git:r=839e96b79600aba73f743fd39628f32bc1628f4c
  patch:file://enigma2-nightly.2.diff
  patch:file://enigma2-nightly.2.gstreamer.diff
  patch:file://enigma2-nightly.2.graphlcd.diff
endif

if ENABLE_E2D3
  git://gitorious.org/open-duckbox-project-sh4/guigit.git:r=51a7b9349070830b5c75feddc52e97a1109e381e
  patch:file://enigma2-nightly.3.diff
  patch:file://enigma2-nightly.3.gstreamer.diff
  patch:file://enigma2-nightly.3.graphlcd.diff
endif

if ENABLE_E2D4
  git://gitorious.org/open-duckbox-project-sh4/guigit.git:r=002b85aa8350e9d8e88f75af48c3eb8a6cdfb880
  patch:file://enigma2-pli-nightly.4.diff
endif

if ENABLE_E2D5
  git://openpli.git.sourceforge.net/gitroot/openpli/enigma2:r=a869076762f6e24305d6a58f95c3918e02a1442a
  patch:file://enigma2-pli-nightly.5.diff
endif

if ENABLE_E2D6
  git://openpli.git.sourceforge.net/gitroot/openpli/enigma2:r=388dcd814d4e99720cb9a6c769611be4951e4ad4
  patch:file://enigma2-pli-nightly.6.diff
endif

if ENABLE_E2D7
  git://code.google.com/p/enigma2-dmm:protocol=https
endif

if ENABLE_E2D8
  git://gitorious.org/~schpuntik/open-duckbox-project-sh4/amiko-guigit.git:b=arp-no_gst
endif
;
xbmc_nightly
  git
  $(appsdir)/{PN}
if ENABLE_XBD0
  git://github.com/xbmc/xbmc.git
  patch:file://xbmc-nightly.0.diff
endif

if ENABLE_XBD1
  git://github.com/xbmc/xbmc.git:r=460e79416c5cb13010456794f36f89d49d25da75
  patch:file://xbmc-nightly.1.diff
endif

if ENABLE_XBD2
  git://github.com/xbmc/xbmc.git:r=327710767d2257dad27e3885effba1d49d4557f0
  patch:file://xbmc-nightly.2.diff
endif

if ENABLE_XBD3
  git://github.com/xbmc/xbmc.git:r=12840c28d8fbfd71c26be798ff6b13828b05b168
  patch:file://xbmc-nightly.3.diff
endif

if ENABLE_XBD4
  git://github.com/xbmc/xbmc.git:r=e292b1147bd89a7e53742e3e5039b9a906a3b1d0
  patch:file://xbmc-nightly.4.diff
endif
;
]]END
