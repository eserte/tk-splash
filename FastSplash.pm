# -*- perl -*-

#
# $Id: FastSplash.pm,v 1.8 2001/11/25 13:35:00 eserte Exp $
# Author: Slaven Rezic
#
# Copyright (C) 1999 Slaven Rezic. All rights reserved.
# This package is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# Mail: eserte@cs.tu-berlin.de
# WWW:  http://user.cs.tu-berlin.de/~eserte/
#

package Tk::FastSplash;
#use strict;
$VERSION = 0.07;
$TK_VERSION = 800 if !defined $TK_VERSION;

sub Show {
    my($pkg,
       $image_file, $image_width, $image_height, $title, $override) = @_;
    $title = $0 if !defined $title;
    my $splash_screen = {};
    eval {
	package Tk;
	require DynaLoader;
	eval q{ require Tk::Event };
	@ISA = qw(DynaLoader);
	bootstrap Tk;
	sub TranslateFileName { $_[0] }
	sub SplitString { split /\s+/, $_[0] } # rough approximation

	package Tk::Photo;
	@ISA = qw(DynaLoader);
	bootstrap Tk::Photo;

	package Tk::FastSplash;
	sub _Destroyed { }
	$splash_screen = Tk::MainWindow::Create(".", $title);
	bless $splash_screen, Tk::MainWindow;
	$splash_screen->{"Exists"} = 1;

	if ($override) {
	    require Tk::Wm;
	    $splash_screen->overrideredirect(1);
	}

	Tk::image($splash_screen, 'create', 'photo', 'splashphoto',
		  -file => $image_file);
	my $sw = Tk::winfo($splash_screen, 'screenwidth');
	my $sh = Tk::winfo($splash_screen, 'screenheight');
	Tk::wm($splash_screen, "geometry",
	       "+" . int($sw/2 - $image_width/2) .
	       "+" . int($sh/2 - $image_height/2));

	$splash_screen->{ImageWidth} = $image_width;

	my(@fontarg) = ($TK_VERSION >= 800
			# dummy font to satisfy SplitString
			? (-font => "Helvetica 10")
			# no font for older Tk's
			: ());
	my $l_path = '.splashlabel';
	my $l = Tk::label($splash_screen, $l_path,
			  @fontarg,
			  -image => 'splashphoto');
	if (!ref $l) {
	    # >= Tk803
	    $l = Tk::Widget::Widget($splash_screen, $l);
	}
	$l->{'_TkValue_'} = $l_path;
	bless $l, Tk::Widget;
	Tk::pack($l, -fill => 'both', -expand => 1);
	Tk::update($splash_screen);
    };
    warn $@ if $@;
    bless $splash_screen, $pkg;
}

sub Raise {
    my $w = shift;
    if ($w->{"Exists"}) {
	Tk::catch { Tk::raise($w) };
    }
}

sub Destroy {
    my $w = shift;
    if ($w->{"Exists"}) {
	Tk::catch { Tk::destroy($w) };
    }
}

1;

=head1 NAME

Tk::FastSplash - create a fast starting splash screen

=head1 SYNOPSIS

    BEGIN {
        require Tk::FastSplash;
        $splash = Tk::FastSplash->Show($image, $width, $height, $title);
    }
    ...
    use Tk;
    ...
    $splash->Destroy if $splash;
    MainLoop;

=head1 DESCRIPTION

This module creates a splash screen for perl/Tk programs. It uses
lowlevel perk/Tk stuff, so upward compatibility is not given (the
module should work at least for Tk800.015 and .022). The splash screen is
created with the B<Show> function. Supplied arguments are: filename of
the displayed image, width and height of the image and the string for
the title bar. If something goes wrong, then B<Show> will silently
ignore all errors and continue without a splash screen. The splash
screen can be destroyed with the B<Destroy> method, best short before
calling B<MainLoop>.

If you want to run this module on a Tk402.xxx system, then you have to
set the variable C<$Tk::FastSplash::TK_VERSION> to a value less than
800.

=head1 BUGS

Probably many.

The $^W variable should be turned off until the "use Tk" call.

If FastSplash is executed in a BEGIN block (which is recommended for
full speed), then strange things will happen when using "perl -c" or
trying to compile a script: the splash screen will always pop up while
doing those things.

The -display switch is not honoured (but setting the environment
variable DISPLAY will work).

=head1 AUTHOR

Slaven Rezic

=cut

__END__
