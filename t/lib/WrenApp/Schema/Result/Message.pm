use 5.14.2;
package WrenApp::Schema::Result::Message {
    use strictures;
    use parent "DBIx::Class::Core";
    __PACKAGE__->table( __PACKAGE__ =~ /(\w+)\z/ );

    __PACKAGE__->add_columns(
        id => { data_type => "INT",
                is_auto_increment => 1,
                default_value => 0,
                is_nullable => 0,
                size => 11 },
        user => { data_type => "INT",
                default_value => 0,
                is_nullable => 0,
                size => 11 },
        text => {
            data_type => "VARCHAR",
            default_value => undef,
            is_nullable => 0,
            size => 140,
        } );

    __PACKAGE__->set_primary_key("id");

    __PACKAGE__->belongs_to( user => "WrenApp::Schema::Result::User",
                             { "foreign.id" => "self.user" } );

}

1;

__END__

=pod

=head1 Name

WrenApp::Schema::Result::Message - ...

=over 4

=item * 

=back

=cut
