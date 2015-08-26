// tweaks
int FRAMERATE = 60;
float DT = 1.0f;
int windowWidth = 730;
int windowHeight = 420;
float clockSize = 30;
float clockBufferDistance = 1;
int FRAMESTART = 400;
boolean saveimage = false;

// globals
boolean running = false;
int cframe = 0;
 
int numClockColumns = floor(windowWidth/clockSize-clockBufferDistance);
int numClockRows = floor(windowHeight/clockSize-clockBufferDistance);
Clock[][] clocks = new Clock[numClockColumns][numClockRows];
Clock cclock = null;
 
void setup() {
  size(500,500);
  frameRate(FRAMERATE);
  surface.setSize(windowWidth, windowHeight);
  for(int i=0; i<numClockColumns; i++) {
    for(int j=0; j<numClockRows; j++) {
      clocks[i][j] = new Clock(map(i+1, 0, numClockColumns+1, 0, windowWidth),
        map(j+1, 0, numClockRows+1, 0, windowHeight),
        clockSize);
    }
  }
  
  for(int i=0; i<numClockColumns; i++) {
      for(int j=0; j<numClockRows; j++) {
        if( clocks[i][j].isCenterClock() )
        cclock = clocks[i][j];
      }
  }
  
  for(int f=0; f<FRAMESTART; ++f) {
    ++cframe;
    for(int i=0; i<numClockColumns; i++) {
      for(int j=0; j<numClockRows; j++) {
        clocks[i][j].update(DT);
      }
    }
  }
}
 
void draw() {
  background(235);
  ++cframe;
  for(int i=0; i<numClockColumns; i++) {
    for(int j=0; j<numClockRows; j++) {
      clocks[i][j].update(DT);
      clocks[i][j].draw();
    }
  }
  
  if( cclock != null && cclock.hourHand.rot > 2* PI ) {
    // when the hour hand has turned a whole turn, stop saving
    saveimage = false;
  }
  if( saveimage ) {
    saveFrame("out/clock-######.png");
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
  
  boolean isCenterClock() {
    return x==windowWidth/2 && y==windowHeight/2;
  }
 
  void update(float dt) {
    hourHand.turn(dt);
    minuteHand.turn(dt);
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
  float rot;
 
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
    rot = 0;
  }
 
  void turn(float dt) {
    if(cframe>direction.mag() || isCenterClock) {
      direction.rotate(dt * ( PI/-150) );
      if(frameCount > 0 ) {
        // frameCount is 0 during setup, only count rotation
        // during running and not during the setup dry rotation
        rot += dt * ( PI/-150);
      }
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
 
  void turn(float dt) {
    if(cframe>direction.mag() || isCenterClock) {
      direction.rotate(dt * (PI/150));
    }
  }
 
  void draw() {
    strokeWeight(2.25);
    strokeCap(ROUND);
    stroke(0);
    line(x,y,x+direction.setMag(null,l).x,y+direction.setMag(null,l).y);
    // fill(0);
    // text(direction.mag(), x,y);
  }
}