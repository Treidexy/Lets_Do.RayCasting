class Color {
  float r;
  float g;
  float b;
  float a;
  
  public Color(float r, float g, float b) {
    this.r = r;
    this.g = g;
    this.b = b;
    a = 255;
  }
  
  public Color(float r, float g, float b, float a) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = a;
  }
  
  String toString() {
    return "[ " + r + ", " + g + ", " + b + ", " + a + " ]";
  }
}
