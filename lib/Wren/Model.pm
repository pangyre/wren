use strictures;

package Wren::Model {
    use Moo;
    use Wren::Error;

    has name =>
        is => "ro",
        required => 1,
        ;

    has model =>
        is => "ro",
        required => 1,
        ;

    sub compose {
        my ( $self, $name, %arg ) = @_;
        my $type = delete $arg{type};
        if ( $type )
        {
            eval "use $type; 1" or Wren::Error->throw($@);
            # eval { require "$type"; } or die $@; #Wren::Error->throw($@);
            # Wren::Error->throw("Couldn't load model type $type: ", $@) if $@;
            return $type->instantiate( $name, %arg );
        }
        die "SHOULDN'T GET HERE YET";
        ## my $constructor = $arg{constructor} || "new";
        #my $model_class = delete $arg{class};
        #my $constructor = delete $arg{constructor} || "new";
        #eval "require $model_class;";
        #Wren::Error->throw("Couldn't load $model_class: ", $@) if $@;

        #my $model = "$model_class"->$constructor(@{ $arg{arguments} });
        #$class->next::method( name => $name, model => $model );
    }

};

"Cactus";

__END__

=pod

=encoding utf8

=head1 Name

Wren::Model - ...

=head1 Synopsis

=head1 Description

=over 4

=item * new

=item * compose

=item * name

=item * model

=back

=head1 License, Author, Etc

See L<Wren>.

=cut
