class FourierCircle {
  public float mag, phase, freq; // rad/frame
  FourierCircle(float _mag, float _phase, float _freq) {
    this.mag = _mag;
    this.phase = _phase;
    this.freq = _freq;
  }
  public void update() {
    this.phase += TWO_PI*this.freq/stepConst * 10*mouseX/width;
    if (this.phase >= TWO_PI) this.phase %= TWO_PI;
  }
  public void drawLine(FloatVec _pos, float _phase) {
    line(_pos.x, _pos.y, _pos.x + this.mag*cos(_phase + this.phase), _pos.y + this.mag*sin(_phase + this.phase));
  }
  public void drawCircle(FloatVec _pos) {
    circle(_pos.x, _pos.y, 2 * this.mag);
  }
};
