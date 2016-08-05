
class Skeleton {
  has @.segments;

  method draw($image) {
    for @.segments.list -> $segment {
      $segment.draw($image);
    }
  }
}
