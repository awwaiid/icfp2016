use Vertex;

class Polygon {
  has @.vertices;

  multi method add-vertex(Vertex $v) {
    @.verticies.push($v);
  }

  multi method add-vertex($x, $y) {
    my $v = Vertex.new(:$x, :$y);
    @.verticies.push($v);
  }

  sub determinant($x1,$y1,$x2,$y2) {
    $x1*$y2 - $x2*$y1;
  }

	sub segment_line_intersection(@p1, @p2, @p3, @p4) {
    say "Looking for segment {@p1} -> {@p2} intersecting {@p3} -- {@p4}";
		my @p5;
		my $n1 = determinant((@p3[0]-@p1[0]),(@p3[0]-@p4[0]),(@p3[1]-@p1[1]),(@p3[1]-@p4[1]));
		my $d  = determinant((@p2[0]-@p1[0]),(@p3[0]-@p4[0]),(@p2[1]-@p1[1]),(@p3[1]-@p4[1]));
    my $delta = 10 ** -7;
		if (abs($d) < $delta) {
      say "Parallel!";
			return; # parallel
		}
		if (!(($n1/$d < 1) && ($n1/$d > 0))) {
      say "Nope!";
			return; # not overlapping
		}
		@p5[0] = @p1[0] + $n1/$d * (@p2[0] - @p1[0]);
		@p5[1] = @p1[1] + $n1/$d * (@p2[1] - @p1[1]);
    say "Yep: {@p5}";
		return @p5; # intersection point
	}

  method edges {
    # Slice these out into redundant pairs, looping back to the first
    # <a b c d e> ends up being a,b b,c c,d d,e e,a
    # This is what we want for the edges of our polygon
    (@.vertices, @.vertices.first).flat.rotor(2 => -1).list;
  }

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


  method split-on($p1, $p2) {
    # split into multiple polygons
    # Maybe return two lists, one from the left and one from the right?
    my @output;
    my @crossbacks;

    my @intersections;
    for self.edges -> ($v1, $v2) {
      # See if $p1->$p2 intercepts $v1, $v2
      my @intersection = segment_line_intersection( $v1.to-pair, $v2.to-pair, $p1, $p2 );
      if @intersection {
        @intersections.push(@intersection);
      }
    }

    @intersections .= sort({ $^a[0] <=> $^b[0] || $^a[1] <=> $^b[1]});

    my %pairs;
    for @intersections -> ($a, $b) {
      %pairs{$a.perl} = $b;
      %pairs{$b.perl} = $a;
    }

    my @polygon-stack;
    my $current_polygon = Polygon.new;
    for self.edges -> ($v1, $v2) {
      $current_polygon.add_vertex($v1);
      # See if $p1->$p2 intercepts $v1, $v2
      my @intersection = segment_line_intersection( $v1.to-pair, $v2.to-pair, $p1, $p2 );
      if @intersection {
        my @pair_vertex = %pairs{@intersection.perl};
        if @pair_vertex {
          # We haven't started this one yet
          $current_polygon.add_vertex(flat @intersection);
          $current_polygon.add_vertex(flat @pair_vertex);
          push @polygon-stack, $current_polygon;
          $current_polygon = Polygon.new;
          $current_polygon.add_vertex(flat @intersection);
          $current_polygon.add_vertex(flat @pair_vertex);
        } else {
          # Now we're on the other side. Pop goes the weasle!
          $current_polygon = @polygon-stack.pop;
        }
      }
    }

  }

  method draw($image) {
    my $color = [(^256).pick, (^256).pick, (^256).pick];
    my $points = @.vertices.map(*.to-pair);
    $image.polygon(:$points, :$color);
  }
}
