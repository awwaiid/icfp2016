#!/usr/bin/env perl6

use lib 'lib';
use ICFP;

# Get the current status, don't use cache
# my $status-list = api-call('snapshot/list', :!use-cache);
my $status-list = api-call('snapshot/list', :use-cache);

# The lastmost one is the one we want
my $status-hash = $status-list<snapshots>[*-1]<snapshot_hash>;
my $game-state = get-blob($status-hash);

# Get the list of problems
my @problem_hashes = $game-state<problems>.list;
my @problems;
for @problem_hashes -> $problem_hash {
  push @problems, get-blob($problem_hash<problem_spec_hash>, :!decode-json);
}

multi MAIN("hello") {
  my $p = Problem::Grammar.parse-problem(@problems[0]);
  LREP::here;
}

multi MAIN("help") {
  say "hmm...";
}

multi MAIN("upload-trivial") {
  my $boring-solution = q:to/END/;
    4
    0,0
    0,1
    1,1
    1,0
    1
    4 0 1 2 3
    0,0
    0,1
    1,1
    1,0
    END

  for @problem_hashes -> $problem_hash {
    my $id = $problem_hash<problem_id>;
    if $id > 1000 {
      say "Sending $id";
      send-solution($id, $boring-solution);
    }
  }
}

multi MAIN("all-images") {

  for @problems.kv -> $index, $problem {
      my $p = Problem::Grammar.parse-problem($problem);

      my $image = Imager.new(xsize => 1000, ysize => 1000);
      $image.polyline( points => [ [0,0], [0,999], [999,999], [999,0], [0,0] ], color => 'red');
      $p.draw($image);
      $image.flip(dir => 'v');
      $image.write(file => "images/problem_$index.png");
  }
}

multi MAIN("oragami") {
  my $g = Oragami.new;
  my $p = $g.facets[0].polygon;
  $p.split-on( (0, 1/2), (1, 1/2) );

  $g.fold( [0,1], [1,0] );
  say $g.score_for($p);
}




