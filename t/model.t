use strictures;
use Test::More;
use Test::Fatal;
use Path::Tiny;
my $lib;
BEGIN {
    $lib = path( path( __FILE__ )->parent, "lib" );
}
use lib "$lib";

use_ok("WrenApp");
isa_ok WrenApp->wren, "Wren", "Wren object is created as side-effect of use/import";

subtest "DBIx::Class model" => sub {
    my $wren = WrenApp->wren;
    isa_ok my $schema = $wren->model("DB"), "DBIx::Class::Schema";
    is exception { $schema->deploy }, undef,
        "No exception on schema->deploy";

    ok my $user = $wren->model("DB::User")->create({ login => "ohai" }),
        "Create a user with model(DB::User)";

    isa_ok $user, "WrenApp::Schema::Result::User";

    for my $login ( map "user-" . $_, "a" .. "z" )
    {
        $wren->model("DB::User")->create({ login => $login });
    }

    is $wren->model("DB::User")->count, 27, "Result operations seem fine";
    # note sprintf "%5d %s", $_->id, $_->login for $wren->model("DB::User")->all;

    done_testing(5);
};

done_testing(3);

__END__
