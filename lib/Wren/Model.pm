use 5.16.2;
use mop;

class Wren::Model with Wren::Error {

    has $!name is ro;
    has $!model is ro;

    method compose ($class: $name, %arg )
    {
        my $type = delete $arg{type};
        if ( $type )
        {
            eval "use $type; 1" or die "OHAI: $@"; #Wren::Error->throw($@);
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


__END__

=pod

=encoding utf8

=head1 Name

Wren::Model - ...

=head1 Synopsis

=head1 Description

=over 4

=item * compose

=back

=head1 License, Author, Etc

See L<Wren>.

=cut
