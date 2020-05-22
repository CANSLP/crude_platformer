int TICK = 0;

class Game{
  
  
  class Material{
    String physics;
    color c;
    float res;
    float fric;
    Material(String physics,color c,float res,float fric){
      this.physics = physics;
      this.c = c;
      this.res = res;
      this.fric = fric;
    }
  }
  
  class Struct{
    ArrayList<Vert> vs;
    Shape shape;
    Material mat;
    Struct(ArrayList<Vert> vs, Material mat){
      this.vs = vs;
      this.shape= new Shape(vs,mat.c);
      this.mat = mat;
    }
  }
  
  class Ball{
    float x;
    float y;
    float xv;
    float yv;
    float s;
    float res;
    float fric;
    float wallAngle = 0;
    boolean onGround = false;
    float onWall = 0;
    Dot dot;
    Ball(float x,float y,float xv,float yv,float s,float res,float fric){
      this.x=x;
      this.y=y;
      this.xv=xv;
      this.yv=yv;
      this.s=s;
      this.res=res;
      this.fric=fric;
      this.dot = new Dot(new Vert(x,y),s,color(255,255,255));
    }
    int cStruct;
    boolean collide(){
      cStruct = -1;
      boolean collision = false;
          for(int si = 0;si < structs.size();si ++){
            Struct s = structs.get(si);
            if(s.mat.physics=="solid"){
              ArrayList<Vert> vs = s.vs;
              if(pInPoly(x,y,vs)){
                collision = true;
                cStruct = si;
              }
            }
          }
          return collision;
    }
    void moveX(float u,float va){
      x+=sin(va)*u;
      if(collide()){
        y+=u;
        if(collide()){
          if(sin(va)>0){
            onWall = structs.get(cStruct).mat.fric;
          }
          if(sin(va)<0){
            onWall = -structs.get(cStruct).mat.fric;
          }
          y-=u;
          x-=sin(va)*u;
          xv*=-res;
          yv*=structs.get(cStruct).mat.fric;
        } else {
        //println("SLOPE");
        }
      }
    }
    void moveY(float u,float va){
      y+=cos(va)*u;
      if(collide()){
        y-=cos(va)*u;
        if(cos(va)<0){
          onGround = true;
        }
        yv*=-res;
        xv*=structs.get(cStruct).mat.fric;
      }
    }
    void run(){

      //yv-=0.25;
      
      onGround = false;
      onWall = 0;
      cStruct = -1;
      
      float unit = 1;
      float vd = dist(0,0,xv,yv);
      float va = angle(xv,yv);


      if(vd>0){
        for(int i = 0;i < floor(vd/unit);i ++){
          moveY(unit,va);
          moveX(unit,va);
        }
        moveY(vd%unit,va);
        moveX(vd%unit,va);
      }
      xv*=fric;
      //yv*=fric;
      
      dot.update(x,y);
    }
    void addForce(float xf,float yf){
      xv+=xf;
      yv+=yf;
    }
    void setForce(float xf,float yf){
      xv=xf;
      yv=yf;
    }
    void setXv(float xf){
      xv=xf;
    }
    void setYv(float yf){
      yv=yf;
    }
    void setPos(float x,float y){
      this.x = x;
      this.y = y;
    }
    void setFric(float fric){
     this.fric = fric; 
    }
  }
  
  
  class Rain{
    Ball ball;
    float xv;
    float yv;
    Rain(float x,float y,float xv,float yv){
      this.xv = xv;
      this.yv = yv;
      this.ball = new Ball(x,y,0,0,random(1,3),0.9,1);
      ball.setForce(xv,yv);
    }
    void run(){
      ball.addForce(0,-0.1);
      ball.run();
      if(ball.y<-100){
        ball.setPos(player.ball.x+random(-300,300),1000);
        ball.setForce(random(-xv,xv),random(-yv,yv));
        ball.s=random(3,5);
        ball.dot.update(ball.x,ball.y);
      }
      ball.s-=0.01;
      if(ball.s<=0){
        ball.setPos(player.ball.x+random(-300,300),1000);
        ball.setForce(random(-xv,xv),random(-yv,yv));
        ball.s=random(3,5);
        ball.dot.update(ball.x,ball.y);
      }
      ball.dot.s=ball.s;
    } 
  }
  
  class Player{
    
    
    
