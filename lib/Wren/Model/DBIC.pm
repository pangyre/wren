use strictures;

package Wren::Model::DBIC {
    use Moo;
    extends "Wren::Model";
    no warnings "redefine"; # WHY?! Is this the eval "use ..." stuff?

    sub instantiate {
        my ( $class, $name, %arg ) = @_;
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

1;

__END__

=pod

=encoding utf8

=head1 Name

Wren::Model::DBIC - ...

=head1 Synopsis

=head1 Description

=over 4

=item * instantiate

=back

=head1 License, Author, Etc

See L<Wren>.

=cut
