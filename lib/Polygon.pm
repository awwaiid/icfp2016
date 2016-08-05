
class Polygon {
  has @.vertices;

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

  method edges {
    # Slice these out into redundant pairs, looping back to the first
    # <a b c d e> ends up being a,b b,c c,d d,e e,a
    # This is what we want for the edges of our polygon
    (@.vertices, @.vertices.first).flat.rotor(2, -1);
  }

  method split-on($p1, $p2) {
    # split into multiple polygons
    # Maybe return two lists, one from the left and one from the right?
    my @output;
    my @crossbacks;

    for self.edges -> $v1, $v2 {
      # See if $p1->$p2 intercepts $v1, $v2
    }
  }

  method draw($image) {
    my $color = [(^256).pick, (^256).pick, (^256).pick];
    my $points = @.vertices.map(*.to-pair);
    $image.polygon(:$points, :$color);
  }
}
