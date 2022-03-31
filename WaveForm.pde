// Used for original/input wave

class Waveform {
  public ArrayList<FloatVec> floatWave = new ArrayList<FloatVec>();
  private float span;
  
  // floatWaveform
  Waveform() {}
  
  // floatWaveform (cosine)
  Waveform(float _span, float _mag, float _freq, float _phase) {
    this.span = _span;
    
    // Sine floatWave
    for (float i = 0; i < this.span; i += 1/step) {
      this.floatWave.add(new FloatVec(i - this.span/2, _mag*cos(TWO_PI * _freq * i / unitLength + _phase)));
    }
  }
  
  // floatWaveform (square)
  Waveform(float _span, float _mag) {
    this.span = _span;
    
    // Square floatWave
    for (float i = 0; i < this.span; i += 1/step) {
      if (i%unitLength < unitLength/2) this.floatWave.add(new FloatVec(i - this.span/2, _mag));
      else this.floatWave.add(new FloatVec(i - this.span/2, -_mag));
    }
  }
  
  // floatWaveform (input)
  Waveform(ArrayList<FloatVec> _waveform, float _span) {
    this.span = _span;
    
    for (int i = 0; i < _waveform.size(); i++) {
      this.floatWave.add(new FloatVec(_waveform.get(i).x, _waveform.get(i).y));
    }
  }
  
  // wave representation
  public void showFloatWave(float _x, float _y) {
    push();
    translate(_x, _y);
    noFill();
    beginShape();
    for (int i = 0; i < this.floatWave.size(); i++) {
      vertex(this.floatWave.get(i).x, -this.floatWave.get(i).y); 
    }
    endShape();
    pop();
  }
  
  //public void addPoint(FloatVec _fv) {
  //  this.floatWave.add(_fv);
  //}
  
  // Used for combining cosine waves
  public void addFloatWave(Waveform _floatWaveForm) {
    for (int i = 0; i < this.floatWave.size(); i++) {
      this.floatWave.get(i).y += _floatWaveForm.floatWave.get(i).y;
    }
  }
  
  //public void calcMin() {
  //  //float min = this.floatWave.get(0).y;
  //  //for (int i = 1; i < this.floatWave.size(); i++) {
  //  //  if (this.floatWave.get(i).y < min) min = this.floatWave.get(i).y;
  //  //}
  //  //this.min = min;
  //  this.min_X = 0;
  //  this.min_Y = 0;
  //}
  
  // Revolution
  public Complex calcComplex_X(float _freq, boolean _draw) {
    // if (this.doneFourier) return; //<>//
    // boolean fullRevolution = false;
    float mag, phase = 0;
    Complex avg = new Complex();
    noFill();
    beginShape();
    stroke(255);
    for (int i = 0; i < this.floatWave.size(); i++) {
      mag = floatWave.get(i).x;
      if (_draw) vertex(mag*cos(phase), -mag*sin(phase));
      // if (fullRevolution) 
      avg.add(mag*cos(phase), mag*sin(phase));
      phase -= TWO_PI*_freq/unitLength/step;
      // if (phase <= -TWO_PI) fullRevolution = true;
    }
    
    endShape();
    stroke(255,0,0);
    fill(255,0,0);
    avg.div(this.floatWave.size());
    if (_draw) circle(avg.a, -avg.b, 5);
    // this.complexWave.add(avg);
    return avg;
  }
  
  public Complex calcComplex_Y(float _freq, boolean _draw) {
    // if (this.doneFourier) return;
    // boolean fullRevolution = false;
    float mag, phase = 0;
    Complex avg = new Complex();
    noFill();
    beginShape();
    stroke(255);
    for (int i = 0; i < this.floatWave.size(); i++) {
      mag = floatWave.get(i).y;
      if (_draw) vertex(mag*cos(phase), -mag*sin(phase));
      // if (fullRevolution) 
      avg.add(mag*cos(phase), mag*sin(phase));
      phase -= TWO_PI*_freq/unitLength/step;
      // if (phase <= -TWO_PI) fullRevolution = true;
    }
    
    endShape();
    stroke(255,0,0);
    fill(255,0,0);
    avg.div(this.floatWave.size());
    if (_draw) circle(avg.a, -avg.b, 5);
    // this.complexWave.add(avg);
    return avg;
  }
};
