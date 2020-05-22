float dist(float x,float y){
  return sqrt(pow(x,2)+pow(y,2));
}
float angle(float x,float y){
  if(x<0){
        return (3*PI/2)-atan(y/x);
    } else {
        return (PI/2)-atan(y/x);
    }
}



boolean rbool;

float[] crossSegs(float x1,float y1,float x2,float y2,float x3,float y3,float x4,float y4){
    
    float rx;
    float ry;
    rbool = false;
    
    //Divert methods for vertical lines
    if(x1-x2==0){
        if(x3-x4==0){
        //Both
            //Parallel
            rbool = false;
            return null;
        } else {
        //1
            //Vertical Intersection
            rx = x1;
            ry = x1*((y3-y4)/(x3-x4))+(y3-(x3*((y3-y4)/(x3-x4))));
            //Check segment overlap
                if(!((rx>x1&&rx>x2)||(rx<x1&&rx<x2)||(rx>x3&&rx>x4)||(rx<x3&&rx<x4)||(ry>y1&&ry>y2)||(ry<y1&&ry<y2)||(ry>y3&&ry>y4)||(ry<y3&&ry<y4))){
                    rbool = true;   
                }
        }
        } else {
        if(x3-x4==0){
        //2
            //Vertical Intersection
            rx = x3;
            ry = x3*((y1-y2)/(x1-x2))+(y1-(x1*((y1-y2)/(x1-x2))));
            //Check segment overlap
                if(!((rx>x1&&rx>x2)||(rx<x1&&rx<x2)||(rx>x3&&rx>x4)||(rx<x3&&rx<x4)||(ry>y1&&ry>y2)||(ry<y1&&ry<y2)||(ry>y3&&ry>y4)||(ry<y3&&ry<y4))){
                    rbool = true;   
                }
        } else {
        //None
            //Check Parallel
            if((y1-y2)/(x1-x2)==(y3-y4)/(x3-x4)){
                //Parallel
                rbool = false;
                return null;
            } else {
                //Do normal intersection
                rx = ((y3-(x3*((y3-y4)/(x3-x4))))-(y1-(x1*((y1-y2)/(x1-x2)))))/(((y1-y2)/(x1-x2))-((y3-y4)/(x3-x4)));
                ry = rx*((y1-y2)/(x1-x2))+(y1-(x1*((y1-y2)/(x1-x2))));
            }
            
                //Check segment overlap
                if(!((rx>x1&&rx>x2)||(rx<x1&&rx<x2)||(rx>x3&&rx>x4)||(rx<x3&&rx<x4)||(ry>y1&&ry>y2)||(ry<y1&&ry<y2)||(ry>y3&&ry>y4)||(ry<y3&&ry<y4))){
                    rbool = true;   
                }
        }
    }
    float[] r = {rx,ry};
    return r;
};


boolean pInPoly(float x,float y,ArrayList<Vert> shape){
  java.awt.Polygon p = new java.awt.Polygon();
  for(int i = 0;i < shape.size();i ++){
    p.addPoint((int)shape.get(i).x,(int)shape.get(i).y);
  }
  return p.contains(x,y);
  
}
