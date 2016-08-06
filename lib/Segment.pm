
class Segment {
  has $.from-vertex;
  has $.to-vertex;

  method draw($image, $xmin, $ymin) {
    my $color = [(^256).pick, (^256).pick, (^256).pick];
    $image.line(
      x1 => ( $.from-vertex.x - $xmin ) * 1000,
      y1 => ( $.from-vertex.y - $ymin ) * 1000,
      x2 => ( $.to-vertex.x - $xmin ) * 1000,
      y2 => ( $.to-vertex.y - $ymin ) * 1000,
      :$color
    );
  }
}
