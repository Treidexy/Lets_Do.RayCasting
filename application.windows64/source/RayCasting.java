import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class RayCasting extends PApplet {

final RenderTypes GrenderType = RenderTypes._3D;

final float raysCasted = 690;
final float scale = 1;
final float moveSpeed = 50;
final float fov = 70;
final float speed = 14f;

final String ThingysScript = "example.thingy";

float ang = 0;
float turnSpeed = 1;
float tsInc = 0.069f;

Ray ray;
//Thing[] thingys;
PVector rayPos;

ArrayList<PVector> lightPoses = new ArrayList<PVector>();

ArrayList<Ray> rays;
Thing thing;

PVector mouse;
int tesdcxt = 69;
String tset = "ur mom";
float angle = 0;
float mostDist = 0;

public void setup() {
  
  surface.setAlwaysOnTop(true);
  
  //readThingys(ThingysScript);
  
  ray = new Ray(new PVector(width/2, height/2), 0, thingys);
  ray.renderType = RenderTypes.ALL;
  rayPos = new PVector(0, 0);
}

public void draw() {
  background(0);
  
  rayPos.x = constrain(rayPos.x, 0, width);
  rayPos.y = constrain(rayPos.y, 0, height);
  //rayCast(lightPos);
  //rayCast(lightPos2);
  //for (int i = 0; i < lightPoses.size(); i++) {
  //  rayCastAllDir(lightPoses.get(i));
  //}
  //rayCastAllDir(new PVector(mouseX, mouseY));
  
  rayCastAllDir(rayPos);
  
  //ray.startPos = mouse;
  //ray.renderType = RenderTypes.ALL;
  //ray.reDraw();
  //while (!ray.isDead) {
  //  ray.draw();
  //}

  noStroke();
  fill(0);
  rect(0, 0, 100, 30);
  fill(random(0, 255), random(0, 255), random(0, 255));
  text("FPS: " + frameRate, 5, 15);
}

public void rayCastAllDir(PVector pos) {
  scale(scale);

  rays = new ArrayList<Ray>();



  for (float i = 0; i <= fov; i += fov / raysCasted) {
    rays.add(new Ray(pos.copy(), radians(i + ang - fov/2), thingys));
    //rays.add(new Ray(new PVector(width - mouseX, height - mouseY), i));
  }

  for (int i = 0; i < rays.size(); i++) {
    rays.get(i).thingys = thingys;
  }

  for (int i = 0; i < rays.size(); i++) {
    while (!rays.get(i).isDead) {
      rays.get(i).draw();
      if (GrenderType == RenderTypes._3D) {
        //rectMode(CORNER);
        //fill(14);
        //rect(0, height/3*2, width, height/3);
        if (rays.get(i).isDead && rays.get(i).gotHit) {
          float dist = rays.get(i).dist;
          float ang = PVector.angleBetween(rays.get(i).position, rayPos);
          //dist *= ang;
          float w = (float) width / (float) rays.size();
          float h = (float) height - map(dist, 0, sqrt((width*width) + (height*height)), 0, height);
          rectMode(CENTER);
          fill(rays.get(i).hit.mat.col.r, rays.get(i).hit.mat.col.g, rays.get(i).hit.mat.col.b, rays.get(i).hit.mat.col.a);
          rect(width - i * w - (w/2), height/2, w, h);
        }
      }
    }
  }
}

public void mouseReleased() {
  println(ray.gotHit? ray.dist: "No Target Hit");
  //lightPoses.add(new PVector(mouseX, mouseY));
}

public void keyPressed() {
  switch(keyCode) {
  //case 87:
  //  lightPos.y -= moveSpeed;
  //  break;
  //case 83:
  //  lightPos.y += moveSpeed;
  //  break;
  //case 65:
  //  lightPos.x -= moveSpeed;
  //  break;
  //case 68:
  //  lightPos.x += moveSpeed;
  //  break;

  case 38:
    //turnSpeed += tsInc;
    //lightPos2.y -= moveSpeed;
    rayPos.x += sin(radians(ang)) * speed;
    rayPos.y += cos(radians(ang)) * speed;
    break;
  case 40:
  //  turnSpeed -= tsInc;
  //  //lightPos2.y += moveSpeed;
    rayPos.x -= sin(radians(ang)) * speed;
    rayPos.y -= cos(radians(ang)) * speed;
    break;
  case 37:
    ang += turnSpeed;
    //lightPos2.x -= moveSpeed;
    break;
  case 39:
    ang -= turnSpeed;
    //lightPos2.x += moveSpeed;
    break;
  }
}

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
  
  public String toString() {
    return "[ " + r + ", " + g + ", " + b + ", " + a + " ]";
  }
}
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
  
  public String toString() {
    return "[ " + col.toString() + ", " + reflectiveness + " ]";
  }
}
enum RenderTypes { //<>//
  ALL, 
  EXCEPT,
  HIT,
  ONLY, 
  NONE,
  _3D
}

class Ray {
  PVector startPos, position, pPos;

  RenderTypes renderType;
  float ang, xMove, yMove, range, dist;

  Color col;
  Thing[] thingys;
  
  Thing hit;
  Thing lastHit;

  boolean gotHit, isDead;

  Ray(PVector startPos, float ang, Thing[] thingys) {
    renderType = GrenderType;
    this.startPos = startPos;
    this.ang = ang;
    this.thingys = thingys;
    col = new Color(255, 255, 255);
    range = pow(2, 32);

    reDraw();
  }
  
  Ray(PVector startPos, float ang, float range) {
    this.startPos = startPos;
    this.ang = ang;
    this.range = range;
    col = new Color(255, 255, 255);

    reDraw();
  }

