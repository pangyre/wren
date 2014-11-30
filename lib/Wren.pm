use 5.14.2;

package Wren v0.0.1 {
    use Moo;
    use MooX::late;
    use MooX::HandlesVia;
    use Plack::Request;
    use Plack::Response;
    use HTTP::Status ":constants", "status_message";
    use Wren::Error;
    use parent "Exporter";
    # use Exporter "import";
    our @EXPORT = qw( add_model $wren );

    my $wren;
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
        my $schema = "$arg{class}"->connect( $arg{connect_info} );
        $wren->set_model( $name => $schema ); # iterate on named Sources?
        for my $source ( $wren->model("DB")->sources )
        {
            $wren->set_model( join("::",$name,$source) => $schema->resulset($source) );
        }
    }
}

"Winter"

__END__
    #use Path::Tiny;
    #use HTTP::Negotiate "choose";
    #use HTTP::Headers::Util qw( split_header_words join_header_words );
    #use HTML::Entities;
    #use HTTP::Date;
    #use Encode qw( encode decode );
    require Wren::Error;

    sub BUILDARGS { @_ == 2 ? { env => $_[1] } : { @_[1..$#_-1] } };

    has [qw/ env /] =>
        is => "ro",
        required => 1;

    has "request" =>
        is => "lazy",
        # Maybe not all these shortcuts?
        # handles => [qw/ parameters query_parameters body_parameters referer user_agent param base uri /],
        default => sub { "Plack::Request"->new( +shift->env ) };
        
    has "response" =>
        is => "lazy",
        default => sub {
            "Plack::Response"->new(HTTP_NOT_FOUND,
                                   [ Content_Type => "text/plain; charset=utf-8" ]);
        };

    has "errors" =>
        is => "ro",
        isa => sub { ref $_[0] eq "ARRAY" },
        default => sub { [] };

    sub app {
        Wren::Error->throw("The method ", __PACKAGE__, "->", "app cannot accept arguments")
            unless $_[0] eq __PACKAGE__ and @_ == 1;

        sub {
            my $self = __PACKAGE__->new( $_[0] );
            eval {
                1; # Dispatch stuff...
            };

            $self->response->status(HTTP_NOT_ACCEPTABLE) if $@;

            $self->response->body([ join(": ", $self->response->status, status_message( $self->response->status )), 
                                    $/, "Requested resource: ", $self->request->path,
                                    $/, $/, $@ ])
                unless $self->response->body;

            $self->response->finalize;
        };
    }
};

"Winter";

__END__

=pod

=encoding utf8

=head1 Name

Wren - ...

=head1 Synopsis

=head1 Description

=over 4

=item * app

=item * env

=item * errors

=item * request

=item * response

=back

=head1 MVC

=head2 Models

=over 4

=item * add_model

Only L<DBIx::Class> models are supported just now. Not intentional, just what is stubbed out.

 add_model "NameSpace" =>
     class => "My::Schema",
     connect_info => [ "dbi:SQLite::memory:",
                       undef,
                       undef,
                       { RaiseError => 1,
                         AutoCommit => 1,
                         ChopBlanks => 1,
                         sqlite_unicode => 1, } ];

 $wren->model("NameSpace"); # Gets Schema

 $wren->model("NameSpace::Source"); # Gets resultset for source (usually a table).

=back

=head1 Code Repository

L<http://github.com/pangyre/wren>.

=head1 See Also


=head1 Author

Ashley Pond V E<middot> ashley@cpan.org.

=head1 License

Artistic 2.0.

=cut

 #  ID       QS     Content-Type   Encoding Char-Set        Lang   Size
  [['var1',  1.000, 'text/html',   undef,   'iso-8859-1',   'en',   3000],
   ['var2',  0.950, 'text/plain',  'gzip',  'us-ascii',     'no',    400],
   ['var3',  0.3,   'image/gif',   undef,   undef,          undef, 43555],
  ];

