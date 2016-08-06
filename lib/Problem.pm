#!perl6


class Problem {
  has $.silhouette;
  has $.skeleton;

  method draw($image) {
    my ($xmin, $ymin) = $.silhouette.get-min-coords();
    $.silhouette.draw($image, $xmin, $ymin);
    $.skeleton.draw($image, $xmin, $ymin);
  }
}

