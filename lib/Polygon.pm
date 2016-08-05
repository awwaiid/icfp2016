
class Polygon {
  has @.verticies;

  # Create an empty list of output polygons
  # Create an empty list of pending crossbacks (one for each polygon)
  # Find all intersections between the polygon and the line.
  # Sort them by position along the line.
  # Pair them up as alternating entry/exit lines.
  # Append a polygon to the output list and make it current.
  # Walk the polygon. For each edge:
  #     Append the first point to the current polygon.
  #     If there is an intersection with the split line:
  #         Add the intersection point to the current polygon.
  #         Find the intersection point in the intersection pairs.
  #         Set its partner as the crossback point for the current polygon.
  #         If there is an existing polygon with a crossback for this edge:
  #             Set the current polygon to be that polygon.
  #         Else
  #             Append a new polygon and new crossback point to the output lists and make it current.
  #         Add the intersection point to the now current polygon.


  method draw($image) {
    my $color = [(^256).pick, (^256).pick, (^256).pick];
    my $points = @.verticies.map(*.to-pair);
    $image.polygon(:$points, :$color);
  }
}
