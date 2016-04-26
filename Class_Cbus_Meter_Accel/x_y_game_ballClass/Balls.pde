class Balls {
  //constructor vars
  int ix;
  float bx, by, dia;
  //class vars
  int r, g, b;
  boolean visable = true;

  //constructor
  Balls(int aix, float abx, float aby, float adia) {
    ix = aix;
    bx = abx;
    by = aby;
    dia = adia;

    //instance setup
    r = int(random(0, 255));
    g = int(random(0, 255));
    b = int(random(0, 255));
  }

  void drw() {
    if (visable) {
      ellipseMode(CENTER);
      noStroke();
      fill(r, g, b);
      ellipse(bx, by, dia, dia);
    }
  }
}