requires "parent";
requires "Moo";
requires "MooX::HandlesVia";
requires "MooX::late";
requires "Plack";
requires "Plack::Middleware::Headers";
requires "HTTP::Status";
requires "Path::Tiny";
requires "URI";

on build => sub {
   requires "Module::CPANfile::Result";
};

on test => sub {
    requires "Test::More" => 1;
    requires "Test::Fatal" => "0.01";
    requires "SQL::Translator" => "0.11018",
    requires "DBIx::Class" => "0.082";
    requires "Pod::Coverage::Moose" => "0.05";
};
