use strictures;
use Test::More;
use Test::Fatal;
use Path::Tiny;
use Plack::Test;
# use HTTP::Tiny;
use HTTP::Request::Common;

my $test_lib = path( path(__FILE__)->parent, "lib" );
push @INC, "$test_lib";
ok eval "use WrenApp; 1", "use WrenApp;"
    or diag $@;

subtest "Walk everything: use/Pod/coverage/spelling" => sub {
    use Test::Pod;
    use Test::Pod::Coverage;
    use Pod::Coverage::Moose;

    my $lib = path( path(__FILE__)->parent->parent, "lib" );
    my $iter = $lib->iterator({ recurse => 1 });

    my $count = 0;
    while ( my $path = $iter->() )
    {
        next unless -f $path;
        next if $path =~ /[#~]/;
        ( my $package = $path->relative($lib) =~ s,/,::,gr ) =~ s/\.pm$//;

        use_ok( $package );
        pod_file_ok("$path");
        pod_coverage_ok($package,
                        { also_private => [ qr/^[A-Z_]+$/ ] });

        # Ineffectual as is...
        #pod_coverage_ok($package,
        #                { coverage_class => 'Pod::Coverage::Moose',
        #                  also_private => [ qr/^[A-Z_]+$/ ] });

        $count += 3;
    }
    done_testing($count);
};

subtest "Some exception stuff" => sub {
    ok 1;
    done_testing();
};

subtest "..." => sub {

    my $app = WrenApp->new->to_app;

    #like exception { add_model( Name => { stuff => "here" } ) },
    #    qr/Undefined subroutine/,
    #"add_model is broken after object instantiation";

    test_psgi $app, sub {
        my $cb  = shift;
        my $res = $cb->(GET "/");
        is $res->code, 200, "GET / is successful";
        like $res->content, qr/OHAI/, "Body looks right";
    };

    test_psgi $app, sub {
        my $cb  = shift;
        my $res = $cb->(GET "/of course not");
        like $res->content, qr/Not found/i, "404 is 404";
    };

    subtest "Test a flat model (a counter)" => sub {
        use Time::HiRes qw( gettimeofday tv_interval );

        my @ok;
        my $count = 1_000;

        my $t0 = [gettimeofday];
        for ( 1 .. $count )
        {
            test_psgi $app, sub {
                my $cb  = shift;
                my $res = $cb->(GET "/counter");
                push @ok, "ok" if  $res->content =~ /\b$_\b/;
            };
        }

        my $elapsed = tv_interval ( $t0, [gettimeofday]);
        note sprintf "%d requests per second",
            $count / $elapsed;

        cmp_ok @ok, "==", $count, "Basic counter model works";

        done_testing(1);
    };

    done_testing();
};

done_testing(4);

__END__
