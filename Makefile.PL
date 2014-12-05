use inc::Module::Install;
use strict;
use warnings;

unless ( $Module::Install::AUTHOR )
{
    requires_external_bin "git";
    requires_external_bin "cpanm";
    0 == system qw{ cpanm git://github.com/stevan/p5-mop-redux.git }
    or die "Couldn't install mop from github repo: $!";
}

name "Wren";
all_from "lib/Wren.pm";

# This is stupid... tools should do it on their own.
use lib "lib";
require Wren;
version "Wren"->VERSION;

cpanfile;
WriteAll;

if ( $Module::Install::AUTHOR )
{
    system "pod2markdown lib/Wren.pm README.md";
}

exit 0;
