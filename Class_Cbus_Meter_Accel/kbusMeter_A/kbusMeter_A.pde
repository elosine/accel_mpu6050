import netP5.*;
import oscP5.*;

OscP5 osc;
NetAddress sc;

float kdat = 0.0;
float x = 0.0;
float l,t,r,b;
float w = 200.0;
float h = 50.0;


void setup(){
  size(500,500);
  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);
  osc.plug(this,   "meter", "/kdat");
  l = (width/2)-(w/2);
  t = (height/2)-(h/2);
  r = l+w;
  b = t+h;
  
}

void draw(){
  background(0);
  osc.send("/getkdat", new Object[]{0}, sc);
  x = map(kdat, 0.0, 1.0, l, r);
  fill(153,255,0);
  noStroke();
  rect(l, t, w, h);
  strokeWeight(3);
  stroke(255,127,0);
  line(x, t, x, b);
}

void meter(int bus, float val){
  kdat = val;
}