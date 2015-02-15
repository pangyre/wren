# Name

Wren - **Experimental** lightweight web framework.

# Synopsis

DOCS ARE ENTIRELY UP THE AIR ON THIS BRANCH AND REPRESENT NOTHING RELIABLE.

# Description

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

## Functions/Muncthods

- add\_route
- add\_model
- add\_view
- root

    Gives [Path::Tiny](https://metacpan.org/pod/Path::Tiny) object of package's dir.

## Methods

...exposit on object and request cycle from ["Description"](#description).

- to\_app
- env
- router
- has\_errors
- errors
- request
- response
- models
- model
- views
- view
- finalize

# MVC

## Models

Only [DBIx::Class](https://metacpan.org/pod/DBIx::Class) models are supported just now. Not intentional, just what is stubbed out.

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

# Code Repository

[http://github.com/pangyre/wren](http://github.com/pangyre/wren).

# Make this Tenable

- Deployment guide, cookbook
- [http://wiki.nginx.org/XSendfile](http://wiki.nginx.org/XSendfile)

    [https://metacpan.org/pod/Plack::Middleware::XSendfile](https://metacpan.org/pod/Plack::Middleware::XSendfile). Now it is a
    recipe instead of code.

        # Nginx supports the X-Accel-Redirect header. This is similar to X-Sendfile
        # but requires parts of the filesystem to be mapped into a private URL
        # hierarachy.
        #
        # The following example shows the Nginx configuration required to create
        # a private "/files/" area, enable X-Accel-Redirect, and pass the special
        # X-Sendfile-Type and X-Accel-Mapping headers to the backend:
        #
        #   location /files/ {
        #     internal;
        #     alias /var/www/;
        #   }
        #
        #   location / {
        #     proxy_redirect     false;
        #
        #     proxy_set_header   Host                $host;
        #     proxy_set_header   X-Real-IP           $remote_addr;
        #     proxy_set_header   X-Forwarded-For     $proxy_add_x_forwarded_for;
        #
        #     proxy_set_header   X-Sendfile-Type     X-Accel-Redirect
        #     proxy_set_header   X-Accel-Mapping     /files/=/var/www/;
        #
        #     proxy_pass         http://127.0.0.1:8080/;
        #   }
        #
        # Note that the X-Sendfile-Type header must be set exactly as shown above. The
        # X-Accel-Mapping header should specify the name of the private URL pattern,
        # followed by an equals sign (=), followed by the location on the file system
        # that it maps to. The middleware performs a simple substitution on the
        # resulting path.
        #
        # See Also: http://wiki.codemongers.com/NginxXSendfile

- LOGGING? Logger?
- Plugins?

    Session, DBIC, etc, etc. XSRF... Rely on middleware.

# Author

Ashley Pond V � ashley@cpan.org.

# License

Artistic 2.0.

# Disclaimer of Warranty

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

