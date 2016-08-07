
use Vertex;

class Polygon {
  has @.vertices;
  has @.reflection-history;

  multi method add-vertex(Vertex $v) {
    @.vertices.push($v);
  }

  multi method add-vertex($x, $y) {
    my $v = Vertex.new(:$x, :$y);
    @.vertices.push($v);
  }

  sub determinant($x1,$y1,$x2,$y2) {
    $x1*$y2 - $x2*$y1;
  }

	sub segment-line-intersection(@p1, @p2, @p3, @p4) {
    # say "Looking for segment {@p1} -> {@p2} intersecting {@p3} -- {@p4}";
		my @p5;
		my $n1 = determinant((@p3[0]-@p1[0]),(@p3[0]-@p4[0]),(@p3[1]-@p1[1]),(@p3[1]-@p4[1]));
		my $d  = determinant((@p2[0]-@p1[0]),(@p3[0]-@p4[0]),(@p2[1]-@p1[1]),(@p3[1]-@p4[1]));
    # my $delta = 10 ** -7;
		# if (abs($d) < $delta) {
		# if $n1/$d == 0 {
      # return "start";
    # }
		# if $n1/$d == 1 {
      # return "end";
    # }
		if $d == 0 { # Maybe we can get away without delta in Rat land
      # say "Parallel!";
			return False; # parallel
		}
		if !(($n1/$d <= 1) && ($n1/$d >= 0)) {
      # say "Nope!";
			return False; # not overlapping
		}
		@p5[0] = @p1[0] + $n1/$d * (@p2[0] - @p1[0]);
		@p5[1] = @p1[1] + $n1/$d * (@p2[1] - @p1[1]);
    # say "Yep: {@p5}";
		return @p5; # intersection point
	}

  # sub on-line(@point, @line_p1, @line_p2) {
  #   my $dxc = @point[0] - @line_p1[0];
  #   my $dyc = @point[1] - @line_p1[1];

  #   my $dxl = @line_p2[0] - @line_p1[0];
  #   my $dxl = @line_p2[1] - @line_p1[1];

