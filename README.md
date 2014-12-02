# Name

Wren - **Experimental** lightweight web framework.

# Synopsis

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

## Functions

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

# See Also

# Author

Ashley Pond V · ashley@cpan.org.

# License

Artistic 2.0.
