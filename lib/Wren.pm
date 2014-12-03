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
    our @EXPORT = qw( add_model wren );

    my $wren;
    sub wren { $wren } # No, but for now...

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


=head2 Functions

=over 4

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

=head1 See Also

...

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



