// Used to compute and store FourtierTransform and wave

class FourierTransform {
  private Waveform waveform;
  private ArrayList<Complex> complexWave_Y = new ArrayList<Complex>();
  private FourierWave fourierWaveY = new FourierWave(new FloatVec(width/2,  height*3/4));
  public boolean doneFourier = false, drawFourier = false;
  private float span, freq = 0, drawStep = 0, threshold = 0.2;
  
  FourierTransform(Waveform _waveform, float _span) {
    this.waveform = _waveform;
    this.span = _span;
    waveform.calcMin();
  }
  
  public void compute_Y(float _x, float _y) {
    push();
    translate(_x, _y);
    for (int i = 0; i < step/freqStep/60; i++) {
      if (freq < freqRange) {
        this.complexWave_Y.add(waveform.calcComplex_Y(freq, i == 0));
        freq += freqStep;
      } else {
        this.doneFourier = true;
      }
    }
    pop();
  }
  
  // fourier mag representation
  public void showComplexMag_Y(float _x, float _y) {
    push();
    translate(_x, _y);
    noFill();
    beginShape();
    stroke(255,0,255);
    for (int i = 0; i < this.complexWave_Y.size(); i++) {
      vertex(i * this.span/this.complexWave_Y.size() * freq/freqRange, -this.complexWave_Y.get(i).magnitude()); 
    }
    endShape();
    stroke(255,0,255, 255/4);
    if (this.drawFourier) line(0, -this.threshold, width/2, -this.threshold);
    pop();
  }
  
  // fourier phase representation
  public void showComplexPhase_Y(float _x, float _y) {
    push();
    translate(_x, _y);
    noFill();
    beginShape();
    stroke(0,255,0);
    for (int i = 0; i < this.complexWave_Y.size(); i++) {
      vertex(i * this.span/this.complexWave_Y.size() * freq/freqRange, -this.complexWave_Y.get(i).phase()*45/PI); 
    }
    endShape();
    pop();
  }
  
  // fourier complex components representation
  public void showComplexComponents_Y(float _x, float _y) {
    push();
    translate(_x, _y);
    noFill();
    beginShape();
    stroke(255,0,0);
    for (int i = 0; i < this.complexWave_Y.size(); i++) {
      vertex(i * this.span/this.complexWave_Y.size() * freq/freqRange, -this.complexWave_Y.get(i).a); 
    }
    endShape();
    beginShape();
    stroke(0,0,255);
    for (int i = 0; i < this.complexWave_Y.size(); i++) {
      vertex(i * this.span/this.complexWave_Y.size() * freq/freqRange, -this.complexWave_Y.get(i).b); 
    }
    endShape();
    pop();
  }
  
