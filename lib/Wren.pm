use 5.16.2;
use mop;
our $AUTHORITY = "cpan:ASHLEY";

class Wren v0.0.1 with Wren::Error {
    use strictures;
    use HTTP::Status ":constants", "status_message";
    use Exporter;# "export_to_level";
    use Router::R3;

    has $!env      is ro;
    has $!request  is ro, lazy = $_->_build_request;
    has $!response is ro, lazy = $_->_build_response;
    has $!router   is ro, lazy = $_->_build_routes;
    has $!models   is ro, lazy = $_->_build_models;

    sub import {
        shift->export_to_level(1); # handle our exports
    }

    our %_models;
    sub add_model {
        my $name = shift;
        require Wren::Model;
        if ( @_ == 1 and ref $_[0] eq "CODE" )
        {
            $_models{$name} = +shift;
        }
        else
        {
            $_models{$_->name} = $_ for Wren::Model->compose($name => @_);
        }
    }

    method _build_models {
        # no warnings "redefine";
        # Not this... *add_model = sub { ... };
        \%_models; # UNDEFINE OR REDEFINE add_model here to error out post _build?
    };

    our @_routes;
    sub add_route {
        my $route = shift;
        my %arg = ( "http" => "*",
                    "method" => undef,
                   @_ );
        $arg{route} = $route;
        push @_routes, $route => \%arg;
    }

    method _build_routes {
        "Router::R3"->new(@_routes);
    };

    method model ($name) {
        use Scalar::Util "blessed";
        my $metamodel = $!models->{$name} || die "No such model: $name"; # Wren::Error->throw("No such model: $name");
        return $metamodel->() unless blessed $metamodel;
        my $model = $metamodel->model;
        ref $model eq "CODE" ?
            $model->()
                :
            $model;
    };


    method _build_response {
        require Plack::Response;
        "Plack::Response"
            ->new( HTTP_NOT_FOUND,
                   [ "Content-Type" => "text/plain" ],
                   [ status_message(HTTP_NOT_FOUND), " : ", $!request->path ] );
    };

    method _build_request {
        require Plack::Request;
        $!request = "Plack::Request"->new( $!env );
    };

    method reset {
        undef $!env;
        undef $!request;
        undef $!response;
    };

    method to_app {
        sub {
            $self->reset;
            $!env = shift;
            my ( $match, $captures ) = $!router->match( $!env->{PATH_INFO} );

            use Data::Dump "dump";
            # say dump $match;

            my $method = $match->{method} || return $!response->finalize; # Default is 404.
            $self->$method( $captures );
            $!response->finalize;
            # return [ 200, [ "Content-Type" => "text/plain" ], [ "OHAI\n"] ];
        }
    }

};

"Winter";

__END__

    method clear_env { undef $!env };
    method clear_request { undef $!request };
    method clear_response { undef $!response };

    # use Exporter "import";
    our @EXPORT = qw( add_model wren );
    sub import {
        __PACKAGE__->export_to_level(1, @_);
        $wren = __PACKAGE__->new;
    }

    has "models" =>
        is => "ro",
        traits  => ["Hash"],
        default => sub { {} },
        handles => {
            model => "get",
            set_model => "set",
        };

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


    # use Exporter "import";
    # method new ($class) { $class->next::method };
    # sub import { Exporter->export_to_level(1, @_) }

=pod

=encoding utf-8

=head1 Name

Wren - B<Experimental> lightweight web framework.

=head1 Synopsis

=head1 Description

    # Config, build
    # wren->to_app???

    # Pipeline-
    # Negotiate...?
    # Handle input -> Request.
    # Dispatch to Controller.
    # (Models available at all points here).
    # Render in View to Response (Should have a FAST/SANE default.)
    #   OR -> give FH type object to response.
    # Finalize ^implied aboe^.

=head2 Functions/Muncthods

=over 4

=item * to_app

=item * wren

=item * add_model

=back

=head2 Methods

...exposit on object and request cycle from L</Description>.

=over 4

=item * env

=item * errors

=item * request

=item * response

=item * models

=back

=head1 MVC

=head2 Models

Only L<DBIx::Class> models are supported just now. Not intentional, just what is stubbed out.

This stuff should be descripted in abstract and index here and
detailed in Wren::Guide or something.

 add_model "NameSpace" =>
     class => "My::Schema",
     connect_info => [ "dbi:SQLite::memory:",
                       undef,
                       undef,
                       { RaiseError => 1,
                         AutoCommit => 1,
                         ChopBlanks => 1,
                         sqlite_unicode => 1, } ];

 my $schema = $wren->model("NameSpace");
 my $source_rs = $wren->model("NameSpace::Source");
 my @results = $wren->model("NameSpace::Source")
      ->search({ field => "value" });

=head1 Code Repository

