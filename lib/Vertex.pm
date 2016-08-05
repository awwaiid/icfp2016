
class Vertex {
  has $.x;
  has $.y;
  method to-pair {
    [$.x * 100, $.y * 100]
  }
}

