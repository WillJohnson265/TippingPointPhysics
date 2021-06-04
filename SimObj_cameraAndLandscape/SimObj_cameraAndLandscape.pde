

SimSurfaceMesh landscape; 
SimpleUI myUI;

SimModel rocket;
SimModel cylinder,cylinder2,cylinder3;
SimBox edge1, edge2, points1, points2, points3, points4, points5;
SimSphere dropBall;
ArrayList<SimModel> rungs = new ArrayList<SimModel>();
int yVal = -175;
int count = 1;
int rows = 0;
boolean moving = false;
PVector ballSpeed;
PVector accelleration;
float startXVal;
String scoreStr = "0";
int score;


SimCamera theCamera;

void setup(){
  size(900, 700, P3D);
  setUpDropBox();
  //setupRungs();
  makeRungList();
  setUpPointBoxes();
  print(rungs);
  
  landscape = new SimSurfaceMesh(100, 100, 10.0);
  
 
  landscape.setTransformAbs( 1, 0,0,0, vec(-500,0,-500) ); 
  
  myUI = new SimpleUI();
  myUI.addPlainButton("Drop Zone 1", 20,20);
  myUI.addPlainButton("Drop Zone 2", 20, 50);
  myUI.addPlainButton("Drop Zone 3", 20, 80);
  myUI.addPlainButton("Drop Ball", 20, 120);
  myUI.addLabel("Score",20,150,scoreStr);

  
  setBallStartPos(); 
  
  
  
  theCamera = new SimCamera();
  theCamera.setPositionAndLookat( vec(50,-200,200),  vec(0,0,0));
  theCamera.setHUDArea(20,20,240,240);
  //theCamera.setSpeed(30);
  
}

void draw(){
  background(0);
  lights();
  
  theCamera.update();
  
  fill(70,127, 70 );
  noStroke();
  landscape.drawMe();
  
  //drawMajorAxis(vec(0,0,0), 100);
  drawRungList();
  drawPointBoxes();
  fill(255,0,0);
  dropBall.drawMe();
  updateDropBall();
  checkRungCollision();
  //handlePointsCollision();
  drawDropBox();
  handlePointsCollision();
  theCamera.startDrawHUD();
    // any 2d drawing has to happen between 
    // startDrawHUD and endDrawHUD
    myUI.update();
  theCamera.endDrawHUD();
  

  
}



void keyPressed(){
  if(key == 'r'){
    moving = true;
  }
  if (key == 'a') {
     startXVal -= 5;
     setBallStartPos();
    }
  if (key == 'd'){
     startXVal += 5;
     setBallStartPos();
    }
  
}

void setUpDropBox(){
  edge1 = new SimBox(vec(0,0,0),vec(230,200,2));
  edge1.setTransformAbs( 1, 0,0,0, vec(0,-200,0));
  edge2 = new SimBox(vec(0,0,0),vec(230,200,2));
  edge2.setTransformAbs( 1, 0,0,0, vec(0,-200,-10));
  
 
}
void drawDropBox(){
  
  fill(255,255,255);
  tint(255,126);
  edge2.drawMe();
  fill(255,0,0,0);
  edge1.drawMe();
}

void setUpPointBoxes(){
  points1 = new SimBox(vec(0,0,0),vec(45,5,10));
  points1.setTransformAbs( 1, 0,0,0, vec(5,-10,-10));
  points2 = new SimBox(vec(0,0,0),vec(45,5,10));
  points2.setTransformAbs( 1, 0,0,0, vec(50,-10,-10));
  points3 = new SimBox(vec(0,0,0),vec(45,5,10));
  points3.setTransformAbs( 1, 0,0,0, vec(95,-10,-10));
  points4 = new SimBox(vec(0,0,0),vec(45,5,10));
  points4.setTransformAbs( 1, 0,0,0, vec(140,-10,-10));
  points5 = new SimBox(vec(0,0,0),vec(45,5,10));
  points5.setTransformAbs( 1, 0,0,0, vec(185,-10,-10));
}

void drawPointBoxes(){
  fill(255,0,0);
  points1.drawMe();
  points5.drawMe();
  fill(0,0,255);
  points2.drawMe();
  points4.drawMe();
  fill(255,215,0);
  points3.drawMe();
}

void drawRungList(){
  fill(0,0,0);
  for(int n =0; n< rungs.size(); n++){
    SimModel thisRung = rungs.get(n);
    thisRung.showBoundingVolume = false;
    thisRung.drawMe();
    
  }
}

