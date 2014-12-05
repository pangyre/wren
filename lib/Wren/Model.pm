use 5.16.2;
use mop;

class Wren::Model with Wren::Error {
    has $!name is ro;
    has $!model is ro;

    method compose ($class: $name, %arg ) {
        my $type = delete $arg{type};
        if ( $type )
        {
            eval "use $type; 1" or die "OHAI: $@"; #Wren::Error->throw($@);
            # eval { require "$type"; } or die $@; #Wren::Error->throw($@);
            # Wren::Error->throw("Couldn't load model type $type: ", $@) if $@;
            # say "\n$type->new(", join(",", %arg), ")";
            return $type->instantiate( $name, %arg );
        }
        die;
        ## my $constructor = $arg{constructor} || "new";
        #my $model_class = delete $arg{class};
        #my $constructor = delete $arg{constructor} || "new";
        #eval "require $model_class;";
        #Wren::Error->throw("Couldn't load $model_class: ", $@) if $@;

        #my $model = "$model_class"->$constructor(@{ $arg{arguments} });
        #$class->next::method( name => $name, model => $model );
    }

    method throw {
        die +shift->new(join " ", @_);
    };

};


__END__
    add_model "DB" =>
        class => "WrenApp::Schema",
        connect_info => [ "dbi:SQLite::memory:",
                          undef,
                          undef,
                          { RaiseError => 1,
                            AutoCommit => 1,
                            ChopBlanks => 1,
                            sqlite_unicode => 1, } ];
    sub add_model {
        my $name = shift;
        my %arg = @_;
        eval "use $arg{class}";
        Wren::Error->throw("Couldn't load $arg{class}: ", $@) if $@;
        my $schema = "$arg{class}"->connect( @{ $arg{connect_info} } );
        $wren->set_model( $name => $schema ); # iterate on named Sources?
        for my $source ( $wren->model("DB")->sources )
        {
            $wren->set_model( join("::",$name,$source) => $schema->resultset($source) );
        }
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
