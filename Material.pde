class Material {
  Color col;
  float reflectiveness;
  
  Material(int r, int g, int b) {
    col = new Color(r, g, b, 255);
    reflectiveness = 0;
  }
  
  Material(int r, int g, int b, int a) {
    col = new Color(r, g, b, a);
    reflectiveness = 0;
  }
  
  Material(Color col) {
    this.col = col;
    reflectiveness = 0;
  }
  
  Material(Color col, float reflectiveness) {
    this.col = col;
    this.reflectiveness = reflectiveness;
  }
  
  String toString() {
    return "[ " + col.toString() + ", " + reflectiveness + " ]";
  }
}