void makeRungList(){
  while (rows < 4){
   while (count < 6){
      SimModel rung = new SimModel("basicCylinder.obj");
    
      rung.setPreferredBoundingVolume("sphere");
      rung.showBoundingVolume(true);
      rung.setTransformAbs( 0.4, 0,0,0, vec(((count * 40) - random(10,20)),yVal,-7.1106));
      rungs.add(rung);
      SimModel rung2 = new SimModel("basicCylinder.obj");
      rung2.setPreferredBoundingVolume("sphere");
      rung2.showBoundingVolume(true);
      rung2.setTransformAbs( 0.4, 0,0,0, vec((count * 40),(yVal+20),-7.1106));
      rungs.add(rung2);
      count++;
    }
    yVal += 40;
    rows ++;
    count = 1;
  }

}

void setBallStartPos(){
  dropBall = new SimSphere(vec(startXVal,-205,-5.5), 6);
  moving = false;
  ballSpeed = new PVector(0,0,0);
}

void updateDropBall(){
  if (moving){
    accelleration = new PVector(0,0.098,0);
    ballSpeed = ballSpeed.add(accelleration);
    //print(ballSpeed.y);
    if(ballSpeed.y == 10) ballSpeed.y = 10;
    dropBall.setTransformRel(1,0,0,0, ballSpeed);
    
    //SimRay ballray = new SimRay( dropBall.getOrigin(), PVector.add(dropBall.getOrigin(), ballSpeed));
    //drawray(ballray);
    
  }
}

void checkRungCollision(){
  for(int n =0; n<rungs.size(); n++){
    SimModel thisRung = rungs.get(n);
    //SimSphere rungSphere = thisRung.getBoundingSphere();
    if(thisRung.collidesWith(dropBall)){
      collisionResponse(thisRung);
      //print("collided with a rung");
      //print(rungSphere.getCentre());
      //print(dropBall.getCentre());
    }
  }
}


void collisionResponse(SimModel thisRung){
  PVector v1 = ballSpeed;
  PVector v2 = new PVector(0, 0, 0);
  
  SimSphere rungSphere = thisRung.getBoundingSphere();
  
  PVector cen1 = dropBall.getCentre();
  PVector cen2 = rungSphere.getCentre();
  
  float massPart1 = 2*750 / (8 + 1000);
  PVector v1subv2 = PVector.sub(v1,v2);
  PVector cen1subCen2 = PVector.sub(cen1,cen2);
  float topBit1 = v1subv2.dot(cen1subCen2);
  float bottomBit1 = cen1subCen2.mag()*cen1subCen2.mag();
    
  float multiplyer1 = massPart1 * (topBit1/bottomBit1);
  PVector changeV1 = PVector.mult(cen1subCen2, multiplyer1);
    
  PVector v1New = PVector.sub(v1,changeV1);  
  float xval = v1New.x;
  float yval = v1New.y * -1;
  float zval = v1New.z;
  PVector newSpeed = new PVector(xval,yval,zval);
  ballSpeed = newSpeed;
  ensureNoOverlap(thisRung);
}


void ensureNoOverlap(SimModel thisRung){
  SimSphere rungSphere = thisRung.getBoundingSphere();
  //thisRung.getRadius();

  PVector cen1 = dropBall.getCentre();
  PVector cen2 = rungSphere.getCentre();
  
  float combinedRadii = 13;
  float distanceBetween = cen1.dist(cen2);
  
  float overlap = combinedRadii - distanceBetween;
  if (overlap > 0){
    PVector vectorAwayFromOtherNormalized = PVector.sub(cen1, cen2).normalize();
    PVector amountToMove = PVector.mult(vectorAwayFromOtherNormalized, overlap);
    float newX = amountToMove.x;
    PVector newSpeed = new PVector(newX, ballSpeed.y, ballSpeed.z);
    ballSpeed = newSpeed;
  }
}

void handlePointsCollision(){
  if(dropBall.collidesWith(points1) || dropBall.collidesWith(points5)){
    score += 50;
    moving = false;
    setBallStartPos();
    scoreStr = str(score);
    print(score); 
  }
  if(dropBall.collidesWith(points2) || dropBall.collidesWith(points4)){
    score += 20;
    moving = false;
    setBallStartPos();
    scoreStr = str(score);
    print(score);
  }
  if(dropBall.collidesWith(points3)){
    score += 10;
    moving = false;
    setBallStartPos();
    scoreStr = str(score);
    print(score);
  }
}

void handleUIEvent(UIEventData uied){
  uied.print(1);
  
  if(uied.eventIsFromWidget("Drop Zone 1") ){
    startXVal = 40;
    setBallStartPos();
  }
  if(uied.eventIsFromWidget("Drop Zone 2") ){
    startXVal = 100;
    setBallStartPos();
  }
  if(uied.eventIsFromWidget("Drop Zone 3") ){
    startXVal = 170;
    setBallStartPos();
  }
  if(uied.eventIsFromWidget("Drop Ball") ){
    moving = true;
  }
}
