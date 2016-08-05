#!/usr/bin/env perl6

use lib 'lib';
use JSON::Tiny;
use LREP;
use Problem;


sub api-call($path, :$use-cache = True, :$decode-json = True) {
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

sub get-hash($hash, :$decode-json = True) {
  api-call("blob/$hash", :$decode-json);
}

# Get the current status, don't use cache
my $status-list = api-call('snapshot/list', :!use-cache);

# The lastmost one is the one we want
my $status-hash = $status-list<snapshots>[*-1]<snapshot_hash>;
my $game-state = get-hash($status-hash);

# Get the list of problems
my @problem_hashes = $game-state<problems>.list;
my @problems;
for @problem_hashes -> $problem_hash {
  push @problems, get-hash($problem_hash<problem_spec_hash>, :!decode-json);
}

sub parse-problem($problem) {
  my $a = Problem::Grammar::Actions.new;
  my $m = Problem::Grammar.parse($problem, actions => $a);
  $m.made;
}

my $p = parse-problem(@problems[0]);

LREP::here;

