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

my $p = Problem::Grammar.parse-problem(@problems[0]);

# my $boring-solution = q:to/END/;
#   4
#   0,0
#   0,1
#   1,1
#   1,0
#   1
#   4 0 1 2 3
#   0,0
#   0,1
#   1,1
#   1,0
#   END

# for @problem_hashes -> $problem_hash {
#   my $id = $problem_hash<problem_id>;
#   send-solution($id, $boring-solution);
# }

# for @problems.kv -> $index, $problem {
#     my $p = parse-problem( $problem );

#     my $image = Imager.new(xsize => 1000, ysize => 1000);
#     $image.polyline( points => [ [0,0], [0,999], [999,999], [999,0], [0,0] ], color => 'red');
#     $p.draw($image);
#     $image.flip(dir => 'v');
#     $image.write(file => "images/problem_$index.png");
# }

# my $g = Oragami.new;
# $g.fold( [0,1], [1,0] );
# say $g.score_for($p);

LREP::here;

