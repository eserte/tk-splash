#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: 03progress.t,v 1.1 2001/11/25 13:33:54 eserte Exp $
# Author: Slaven Rezic
#

use strict;
use vars qw($loaded $splash $top);

BEGIN { $| = 1; $^W = 0; print "1..3\n"; }
END {print "not ok 1\n" unless $loaded;}

BEGIN {
    require Tk::ProgressSplash;
    $loaded = 1;
    print "ok 1\n";
}

sub findINC
{
 my $file = join('/',@_);
 my $dir;
 $file  =~ s,::,/,g;
 foreach $dir (@INC)
  {
   my $path;
   return $path if (-e ($path = "$dir/$file"));
  }
 return undef;
}

BEGIN {
    $splash = Tk::ProgressSplash->Show(-splashtype => 'fast',
				       findINC("Tk", "Xcamel.gif"),
				       60, 60, "Splash");
    print "ok 2\n";
}

use Tk;

$splash->Update(0.1);
$top=tkinit;
$splash->Update(0.2); $top->after(300);
$top->update;
$splash->Raise;
$splash->Update(0.4); $top->after(300);
$splash->Update(0.8); $top->after(300);

$splash->Destroy;
print "ok 3\n";

$splash = Tk::ProgressSplash->Show(-splashtype => 'normal',
				   findINC("Tk", "Xcamel.gif"),
				   60, 60, "Splash");
$splash->Update(0.2); $top->after(300);
$splash->Update(0.4); $top->after(300);
$splash->Update(0.8); $top->after(300);
$splash->Destroy;

$top->update;
sleep 1;
