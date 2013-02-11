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

#opkg-host
#ipkg_host
#  0.99.163
#  {PN}
#  dirextract:ftp://ftp.gwdg.de/linux/handhelds/packages/ipkg/ipkg-{PV}.tar.gz
#  patch:file://{PN}.diff
#;
#ncurses
#  5.5
#  {PN}-{PV}
#  extract:http://ftp.gnu.org/pub/gnu/{PN}/{PN}-{PV}.tar.gz
#;
#dvbdata
# 0.6
#  {PN}-{PV}
#  extract:file://{PN}-{PV}.tar.gz
#;
  git://code.google.com/p/taapat-plugins:protocol=https
#  git://github.com/schpuntik/enigma2-plugins-sh4.git
  git://bitbucket.org:Taapat/enigma2-pli-arp.git;b=master;protocol=ssh
#  git://github.com/technic/amiko-e2-pli.git:b=last
]]END
