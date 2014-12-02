use inc::Module::Install;
use strict;
use warnings;

name "Wren";
all_from "lib/Wren.pm";

# This is stupid... tools should do it on their own.
use lib "lib";
require Wren;
version "Wren"->VERSION;

cpanfile;
WriteAll;

# pod2markdown?
system("pod2text lib/Wren.pm > README");

exit 0;