L<http://github.com/pangyre/wren>.

=head1 Make this Tenable

=over 4

=item * Deployment guide, cookbook

=item * L<http://wiki.nginx.org/XSendfile>

=back

=head1 Author

Ashley Pond V E<middot> ashley@cpan.org.

=head1 License

Artistic 2.0.

=head1 Disclaimer of Warranty

Because this software is licensed free of charge, there is no warranty
for the software, to the extent permitted by applicable law. Except when
otherwise stated in writing the copyright holders and other parties
provide the software "as is" without warranty of any kind, either
expressed or implied, including, but not limited to, the implied
warranties of merchantability and fitness for a particular purpose. The
entire risk as to the quality and performance of the software is with
you. Should the software prove defective, you assume the cost of all
necessary servicing, repair, or correction.

In no event unless required by applicable law or agreed to in writing
will any copyright holder, or any other party who may modify or
redistribute the software as permitted by the above license, be
liable to you for damages, including any general, special, incidental,
or consequential damages arising out of the use or inability to use
the software (including but not limited to loss of data or data being
rendered inaccurate or losses sustained by you or third parties or a
failure of the software to operate with any other software), even if
such holder or other party has been advised of the possibility of
such damages.

=cut

 #  ID       QS     Content-Type   Encoding Char-Set        Lang   Size
  [['var1',  1.000, 'text/html',   undef,   'iso-8859-1',   'en',   3000],
   ['var2',  0.950, 'text/plain',  'gzip',  'us-ascii',     'no',    400],
   ['var3',  0.3,   'image/gif',   undef,   undef,          undef, 43555],
  ];


package MSS v0.0.1 {
    use Moo;
    use Path::Tiny;
    # Types...?
    has [qw/ request response /] =>
        is => "ro",
        required => 1,
        ;

    has "root" =>
        is => "ro",
        init_arg => undef,
        default => sub { path(__FILE__)->parent },
        ;

    has "static" =>
        is => "ro",
        init_arg => undef,
        default => sub { path(+shift->root,"static") },
        ;

    sub uri_for {
        require URI;
        my $self = shift;
        URI->new_abs(@_, $self->request->uri);
    }
}

my $Routes = "Router::R3"->new(
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
        my $args = shift;
        my $file = path($self->root, "static", $args->{resource});
        return $self->response->status(404) unless -f $file;
        return $self->response->status(403) unless -r _;
        require MIME::Types;
        my $type = "MIME::Types"->new->mimeTypeOf($file);
        # Cache headers? Or middleware?
        $type->encoding eq "8bit" ?
            $self->response->content_type(join";", $type->simplified, "charset=utf8")
            :
            $self->response->content_type($type->simplified);
        $self->response->body( $file->filehandle("<", ":bytes") );
    }},
    );

sub {
    my $env = shift; # PSGI env
    my $mss = "MSS"->new( request => Plack::Request->new($env),
                          response => Plack::Response->new(HTTP_NOT_FOUND) );
    # response => Plack::Response->new( status => +HTTP_NOT_FOUND ) );
    # ROUTING/DISPATCH--------------
    my ( $match, $captures ) = $Routes->match( $env->{PATH_INFO} );
    # Defaults.
    $mss->response->status(HTTP_OK) if $match;
    $mss->response->content_type("text/plain; charset=utf8");


    if ( $match )
    {
        if ( my $sub = $match->{ $env->{REQUEST_METHOD} } || $match->{"*"} )
        {
            eval { $sub->($mss,$captures) } || warn $/, $@, $/;
        }
        else
        {
            # my @acceptable = $... breaks down without access to match path logic
            $mss->response->status(406);
        }
    }

    $mss->response->body([ encode "UTF-8",
                           join "\n",
                           join(" ",
                                status_message( $mss->response->status ),
                                decode "UTF-8", $env->{PATH_INFO}),
                           "match: " . dump($match), dump($captures),
                           dump($env), dump([keys %INC]) ])
        unless $mss->response->body;

    $mss->response->finalize;
};

__DATA__

Consider doing a ->relative($self->static) in the uri_for because it
could be a no-op maybe when it's already relative but it will "do the
right thing" with web paths... not application aware though so it's in
fact sort of broken as is... Dispatch much be application object and
not just an irreversible run time map.

Should have a sendfile v self-managed static server.

=pod

=encoding utf8

=head1 Name

=head1 Synopsis

=head1 Description

=over 4

=item *

=back

=head1 Code Repository

L<http://github.com/pangyre/>.

=head1 See Also

WADO spec: L<http://medical.nema.org/Dicom/2011/11_18pu.pdf>.

Repository: L<https://bitbucket.org/pangyre/studyshare-html5-viewer>

=head1 Author

Ashley Pond V E<middot> ashley@cpan.org.

=head1 License

None!

=cut

