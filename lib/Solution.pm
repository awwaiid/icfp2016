
class Solution {
  has @.source-positions;
  has @.facets;
  has @.dest-positions;
}

class Facet {
  has $.polygon;
  has @.transforms; # [a,c], [a,c], ...
}

grammar Solution::Grammar {
  rule TOP {
    <source-positions>
    <facets>
    <dest-positions>
  }

  rule source-positions {
    $<vertex-count>=\d+
    <vertex> ** {$/<vertex-count>}
  }

  rule vertex { <location> "," <location> }

  rule location { \d+ [ "/" \d+ ]? }

  rule facets {
    $<facet-count>=\d+
    <facet> ** {$/<facet-count>}
  }

  rule facet {
    $<vertex-count>=\d+
    <vertex-id> ** {$/<vertex-count>} # Thse are IDs, not full vertexes
  }

  rule vertex-id { \d+ }

  rule dest-positions {
    $<vertex-count>=\d+
    <vertex> ** {$/<vertex-count>}
  }
}

class Solution::GrammarActions {
  method TOP($/) {
    make Solution.new(
      source-positions => $<source-positions>.made,
      factets          => $<facets>.made,
      dest-positions   => $<dest-positions>.made
    );
  }

  method source-positions($/) {
    make $<vertex>>>.made;
  }

  method dest-positions($/) {
    make $<vertex>>>.made;
  }

  method facets($/) {
    make $<vertex-id>>>.made;
  }

  method vertex-id($/) { (~$/).Int }
}

