int windowWidth = 730;
int windowHeight = 420;
float clockSize = 30;
float clockBufferDistance = 1;
 
int numClockColumns = floor(windowWidth/clockSize-clockBufferDistance);
int numClockRows = floor(windowHeight/clockSize-clockBufferDistance);
Clock[][] clocks = new Clock[numClockColumns][numClockRows];
 
void setup() {
  size(500,500);
  surface.setSize(windowWidth, windowHeight);
  for(int i=0; i<numClockColumns; i++) {
    for(int j=0; j<numClockRows; j++) {
      clocks[i][j] = new Clock(map(i+1, 0, numClockColumns+1, 0, windowWidth), map(j+1, 0, numClockRows+1, 0, windowHeight), clockSize);
    }
  }
}
 
void draw() {
  background(235);
  for(int i=0; i<numClockColumns; i++) {
    for(int j=0; j<numClockRows; j++) {
      clocks[i][j].update();
      clocks[i][j].draw();
    }
  }
}
 
class Clock {
  float x,y,d;
  Hour_Hand hourHand;
  Minute_Hand minuteHand;
 
  Clock(float x_, float y_, float d_) {
    x=x_;
    y=y_;
    d=d_;
    hourHand = new Hour_Hand(x,y,d);
    minuteHand = new Minute_Hand(x,y,d);
  }
 
  void update() {
    hourHand.turn();
    minuteHand.turn();
  }
 
  void draw() {
    noStroke();
    fill(255);
    ellipse(x,y,d,d);
    hourHand.draw();
    minuteHand.draw();
  }
}
 
class Hour_Hand {
  float x,y,l;
  PVector direction;
  boolean isCenterClock;
 
  Hour_Hand(float x_, float y_, float d_) {
    x=x_;
    y=y_;
    l=d_/2;
    isCenterClock = x==windowWidth/2 && y==windowHeight/2;
    if (!isCenterClock) {
      direction = new PVector(windowWidth/2-x,windowHeight/2-y);
    } else {
      direction = new PVector(l,0);
    }
    direction.rotate(PI/2);
  }
 
  void turn() {
    if(frameCount>direction.mag() || isCenterClock) {
      direction.rotate(PI/-150);
    }
  }
 
  void draw() {
    strokeWeight(2.25);
    strokeCap(ROUND);
    stroke(0);
    line(x,y,x+direction.setMag(null,l).x,y+direction.setMag(null,l).y);
  }
}
 
class Minute_Hand {
  float x,y,l;
  PVector direction;
  boolean isCenterClock;
 
  Minute_Hand(float x_, float y_, float d_) {
    x=x_;
    y=y_;
    l=d_/2-d_/8;
    isCenterClock = x==windowWidth/2 && y==windowHeight/2;
    if (!isCenterClock) {
      direction = new PVector(windowWidth/2-x,windowHeight/2-y);
    } else {
      direction = new PVector(l,0);
    }
    direction.rotate(PI/-2);
  }
 
  void turn() {
    if(frameCount>direction.mag() || isCenterClock) {
      direction.rotate(PI/150);
    }
  }
 
  void draw() {
    strokeWeight(2.25);
    strokeCap(ROUND);
    stroke(0);
    line(x,y,x+direction.setMag(null,l).x,y+direction.setMag(null,l).y);
  }
}