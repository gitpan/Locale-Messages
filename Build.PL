use Module::Build;
use strict;
use warnings;

my %requires = (
                 'perl'                     => '5.010000',
                 'Encode'                   => '0',
                 'File::Path'               => '0',
                 'I18N::LangTags::Detect'   => '0',
                 'IO::File'                 => '0',
                 'Locale::Country'          => '0',
                 'Locale::Language'         => '0',
                 'POSIX'                    => '0',
                 'Tk'                       => '0',
                 'Tk::ROText'               => '0',
               );
my %build_mods = (
                 'Test::Inter'              => '0',
                 'lib'                      => '0',
               );


my $class = Module::Build->subclass(
   class => "Module::Build::Custom",
   code  => q { sub ACTION_html { my $self = shift ; $self->SUPER::ACTION_html ( @_ ) if ( $ENV{ MAKE_HTML } ) ; } }
);

my $build = $class->new(
        license            => 'perl',
        dist_version       => '0.90',
        dist_author        => 'Sullivan Beck <sbeck@cpan.org>',
        module_name        => 'Locale::Messages',
        dist_abstract      => 'handle all aspects of the localization process',
        requires           => \%requires,
        build_requires     => \%build_mods,
        sign               => 1,
        script_files => [
           'bin/lm_gui',
        ],
);

$build->create_build_script;
