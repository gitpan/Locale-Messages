
use ExtUtils::MakeMaker;
use 5.010000;
use strict;
use warnings;
my %requires = (
                 'Encode'                   => '0',
                 'File::Path'               => '0',
                 'I18N::LangTags::Detect'   => '0',
                 'IO::File'                 => '0',
                 'Locale::Country'          => '0',
                 'Locale::Language'         => '0',
                 'POSIX'                    => '0',
                 'Tk'                       => '0',
                 'Tk::ROText'               => '0',
                 'Test::Inter'              => '0',
                 'lib'                      => '0',
               );


WriteMakefile(
        NAME             => 'Locale::Messages',
        VERSION          => '0.90',
        ($] >= 5.010000
        ? (ABSTRACT=>'handle all aspects of the localization process',
           AUTHOR  =>'Sullivan Beck (sbeck@cpan.org)')
        : ()),
        'dist' => {COMPRESS=>'gzip',SUFFIX=>'gz'},
        PL_FILES  => {},
        PREREQ_PM => \%requires,
        EXE_FILES => [
           'bin/lm_gui',
        ],
);
