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

void setup() {
  size(1000, 800);
  surface.setAlwaysOnTop(true);
  
  //readThingys(ThingysScript);
  
  ray = new Ray(new PVector(width/2, height/2), 0, thingys);
  ray.renderType = RenderTypes.ALL;
  rayPos = new PVector(0, 0);
}

void draw() {
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

void rayCastAllDir(PVector pos) {
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

void mouseReleased() {
  println(ray.gotHit? ray.dist: "No Target Hit");
  //lightPoses.add(new PVector(mouseX, mouseY));
}

void keyPressed() {
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
