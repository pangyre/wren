use inc::Module::Install;
use strict;
use warnings;
use Cwd ();
#use Path::Class;
#my $MAKEFILE = Path::Class::File->new( Cwd::realpath($0) );
#my $DIR = $MAKEFILE->dir->stringify;

name "Wren";
all_from "lib/Wren.pm";

# requires "parent" => undef;
#install_requires "LWP::Simple" => undef;
#install_requires "Archive::Zip" => undef;

# Cat the cpanfile here?

test_requires "Test::More" => undef;
test_requires "Test::Fatal" => undef;
# test_requires "SQL::Translator" => undef;

# build_requires "Path::Class" => undef;

system( 'pod2text lib/Wren.pm > README' );

# install_script glob("script/*.pl");

auto_install;

WriteAll;

exit 0;
