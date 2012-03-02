#!/usr/bin/perl
use strict;
use warnings;
use IO::File;

my $version;

my $supported_protocols = "http|ftp|file";
my $make_commands = "nothing|extract|dirextract|patch(time)?(-(\\d+))?";

sub load ($$$);

sub load ($$$)
{
  my ( $filename, $package, $ignore ) = @_;

  my $fh = new IO::File $filename;

  if ( ! $fh )
  {
    return undef if $ignore;
    die "can't open $filename\n";
  }
  
  my $lines;
  while ( <$fh> )
  {
    $_ =~ s/#.*$//;
    $lines .= $_ if not $_ =~ m#^\s+$#;
  }
  my @lines = split( /\;;|\n\n|\n;|;\n/ , $lines);

  foreach ( @lines )
  {
    my @l = split ( /\n|;/ , $_ );
    chomp @l;
    my @rule;
    foreach (@l)
    {
      $_ =~ s/^\s+//; #remove leading spaces
      $_ =~ s/\s+$//; #remove trailing spaces
      push(@rule, $_) if ( $_ ne "" );
    }
    
    #print "BEGIN package\n" . join(";", @rule) . "\nEND\n";

    next if not defined $rule[0];
    return @rule if $rule[0] eq $package;

    next if not defined $rule[1];
    my @ret;
    @ret = load ( $rule[1], $package, 0 ) if $rule[0] eq ">>>";
    @ret = load ( $rule[1], $package, 1 ) if $rule[0] eq ">>?";
    return @ret if @ret;
  }

  die "can't find package $package";
}

