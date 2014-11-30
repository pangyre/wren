use 5.14.2;
package Wren::Error {
    use Moo;
    use Devel::StackTrace;
    use overload '""' => sub { +shift->message };

    sub BUILDARGS { @_ == 2 ? { message => $_[1] } : { @_[1..$#_-1] } };

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

    sub throw { die +shift->new(join " ", @_) }

};

"Error! Error! Error!";

__END__

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
