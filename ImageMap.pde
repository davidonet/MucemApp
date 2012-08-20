class ImageMap
{
  class TouchZone
  {
    PVector tTopLeft;
    PVector tBottomRight;
    Function tFunc;
    TouchZone(int xmin, int ymin, int xmax, int ymax, Function aFunc) {
      tTopLeft = new PVector(xmin, ymin);
      tBottomRight = new PVector(xmax, ymax);
      tFunc = aFunc;
    }
    boolean isIn(int x, int y) {
      return ((tTopLeft.x < x) && (x < tBottomRight.x)) && ((tTopLeft.y < y) && (y < tBottomRight.y));
    }
  }

  ArrayList theZones;
  boolean isActive;

  ImageMap() {
    theZones = new ArrayList();
    isActive = true;
  }

  void addATouchZone(int xmin, int ymin, int xmax, int ymax, Function aFunc) {
    theZones.add(new TouchZone(xmin, ymin, xmax, ymax, aFunc));
  }
  void testIn(int x, int y) {
    if (isActive)
      for (int i=0;i<theZones.size();i++) {
        TouchZone aTZ = (TouchZone)theZones.get(i);
        if (aTZ.isIn(x, y)) {
          aTZ.tFunc.call();
        }
      }
  }
}

