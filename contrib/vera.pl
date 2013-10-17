#! /usr/bin/perl -w
#
#  Andres Soolo <soolo [at] ut . ee> writes:
#  "Also, I'd like to contribute this non-interactive tool to look up
#  VERA entries:"


use strict;

# Global parameters

use vars qw/$verainfo/; $verainfo = '/usr/share/info/vera.info.gz';

# End of global parameters

# All items in %acronym are wanted; those with empty string as their
# values will be reported as unknown.
my %acronym = map {uc, ''} @ARGV;

delete $acronym{''}; # no such

# Check whether user asked for --help
if (not %acronym or defined $acronym{'--HELP'})
{
    print "Usage: vera acronym ...\n";
    exit;
}

# The MNP5 -> MNP translation.  Note that MNP is only weakly wanted.
# See 'Acronyms pointing to versions'.
s/\d+$// and $acronym{$_} = $_ for keys %acronym;

open VERA, "zcat $verainfo |" or die "Trouble opening $verainfo: $!";

print "\n";

while (%acronym and $_ = <VERA>)
{
    chomp;
    last if $_ eq 'Examples:'; # No unnecessary duplicates
    if (defined $acronym{$_})
      {
        $acronym{$_} = $_; # Not unknown anymore
        print "$_\n";
        while ($_ ne "\n") { $_ = <VERA>; print; }
      }
}

close VERA;

delete $acronym{$_} for values %acronym; # Delete weakly wanted ones

print "Unknown acronyms: ", join (', ', sort keys %acronym), "\n\n" if %acronym;

