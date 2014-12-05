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

- to\_app
- wren
- add\_model

## Methods

...exposit on object and request cycle from ["Description"](#description).

- env
- errors
- request
- response
- models

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

# Author

Ashley Pond V · ashley@cpan.org.

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
