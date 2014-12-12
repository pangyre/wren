requires "parent";
requires "Moo";
requires "MooX::late";
requies "MooX::ClassAttribute";
requires "MooX::HandlesVia";

requires "Scalar::Util";
requires "strictures";
requires "Plack";
requires "Plack::Middleware::Headers";
requires "HTTP::Status";
requires "Path::Tiny";
requires "URI";
requires "Router::R3";

# Maybe be more agnostic?
requires "Text::Xslate";

on build => sub {
   requires "Module::CPANfile::Result";
};

on test => sub {
    requires "Data::Dump" => 1;
    requires "Test::Most" => 1;
    requires "Test::More" => 1;
    requires "Test::Fatal" => "0.01";
    requires "DBIx::Class" => "0.082";
    requires "SQL::Translator" => "0.11018",
    requires "Pod::Coverage::Moose" => "0.05";
    requires "Time::HiRes" => "1.9726";
    requires "Plack::Middleware::Session";
};
