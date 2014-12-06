use inc::Module::Install;
use strict;
use warnings;

name "Wren";
all_from "lib/Wren.pm";
# Apparently a no-op, perl_version_from "lib/Wren.pm";

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
