// Used for showing and updating FourierWave

class FourierWave {
  public FloatVec pos;
  private ArrayList<FourierCircle> circles = new ArrayList<FourierCircle>();
  public ArrayList<FloatVec> points = new ArrayList<FloatVec>();
  FourierWave(FloatVec _pos) {
    this.pos = _pos;
  }
  public void addCircle(FourierCircle circle) {
    circles.add(circle);
  }
  public void show(boolean _line, boolean _circle) {    
    FloatVec prevOffset = new FloatVec(), offset = new FloatVec();
    prevOffset.copy(pos);
    float prevPhase = 0;
    FourierCircle c;
    for (int i = 0; i < circles.size(); i++) {  
      c = circles.get(i);
      offset.set(prevOffset.x + c.mag * cos(c.phase + prevPhase), prevOffset.y + c.mag * sin(c.phase + prevPhase));
      if (_circle) {
        stroke(255, 255/4);
        c.drawCircle(prevOffset);   
      }
      if (_line) {
        stroke(255);
        c.drawLine(prevOffset, prevPhase);
      }
      prevOffset.copy(offset);
      //println(c.mag, " ", c.freq, " ", c.phase);
      //break;
    }
  }
  public void update() {
    FloatVec prevOffset = new FloatVec(), offset = new FloatVec();
    prevOffset.copy(pos);
    FourierCircle c;
    for (int i = 0; i < circles.size(); i++) {  
      c = circles.get(i);
      offset.set(prevOffset.x + c.mag * cos(c.phase), prevOffset.y + c.mag * sin(c.phase));
      c.update();
      prevOffset.copy(offset);
    }
    points.add(offset);
  }
  public void showPoints() {
    for (int i = 0; i < points.size(); i++) {
      point(points.get(i).x, points.get(i).y);
    }
  }
  public void offsetPoints_X(float _x) {
    //if (points.size() > 0) points.get(points.size()-1).x = _x;
    for (int i = 0; i < points.size(); i++) {
      points.get(i).x += _x;
    }
  }
  public void showLine() {
    beginShape();
    for (int i = 0; i < points.size(); i++) {
      vertex(points.get(i).x, points.get(i).y);
    }
    endShape();
  }
  public void deleteExcess() {
    for (int i = 0; i < points.size(); i++) {
      if (points.get(i).x > width) points.remove(i);
    }
  }
}
