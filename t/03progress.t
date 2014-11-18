# -*- perl -*-

use strict;

BEGIN {
    if (!eval q{
	use Test::More;
	1;
    }) {
	print "# tests only work with installed Test::More module\n";
	print "1..1\n";
	print "ok 1\n";
	exit;
    }
}

use Tk;

plan tests => 3;

require_ok 'Tk::ProgressSplash';

my $splash = Tk::ProgressSplash->Show(-splashtype => 'normal',
				      Tk::findINC("Tk", "Xcamel.gif"),
				      60, 60, "Splash", 1);
ok $splash;


$splash->Update(0.1);
my $top=tkinit;
$splash->Update(0.2); $top->after(300);
$top->update;
$splash->Raise;
$splash->Update(0.4); $top->after(300);
$splash->Update(0.8); $top->after(300);

$splash->Destroy;
ok !Tk::Exists($splash), 'splash window destroyed';

