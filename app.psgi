my $dir;
BEGIN {
    use File::Spec;
    ( $dir ) = File::Spec->rel2abs( __FILE__ ) =~ m,\A(.+)/[^/]+\z,;
};

use lib "$dir/lib";
use Wren;
use Plack::Builder;

require MIME::Base64;
my $favicon = MIME::Base64::decode_base64(q{AAABAAEAEBAQAAEABAAoAQAAFgAAACgAAAAQAAAAIAAAAAEABAAAAAAAgAAAAAAAAAAAAAAAEAAAAAAAAAD///8AgPT/AICM9AB47MMAQIv0ANjYigB3g7QAOYriAHfrwADU1IAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEREAAAAAAAERERIiIAAAARERQiIiAAABERFCIiIAAAEYiHYiIgAAADiIZiIiAAAAmZmWYiAAAACZmZmQAAAAAAmZmQAAAAAABZmQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA});

use HTTP::Date "time2str";
my $last_mod = time2str( time() );

my $app = builder {
    enable "ConditionalGET";
    enable Headers =>
        set => [ "Last-Modified" => $last_mod ];

    # No... enable "Plack::Middleware::ETag", file_etag => ["inode","mtime"]; <- FH
    enable ETag =>
        cache_control => [ "must-revalidate", "max-age=300" ];

    mount "/favicon.ico" => sub { [ 200, [ "Last-Modified" => $last_mod, "Content-Type" => "image/x-icon" ],
                                    [ $favicon ] ] };

    mount "/" => Wren->new->to_app;
};

__END__

    mount "/favicon.ico" => sub { [ 204, [], [] ] };
