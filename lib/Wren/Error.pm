use 5.16.2;
use mop;

class Wren::Error {
    use Devel::StackTrace;
    use overload '""' => sub { +shift->message };
    has $!message is ro;

    #method new ($class: $msg) {
    #    $class->next::method( message => $msg );
    #}

    method throw {
        die @_; # +shift->new(join " ", @_);
    };

    #method to_string is overload('""') {
    #    "<foo value=$!val />";
    #}


};


__END__
        die @_;
        my %arg = @_ == 1 ?
            ( message => +shift )
            :
            @_;
        $class->next::method(%arg);

    has message =>
        is => "lazy",
        default => sub { +shift->stacktrace->as_string };

    has stacktrace =>
        is => "ro",
        default => sub { Devel::StackTrace->new };

    sub as_string {
        my $self = shift;
        $self->message;
    }


=pod

=encoding utf8

=head1 Name

Wren::Error - ...

=head1 Synopsis

=head1 Description

=over 4

=item * stacktrace

=item * as_string

=item * throw

=back

=head1 License, Author, Etc

See L<Wren>.

=cut
