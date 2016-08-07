
class Vertex {
  has $.x;
  has $.y;

  has @.history;

  method to-pair {
    [$.x, $.y]
  }

  method move-to($new-x, $new-y) {
    @.history.push(self.to-pair);
    $!x = $new-x;
    $!y = $new-y;
  }
}

