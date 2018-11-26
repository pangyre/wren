#!perl
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
    # No. Broken anyway. use Pod::Coverage::Moose;

    my $lib = path( path(__FILE__)->parent->parent, "lib" );
    my $iter = $lib->iterator({ recurse => 1 });

    my $count = 0;
    while ( my $path = $iter->() )
    {
        next unless -f $path;
        next if $path =~ /[#~]/;
        ( my $package = $path->relative($lib) =~ s,/,::,gr ) =~ s/\.pm$//;

        pod_file_ok("$path");
        $count += 1;

        next if $path =~ /\.pod\z/;

        pod_coverage_ok($package, { also_private => [ qr/^[A-Z_]+$/ ] });
        use_ok( $package );

        # Ineffectual as is...
        #pod_coverage_ok($package,
        #                { coverage_class => 'Pod::Coverage::Moose',
        #                  also_private => [ qr/^[A-Z_]+$/ ] });

        $count += 2;
    }
    done_testing($count);
};

subtest "Some exception stuff" => sub {
    plan skip_all => "Write these, please";
    done_testing();
};

subtest "Some view stuff" => sub {
    # plan skip_all => "Write these, please";

    my $wren = WrenApp->new;

    test_psgi $wren->to_app, sub {
        my $cb  = shift;
        # FAIL b/c of Xslate+Plack param.contex handling... my
        # $path_query = "/view/index?ohai=DER;ohai=HAI";
        my $path_query = "/view/index?ohai=DER";

        my $res = $cb->(GET $path_query);

        is $res->code, 200, "GET $path_query is successful"
            or note $res->as_string;

        like $res->content, qr/OHAI DER/, "Body looks right";
    };


    done_testing();
};

# Accept => "text/plain");


subtest "Excercise the test app WrenApp" => sub {
    my $wren = WrenApp->new;
    isa_ok $wren, "Wren";
    isa_ok $wren, "WrenApp";

    ok $wren->routes, "Routes are there";
    ok $wren->router, "Router is there";

    ok ! $wren->has_errors, "No errors";
    ok $wren->error("OHAI") ,"Add an error";
    is $wren->has_errors, 1, "Now there is an error";
    ok eval { $wren->clear_errors; 1 }, "Clear errors"
        or note $@;
    ok ! $wren->has_errors, "Back to no errors";

    my $app = $wren->to_app;
    is ref $app, "CODE", "WrenApp->new->to_app return code reference";

    #like exception { add_model( Name => { stuff => "here" } ) },
    #    qr/Undefined subroutine/,
    #"add_model is broken after object instantiation";

    test_psgi $app, sub {
        my $cb  = shift;
        my $res = $cb->(GET "/");
        is $res->code, 200, "GET / is successful"
            or note $res->as_string;
        like $res->content, qr/OHAI/, "Body looks right";
    };

    test_psgi $app, sub {
        my $cb  = shift;
        my $res = $cb->(GET "/of course not");
        is $res->code, 404, "Status is 404";
        like $res->content, qr/Not Found/i, '404 content contains "Not Found"';
    };

    test_psgi $app, sub {
        my $cb  = shift;
        my $res = $cb->(GET "/exception");
        is $res->code, 500, "Status is 500";
        like $res->content, qr/NO CAN HAZ/i, '500 content contains exception text'
            or note $res->as_string;
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

    subtest "Observe model changes via view" => sub {
        plan skip_all => "WRITE THIS";
        done_testing();

    };

    done_testing();
};

done_testing(5);

__END__