    Ball ball;
    Player(float x,float y){
      this.ball = new Ball(x,y,0,0,10,0,0.9);
    }
    void run(){
      float runPower = 0.25;
      float jumpPower = 5;
      float grav = -0.25;
      
      ball.addForce(0,grav);
      
      /*if(hUP){
        ball.addForce(0,0.25);
      }
      if(hDOWN){
        ball.addForce(0,-0.25);
      }*/

      if(ball.onGround){
        if(hUP){
          ball.yv=jumpPower;
        }
      } else {
        runPower*=0.8; 
      }
      if(ball.onWall!=0){
        if(hUP){
          ball.setForce(ball.onWall*jumpPower*-1.1,jumpPower*0.85);
        }
      }
      if(hRIGHT){
        ball.addForce(runPower,0);
      }
      if(hLEFT){
        ball.addForce(-runPower,0);
      }
      //println("v1: "+ball.xv+" , "+ball.yv);
      ball.run();
      
      //println("ground: "+ball.onGround+" , wall: "+ball.onWall);
      //println("v2: "+ball.xv+" , "+ball.yv);
      //println("res: "+ball.res+" , fric: "+ball.fric);

    }
  }
  
  class Platform{
    float x;
    float y;
    float w;
    float h;
    Material mat;
    int si;
    Platform(float x,float y,float w,float h,Material mat){
      this.x=x;
      this.y=y;
      this.w=w;
      this.h=h;
      this.mat=mat;
      genRect(x,y,w,h,mat);
      si = structs.size()-1;
    }
    void updateStruct(){
      ArrayList<Vert> vs = new ArrayList<Vert>();
      vs.add(new Vert(x-w/2,y-h/2));
      vs.add(new Vert(x-w/2,y+h/2));
      vs.add(new Vert(x+w/2,y+h/2));
      vs.add(new Vert(x+w/2,y-h/2));
      structs.get(si).vs = vs;
      structs.get(si).shape.verts = vs;
    }
    void move(float mx,float my){
      float topBubble = 5;
      
      if(mx!=0){
        x+=mx;
        if(mat.physics=="solid"){
          for(int bi = 0;bi < balls.size();bi ++){
            if(balls.get(bi).x<x+w/2&&balls.get(bi).x>x-w/2){
              if(balls.get(bi).y-topBubble<=y+h/2&&balls.get(bi).y>y-h/2){
                /*if(mx>0){
                  balls.get(bi).x=x+w/2;
                }
                if(mx<0){
                  balls.get(bi).x=x-w/2;
                }
                */
                balls.get(bi).x+=mx;
                //println("push "+mx);
              }
            }
          }
        }
      }
      if(my!=0){
        y+=my;
        if(mat.physics=="solid"){
          for(int bi = 0;bi < balls.size();bi ++){
            if(balls.get(bi).x<x+w/2&&balls.get(bi).x>x-w/2){
              if(balls.get(bi).y-topBubble<y+h/2&&balls.get(bi).y>y-h/2){
                /*if(my>0){
                  balls.get(bi).y=y+h/2;
                }
                if(my<0){
                  balls.get(bi).y=y+h/2;
                }*/
                balls.get(bi).y+=my;
              }
            }
          }
        }
      }
      updateStruct();
      //println(x+" , "+y);
    }
  }
  
  
  void runBalls(){
    for(int bi = 0;bi < balls.size();bi ++){
      if(balls.get(bi)!=player.ball){
        balls.get(bi).run();
      }
    }
  }
  
  void runRain(){
    for(int ri = 0;ri < rain.size();ri ++){
      rain.get(ri).run();
    }
  }
  void runPlatforms(){
    plat1.move(0,-cos((float)TICK/50));
    plat2.move(cos((float)TICK/50),0);
    plat3.move(-cos((float)TICK/50),0);
    plat4.move(sin((float)TICK/50),-cos((float)TICK/50));
  }
  
  
  Material ground = new Material("solid",color(175,175,175),0.5,1);
  Material ice = new Material("solid",color(200,225,225),0,1.025);
  Material mud = new Material("solid",color(150,100,75),0,0.8);
  
  ArrayList<Struct> structs = new ArrayList<Struct>();
  ArrayList<Ball> balls = new ArrayList<Ball>();
  ArrayList<Rain> rain = new ArrayList<Rain>();
  Player player;
  Platform plat1;
  Platform plat2;
  Platform plat3;
  Platform plat4;
  
