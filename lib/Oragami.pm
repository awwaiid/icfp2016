
use Polygon;
use Vertex;

class Facet {
  has $.polygon;
  has @.transforms;
}

class Oragami {

  has @.facets;

  method BUILD {
    @.facets = [
      Facet.new( polygon => Polygon.new( verticies => [
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