  // Final result
  private void createFourier_Y(String method) {
    if (!this.doneFourier) return;
    if (this.drawFourier) return;
    // this.threshold = 1;
    int index;
    
    Complex maxBefore = new Complex(0,0);
    Complex maxCurrent = new Complex(0,0);
    Complex maxAfter = new Complex(0,0);
   
    for (int i = 0; i < this.complexWave_Y.size(); i++) {
      
      // Method of max frequencies of neightbours
      if (method == "peak") {
        if (this.isMax_Y(i, this.complexWave_Y.size())) {
          
          // center i
          index = i;
          while (this.isMax_Y(index+1, this.complexWave_Y.size())) index++;
          i = (i+index)/2;
          
          maxCurrent = this.complexWave_Y.get(i);
          
          if (maxBefore.magnitude() == 0) {
            maxBefore = maxCurrent;
            continue;
          }
            
          // compare current max to max before
          if (maxCurrent.magnitude() > maxBefore.magnitude()) {
            
            // go to next max
            int tempI = index+1;
            while (tempI < this.complexWave_Y.size() && !this.isMax_Y(tempI, this.complexWave_Y.size())) tempI++;
            if (tempI >= this.complexWave_Y.size()) continue;
            
            // center tempI
            int indexTemp = tempI;
            while (tempI < this.complexWave_Y.size() && this.isMax_Y(indexTemp+1, this.complexWave_Y.size())) indexTemp++;
            if (tempI >= this.complexWave_Y.size()) continue;
            tempI = (tempI+indexTemp)/2;
            
            maxAfter = this.complexWave_Y.get(tempI);
            
            // println(maxBefore.magnitude(), maxCurrent.magnitude(), maxAfter.magnitude());
            
            // compare current max to max after
            if (maxCurrent.magnitude() > maxAfter.magnitude()) {
              this.fourierWaveY.addCircle(new FourierCircle(maxCurrent.magnitude()*2, maxCurrent.phase() - HALF_PI, i*freqStep));
              this.fourierWaveY.addCircle(new FourierCircle(maxCurrent.magnitude()*2, -maxCurrent.phase() - HALF_PI, -i*freqStep));
              
              println("Mag:", maxCurrent.magnitude());
              println("Phase:", maxCurrent.phase());
              println("Freq:", i*freqStep);
              
              stroke(255);
              line((float)i/this.complexWave_Y.size()*width/2, height/2, (float)i/this.complexWave_Y.size()*width/2, height);
            }
          }
          maxBefore = maxCurrent;
        }
      }
      
      else if (method == "any") {
        if (this.isMax_Y(i, this.complexWave_Y.size())) {
          
          // center i
          index = i;
          while (this.isMax_Y(index+1, this.complexWave_Y.size())) index++;
          i = (i+index)/2;
          
          maxCurrent = this.complexWave_Y.get(i);
      
          this.fourierWaveY.addCircle(new FourierCircle(maxCurrent.magnitude()*2, maxCurrent.phase() - HALF_PI, i*freqStep));
          this.fourierWaveY.addCircle(new FourierCircle(maxCurrent.magnitude()*2, -maxCurrent.phase() - HALF_PI, -i*freqStep));
          
          println("Mag:", maxCurrent.magnitude());
          println("Phase:", maxCurrent.phase());
          println("Freq:", i*freqStep);
          
          stroke(255);
          line((float)i/this.complexWave_Y.size()*width/2, height/2, (float)i/this.complexWave_Y.size()*width/2, height);
        }
      }
      
      else {
        println("error, invalid method used in FourierTransfrom.createFourier()");
        noLoop();
      }
    }
    run = false;
    this.drawFourier = true;
  }
  
   private boolean isMax_Y(int i, int upper) {
    int lowerIndex = i-1, upperIndex = i+1;
    if (lowerIndex < 0) return false;
    if (upperIndex >= upper) return false;
    
    if (this.complexWave_Y.get(lowerIndex).magnitude() <= this.complexWave_Y.get(i).magnitude() && this.complexWave_Y.get(i).magnitude() >= this.complexWave_Y.get(upperIndex).magnitude()) {
      if (this.complexWave_Y.get(i).magnitude() > this.threshold) return true;
      else return false;
    }
    else return false;
  }
  
  public void showFourierWave_Y() {
    if (this.doneFourier && !this.drawFourier) this.createFourier_Y("peak");
    else if (this.drawFourier) {     
      stroke(255);
      strokeWeight(1);
      this.fourierWaveY.showLine();
      
      if (drawStep >= width/2 / step) {
        noLoop();
        return;
      }
      // this.fourierWaveY.pos.x = width/2; //* unitsPerWindow;
      strokeWeight(2);
      this.fourierWaveY.show(true, true);
      this.fourierWaveY.offsetPoints_X(step * width/2 / (unitLength*unitsPerWindow) * mouseX/width);
      this.fourierWaveY.update();
      this.fourierWaveY.deleteExcess();
      drawStep += (float)mouseX/width; // += step*unitLength/60 * 2*mouseX/width;
      // frameRate(5);
    }
  }
  
  public void addPoint_Y(Complex _c) {
    this.complexWave_Y.add(_c);
  }
};