  #   $dxc * $dyl - $dyc * $dxl == 0;
  # }

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
      my $intersection = segment-line-intersection( $v1.to-pair, $v2.to-pair, $p1, $p2 );
      if $intersection {
        @intersections.push($intersection);
      }
    }

    @intersections .= sort({ $^a[0] <=> $^b[0] || $^a[1] <=> $^b[1]});
    @intersections .= squish(:as(*.gist));
    # say "Intersections: {@intersections.gist}";

    my %pairs;
    for @intersections.rotor(2) -> ($a, $b) {
      %pairs{$a.gist} = $b;
      %pairs{$b.gist} = $a;
    }

    # Ignore intersections that are part of a fold on an edge
    my $ignore = set();
    for self.edges -> ($v1, $v2) {
      # say "Looking for {$v1.to-pair.gist} -> {$v2.to-pair.gist}";
      if %pairs{$v1.to-pair.gist}:exists && %pairs{$v1.to-pair.gist}.gist eq $v2.to-pair.gist {
        %pairs{$v1.to-pair.gist}:delete;
        %pairs{$v2.to-pair.gist}:delete;
        $ignore (|)= $v1.to-pair.gist;
        $ignore (|)= $v2.to-pair.gist;
      } else {
        # say "Didn't find it.";
      }
    }

    # say "Pairs: {%pairs.gist}";
    # say "Ignore: {$ignore.gist}";


    my @polygon-stack;
    my @all-polygons;
    my $current-polygon = Polygon.new(reflection-history => @.reflection-history);
    @all-polygons.push($current-polygon);
    for self.edges -> ($v1, $v2) {
      # say "Working edge {$v1.to-pair} -> {$v2.to-pair}";
      # LREP::here;
      $current-polygon.add-vertex($v1);
      # say "Added edge to current: {$current-polygon.gist}";
      # See if $p1->$p2 intercepts $v1, $v2
      # my $i2 = segment-line-intersection( $v2.to-pair, $v1.to-pair, $p1, $p2 );
      my $intersection = segment-line-intersection( $v1.to-pair, $v2.to-pair, $p1, $p2 );
      if $intersection && $intersection.gist ne $v2.to-pair.gist && $intersection.gist !(elem) $ignore {
        # say "Found intersection at $intersection";
        my $pair-vertex = %pairs{$intersection.gist};

        # if $pair-vertex and $intersection are on the fold
        #    and they are end-points
        #    then ignore them

        if $pair-vertex {
          # say "We haven't started this one yet";
          %pairs{$intersection.gist}:delete;
          %pairs{$pair-vertex.gist}:delete;
          # say "i: {$intersection.gist} v1: {$v1.to-pair.gist}";
          if $intersection.gist eq $v1.to-pair.gist {
            # say "Not adding redundant vertex";
          }
          if $intersection.gist ne $v1.to-pair.gist {
            $current-polygon.add-vertex(|$intersection);
          }
          $current-polygon.add-vertex(|$pair-vertex);
          push @polygon-stack, $current-polygon;
          # say "Pushed current: {$current-polygon.gist}";
          $current-polygon = Polygon.new(reflection-history => @.reflection-history);
          @all-polygons.push($current-polygon);
          $current-polygon.add-vertex(|$pair-vertex);
          $current-polygon.add-vertex(|$intersection);
        } else {
          # say "Now we're on the other side.";
          # if $intersection.gist eq $v1.to-pair.gist {
          #   # say "... or are we?";
          if $intersection.gist eq $v2.to-pair.gist {
            # say "... or maybe not?";
          } else {
            # say "Pop goes the weasle!";
            $current-polygon = @polygon-stack.pop;
          }
        }
      }
      # say "current: {$current-polygon.gist}";
      # say "stack: {@polygon-stack>>.gist}";
      # say "all: {@all-polygons>>.gist}";
    }


    my ($p1_x, $p1_y) = $p1;
    my ($p2_x, $p2_y) = $p2;

    my $fixed_p2_x = $p2_x - $p1_x;
    my $fixed_p2_y = $p2_y - $p1_y;

    # say "base $p1_x, $p1_y";
    # say "norm $fixed_p2_x, $fixed_p2_y";

    for @all-polygons -> $polygon {

      # say "Considering flipping {$polygon.gist}";
      for $polygon.vertices -> $v {
        my ($vx, $vy) = $v.to-pair;
        # Normalize to new origin
        $vx -= $p1_x;
        $vy -= $p1_y;
        next if $vx == 0 && $vy == 0;
        my $angle = (atan2($vy, $vx) - atan2($fixed_p2_y, $fixed_p2_x)) % tau;
        if $angle > 0 {
          # say "$angle ($vx, $vy): {$polygon.gist}";
          if $angle < tau/2 {
            # say "LEFT. Let's reflect.";
            $polygon.reflect($p1, $p2);
            # say "New polygon: {$polygon.gist}";
          } else {
            # say "RIGHT";
          }
          last;
        }
      }
    }

    @all-polygons;
  }

  method mirror($mirror-x) {
    my @new_vertices;
    for @.vertices -> $vertex {
      my ($x, $y) = $vertex.to-pair;
      my $dist = $x - $mirror-x;
      my $new_x = $x - 2 * $dist;
      my $new_y = $y;
      # $vertex.move-to($new_x, $new_y);
      @new_vertices.push( Vertex.new(x => $new_x, y => $new_y) );
    }
    @!vertices = @new_vertices;
  }

  method reflect($p1, $p2, $save_reflection = True) {
    @.reflection-history.push([$p1, $p2]) if $save_reflection;
    my ($p1_x, $p1_y) = $p1;
    my ($p2_x, $p2_y) = $p2;
    if $p2_x - $p1_x == 0 {
      return self.mirror($p1_x);
    }
    my $slope = ($p2_y - $p1_y) / ($p2_x - $p1_x);
    my $intercept = $p1_y - $slope * $p1_x;
    # say $p1_x;
    # say $p1_y;
    # say $p2_x;
    # say $p2_y;
    # say $slope;
    # say $intercept;
    # say "({$p1_x}, {$p1_y}) -> ({$p2_x}, {$p2_y}) slope: {$slope} int: {$intercept}";
    my &d = -> $x, $y, $slope, $intercept {
      ($x + $slope * ($y - $intercept)) / (1 + $slope ** 2)
    };

    my @new_vertices;
    for @.vertices -> $vertex {
      my ($x, $y) = $vertex.to-pair;
      my $d = &d($x, $y, $slope, $intercept);
      my $new_x = 2 * $d - $x;
      my $new_y = 2 * $d * $slope - $y + 2 * $intercept;
      # $vertex.move-to($new_x, $new_y);
      @new_vertices.push( Vertex.new(x => $new_x, y => $new_y) );
    }
    @!vertices = @new_vertices;
  }

  method current-xy {
    @.vertices.map(*.to-pair);
  }

  method source-xy {
    my $p = self.clone;
    for @.reflection-history.reverse -> ($p1, $p2) {
      $p.reflect($p1, $p2, False);
    }
    $p.vertices.map(*.to-pair);
  }

  method unfolded {
    my $p = self.clone;
    for @.reflection-history.reverse -> ($p1, $p2) {
      $p.reflect($p1, $p2, False);
    }
    return $p;
  }

  method clone {
    Polygon.new( vertices => @.vertices>>.clone );
  }

  method gist {
    "Polygon[ { @.vertices.map(*.to-pair.gist).join("->") } ]";
  }

  method draw($image, $xmin = 0, $ymin = 0, $given_color = False) {
    my $color = $given_color || [(^256).pick, (^256).pick, (^256).pick];
    my $unoffset = @.vertices.map(*.to-pair).list;
    my $points = $unoffset.map(-> ($x, $y) { [ ($x - $xmin) * 1000, ($y - $ymin) * 1000 ] } ).list;
    $image.polygon(:$points, :$color);
  }

  method bounding-box() {
    my @points = @.vertices.map(*.to-pair);
    my ($xmin, $xmax, $ymin, $ymax);
    for @points -> ($x, $y) {
        $xmin = $x if ! $xmin.defined || $x < $xmin;
        $xmax = $x if ! $xmax.defined || $x > $xmax;
        $ymin = $y if ! $ymin.defined || $y < $ymin;
        $ymax = $y if ! $ymax.defined || $y > $ymax;
    }

    return [$xmin,$ymin,$xmax,$ymax];
  }

  method bounding-box-min() {
    my ($xmin, $ymin, $xmax, $ymax) = $.bounding-box();
    return [$xmin, $ymin];

  }

  use Math::Geometry::Planar:from<Perl5>;

  method mgp-polygon {
    my $mpg-polygon = Math::Geometry::Planar.new;
    $mpg-polygon.points( $[ @.vertices>>.to-pair ] );
    return $mpg-polygon;
  }

  method area {
    self.mgp-polygon.area;
  }

  method clip($type, $other_p) {
    my $p1 = self.mgp-polygon;
    my $p2 = $other_p.mgp-polygon;

    my $g1 = $p1.convert2gpc;
    my $g2 = $p2.convert2gpc;

    my $g_clip = GpcClip($type, $g1, $g2);
    my $g_result = Gpc2Polygons($g_clip);
    my $polygons = $g_result.polygons;

    my $result = $polygons[0];
    my $p = Polygon.new;
    for $result.flat -> $point {
      $p.add-vertex(|$point>>.Rat);
    }

    return $p;
  }

  method clip_difference($other_p) {
    self.clip('DIFFERENCE', $other_p);
  }

  method clip_intersection($other_p) {
    self.clip('INTERSECTION', $other_p);
  }

  method clip_XOR($other_p) {
    self.clip('XOR', $other_p);
  }

  method clip_union($other_p) {
    self.clip('UNION', $other_p);
  }

}
