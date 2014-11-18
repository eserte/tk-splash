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

BEGIN {
    plan tests => 3;
}

BEGIN {
    require_ok 'Tk::Splash';
}

my $splash;
BEGIN {
    $splash = Tk::Splash->Show(Tk->findINC("Xcamel.gif"), 60, 60, "Splash");
    ok $splash;
}

use Tk;

my $top=tkinit;
$top->update;

$splash->Destroy;
ok !Tk::Exists($splash), 'splash window destroyed';

$top->update;
#sleep 1;