  ArrayList<Vert> vs;
  
  void genRect(float x,float y,float w,float h,Material mat){
    vs = new ArrayList<Vert>();
    vs.add(new Vert(x-w/2,y+h/2));
    vs.add(new Vert(x+w/2,y+h/2));
    vs.add(new Vert(x+w/2,y-h/2));
    vs.add(new Vert(x-w/2,y-h/2));
    structs.add(new Struct(vs,mat));
  }
  void genIsle(float x,float y,float w,float h,Material mat){
    vs = new ArrayList<Vert>();
    vs.add(new Vert(x-w/2,y+h/2));
    vs.add(new Vert(x+w/2,y+h/2));
    vs.add(new Vert(x+w/3,y-h/2));
    vs.add(new Vert(x-w/3,y-h/2));
    structs.add(new Struct(vs,mat));
  }
  void genHill(float x,float y,float w,float h,Material mat){
    vs = new ArrayList<Vert>();
    vs.add(new Vert(x-w/4,y+h/2));
    vs.add(new Vert(x+w/4,y+h/2));
    vs.add(new Vert(x+w/2,y-h/2));
    vs.add(new Vert(x-w/2,y-h/2));
    structs.add(new Struct(vs,mat));
  }
  void genPyramid(float x,float y,float w,float h,Material mat){
    vs = new ArrayList<Vert>();
    vs.add(new Vert(x,y+h/2));
    vs.add(new Vert(x+w/2,y-h/2));
    vs.add(new Vert(x-w/2,y-h/2));
    structs.add(new Struct(vs,mat));
  }
  
  
  
  void generate(String level){
    if(level == "test"){
      player = new Player(0,25);
      

      vs = new ArrayList<Vert>();
      vs.add(new Vert(-100,0));
      vs.add(new Vert(0,-25));
      vs.add(new Vert(100,0));
      vs.add(new Vert(75,-50));
      vs.add(new Vert(-75,-50));
      structs.add(new Struct(vs,ground));
      vs = new ArrayList<Vert>();
      vs.add(new Vert(0,40));
      vs.add(new Vert(-10,50));
      vs.add(new Vert(0,60));
      vs.add(new Vert(10,50));
      structs.add(new Struct(vs,ground));
      
      for(int i = 0;i < 10;i ++){
        balls.add(new Ball(random(-width/2,width/2),random(-height/2,height/2),0,0,random(2,8),0,0.9));
      }
    }
    
    if(level == "collision test"){
      player = new Player(0,25);
      genIsle(0,-25,225,50,ground);
      genIsle(100,50,50,25,ground);
      genIsle(50,25,50,25,ground);
      //genIsle(200,50,50,25,ground);
      genIsle(400,50,200,25,ground);
      genPyramid(450,75,90,30,ground);
      genIsle(525,35,25,5,ground);
      genIsle(600,0,200,25,ground);
      genPyramid(600,25,50,30,ground);
      genPyramid(675,50,25,80,ground);
      genRect(-100,50,25,110,ground);
      genRect(-25,100,25,75,ground);
      genRect(-200,50,100,25,ground);
      genRect(-250,200,25,200,ground);
      genRect(-300,175,25,300,ground);
      genRect(-150,300,100,25,ground);
      genRect(-200,625,25,500,ground);
      genRect(-100,600,25,500,ground);
      genIsle(500,-150,300,25,ground);
      
      plat1 = new Platform(200,75,50,20,ground);
      plat2 = new Platform(500,-125,25,50,ground);
      plat3 = new Platform(500,-50,25,50,ground);
      plat4 = new Platform(700,-100,50,20,ground);
      
      for(int i = 0;i < 100;i ++){
        rain.add(new Rain(random(-500,500),1000,random(-5,5),random(-2,2)));
      }
    }
    
    if(level == "material test"){
      player = new Player(0,25);
      genHill(-125,-65,200,25,ice);
      genRect(-175,0,25,200,ice);
      genHill(125,-65,200,25,mud);
      genRect(175,0,25,200,mud);
      genIsle(0,-100,500,50,ground);
    }
    
    balls.add(player.ball);
    TICK = 0;
  }
  
  
  void run(){
    TICK++;
    player.run(); 
    runRain();
    runBalls();
    runPlatforms();
  }
  
  
  
}
