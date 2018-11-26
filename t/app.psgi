#!/usr/bin/env perl /usr/local/bin/plackup -r
my $dir;
BEGIN {
    use File::Spec;
    ( $dir ) = File::Spec->rel2abs( __FILE__ ) =~ m,\A(.+)/[^/]+\z,;
};

use lib "$dir/../lib", "$dir/lib";
use WrenApp;

WrenApp->new->to_app;

__END__

