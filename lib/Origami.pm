
use Polygon;
use Vertex;
use Imager:from<Perl5>;

class Origami {

  has @.polygons;

  method BUILD {

    # By default we just one one plain piece of square paper
    @.polygons = [
      Polygon.new( vertices => [
        # Simple paper
        # Vertex.new(x => <0/1>, y => <0/1>),
        # Vertex.new(x => <1/1>, y => <0/1>),
        # Vertex.new(x => <1/1>, y => <1/1>),
        # Vertex.new(x => <0/1>, y => <1/1>),

        # Crazy spiral
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
      ])
    ];
  }

  method fold-all($p1, $p2) {
    my @new_polygons;
    for @.polygons -> $polygon {
      for $polygon.split-on($p1, $p2) -> $new_polygon {
        @new_polygons.push($new_polygon);
      }
    }
    @.polygons = @new_polygons;
  }

  method unfolded {
    my $undone = Origami.new;
    $undone.polygons = @.polygons>>.unfolded;
    return $undone;
  }

  method generate-solution {
    my $source = @.polygons>>.source-xy>>.Array.flat.Array;
    my $dest = @.polygons>>.current-xy>>.Array.flat.Array;
    my %m = ($source.list Z $dest.list).flat.hash;
    my %v_id = %m.keys.sort.kv.reverse.hash;
    my $result = "";
    $result ~= "{%v_id.elems}\n";
    for %v_id.keys.sort -> $xy {
      $result ~= "{$xy}\n";
    }
    $result ~= "{@.polygons.elems}\n";
    LREP::here;
    for @.polygons -> $polygon {
      $result ~= "{$polygon.vertices.elems}";
      for $polygon.vertices -> $vertex {
        my $id = %v_id{ $vertex.to-pair.Str };
        $result ~= " $id";
      }
      $result ~= "\n";
    }
    for ^%v_id.elems -> $id {
      $result ~= "d $id {%m{%v_id.reverse{$id}}}\n";
    }
    $result;
  }

  method draw($image) {
    @.polygons.map(*.draw($image));
  }

  method draw-file($filename) {
    my $image = Imager.new(xsize => 1000, ysize => 1000);
    $image.polyline( points => [ [0,0], [0,999], [999,999], [999,0], [0,0] ], color => 'red');
    self.draw($image);
    $image.flip(dir => 'v');
    $image.write(file => $filename);
  }

}

