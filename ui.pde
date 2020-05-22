
boolean hUP;
boolean iUP;
boolean hDOWN;
boolean iDOWN;
boolean hRIGHT;
boolean iRIGHT;
boolean hLEFT;
boolean iLEFT;
boolean hR;
boolean iR;


void uiUpdate(){
  iUP = false;
  iDOWN = false;
  iRIGHT = false;
  iLEFT = false;
  iR = false;
}

void keyPressed(){
  if(keyCode == 38 || keyCode == 87){
      iUP = true;
      hUP = true;
  }
  if(keyCode == 39 || keyCode == 68){
      iRIGHT = true;
      hRIGHT = true;
  }
  if(keyCode == 37 || keyCode == 65){
      iLEFT = true;
      hLEFT = true;
  }
  if(keyCode == 40 || keyCode == 83){
      iDOWN = true;
      hDOWN = true;
  }
  if(keyCode == 82){
    iR = true;
    hR = true;
  }
}
void keyReleased(){
  if(keyCode == 38 || keyCode == 87){
      hUP = false;
  }
  if(keyCode == 39 || keyCode == 68){
      hRIGHT = false;
  }
  if(keyCode == 37 || keyCode == 65){
      hLEFT = false;
  }
  if(keyCode == 40 || keyCode == 83){
    hDOWN = false;
  }
  if(keyCode == 82){
    hR = false;
  }
}
