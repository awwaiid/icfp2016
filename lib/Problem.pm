#!perl6

use Vertex;
use Polygon;

class Segment {
  has $.from-vertex;
  has $.to-vertex;

  method draw($image) {
    my $color = [(^256).pick, (^256).pick, (^256).pick];
    $image.line(
      x1 => $.from-vertex.x * 100,
      y1 => $.from-vertex.y * 100,
      x2 => $.to-vertex.x * 100,
      y2 => $.to-vertex.y * 100,
      :$color
    );
  }
}

class Skeleton {
  has @.segments;

  method draw($image) {
    for @.segments.list -> $segment {
      $segment.draw($image);
    }
  }
}

class Silhouette {
  has @.polygons;

  method draw($image) {
    for @.polygons.list -> $polygon {
      say "Drawing $polygon";
      $polygon.draw($image);
    }
  }
}

class Problem {
  has $.silhouette;
  has $.skeleton;

  method draw($image) {
    $.silhouette.draw($image);
    $.skeleton.draw($image);
  }
}

class Solution {
  has @.source-positions;
  has @.facets;
  has @.dest-positions;
}

class Facet {
  has $.polygon;
  has @.transforms; # [a,c], [a,c], ...
}

class Oragami {
  has @.facets;
  method fold( $p1, $p2 ) {
  }
}

# use Grammar::Tracer;
grammar Problem::Grammar {

  rule TOP {
    <silhouette>
    <skeleton>
  }

  rule silhouette {
    $<polygon-count>=\d+
    <polygon> ** {$/<polygon-count>}
  }

  # rule polygons($count) { <polygon> ** {$count} }

  rule polygon {
    $<vertex-count>=\d+
    <vertex> ** {$/<vertex-count>}
  }

  rule vertex { <location> "," <location> }

  rule location { "-"?\d+ [ "/" \d+ ]? }

  rule skeleton {
    $<segment-count>=\d+
    <segment> ** {$/<segment-count>}
  }

  rule segment { <vertex> <vertex> }
}

class Problem::Grammar::Actions {
  method TOP($/) {
    make Problem.new( silhouette => $<silhouette>.made, skeleton => $<skeleton>.made );
  }
  method silhouette($/) {
    make Silhouette.new( polygons => $<polygon>>>.made );
  }
  method polygon($/) {
    make Polygon.new( verticies => $<vertex>>>.made );
  }
  method vertex($/) {
    make Vertex.new( x => $<location>[0].made, y => $<location>[1].made );
  }
  method location($/) {
    make (~$/).Rat;
  }
  method skeleton($/) {
    make Skeleton.new( segments => $<segment>>>.made );
  }
  method segment($/) {
    make Segment.new( from-vertex => $<vertex>[0].made, to-vertex => $<vertex>[1].made );
  }
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

