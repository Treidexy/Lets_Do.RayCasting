class Thing {
  PVector position, size;
  Material mat;
  
  boolean isReflective;
  
  Thing (PVector position, PVector size, Material mat) {
    this.position = position;
    this.size = size;
    this.mat = mat;
  }
  
  boolean checkCollision(PVector checkPos) {
    if (
      (position.x - size.x <= checkPos.x && position.x + size.x >= checkPos.x) &&
      (position.y - size.y <= checkPos.y && position.y + size.y >= checkPos.y)
    ) {
      return true;
    }
        
    return false;
  }
  
  String toString() {
    return "Pos: " + position.toString() + " Size: " + size.toString() + " Col:" + mat.toString();
  }
}
