
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
        Vertex.new(x => <0/1>, y => <0/1>),
        Vertex.new(x => <1/1>, y => <0/1>),
        Vertex.new(x => <1/1>, y => <1/1>),
        Vertex.new(x => <0/1>, y => <1/1>),

        # Crazy spiral
        # Vertex.new(x => <0/5>, y => <0/5>),
        # Vertex.new(x => <0/5>, y => <5/5>),
        # Vertex.new(x => <5/5>, y => <5/5>),
        # Vertex.new(x => <5/5>, y => <4/5>),
        # Vertex.new(x => <1/5>, y => <4/5>),
        # Vertex.new(x => <1/5>, y => <1/5>),
        # Vertex.new(x => <4/5>, y => <1/5>),
        # Vertex.new(x => <4/5>, y => <2/5>),
        # Vertex.new(x => <2/5>, y => <2/5>),
        # Vertex.new(x => <2/5>, y => <3/5>),
        # Vertex.new(x => <5/5>, y => <3/5>),
        # Vertex.new(x => <5/5>, y => <0/5>),
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

  multi format_pair(Array $p) {
    my ($x, $y) = $p;
    my $x_str = $x.denominator == 1 ?? $x !! $x.numerator ~ '/' ~ $x.denominator;
    my $y_str = $y.denominator == 1 ?? $y !! $y.numerator ~ '/' ~ $y.denominator;
    "$x_str $y_str";
  }

  multi format_pair(Str $p) {
    my ($x, $y) = $p;
    my $x_str = $x.denominator == 1 ?? $x !! $x.numerator ~ '/' ~ $x.denominator;
    my $y_str = $y.denominator == 1 ?? $y !! $y.numerator ~ '/' ~ $y.denominator;
    "$x_str $y_str";
  }

  method generate-solution {
    my $source = @.polygons>>.source-xy>>.Array.flat.Array;
    my $dest = @.polygons>>.current-xy>>.Array.flat.Array;
    my %source_to_dest = ($source.list Z $dest.list).flat.hash;
    my %dest_to_source = ($dest.list Z $source.list).flat.hash;

    # my %source_to_id = %source_to_dest.keys.sort.kv.reverse.hash;
    # my %id_to_source = %source_to_id.invert;

    my %id_to_source = $source.unique(:as(*.gist)).kv.hash;
    my %source_to_id = %id_to_source.antipairs.hash;

    my $result = "";

    # First the unique vertexes
    $result ~= "{%source_to_id.elems}\n";
    for %id_to_source.keys.sort -> $id {
      $result ~= format_pair(%id_to_source{$id}) ~ "\n";
    }

    # Then the facets
    $result ~= "{@.polygons.elems}\n";
    for @.polygons -> $polygon {
      $result ~= "{$polygon.vertices.elems}";
      for $polygon.vertices -> $vertex {
        my $id = %source_to_id{%dest_to_source{ $vertex.to-pair.Str }};
        $result ~= " $id";
      }
      $result ~= "\n";
    }

    # Finally the destination of the vertices
    # LREP::here;
        # my $x_str = $x.denominator == 1 ?? $x !! $x.numerator ~ '/' ~ $x.denominator;
        # my $y_str = $y.denominator == 1 ?? $y !! $y.numerator ~ '/' ~ $y.denominator;
    for ^%id_to_source.keys.sort -> $id {
      $result ~= format_pair(%source_to_dest{%id_to_source{$id}}) ~ "\n";
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

