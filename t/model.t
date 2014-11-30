use strictures;
use Test::More;
use Test::Fatal;
use Path::Tiny;
my ( $lib, $demo );
BEGIN {
    $lib = path( path( __FILE__ )->parent, "lib" );
}

use lib "$lib";
use_ok("WrenApp");


done_testing();

__END__

subtest "DBIx::Class model" => sub {
    

    ok my $schema = Taster::Schema->connect("dbi:SQLite::memory:",
                                            { RaiseError => 1,
                                              AutoCommit => 1 }),
        "Connecting to dbi:SQLite::memory:";

    is eval { $schema->deploy; "ok" },
        "ok",
    "Deploying schema is okay";

    done_testing();
};

done_testing(1);

__END__
