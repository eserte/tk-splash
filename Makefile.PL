use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'Tk::Splash',
    'VERSION'   => '0.08',
    'dist'      => {'COMPRESS'=>'gzip -9f', 'SUFFIX' => '.gz',
                    'POSTOP'=>'-$(CHMOD) 644 $(DISTVNAME).tar$(SUFFIX)'},
    'ABSTRACT_FROM' => 'Splash.pm',
    'AUTHOR' => 'Slaven Rezic (srezic@cpan.org)',
);
