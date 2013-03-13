package Locale::Messages::lm;
# Copyright (c) 2010-2013 Sullivan Beck.  All rights reserved.
# This program is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.

###############################################################################
require 5.010000;
use IO::File;

use strict;
use integer;
use warnings;

use IO::File;
use File::Path qw(make_path);

=pod

=head1 NAME

Locale::Messages::lm -- Internal module used by tools

=head1 DESCRIPTION

This module is not intended for public use. It is used internally by
the tools that are distributed with the Locale-Messages distribution.

=head1 SEE ALSO

Locale::Messages

=head1 LICENSE

This script is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 AUTHOR

Sullivan Beck (sbeck@cpan.org)

=cut

###############################################################################

# Create the message set module.
#
sub _set_create {
   my($set,$dir,$def_locale) = @_;

   my $d = "$dir/Locale/Messages/Sets";
   my $f = "$d/$set.pm";

   if (-f $f) {
      die "ERROR: message set already exists\n";
   }

   make_path($d)  if (! -d $d);

   _set_write($set,$dir,{},$def_locale);
}

# Load the message set module.
#
no strict 'refs';
sub _set_read {
   my($set,$dir) = @_;

   my $m   = "Locale::Messages::Sets::$set";
   my $d   = "Locale/Messages/Sets";
   my $f   = "$d/$set.pm";
   delete $INC{$f};

   $d      = "$dir/$d";
   $f      = "$dir/$f";

   if (! -f $f) {
      die "ERROR: message set module does not exist: $f\n";
   }

   eval "use lib '$dir'; require $m";
   if ($@) {
      die "ERROR: failed to load message set module [$m]: $@\n";
   }

   my $def_locale = ${ "${m}::DefaultLocale" };
   my @alllocale = @{ "${m}::AllLocale" };
   my %messages  = %{ "${m}::Messages" };

   if (! @alllocale  ||  $alllocale[0] ne $def_locale) {
      die "ERROR: locales not specified correctly in set module: $m\n";
   }

   return (\%messages,@alllocale);
}
use strict 'refs';

# Write the message set module.
#
sub _set_write {
   my($set,$dir,$messages,$def_locale,@oth_locale) = @_;

   my $m   = "Locale::Messages::Sets::$set";
   my $d   = "$dir/Locale/Messages/Sets";
   my $f   = "$d/$set.pm";

   my $out = new IO::File;

   if (! $out->open("> $f")) {
      die "ERROR: unable to write set file: $f: $!\n";
   }

   print $out "package Locale::Messages::Sets::${set};
####################################################
#        *** WARNING WARNING WARNING ***
#
# This file was generated, and is intended to be
# maintained automatically using the Locale::Messages
# tools.
#
# Any changes to this file may be lost the next
# time these commands are run.
####################################################

use strict;
use warnings;

our(\$DefaultLocale,\@AllLocale,\%Messages);

\$DefaultLocale = '$def_locale';
\@AllLocale     = (qw($def_locale @oth_locale));

\%Messages = (
";

   foreach my $msgid (sort keys %$messages) {
      print $out "   '$msgid' => {\n";

      if (exists $$messages{$msgid}{'desc'}) {
         my $desc = $$messages{$msgid}{'desc'};
         print $out "      'desc'  => q{$desc},\n";
      }

      if (exists $$messages{$msgid}{'vals'}) {
         my @vals = @{ $$messages{$msgid}{'vals'} };
         my $vals = "['" . join("','",@vals) . "']";
         print $out "      'vals'  => $vals,\n";
      }

      print $out "   },\n";
   }

   print $out ");

1;

=pod

=head1 NAME

Locale::Messages::Sets::$set -- Description of the $set message set

=head1 DESCRIPTION

This module is not intended for public use. It is used internally by
Locale::Messages to store the description of a set of messages that
will be localized for some application.

=cut
";

   $out->close();
}

###############################################################################

# Create a lexicon module.
#
sub _lexicon_create {
   my($set,$dir,$locale) = @_;

   #
   # Create the new lexicon module.
   #

   my $d = "$dir/Locale/Messages/Sets/$set";
   my $f = "$d/$locale.pm";

   if (-f $f) {
      die "ERROR: message lexicon already exists\n";
   }

   make_path($d)  if (! -d $d);

   _lexicon_write($set,$dir,$locale,{});
}

# Load a lexicon module.
#
no strict 'refs';
sub _lexicon_read {
   my($set,$dir,$locale) = @_;

   my $m = "Locale::Messages::Sets::${set}::${locale}";
   my $d = "Locale/Messages/Sets/$set";
   my $f = "$d/$locale.pm";
   delete $INC{$f};

   $d      = "$dir/$d";
   $f      = "$dir/$f";

   if (! -f $f) {
      die "ERROR: lexicon module does not exist: $f\n";
   }

   eval "use lib '$dir'; require $m";
   if ($@) {
      die "ERROR: failed to load lexicon module [$m]: $@\n";
   }

   my %messages  = %{ "${m}::Messages" };

   return \%messages;
}
use strict 'refs';

# Write a lexicon module.
#
sub _lexicon_write {
   my($set,$dir,$locale,$messages) = @_;

   my $d = "$dir/Locale/Messages/Sets/$set";
   my $f = "$d/$locale.pm";

   my $out = new IO::File;

   if (! $out->open("> $f")) {
      die "ERROR: unable to write lexicon: $f: $!\n";
   }

   print $out "package Locale::Messages::Sets::${set}::${locale};
####################################################
#        *** WARNING WARNING WARNING ***
#
# This file was generated, and is intended to be
# maintained automatically using the Locale::Messages
# tools.
#
# Any changes to this file may be lost the next
# time these commands are run.
####################################################

use strict;
use warnings;

our(\%Messages);

\%Messages = (
";

   foreach my $msgid (sort keys %$messages) {
      print $out "   '$msgid' => {\n";

      if (exists $$messages{$msgid}{'vers'}) {
         my $vers = $$messages{$msgid}{'vers'};
         print $out "      'vers'  => $vers,\n";
      } else {
         print $out "      'vers'  => 0,\n";
      }

      if (exists $$messages{$msgid}{'text'}) {
         my $text = $$messages{$msgid}{'text'};
         $text    =~ s,',\\',g;
         print $out "      'text'  => '$text',\n",
      }

      print $out "   },\n";
   }

   print $out ");

1;

=pod

=head1 NAME

Locale::Messages::Sets::${set}::${locale} -- Localized messages

=head1 DESCRIPTION

This module is not intended for public use. It is used internally by
Locale::Messages to store the lexicon for the set of messages ($set)
translated into the locale ($locale).

=cut
";

   $out->close();
}

1;

# Local Variables:
# mode: cperl
# indent-tabs-mode: nil
# cperl-indent-level: 3
# cperl-continued-statement-offset: 2
# cperl-continued-brace-offset: 0
# cperl-brace-offset: 0
# cperl-brace-imaginary-offset: 0
# cperl-label-offset: 0
# End:
