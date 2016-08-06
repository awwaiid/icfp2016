
use LREP;
use Inline::Perl5;
use Imager:from<Perl5>;
use Data::Dump::Tree;
# use JSON::Tiny;
use JSON::Fast;

use Vertex;
use Polygon;
use Segment;
use Skeleton;
use Silhouette;
use Problem;
use Problem::Grammar;
use Solution;
use Oragami;

sub api-call($path, :$use-cache = True, :$decode-json = True) is export {
  my $filename = "data/{$path.subst(/\//, '_', :g)}";
  my $raw-result;
  if $use-cache && $filename.IO ~~ :e {
    $raw-result = slurp $filename;
  } else {
    say "Downloading $path";
    $raw-result = qqx«curl -s --compressed -L -H Expect: -H 'X-API-Key: 31-99e01d42cda065257f188de236e944ef' 'http://2016sv.icfpcontest.org/api/$path'»;
    spurt $filename, $raw-result;
    sleep 1; # They want us to wait a second for API limiting
  }
  if $decode-json {
    from-json($raw-result);
  } else {
    $raw-result;
  }
}

sub get-blob($hash, :$decode-json = True) is export {
  api-call("blob/$hash", :$decode-json);
}

sub send-solution($id, $solution) is export {
  spurt 'solution.txt', $solution;
  say qqx«curl -s --compressed -L -H Expect: -H 'X-API-Key: 31-99e01d42cda065257f188de236e944ef' -F 'problem_id=$id' -F 'solution_spec=@solution.txt' 'http://2016sv.icfpcontest.org/api/solution/submit'»;
  sleep 1;
}
