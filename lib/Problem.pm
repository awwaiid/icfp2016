#!perl6

use Imager:from<Perl5>;

class Problem {
  has $.silhouette;
  has $.skeleton;

  method draw($image) {
    my ($xmin, $ymin) = $.silhouette.get-min-coords();
    $.silhouette.draw($image, $xmin, $ymin);
    $.skeleton.draw($image, $xmin, $ymin);
  }

  method draw-file($filename) {
    my $image = Imager.new(xsize => 1000, ysize => 1000, channels => 4);
    $image.polyline( points => [ [0,0], [0,999], [999,999], [999,0], [0,0] ], color => 'red');
    self.draw($image);
    $image.flip(dir => 'v');
    $image.write(file => $filename);
  }

}