  public void reDraw() {
    isDead = false;
    gotHit = false;
    hit = null;
    pPos = startPos.copy();
    position = startPos.copy();

    dist = 0;

    xMove = sin(ang);
    yMove = cos(ang);
  }

  public void draw() {
    position.x += xMove;
    position.y += yMove;
    dist++;

    for (int i = 0; i < thingys.length; i++) {
      if (thingys[i].checkCollision(position)) {
        //println("Colliding with { Thing:", thingys[i] + " }", "At { Position:", position + " }");
        
        gotHit = true;
        hit = thingys[i];

        if (renderType == RenderTypes.ALL || renderType == RenderTypes.ONLY) {
          stroke(col.r, col.g, col.b, col.a);
          line(pPos.x, pPos.y, position.x, position.y);
        }

        pPos = position.copy();

        Material objectMat = thingys[i].mat;
        Color objectCol = objectMat.col;

        if (renderType == RenderTypes.ALL || renderType == RenderTypes.HIT || renderType == RenderTypes.ONLY || renderType == RenderTypes.EXCEPT) {
          stroke(col.r - (255 - objectCol.r), col.g - (255 - objectCol.g), col.b - (255 - objectCol.b), col.a - (255 - objectCol.a));
          line(pPos.x, pPos.y, position.x, position.y);
        }
        
        if (renderType == RenderTypes._3D) {
          
        }

        col.r -= objectCol.r;
        col.g -= objectCol.g;
        col.b -= objectCol.b;
        col.a -= objectCol.a;
      }
    }

    if (position.y <= 0 || position.y >= height || position.x <= 0 || position.x >= width || col.a <= 0 || dist >= range) {
      if (col.a > 0) {
        if (renderType == RenderTypes.ALL || renderType == RenderTypes.EXCEPT) {        
          stroke(col.r, col.g, col.b);
          line(pPos.x, pPos.y, position.x, position.y);
        }
      }

      isDead = true;
    }
  }
}
class Rectangle extends Thing {
  Rectangle(PVector position, PVector size, Material col) {
    super(position, size, col);
  }
}

class Ellipse extends Thing {
  Ellipse(PVector position, PVector size, Material col) {
    super(position, size, col);
  }

  public boolean checkCollision(PVector checkPos) {
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

  public boolean checkCollision(PVector checkPos) {
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
class Thing {
  PVector position, size;
  Material mat;
  
  boolean isReflective;
  
  Thing (PVector position, PVector size, Material mat) {
    this.position = position;
    this.size = size;
    this.mat = mat;
  }
  
  public boolean checkCollision(PVector checkPos) {
    if (
      (position.x - size.x <= checkPos.x && position.x + size.x >= checkPos.x) &&
      (position.y - size.y <= checkPos.y && position.y + size.y >= checkPos.y)
    ) {
      return true;
    }
        
    return false;
  }
  
  public String toString() {
    return "Pos: " + position.toString() + " Size: " + size.toString() + " Col:" + mat.toString();
  }
}
//void readThingys(String file_name) {
//  String[] lines = loadStrings(file_name);
//  ArrayList<Thing> tempThingys = new ArrayList<Thing>();

//  for (String line : lines)
//    tempThingys.add(convertThingys(line));
    
//  thingys = new Thing[tempThingys.size()];
//  thingys = tempThingys.toArray(thingys);
//}

//Thing convertThingys(String line) {
//  String[] words = line.split(" ");

//  String keyword;
//  String[] args;

//  keyword = words[0];

//  args = new String[words.length];
//  for (int i = 1; i < words.length; i++)
//    args[i - 1] = words[i];
    
//  return parseThingy(keyword, args);
//}

//Thing parseThingy(String keyword, String... args) {
//  Thing out = null;

//  switch(keyword) {
//  case "Rectangle":
//    out = new Rectangle (
//      new PVector(float(args[0]), float(args[1])), 
//      new PVector(float(args[2]), float(args[3])), 
//      new Colo(float(args[4]), float(args[5]), float(args[6]), float(args[7]))
//      );
//    break;
//  case "Ellipse":
//    out = new Ellipse (
//      new PVector(float(args[0]), float(args[1])), 
//      new PVector(float(args[2]), float(args[3])), 
//      new Color(float(args[4]), float(args[5]), float(args[6]), float(args[7]))
//      );
//    break;
//  case "Polygon":
//    int polyLen = (args.length - 4) / 2;
//    ArrayList<PVector> verticesBuff = new ArrayList<PVector>();
    
//    for (int i = 0; i < polyLen; i++) {
//      verticesBuff.add(new PVector(float(args[i*2 + 4]), float(args[i*2 + 5])));
//    }
    
//    PVector[] vertices = new PVector[verticesBuff.size()];
//    vertices = verticesBuff.toArray(vertices);
    
//    out = new Polygon (
//      new Color(float(args[0]), float(args[1]), float(args[2]), float(args[3])),
//      vertices
//      );
//    break;
//  case "#":
//    out = new Polygon(new Color(0, 0, 0));
//    break;
//  }
  
//  return out;
//}
Thing[] thingys = new Thing[] {
    new Rectangle(new PVector(500, 400), new PVector(30, 30), new Material(255, 255, 255)), 
    new Ellipse(new PVector(400, 300), new PVector(69, 50), new Material(0, 255, 0)), 
    new Rectangle(new PVector(800, 600), new PVector(100, 150), new Material(0, 255, 0)), 
    //new Thing(new PVector(0, 0), new PVector(1000, 800), new Color(255, 255, 255, 14))
    new Polygon(new Material(0, 255, 100, 1), new PVector(0, 700), new PVector(50, 710), new PVector(14, 760), new PVector(100, 769))
  };
  public void settings() {  size(1000, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "RayCasting" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
