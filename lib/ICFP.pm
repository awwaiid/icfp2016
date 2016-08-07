
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
use Origami;

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

sub shifted-solution( $problem ) is export  {
    my $p = Problem::Grammar.parse-problem( $problem );
    my ( $xmin, $ymin ) = $p.silhouette.get-min-coords();
    my @square = (
        [$xmin, $ymin],
        [$xmin, $ymin + 1],
        [$xmin + 1, $ymin + 1],
        [$xmin + 1, $ymin],
    );

    my $solution = "4\n";
    my $point_list = '';
    for @square -> ($x,$y) {
        my $x_str = $x.denominator == 1 ?? $x !! $x.numerator ~ '/' ~ $x.denominator;
        my $y_str = $y.denominator == 1 ?? $y !! $y.numerator ~ '/' ~ $y.denominator;
        $point_list ~= "$x_str,$y_str\n";
    }
    $solution ~= "0,0\n0,1\n1,1\n1,0\n";
    $solution ~= "1\n4 0 1 2 3\n";
    $solution ~= $point_list;

    return $solution;
}
