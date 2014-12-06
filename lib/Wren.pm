use 5.16.2;
use strictures;
our $AUTHORITY = "cpan:ASHLEY";

package Wren v0.0.1 {
    use Moo;
    use MooX::late;
    use MooX::HandlesVia;
    use Wren::Error;

    use HTTP::Status ":constants", "status_message";
    use Exporter "import"; # "export_to_level";
    our @EXPORT = qw/ add_model add_route /;

    has errors =>
        is => "ro",
        traits  => ["Array"],
        handles => { error => "push",
                     has_errors => "count",
                     clear_errors => "clear" },
        default => sub { [] },
        ;

    has routes =>
        is => "lazy",
        traits  => ["Array"],
        ;

    has models =>
        is => "lazy",
        traits  => ["Hash"],
        handles => { get_model => "get" },
        ;

    has router =>
        is => "lazy",
        ;

    has env =>
        is => "rwp",
        clearer => 1,
        ;

    has request =>
        is => "lazy",
        # Maybe no shortcuts?
        # handles => [qw/ parameters query_parameters body_parameters referer user_agent param base uri /],
        clearer => 1;

    has response =>
        is => "lazy",
        clearer => 1;

    sub _build_request {
        require Plack::Request;
        "Plack::Request"->new( +shift->env );
    };

    sub _build_response {
        require Plack::Response;
        "Plack::Response"->new( HTTP_NOT_FOUND,
                                [ "Content-Type" => "text/plain; charset=utf-8" ] );
    }

#    sub import {
#        Exporter->export_to_level(1); # handle our exports
#    }

    my %_models;
    sub add_model {
        my $name = shift;
        if ( @_ == 1 and ref $_[0] eq "CODE" )
        {
            $_models{$name} = +shift;
        }
        else
        {
            require Wren::Model;
            $_models{$_->name} = $_ for Wren::Model->compose($name => @_);
        }
    }

    sub _build_models {
        # no warnings "redefine";
        # Not this... *add_model = sub { ... };
        \%_models; # Undefine or redefine add_model here to error out post _build?
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

    sub _build_routes { \@_routes };
    sub _build_router { require Router::R3; "Router::R3"->new(@_routes) };

    sub model {
        my ( $self, $model_name, @arg ) = @_;
        # say STDERR "HERE ",  $self->models;

        my $metamodel = $self->get_model($model_name)
            or Wren::Error->throw("No such model: $model_name");

        ref $metamodel eq  "CODE" ?
            $metamodel->(@arg)
            :
            $metamodel->model;
    }

    sub _reset { $_[0]->$_ for map "clear_$_", qw/ env request response errors / }

    sub finalize {
        my $self = shift;

        $self->response->body( status_message( $self->response->status ), ": ", $self->request->path )
            unless $self->response->body;

        if ( $self->has_errors )
        {
            $self->response->status(500);
            $self->response->body( join "\n", @{$self->errors} );
        }

        $self->response->finalize;
    }

    sub to_app {
        no warnings "uninitialized";
        my $self = shift;
        sub {
            $self->_reset;
            $self->_set_env( +shift );

            my ( $match, $captures ) = $self->router->match( $self->env->{PATH_INFO} );
            # use Data::Dump "dump"; say dump $match;
            # say STDERR "Matched route: ", $match->{route};

            my $code = $match->{code} || return $self->finalize; # Default is NOT_FOUND.
            $self->response->status(200); # New default is OK.

            $self->error( $@ || Wren::Error->new("Unkown error!") )
                unless "ok" eq eval { $code->( $self, $captures ); "ok" };

            if ( $self->has_errors )
            {
                $self->response->status(500);
                $self->response->body( join "\n", @{$self->errors} );
            }

            #$self->response->status(HTTP_NOT_FOUND);# unless $self->response->status;
            #$self->response->body   || $self->response->body([ status_message( $self->response->status ), ": ", $self->request->path ]);

            $self->response->finalize;
            # return [ 200, [ "Content-Type" => "text/plain" ], [ "OHAI\n"] ];
        };
    }
};

"Winter";

__END__

=pod

=encoding utf-8

=head1 Name

Wren - B<Experimental> lightweight web framework.

=head1 Synopsis

DOCS ARE ENTIRELY UP THE AIR ON THIS BRANCH AND REPRESENT NOTHING RELIABLE.

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

=item * add_route

=item * add_model

=back

=head2 Methods

...exposit on object and request cycle from L</Description>.

=over 4

=item * to_app

=item * env

=item * router

=item * has_errors

=item * errors

=item * request

=item * response

=item * models

=item * model

=item * finalize

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


Consider doing a ->relative($self->static) in the uri_for because it
could be a no-op maybe when it's already relative but it will "do the
right thing" with web paths... not application aware though so it's in
fact sort of broken as is... Dispatch much be application object and
not just an irreversible run time map.

Should have a sendfile v self-managed static server.


FFFFFFF...FFFFF...F...F...FFFFFF...

RFC 2616
    OPTIONS
    GET
    HEAD
    POST
    PUT
    DELETE
    TRACE
    CONNECT
RFC 2518
    PROPFIND
    PROPPATCH
    MKCOL
    COPY
    MOVE
    LOCK
    UNLOCK
RFC 3253
    VERSION-CONTROL
    REPORT
    CHECKOUT
    CHECKIN
    UNCHECKOUT
    MKWORKSPACE
    UPDATE
    LABEL
    MERGE
    BASELINE-CONTROL
    MKACTIVITY
RFC 3648
    ORDERPATCH
RFC 3744
    ACL
draft-dusseault-http-patch
    PATCH
draft-reschke-webdav-search
    SEARCH
