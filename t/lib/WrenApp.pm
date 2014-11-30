package WrenApp v0.0.1 {
    use strictures;
    use Wren;

    add_model "DB" =>
        class => "WrenApp::Schema",
        connect_info => [ "dbi:SQLite::memory:",
                          undef,
                          undef,
                          { RaiseError => 1,
                            AutoCommit => 1,
                            ChopBlanks => 1,
                            sqlite_unicode => 1, } ];

}

1;

__END__

=pod

=encoding utf8

=head1 Name

WrenApp - a test application for tests and testing. Test.

=head1 Synopsis

=head1 Description

=over 4

=item *

=back

=cut

