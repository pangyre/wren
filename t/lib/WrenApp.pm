use 5.16.2;
use mop;
class WrenApp v0.0.1 extends Wren {

    add_model "DB" =>
        class => "WrenApp::Schema",
        type  => "Wren::Model::DBIC",
        connect_info => [ "dbi:SQLite::memory:",
                          undef,
                          undef,
                          { RaiseError => 1,
                            AutoCommit => 1,
                            ChopBlanks => 1,
                            sqlite_unicode => 1, } ];

    add_model "Counter" => sub {
        state $count = 1;
        $count++;
    };

    add_route "/" =>
        http => "*", # This is default, answer all HTTP methods.
        "method" => "home";

    add_route "/counter" =>
        "method" => "counter";

    method home {
        $self->response->status(200); # This is default on match from Wren.
        $self->response->body("OHAI\n");
    };

    method counter {
        $self->response->body( $self->model("Counter") );
    };
}

1;

__END__

    "/" => { "*" => sub {
        my $self = shift;
        $self->response->content_type("text/html; charset=utf8");
        my $html = path($self->static, "index.html");
        $self->response->body( $html->filehandle("<", ":bytes") );
    }},
    "/list" => { "GET" => sub {
        my $self = shift;
        $self->response->content_type("application/json");
        my $imgs = path($self->static, "img");
        my @dcm = grep /\.dcm$/, $imgs->children;
        @dcm = map $self->uri_for($_)->as_string,
            map $_->relative($self->static),
        @dcm;
        $self->response->body( to_json( \@dcm ) );
    }},
    "/dicom/{study}/{series}/{image}" => { GET => sub {
        my $self = shift;
        # Permission check and cache here. Cache for...what's reasonable? 1 hour?
        return $self->response->body("I CAN HAZ DICOM?");
        my $dcm = path($self->root,"static/img/dicom.dcm");
        $self->response->content_type("application/dicom");
        $self->response->body( $dcm->filehandle("<", ":bytes") );
    }},
    "/{resource:.+}" => { "*" => sub {
        my $self = shift;

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

