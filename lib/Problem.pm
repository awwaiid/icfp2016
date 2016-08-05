#!perl6

class Vertex {
  has $.x;
  has $.y;
  method to-pair {
    [$.x * 100, $.y * 100]
  }
}

class Polygon {
  has @.verticies;
  method draw($image) {
    my $color = [(^256).pick, (^256).pick, (^256).pick];
    my $points = @.verticies.map(*.to-pair);
    $image.polygon(:$points, :$color);
  }
}

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
}

# use Grammar::Tracer;
grammar Problem::Grammar {

  rule TOP {
    <silhouette>
    <skeleton>
  }

  rule silhouette {
    $<polygon-count>=\d+
    # <polygons($/<polygon-count>)>
    <polygon> ** {$/<polygon-count>}
  }

  # rule polygons($count) { <polygon> ** {$count} }

  rule polygon {
    $<vertex-count>=\d+
    <vertex> ** {$/<vertex-count>}
  }

  rule vertex { <location> "," <location> }

  rule location { \d+ [ "/" \d+ ]? }

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
