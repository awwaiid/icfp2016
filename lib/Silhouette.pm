
class Silhouette {
  has @.polygons;

  method draw($image, $xmin, $ymin) {
    for @.polygons.list -> $polygon {
      say "Drawing $polygon";
      $polygon.draw($image, $xmin, $ymin);
    }
  }

  method get-min-coords {
    my ($xmin, $ymin) = @.polygons.list[0].bounding-box-min();
    for @.polygons.list -> $polygon {
        my ($x, $y) = $polygon.bounding-box-min();
        $xmin = $x if $x < $xmin;
        $ymin = $y if $y < $ymin;
    }

    return [$xmin, $ymin];
  }
}

