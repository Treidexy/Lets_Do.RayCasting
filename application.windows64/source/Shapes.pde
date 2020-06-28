class Rectangle extends Thing {
  Rectangle(PVector position, PVector size, Material col) {
    super(position, size, col);
  }
}

class Ellipse extends Thing {
  Ellipse(PVector position, PVector size, Material col) {
    super(position, size, col);
  }

  boolean checkCollision(PVector checkPos) {
    if (
        pow((checkPos.x - position.x), 2) / pow(size.x, 2) + pow((checkPos.y - position.y), 2) / pow(size.y, 2) <= 1
      ) {
      return true;
    }

    return false;
  }
}

class Polygon extends Thing {
  PVector[] vertices;

  Polygon(Material col, PVector... vertices) {
    super(null, null, col);
    this.vertices = vertices;
  }

  boolean checkCollision(PVector checkPos) {
    boolean collision = false;

    // go through each of the vertices, plus
    // the next vertex in the list
    int next = 0;
    for (int current=0; current<vertices.length; current++) {

      // get next vertex in list
      // if we've hit the end, wrap around to 0
      next = current+1;
      if (next == vertices.length) next = 0;

      // get the PVectors at our current position
      // this makes our if statement a little cleaner
      PVector vc = vertices[current];    // c for "current"
      PVector vn = vertices[next];       // n for "next"

      // compare position, flip 'collision' variable
      // back and forth
      if (((vc.y >= checkPos.y && vn.y < checkPos.y) || (vc.y < checkPos.y && vn.y >= checkPos.y)) &&
        (checkPos.x < (vn.x-vc.x)*(checkPos.y-vc.y) / (vn.y-vc.y)+vc.x)) {
        collision = !collision;
      }
    }
    return collision;
  }
}
