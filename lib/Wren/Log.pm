use strictures;

package Wren::Log {
    use Moo;
    # use Wren::Error;
    # requires qw/ trace debug info warn error fatal /;

    has level =>
        is => "ro",
        required => 1,
        default => sub { "warn" }
        ;

    has out =>
        is => "ro",
        default => sub { [] },
        ;

    # sub trace

};

"Bewick";

__END__

=pod

=encoding utf8

=head1 Name

Wren::Log - ...

=head1 Synopsis

=head1 Description

=over 4

=item * new

=item * level

=item * out

=back

=head1 License, Author, Etc

See L<Wren>.

=cut
