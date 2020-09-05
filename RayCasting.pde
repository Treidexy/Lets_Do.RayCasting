RenderTypes GrenderType = RenderTypes._3D; 

float renderWidth;
float renderHeight;

final float raysCasted = 360;
final float scale = 1;
//final float moveSpeed = 50;
final float fov = 90;
final float speed = 14f;

final String ThingysScript = "example.thingy";

float ang = 0;
float turnSpeed = 1f;
float tsInc = 0.069f;

int renNum;

Ray ray;
//Thing[] thingys;
PVector rayPos;

ArrayList<PVector> lightPoses = new ArrayList<PVector>();

ArrayList<Ray> rays;
Thing thing;

void setup() {
  fullScreen();
  
  renderWidth = width;
  renderHeight = height;
  
  //size(1000, 800);
  //surface.setAlwaysOnTop(true);

  //readThingys(ThingysScript);

  ray = new Ray(new PVector(width/2, height/2), 0, thingys);
  ray.renderType = RenderTypes.ALL;
  rayPos = new PVector(0, 0);
  
  setupButtons();
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

  if (GrenderType == RenderTypes._3D) {
    fill(255);
    pushMatrix();
    translate(renderWidth/2, renderHeight/2);
    beginShape();
    vertex(-4, -4);
    vertex(0, -5);
    vertex(4, -4);
    vertex(5, 0);
    vertex(4, 4);
    vertex(0, 5);
    vertex(-4, 4);
    vertex(-5, 0);
    endShape();
    popMatrix();
  }

  //ray.startPos = mouse;
  //ray.renderType = RenderTypes.ALL;
  //ray.reDraw();
  //while (!ray.isDead) {
  //  ray.draw();
  //}
  
  drawButtons();

  noStroke();
  fill(0);
  rect(0, 0, 200, 40);
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
    Ray ray = rays.get(i);
    while (!rays.get(i).isDead) {
      ray.draw();
    }
    
    if (GrenderType == RenderTypes._3D) {
      if (ray.gotHit) {
        float dist = ray.dist;
        //float a = ray.ang - ang;
        float w = renderWidth / (float) rays.size();
        float h = renderHeight - dist;
        h = renderHeight - map(dist, 0, sqrt((renderWidth*renderWidth) + (renderHeight*renderHeight)), 0, renderHeight);
        //if (!mousePressed) {
        //  println(a);
        //  dist *= sin(a);
        //  println(a);
        //  h = map(dist, 0, sqrt((renderWidth*renderWidth) + (renderHeight*renderHeight)), renderHeight, 0);
        //} else if (mouseButton == LEFT) {
          //h = map(dist, 0, sqrt((renderWidth*renderWidth) + (renderHeight*renderHeight)), renderHeight, 0);
        //}
        rectMode(CENTER);
        noStroke();
        //fill(ray.col.r - (255 - ray.hit.mat.col.r), ray.col.g - (255 - ray.hit.mat.col.g), ray.col.b - (255 - ray.hit.mat.col.b), ray.col.a - (255 - ray.hit.mat.col.a));
        fill(ray.hit.mat.col.r, ray.hit.mat.col.g, ray.hit.mat.col.b, ray.hit.mat.col.a);
        rect(renderWidth - i * w - (w/2), renderHeight/2, w, h);
      }// else if (rays.get(i).isDead) {
      //  float dist = rays.get(i).dist;
      //  float ang = radians(ray.ang - (angle - fov/2));
      //  float dif = sin(ang);
      //  float w = renderWidth / (float) rays.size();
      //  float h = renderHeight - dist;
      //  //float h = h = renderHeight - map(dist, 0, ang*sqrt((renderWidth*renderWidth) + (renderHeight*renderHeight)), 0, ang * renderHeight);
      //  if (!mousePressed) {
      //    dist *= dif;
      //    h = renderHeight - map(dist, 0, ang*sqrt((renderWidth*renderWidth) + (renderHeight*renderHeight)), 0, dif * renderHeight);
      //  } else if (mouseButton == LEFT) {
      //    h = renderHeight - map(dist, 0, sqrt((renderWidth*renderWidth) + (renderHeight*renderHeight)), 0, renderHeight);
      //  }
      //  rectMode(CENTER);
      //  noStroke();
      //  fill(0x69);
      //  rect(renderWidth - i * w - (w/2), renderHeight/2, w, h);
      //}
    }
  }
}

void keyPressed() {
  switch(keyCode) {
  case 87:
    forward();
    break;
  case 83:
    backward();
    break;
  case 65:
    left();
    break;
  case 68:
    right();
    break;
  case 32:
    GrenderType = (GrenderType == RenderTypes._3D)? RenderTypes.ALL: RenderTypes._3D;
    break;
  case 9:
    renNum++;
    if (renNum >= RenderTypes.values().length)
      renNum = 0;
    GrenderType = RenderTypes.values()[renNum];
    break;

  case 38:
    //turnSpeed += tsInc;
    //lightPos2.y -= moveSpeed;
    forward();
    break;
  case 40:
    //  turnSpeed -= tsInc;
    //  //lightPos2.y += moveSpeed;
    backward();
    break;
  case 37:
    left();
    //lightPos2.x -= moveSpeed;
    break;
  case 39:
    right();
    //lightPos2.x += moveSpeed;
    break;
  }
}

void forward() {
  rayPos.x += sin(radians(ang)) * speed;
  rayPos.y += cos(radians(ang)) * speed;
}

void backward() {
  rayPos.x -= sin(radians(ang)) * speed;
  rayPos.y -= cos(radians(ang)) * speed;
}

void left() {
  ang += turnSpeed;
}

void right() {
  ang -= turnSpeed;
}
