use 5.16.2;

package WrenApp v0.0.1 {
    use parent "Wren";
    use Wren;
    use Wren::Error;

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

    add_view "Xslate" =>
        class => "Text::Xslate",
        arguments => [ path => Wren->_path ],
        ;
    #my $rendered = eval {
    #    $self->render($template, $vars);
    #};

    add_route "/" =>
        http => "*", # This is default, answer all HTTP methods.
        code => sub {
            my $self = shift;
            $self->response->body("OHAI");
    };

    add_route "/counter" =>
        code => sub {
            my $self = shift;
            $self->response->body( $self->model("Counter") );
    };

    add_route "/exception" =>
        code => sub {
            my $self = shift;
            $self->response->status(200);
            Wren::Error->throw("NO CAN HAZ");
    };

    add_route '/view/{id:\w+}' =>
        code => sub {
            my $self = shift;
            my $arg = shift;
            $self->response->status(200);
            my $template = Path::Tiny::path( "xslate/view", $arg->{id} . ".html" );
            # Negotiate to pick template extension.
            $self->response->body( $self->view("Xslate")->render($template, {}) );
    };

}

1;

__END__

    method home {
        $self->response->status(200); # This is default on match from Wren.
        $self->response->body("OHAI\n");
    };

    method counter {
        $self->response->body( $self->model("Counter") );
    };

    method exception {
        $self->response->status(200);
        $self->throw("NO CAN HAZ");
    };

* Auto document routes to POD/map, allow a description?

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

