use 5.14.2;
package WrenApp::Schema::Result::User {
    use strictures;
    use parent "DBIx::Class::Core";
    __PACKAGE__->table( __PACKAGE__ =~ /(\w+)\z/ );

    __PACKAGE__->add_columns(
        id => { data_type => "INT",
                is_auto_increment => 1,
                default_value => 0,
                is_nullable => 0,
                size => 11 },
        login => {
            data_type => "VARCHAR",
            default_value => undef,
            is_nullable => 0,
            size => 64,
        } );

    __PACKAGE__->set_primary_key("id");
    __PACKAGE__->add_unique_constraint(["login"]);

    __PACKAGE__->has_many( messages => "WrenApp::Schema::Result::Message",
                           { "foreign.user" => "self.id" },
                           { order_by => "created DESC" } );
}

1;

__END__

=pod

=head1 Name

WrenApp::Schema::Result::User - ...

=over 4

=item * 

=back

=cut
