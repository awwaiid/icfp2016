#!/usr/bin/env perl6

use JSON::Tiny;
# use LREP;

# my $status_json = qx«curl -s --compressed -L -H Expect: -H 'X-API-Key: 31-99e01d42cda065257f188de236e944ef' 'http://2016sv.icfpcontest.org/api/snapshot/list'»;

my $status_json = q«{"ok":true,"snapshots":[{"snapshot_hash":"89c4c40226f4efcdb8fc58c9f74339d768ef4737","snapshot_time":1470322800},{"snapshot_hash":"055ed1e43c6c8632c2a980476fa48068ab6cb668","snapshot_time":1470326400},{"snapshot_hash":"704c2e572cac17af59449d2faf6003d3f98d35d2","snapshot_time":1470330000},{"snapshot_hash":"7eb37ebb9131198accaf9a5676b85a61aa547028","snapshot_time":1470333600},{"snapshot_hash":"28815b002de153ffffd43e8026ded96ffe6c6170","snapshot_time":1470337200},{"snapshot_hash":"b8bea9c89823058ece06e7ebb882e95790408284","snapshot_time":1470340800},{"snapshot_hash":"7de2715006b5c1d802858a8012aa06b46b0b315e","snapshot_time":1470344400},{"snapshot_hash":"3c2462860b559c38f18149f98e61aa8315245a94","snapshot_time":1470348000},{"snapshot_hash":"14d559294d8cf3d473eb639c7304add7ad678b37","snapshot_time":1470351600},{"snapshot_hash":"cb852d8e9ab6a1e9fbb2d471e30427fbad8097d6","snapshot_time":1470355200},{"snapshot_hash":"e613b3bbddf467b39c630d8c290c9d19ce11169c","snapshot_time":1470358800},{"snapshot_hash":"d3b221f5606083d47a1470ce875260aa0c147381","snapshot_time":1470362400}]}»;

say $status_json;

my $status = from-json($status_json);
# say $status;

# LREP::here;

for $status<snapshots>.map(*<snapshot_hash>) -> $snapshot_hash {
  my $filename = "data/snapshot_{$snapshot_hash}.json";
  if $filename.IO !~~ :e {
    say "Downloading new hash $snapshot_hash";
    qqx«curl -s --compressed -L -H Expect: -H 'X-API-Key: 31-99e01d42cda065257f188de236e944ef' 'http://2016sv.icfpcontest.org/api/blob/$snapshot_hash' > $filename»;
    sleep 1;
  }
}

