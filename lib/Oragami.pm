
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
        # Vertex.new(:0x, :0y),
        # Vertex.new(:1x, :0y),
        # Vertex.new(:1x, :1y),
        # Vertex.new(:0x, :1y),
        Vertex.new(x => <0/5>, y => <0/5>),
        Vertex.new(x => <0/5>, y => <5/5>),
        Vertex.new(x => <5/5>, y => <5/5>),
        Vertex.new(x => <5/5>, y => <4/5>),
        Vertex.new(x => <1/5>, y => <4/5>),
        Vertex.new(x => <1/5>, y => <1/5>),
        Vertex.new(x => <4/5>, y => <1/5>),
        Vertex.new(x => <4/5>, y => <2/5>),
        Vertex.new(x => <2/5>, y => <2/5>),
        Vertex.new(x => <2/5>, y => <3/5>),
        Vertex.new(x => <5/5>, y => <3/5>),
        Vertex.new(x => <5/5>, y => <0/5>),
      ]))
    ];
  }

  method fold( $p1, $p2 ) {
  }


}

