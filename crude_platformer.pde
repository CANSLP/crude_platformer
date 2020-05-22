import processing.sound.*;
SoundFile click;


Game game;
void setup(){
  size(500,500);
  surface.setResizable(true);
  
  click = new SoundFile(this,"click.wav");
  
  game = new Game();
  game.generate("collision test");
  
}
void draw(){
  
  if(iR){
    game = new Game();
    game.generate("collision test");
    click.play();
  }
  game.run();
  runCam();
  
  background(0);
  drawStructs(camX,camY,camS,camA);
  drawDots(camX,camY,camS,camA);
  
  
  uiUpdate();
  
}
