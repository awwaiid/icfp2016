
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