sub process_rule($) {

  #print "parse: " . $_ . "\n";

  my $f = "";
  my $l = $_;
  my @l = split( /:/ , $l );
  
  my $cmd = shift @l;
  my $p;

  if ( $cmd =~ m#^($supported_protocols)# )
  {
    $p = $cmd;    
    $cmd = "extract";
  }
  elsif ( $cmd =~ m#^($make_commands)$# )
  {
    $p = shift @l;
  }
  
  my $q = shift @l;
  #print "test $q \n";
  if ( $q !~ m#^//.*# )
  {
    $p = "none";
  }
  
  if ( $p ne "none" )
  {
    my @a = split("/", $_);
    $f = $a[-1];
  }
      
  #print "command: $cmd protocol: $p file: $f\n";

  return ($p, $f, $cmd);
}


sub process_make_depends (@)
{
  #return "\"fu\"";
  shift;
  shift;

  my $output;

  foreach ( @_ )
  {  
    my ($p, $f) = process_rule($_);
    next if ( $p eq "none" );

    if ( $p =~ m#^(file)$# )
    {
      $output .= "Patches/" . $f . " ";
    }
    elsif ( $p =~ m#^($supported_protocols)$# )
    {
      $output .= "\\\$(archivedir)/" . $f . " ";
    }
    else
    {
      die "can't recognize protocol " . $_;
    }
  }

  return "\"$output\"";
}

sub process_make_dir (@)
{
  return $_[1];
}


sub process_make_prepare (@)
{
  shift;
  my $dir = shift;

  my $output = "( rm -rf " . $dir . " || /bin/true )";

  foreach ( @_ )
  {
    my ($p, $f, $cmd) = process_rule($_);
    local @_ = ($p, $f);

    if ( $cmd eq "nothing" || $cmd !~ m#$make_commands# )
    {
      next;
    }
    
    if ( $output ne "" )
    {
      $output .= " && ";
    }
    
    if ( $cmd eq "" || $cmd eq "extract")
    {
      if ( $_[1] =~ m#\.tar\.bz2$# )
      {
        $output .= "bunzip2 -cd \\\$(archivedir)/" . $_[1] . " | TAPE=- tar -x";
      }
      elsif ( $_[1] =~ m#\.tar\.gz$# )
      {
        $output .= "gunzip -cd \\\$(archivedir)/" . $_[1] . " | TAPE=- tar -x";
      }
      elsif ( $_[1] =~ m#\.tgz$# )
      {
        $output .= "gunzip -cd \\\$(archivedir)/" . $_[1] . " | TAPE=- tar -x";
      }
      elsif ( $_[1] =~ m#\.exe$# )
      {
        $output .= "cabextract \\\$(archivedir)/" . $_[1];
      }
      elsif ( $_[1] =~ m#\.zip$# )
      {
        $output .= "unzip -d $_[2] \\\$(archivedir)/" . $_[1];
      }
      elsif ( $_[1] =~ m#\.src\.rpm$# )
      {
        $output .= "rpm \${DRPM} -Uhv  \\\$(archivedir)/" . $_[1];
      }
      elsif ( $_[1] =~ m#\.cvs$# )
      {
        $_[1] =~ s/\.cvs//;
        $output .= "cp -a \\\$(archivedir)/" . $_[1] . " . && mv " . $_[1] . " " . $dir;
      }
      else
      {
        warn "can't recognize type of archive " . $_[1] . " skip";
        $output .= "true";
      }
    }
    elsif ( $cmd eq "dirextract" )
    {
      $output .= "( mkdir " . $dir . " || /bin/true ) && ";
      $output .= "( cd " . $dir . "; ";

      if ( $_[1] =~ m#\.tar\.bz2$# )
      {
        $output .= "bunzip2 -cd \\\$(archivedir)/" . $_[1] . " | tar -x";
      }
      elsif ( $_[1] =~ m#\.tar\.gz$# )
      {
        $output .= "gunzip -cd \\\$(archivedir)/" . $_[1] . " | tar -x";
      }
      elsif ( $_[1] =~ m#\.exe$# )
      {
        $output .= "cabextract \\\$(archivedir)/" . $_[1];
      }
      else
      {
        die "can't recognize type of archive " . $_[1];
      }

      $output .= " )";
    }
    elsif ( $cmd =~ m/patch(time)?(-(\d+))?/ )
    {
      $_ = "-p1 ";
      $_ = "-p$3 " if defined $3;
      $_ .= "-Z " if defined $1;
      if ( $_[1] =~ m#\.bz2$# )
      {
        $output .= "( cd " . $dir . "; bunzip2 -cd \\\$(archivedir)/" . $_[1] . " | patch $_ )";
      }
      elsif ( $_[1] =~ m#\.deb\.diff\.gz$# )
      {
        $output .= "( cd " . $dir . "; gunzip -cd ../Patches/" . $_[1] . " | patch $_ )";
      }
      elsif ( $_[1] =~ m#\.gz$# )
      {
        $output .= "( cd " . $dir . "; gunzip -cd \\\$(archivedir)/" . $_[1] . " | patch $_ )";
      }
      elsif ( $_[1] =~ m#\.spec\.diff$# )
      {
        $output .= "( cd SPECS && patch $_ < ../Patches/" . $_[1] . " )";
      }
      else
      {
        $output .= "( cd " . $dir . "; patch $_ < ../Patches/" . $_[1] . " )";
      }
    }
    elsif ( $cmd eq "rpmbuild" )
    {
      $output .= "rpmbuild \${DRPMBUILD} -bb -v --clean --target=sh4-linux SPECS/stm-" . $f . ".spec ";
    }
#     elsif ( $cmd eq "move" )
#     {
#       $output .= "mv " . $_[1] . " " . $_[2];
#     }
#     elsif ( $cmd eq "remove" )
#     {
#       $output .= "( rm -rf " . $_[1] . " || /bin/true )";
#     }
#     elsif ( $cmd eq "link" )
#     {
#       $output .= "( ln -sf " . $_[1] . " " . $_[2] . " || /bin/true )";
#     }
#     elsif ( $cmd eq "dircreate" )
#     {
#       $output .= "( mkdir -p $dir )";
#     }
    else
    {
      die "can't recognize command @_";
    }
  }

  return "\"$output\"";
}

sub process_make_version (@)
{
  $version = $_[0];
  return $_[0];
}

sub process_make ($$$)
{
  my $package = $_[0];
  my @rules = @{$_[1]};
  my $arg = @{$_[2]}[0];
  my $output = "";

  my %args =
  (
    depends => \&process_make_depends,
    dir => \&process_make_dir,
    prepare => \&process_make_prepare,
    version => \&process_make_version,
    sources => \&process_make_sources,
  );

  if ( $arg eq "cdkoutput" )
  {
    foreach ( sort keys %args )
    {
      ( my $tmp = $_ ) =~ y/a-z/A-Z/;
      $output .= $tmp . "_" . $package . "=" . &{$args{$_}} (@rules) . "\n";
    }
  }
  else
  {
    die "can't recognize $arg" if not $args{$arg};

    $output = &{$args{$arg}} (@rules);
  }

  return $output;
}

sub process_install_rule ($)
{
  
  my $rule = shift;
  my ($p, $f, $cmd) = process_rule($rule);
  
  if ( $cmd =~ m#$make_commands# )
  {
    return "";
  }

  @_ = split ( /:/, $rule );
  $_ = shift @_;

  my $output = "";

  if ( $_ eq "make" )
  {
    $output .= "\$\(MAKE\) " . join " ", @_;
  }
  elsif ( $_ eq "install" )
  {
    $output .= "\$\(INSTALL\) " . join " ", @_;
  }
  elsif ( $_ eq "rpminstall" )
  {
    $output .= "rpm \${DRPM} --ignorearch -Uhv RPMS/sh4/" . join " ", @_;
  }
  elsif ( $_ eq "shellconfigadd" )
  {
    $output .= "export HCTDINST \&\& HOST/bin/target-shellconfig --add " . join " ", @_;
  }
  elsif ( $_ eq "initdconfigadd" )
  {
    $output .= "export HCTDINST \&\& HOST/bin/target-initdconfig --add " . join " ", @_;
  }
  elsif ( $_ eq "move" )
  {
    $output .= "mv " . join " ", @_;
  }
  elsif ( $_ eq "remove" )
  {
    $output .= "rm -rf " . join " ", @_;
  }
  elsif ( $_ eq "mkdir" )
  {
    $output .= "mkdir -p " . join " ", @_;
  }
  elsif ( $_ eq "link" )
  {
    $output .= "ln -sf " . join " ", @_;
  }
  elsif ( $_ eq "archive" )
  {
    $output .= "TARGETNAME-ar cru " . join " ", @_;
  }
  elsif ( $_ =~ m/^rewrite-(libtool|pkgconfig|dependency)/ )
  {
    $output .= "perl -pi -e \"s,^libdir=.*\$\$,libdir='TARGET/usr/lib',\" ". join " ", @_ if $1 eq "libtool";
    $output .= "perl -pi -e \"s, /usr/lib, TARGET/usr/lib,g if /^dependency_libs/\"  ". join " ", @_ if $1 eq "dependency";
    $output .= "perl -pi -e \"s,^prefix=.*\$\$,prefix=TARGET/usr,\" " . join " ", @_ if $1 eq "pkgconfig";
  }
  else
  {
    die "can't recognize rule \"$rule\"";
  }

  return $output;
}

sub process_uninstall_rule ($)
{
  my $rule = shift;
  my ($p, $f, $cmd) = process_rule($rule);
  
  if ( $cmd =~ m#$make_commands# )
  {
    return "";
  }

  @_ = split ( /:/, $rule );
  $_ = shift @_;

  my $output = "";

  if ( $_ eq "make" )
  {
    $output .= "\$\(MAKE\) " . join " ", @_;
  }
  elsif ( $_ eq "install" )
  {
    $output .= "\$\(INSTALL\) " . join " ", @_;
  }
  elsif ( $_ eq "rpminstall" )
  {
    $output .= "rpm \${DRPM} --ignorearch -Uhv RPMS/sh4/" . join " ", @_;
  }
  elsif ( $_ eq "shellconfigdel" )
  {
    $output .= "export HCTDUNINST \&\& HOST/bin/target-shellconfig --del " . join " ", @_;
  }
  elsif ( $_ eq "initdconfigdel" )
  {
    $output .= "export HCTDUNINST \&\& HOST/bin/target-initdconfig --del " . join " ", @_;
  }
  elsif ( $_ eq "move" )
  {
    $output .= "mv " . join " ", @_;
  }
  elsif ( $_ eq "remove" )
  {
    $output .= "rm -rf " . join " ", @_;
  }
  elsif ( $_ eq "link" )
  {
    $output .= "ln -sf " . join " ", @_;
  }
  elsif ( $_ eq "archive" )
  {
    $output .= "TARGETNAME-ar cru " . join " ", @_;
  }
  elsif ( $_ =~ m/^rewrite-(libtool|pkgconfig)/ )
  {
    $output .= "perl -pi -e \"s,^libdir=.*\$\$,libdir='TARGET/lib',\"  ". join " ", @_ if $1 eq "libtool";
    $output .= "perl -pi -e \"s,^prefix=.*\$\$,prefix=TARGET,\" " . join " ", @_ if $1 eq "pkgconfig";
  }
  else
  {
    die "can't recognize rule \"$rule\"";
  }

  return $output;
}

sub process_install ($$$)
{
  my @rules = @{$_[1]};
  my $output = "";
  shift @rules;
  shift @rules;

  foreach ( @rules )
  {
    $output .= " && " if $output;
    $output .= process_install_rule ($_);
  }

  return $output;
}

sub process_uninstall ($$$)
{
  my @rules = @{$_[1]};
  my $output = "";
  shift @rules;
  shift @rules;

  foreach ( @rules )
  {
    $output .= " && " if $output;
    $output .= process_uninstall_rule ($_);
  }

  return $output;
}

sub process_make_sources ($$$)
{
  shift;
  shift;
  my $output = "";
  
  foreach ( @_ )
  {
    my ($p, $f, $cmd) = process_rule($_);
    next if ( $p eq "none" );
    $_ =~ s/$cmd:// if ($cmd ne "");
    $output .= $_ . " ";
  }
  return "\"$output\""
}

sub process_download ($$$)
{
  local @_ = @{$_[1]};
  process_make_version (@_);

  my $head;
  my $output;

  shift @_;
  shift @_;
  foreach ( @_ )
  {
    my ($p, $f, $cmd) = process_rule($_);
    next if ( $p eq "file" || $p eq "none" );
    
    $_ =~ s/$cmd:// if ($cmd ne "");
    
    #print "download: " . $_ . "\n";
    
    $head .= " \$(archivedir)/" . $f;
    $output .= " \$(archivedir)/" . $f . ":\n\tfalse";

    if ( $_ =~ m#^ftp://# )
    {
      $output .= " || \\\n\twget -c --passive-ftp -P \$(archivedir) " . $_;
    }
    elsif ( $_ =~ m#^http://# )
    {
      $output .= " || \\\n\twget -c -P \$(archivedir) " . $_;
    }
#     elsif ( $_ =~ m#^CMD_CVS # )
#     {
#       $output .= " || \\\n\tcd \$(archivedir) && " . $_;
#       my $cvsstring = $_;
#       $cvsstring =~ s/ co / up /;
#       $outputupdate .= "\$(archivedir)" . $file . "up:\n\tfalse";
#       $outputupdate .= " || \\\n\tcd \$(archivedir) && " . $cvsstring;
#     }
    if ( $f =~ m/gz$/ )
    {
      $output .= " || \\\n\twget -c -P \$(archivedir) ftp://ftp.stlinux.com/pub/stlinux/2.0/ST_Linux_2.0/RPM_Distribution/sh4-target-glibc-packages/" . $f;
      $output .= "\n\t\@touch \$\@";
    }
  #   elsif ( $file =~ m/cvs$/ )
  #   {
  #     $output .= " || \\\n\twget -c ftp://xxx.com/pub/tufsbox/cdk/src/" . $file;
  #     $filerep =~ s/\.cvs//;
  #     $output .= "\n\t\@touch -r \$(archivedir) " . $filerep . "/CVS \$\@";
  #     $outputupdate .= "\n\t\@touch -r \$(archivedir) " . $filerep . "/CVS \$\(subst cvsup,cvs,\$\@\)";
  #     $outputupdate .= "\n\n";
  #   }
    else
    {
      $output .= " || \\\n\twget -c -P \$(archivedir) http://tuxbox.berlios.de/pub/tuxbox/cdk/src/" . $f;
      $output .= "\n\t\@touch \$\@";
    }
    $output .= "\n\n";
  }
  return "$output"

}

# $output =~ s#CMD_CVS#\$\(CMD_CVS\)#g;
# $outputupdate =~ s#CMD_CVS#\$\(CMD_CVS\)#g;
# 
# print $head . "\n\n" . $output . "\n\n" . $outputupdate . "\n";


my %ruletypes =
(
  make => { process => \&process_make, further_args => 1 },
  download => { process => \&process_download },
  install => { process => \&process_install },
  uninstall => { process => \&process_uninstall },
);

die "please specify a rule type, filename and a package" if $#ARGV < 2;

my $ruletype = shift;
my $filename = shift;
my $package = shift;

die "can't determine rule type" if not $ruletypes{$ruletype};
die "rule type needs further args" if $ruletypes{$ruletype}->{further_args} and $#ARGV + 1 < $ruletypes{$ruletype}->{further_args};

my @rules = load ( $filename, $package, 0 );
shift @rules;

my $output = &{$ruletypes{$ruletype}->{process}} ($package, \@rules, \@ARGV);

if ( $output )
{
  $output =~ s#TARGETNAME#\$\(target\)#g;
  $output =~ s#TARGETS#\$\(prefix\)\/\$\*cdkroot#g;
  $output =~ s#TARGET#\$\(targetprefix\)#g;
  $output =~ s#HCTDINST#HHL\_CROSS\_TARGET\_DIR\=\$\(prefix\)\/\$\*cdkroot#g;
  $output =~ s#HCTDUNINST#HHL\_CROSS\_TARGET\_DIR\=\$\(targetprefix\)#g;
  $output =~ s#HOST#\$\(hostprefix\)#g;
  $output =~ s#BUILD#\$\(buildprefix\)#g;
  $output =~ s#\{PV\}#$version#g;
  my $dashpackage = $package;
  $dashpackage =~ s#_#\-#g;
  $output =~ s#\{PN\}#$dashpackage#g;
  print $output . "\n";
}

