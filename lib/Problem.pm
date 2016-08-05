#!perl6


class Problem {
  has $.silhouette;
  has $.skeleton;

  method draw($image) {
    $.silhouette.draw($image);
    $.skeleton.draw($image);
  }
}

