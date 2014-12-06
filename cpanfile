# Only TRIAL so far, requires "mop" => "0.03";
requires "parent";
requires "strictures";
requires "Plack";
requires "Plack::Middleware::Headers";
requires "HTTP::Status";
requires "Path::Tiny";
requires "URI";
requires "Router::R3";

on build => sub {
   requires "Module::CPANfile::Result";
};

on test => sub {
    requires "Test::More" => 1;
    requires "Test::Fatal" => "0.01";
    requires "DBIx::Class" => "0.082";
    requires "SQL::Translator" => "0.11018",
    requires "Pod::Coverage::Moose" => "0.05";
    requires "Time::HiRes" => "1.9726";
};
