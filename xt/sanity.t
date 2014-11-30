use strictures;
use Test::More;
use Path::Tiny;

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

done_testing(1);

__END__


