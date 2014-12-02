use inc::Module::Install;
use strict;
use warnings;
use Cwd ();
#use Path::Class;
my $MAKEFILE = Cwd::realpath(__FILE__);
( my $DIR = $MAKEFILE ) =~ s,/[^/]+\z,,;

name "Wren";
all_from "lib/Wren.pm";

#install_requires "LWP::Simple" => undef;
#install_requires "Archive::Zip" => undef;

open my $fh, "<", "$DIR/cpanfile"
    or die "Couldn't open cpanfile for reading: $!";

my @requires = grep length,
    map /\A \s* requires \s+ (['"][^;]+) /x, <$fh>;

eval "requires($_)" for @requires;

# Cat the cpanfile here?

test_requires "Test::More" => undef;
test_requires "Test::Fatal" => undef;
test_requires "DBIx::Class" => undef;
test_requires "Pod::Coverage::Moose" => undef;
# test_requires "SQL::Translator" => undef;

# build_requires "Path::Class" => undef;

system( 'pod2text lib/Wren.pm > README' );

# install_script glob("script/*.pl");

auto_install;

WriteAll;

exit 0;
