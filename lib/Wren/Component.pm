use strictures;

package Wren::Component {
    use Moo::Role;
    use Wren::Error;

    has name =>
        is => "ro",
        required => 1,
        ;

    sub compose {
        my ( $self, $name, %arg ) = @_;

        my $component_type = $self =~ s/Wren::(\w+)/lc $1/er; # View|Model is all so far...
        {
            no strict "refs";
            &{"${self}::has"}( $component_type, is => "ro", required => 1 );
        }

        if ( my $class = $arg{class} )
        {
            eval "require $class"
                unless eval { $class->VERSION };
            Wren::Error->throw("Cannot load $class: $@") if $@;

            if ( my $type = delete $arg{type} )
            {
                requires "instantiate";
                eval "require $type"
                    unless eval { $type->VERSION };
                Wren::Error->throw("Cannot load $type: $@") if $@;
                return $type->instantiate( $name, %arg );
            }

            my $constructor = delete $arg{constructor} || "new";
            my $thing = $class->$constructor( @{ $arg{arguments} } );

            return
                $self->new( name => $name,
                            $self->component_type => $thing );
        }
        Wren::Error->throw("Must have a class or a type or both");
    }
};

"Marsh";

__END__

=pod

=encoding utf8

=head1 Name

Wren::Component - ...

=head1 Synopsis

=head1 Description

=over 4

=item * new

=item * compose

Instantiates an attribute based on the caller. L<Wren::Model> becomes attribute C<model>.

=item * name

=back

=head1 License, Author, Etc

See L<Wren>.

=cut
