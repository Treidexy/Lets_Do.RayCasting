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

  void reDraw() {
    isDead = false;
    gotHit = false;
    hit = null;
    pPos = startPos.copy();
    position = startPos.copy();

    dist = 0;

    xMove = sin(ang);
    yMove = cos(ang);
  }

  void draw() {
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
