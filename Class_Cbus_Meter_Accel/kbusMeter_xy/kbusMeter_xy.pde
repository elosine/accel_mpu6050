import netP5.*;
import oscP5.*;

OscP5 osc;
NetAddress sc;

float kdatx = 0.0;
float x = 0.0;
float kdaty = 0.0;
float y = 0.0;
float l, t, r, b;
float w = 270.0;
float h = 270.0;


void setup() {
  size(500, 500);
  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);
  osc.plug(this, "meter", "/kdat");
  l = (width/2)-(w/2);
  t = (height/2)-(h/2);
  r = l+w;
  b = t+h;
}

void draw() {
  background(0);
  osc.send("/getkdat", new Object[]{0}, sc);
  x = map(kdatx, 0.0, 1.0, l, r);
  y = map(kdaty, 0.0, 1.0, t, b);
  fill(153, 255, 0);
  noStroke();
  rect(l, t, w, h);
  strokeWeight(1);
  stroke(0);
  line(l, y, r, y);
  line(x, t, x, b);
  noStroke();
  fill(255, 127, 0);
  ellipseMode(CENTER);
  ellipse(x, y, 10, 10);
}

void meter(int bus, float valx, float valy) {
  kdatx = valx;
  kdaty = valy;
}