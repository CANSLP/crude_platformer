float camX = 0;
float camY = 0;
float camS = 1;
float camA = 0;
float camtx = 0;
float camty = 0;
float camts = 1.5;
float camta = 0;
float camSpeed = 15;





class Vert{
  float x;
  float y;
  Vert(float x,float y){
    this.x = x;
    this.y = y;
  }
  Vert trans(float cx,float cy,float cs,float ca){
    float a = angle(cx-x,cy-y);
    float d = dist(cx-x,cy-y);
    return new Vert((width/2)+(sin(a+ca+PI)*d*cs),(height/2)-(cos(a+ca+PI)*d*cs)); 
  }
}




class Shape{
  ArrayList<Vert> verts;
  color c;
  Shape(ArrayList<Vert> verts,color c){
    this.verts = verts;
    this.c = c;
  }
  void render(float cx,float cy,float cs,float ca){
    noStroke();
    fill(c);
    beginShape();
    for(int vi = 0;vi < verts.size();vi ++){
      Vert v = verts.get(vi).trans(cx,cy,cs,ca);
      vertex(v.x,v.y);
    }
    endShape();
  }
}
class Dot{
  Vert p;
  float s;
  color c;
  Dot(Vert v,float s,color c){
    this.p = v;
    this.s = s;
    this.c = c;
  }
  void update(float x,float y){
    p = new Vert(x,y);
  }
  void render(float cx,float cy,float cs,float ca){
    Vert t = p.trans(cx,cy,cs,ca);
    stroke(c);
    strokeWeight(s*cs);
    point(t.x,t.y);
  }
}

void drawStructs(float cx,float cy,float cs,float ca){
  for(int si = 0;si < game.structs.size();si ++){
    game.structs.get(si).shape.render(cx,cy,cs,ca);
  }
}




void drawBalls(float cx,float cy,float cs,float ca){
  for(int bi = 0;bi < game.balls.size();bi ++){
    game.balls.get(bi).dot.render(cx,cy,cs,ca);
  }
  for(int ri = 0;ri < game.rain.size();ri ++){
    game.rain.get(ri).ball.dot.render(cx,cy,cs,ca);
  }
  game.player.ball.dot.render(cx,cy,cs,ca);
}
void drawDots(float cx,float cy,float cs,float ca){
  for(int di = 0;di < dots.size();di ++){
    dots.get(di).render(cx,cy,cs,ca);
  }
  drawBalls(cx,cy,cs,ca);
}




void runCam(){
   /*
  camX=mouseX-(width/2);
  camY=mouseY-(height/2);
  */
  
  camtx = game.player.ball.x;
  camty = game.player.ball.y;
  
  camX+=(camtx-camX)/camSpeed;
  camY+=(camty-camY)/camSpeed;
  camS+=(camts-camS)/camSpeed;
  camA+=(camta-camA)/camSpeed;
  //println(camX+" , "+camY);
  
}






ArrayList<Vert> vs;
ArrayList<Shape> shapes = new ArrayList<Shape>();
ArrayList<Dot> dots = new ArrayList<Dot>();
