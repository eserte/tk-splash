# -*- perl -*-

BEGIN { $| = 1; print "1..3\n"; }
END {print "not ok 1\n" unless $loaded;}

BEGIN {
    require Tk::Splash;
    $loaded = 1;
    print "ok 1\n";
}

BEGIN {
    $splash = Tk::Splash->Show(Tk->findINC("Xcamel.gif"), 60, 60, "Splash");
    print "ok 2\n";
}

use Tk;

$top=tkinit;
$top->update;

$splash->Destroy;
print "ok 3\n";

$top->update;
sleep 1;
