
use Vertex;
use Polygon;
use Segment;
use Skeleton;
use Silhouette;
use Problem;

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
