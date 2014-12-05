use 5.16.2;
use mop;

class Wren::Model::DBIC extends Wren::Model {
#class Wren::Model::DBIC {
    method instantiate ( $class : $name, %arg ) {
        # Provide for bootstrapping from connection string, I think.
        my $model_class = delete $arg{class};
        eval "use $model_class; 1";
        # Wren::Error->throw("Couldn't load $model_class: ", $@) if $@;

        my $schema = "$model_class"->connect(@{ $arg{connect_info} });

        my @collection;

        push @collection, $class->new( name => $name, model => $schema );

        for my $source ( $schema->sources )
        {
            my $name = join "::", $name, $source;
            push @collection, $class->new( name => $name,
                                           model => $schema->resultset($source) );

        }
        @collection;
    }
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
