
class Silhouette {
  has @.polygons;

  method draw($image) {
    for @.polygons.list -> $polygon {
      say "Drawing $polygon";
      $polygon.draw($image);
    }
  }
}

