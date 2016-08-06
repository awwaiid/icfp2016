
class Skeleton {
  has @.segments;

  method draw($image, $xmin, $ymin) {
    my @segs = @.segments.list;
    for @.segments.list -> $segment {
      $segment.draw($image, $xmin, $ymin);
    }
  }
}
