
use Polygon;
use Vertex;

class Facet {
  has $.polygon;
  has @.transforms;

  method split-on($p1, $p2) {
    # split into multiple polygons
    # Maybe return two lists, one from the left and one from the right?
  }
}

class Oragami {

  has @.facets;

  method BUILD {
    @.facets = [
      Facet.new( polygon => Polygon.new( vertices => [
        Vertex.new(:0x, :0y),
        Vertex.new(:1x, :0y),
        Vertex.new(:1x, :1y),
        Vertex.new(:0x, :1y)
      ]))
    ];
  }

  method fold( $p1, $p2 ) {
    # draw a line from p1 -> p2
    #   (OR along the perpendicular)
    # split polygons based on line
    # everything on the left gets reflected
  }
}

