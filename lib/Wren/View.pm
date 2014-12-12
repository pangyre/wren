use strictures;

package Wren::View {
#    use parent "Wren::Component";
    use Moo;
    with "Wren::Component";
    # requires "render"; # Apply role to non-Moo class?
};

"Cactus";

__END__

=pod

=encoding utf8

=head1 Name

Wren::View - ...

=head1 Synopsis

=head1 Description

=over 4

=item * new

=item * view

=back

=head1 License, Author, Etc

See L<Wren>.

=cut

sub new {
    my $caller = shift;
    my %opt = @_;
    # Paths are resolved in order.
    unless ( ref $opt{path} eq "HASH" )
    {
        no warnings "uninitialized";
        push @{$opt{path}}, dir template_root();
    }

    #$opt{syntax} ||= "TTerse";
    #$opt{module} ||= [ "Text::Xslate::Bridge::TT2Like" ];
    #$opt{cache_dir} ||= dir( "/usr/local", repo(), "tmp/tx" );
    # Cache level 2 means never recompile templates.
    # REVISIT, NEEDS MASTER BEHAVIOR, perhaps same as plack dev stuff: $opt{cache} = ... ? 2 : 1;
    #$opt{verbose} ||= 2;
    #$opt{input_layer} ||= ":utf8";
    #$opt{warn_handler} = sub {};
    #$opt{die_handler} = sub {};

    $opt{function} = { %FUNCTIONS, %{$opt{function}||{}} };

    my $self = $caller->SUPER::new(%opt);

    # THIS MIGHT BE A GOOD IDEA in edge cases but I can't force edge
    # cases right now so I'm not sure and won't uncomment till it's testable.
    # local *STDERR;
    # open ... and write out in DESTROY?
    # $self->{__stderr__} = "";
    # open STDERR, ">>", \$self->{__stderr__};

    $self;
}
