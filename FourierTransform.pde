// Used to compute and store FourtierTransform and wave

class FourierTransform {
  private Waveform waveform;
  private ArrayList<Complex> complexWave_X = new ArrayList<Complex>();
  private ArrayList<Complex> complexWave_Y = new ArrayList<Complex>();
  private FourierWave fourierWaveX = new FourierWave(new FloatVec(width*3/4, height*3/4));
  private FourierWave fourierWaveY = new FourierWave(new FloatVec(width*3/4, height*3/4));
  private ArrayList<FloatVec> fourierWave = new ArrayList<FloatVec>();
  public boolean doneFourier = false, drawFourier = false;
  private float span, freq = 0, drawStep = 0, threshold = 1;
  
  FourierTransform(Waveform _waveform, float _span) {
    this.waveform = _waveform;
    this.span = _span;
    // waveform.calcMin();
  }
  
  public void compute(float _x, float _y) {
    push();
    translate(_x, _y);
    for (int i = 0; i < freqRange/freqStep/60/computeTime * 10*mouseX/width; i++) {
      if (freq < freqRange) {
        this.complexWave_X.add(waveform.calcComplex_X(freq, i == 0));
        this.complexWave_Y.add(waveform.calcComplex_Y(freq, i == 0));
        freq += freqStep;
      } else {
        this.doneFourier = true;
      }
    }
    pop();
  }
  
  // fourier mag representation
  public void showComplexMag(float _x, float _y) {
    push();
    translate(_x, _y);
    stroke(255,0,255);
    noFill();
    
    beginShape();
    for (int i = 0; i < this.complexWave_X.size(); i++) vertex(i * this.span/this.complexWave_X.size() * freq/freqRange, -this.complexWave_X.get(i).magnitude()); 
    endShape();
    beginShape();
    for (int i = 0; i < this.complexWave_Y.size(); i++) vertex(i * this.span/this.complexWave_Y.size() * freq/freqRange, -this.complexWave_Y.get(i).magnitude()); 
    endShape();
    pop();
  }
  
  // fourier phase representation
  public void showComplexPhase(float _x, float _y) {
    push();
    translate(_x, _y);
    stroke(0,255,0);
    noFill();
    beginShape();
    for (int i = 0; i < this.complexWave_X.size(); i++) vertex(i * this.span/this.complexWave_X.size() * freq/freqRange, -this.complexWave_X.get(i).phase()*45/PI); 
    endShape();
    beginShape();
    for (int i = 0; i < this.complexWave_Y.size(); i++) vertex(i * this.span/this.complexWave_Y.size() * freq/freqRange, -this.complexWave_Y.get(i).phase()*45/PI); 
    endShape();
    pop();
  }
  
  // fourier complex components representation
  public void showComplexComponents(float _x, float _y) {
    push();
    translate(_x, _y);
    noFill();
    
    beginShape();
    stroke(255,0,0);
    for (int i = 0; i < this.complexWave_X.size(); i++) vertex(i * this.span/this.complexWave_X.size() * freq/freqRange, -this.complexWave_X.get(i).a); 
    endShape();
    beginShape();
    stroke(0,0,255);
    for (int i = 0; i < this.complexWave_X.size(); i++) vertex(i * this.span/this.complexWave_X.size() * freq/freqRange, -this.complexWave_X.get(i).b); 
    endShape();
    
    beginShape();
    stroke(255,0,0);
    for (int i = 0; i < this.complexWave_Y.size(); i++) vertex(i * this.span/this.complexWave_Y.size() * freq/freqRange, -this.complexWave_Y.get(i).a); 
    endShape();
    beginShape();
    stroke(0,0,255);
    for (int i = 0; i < this.complexWave_Y.size(); i++) vertex(i * this.span/this.complexWave_Y.size() * freq/freqRange, -this.complexWave_Y.get(i).b); 
    endShape();
    pop();
  }
  
  // Final result
  private void createFourier(String method) {
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
              this.fourierWaveX.addCircle(new FourierCircle(maxCurrent.magnitude()*2, maxCurrent.phase(), i*freqStep));
              this.fourierWaveX.addCircle(new FourierCircle(maxCurrent.magnitude()*2, -maxCurrent.phase(), -i*freqStep));
              
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
        if (this.isMax_X(i, this.complexWave_X.size())) {
          int temp = i;
          
          // center i
          index = i;
          while (this.isMax_X(index+1, this.complexWave_X.size())) index++;
          i = (i+index)/2;
          
          maxCurrent = this.complexWave_X.get(i);
      
          this.fourierWaveX.addCircle(new FourierCircle(maxCurrent.magnitude(), maxCurrent.phase(), i*freqStep));
          this.fourierWaveX.addCircle(new FourierCircle(maxCurrent.magnitude(), -maxCurrent.phase(), -i*freqStep));
          
          println("Mag:", maxCurrent.magnitude());
          println("Phase:", maxCurrent.phase());
          println("Freq:", i*freqStep);
          
          stroke(255);
          line((float)i/this.complexWave_X.size()*width/2, height/2, (float)i/this.complexWave_X.size()*width/2, height);
          
          i = temp;
        }
        
        if (this.isMax_Y(i, this.complexWave_Y.size())) {
          int temp = i;
          
          // center i
          index = i;
          while (this.isMax_Y(index+1, this.complexWave_Y.size())) index++;
          i = (i+index)/2;
          
          maxCurrent = this.complexWave_Y.get(i);
      
          this.fourierWaveY.addCircle(new FourierCircle(maxCurrent.magnitude(), maxCurrent.phase() - HALF_PI, i*freqStep));
          this.fourierWaveY.addCircle(new FourierCircle(maxCurrent.magnitude(), -maxCurrent.phase() - HALF_PI, -i*freqStep));
          
          println("Mag:", maxCurrent.magnitude());
          println("Phase:", maxCurrent.phase());
          println("Freq:", i*freqStep);
          
          stroke(255);
          line((float)i/this.complexWave_Y.size()*width/2, height/2, (float)i/this.complexWave_Y.size()*width/2, height);
          
          i = temp;
        }
      }
      
      else if (method == "all") {
        if (i % skip == 0) { // take average between points next
          Complex current_X = this.complexWave_X.get(i);
          Complex current_Y = this.complexWave_Y.get(i);
          
          this.fourierWaveX.addCircle(new FourierCircle(current_X.magnitude()*freqStep*unitsPerWindow * floatWave.size()/(step*this.span) * skip, current_X.phase(), i*freqStep)); // mult by freqStep :: div by unitsPerWindow? slightly off :: 
          this.fourierWaveX.addCircle(new FourierCircle(current_X.magnitude()*freqStep*unitsPerWindow * floatWave.size()/(step*this.span) * skip, -current_X.phase(), -i*freqStep)); // *freqStep*unitLength/5 works at unitsPerWindow = 8
          
          this.fourierWaveY.addCircle(new FourierCircle(current_Y.magnitude()*freqStep*unitsPerWindow * floatWave.size()/(step*this.span) * skip, current_Y.phase() - HALF_PI, i*freqStep)); // mult by freqStep :: div by unitsPerWindow? slightly off :: 
          this.fourierWaveY.addCircle(new FourierCircle(current_Y.magnitude()*freqStep*unitsPerWindow * floatWave.size()/(step*this.span) * skip, -current_Y.phase() - HALF_PI, -i*freqStep)); // *freqStep*unitLength/5 works at unitsPerWindow = 8
          
          //println("Mag:", current_Y.magnitude());
          //println("Phase:", current_Y.phase());
          //println("Freq:", i*freqStep);
          //if (i == 1) break;
          
          //stroke(255);
          //line((float)i/this.complexWave_Y.size()*width/2, height/2, (float)i/this.complexWave_Y.size()*width/2, height);
        }
      }
      
      else {
        println("error, invalid method used in FourierTransfrom.createFourier()");
      }
    }
    run = false;
    this.drawFourier = true;
  }
  
  private boolean isMax_X(int i, int upper) {
    int lowerIndex = i-1, upperIndex = i+1;
    if (lowerIndex < 0) return false;
    if (upperIndex >= upper) return false;
    
    if (this.complexWave_X.get(lowerIndex).magnitude() <= this.complexWave_X.get(i).magnitude() && this.complexWave_X.get(i).magnitude() >= this.complexWave_X.get(upperIndex).magnitude()) {
      if (this.complexWave_X.get(i).magnitude() > this.threshold) return true;
      else return false;
    }
    else return false;
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
  
  public void updateFourierWave() {
    if (this.doneFourier && !this.drawFourier) this.createFourier(method);
    else if (this.drawFourier) {     
      stroke(200, 100, 255);
      strokeWeight(2);
      //this.fourierWaveX.showLine();
      //this.fourierWaveY.showLine();
      this.showFourierWave();
      
      if (drawStep > floatWave.size()) {
        noLoop();
        return;
      }

      // this.fourierWaveY.pos.x = width/2; //* unitsPerWindow;
      strokeWeight(2);
      this.fourierWaveX.show(true, false);
      this.fourierWaveY.show(true, false);
      //this.fourierWaveY.offsetPoints_X(1/step * 2*mouseX/width);
      this.fourierWaveX.update();
      this.fourierWaveY.update();
      
      this.fourierWave.add(new FloatVec(this.fourierWaveX.points.get(this.fourierWaveX.points.size()-1).x, this.fourierWaveY.points.get(this.fourierWaveY.points.size()-1).y));
      
      // this.fourierWaveX.points.get(this.fourierWaveX.points.size()-1).y -= drawStep/step; // DO NOT NEED TO FIGURE OUT
      this.fourierWaveX.deleteExcess();
      this.fourierWaveY.deleteExcess();
      drawStep += (float)10*mouseX/width; // += step*unitLength/60 * 2*mouseX/width;
      // frameRate(5);
      
      // showFourierWave();
    }
  }
  
  private void showFourierWave() {
    if (!this.doneFourier || !this.drawFourier) return;
    beginShape();
    for (int i = 0; i < this.fourierWave.size(); i++) {
      vertex(this.fourierWave.get(i).x, this.fourierWave.get(i).y);
    }
    endShape();
  }
  
  //public void showFourierWave_X() { // FOR TESTING ONLY
  //  if (this.doneFourier && !this.drawFourier) this.createFourier("all");
  //  else if (this.drawFourier) {     
  //    stroke(255);
  //    strokeWeight(1);
  //    this.fourierWaveX.showLine();
      
  //    if (drawStep >= height/2 * step) {
  //      noLoop();
  //      return;
  //    }
  //    // this.fourierWaveY.pos.x = width/2; //* unitsPerWindow;
  //    strokeWeight(2);
  //    this.fourierWaveX.show(true, false);
  //    //this.fourierWaveY.offsetPoints_X(1/step * 2*mouseX/width);
  //    this.fourierWaveX.update();
  //    this.fourierWaveX.points.get(this.fourierWaveX.points.size()-1).y -= drawStep/step; // DO NOT NEED TO FIGURE OUT
  //    this.fourierWaveX.deleteExcess();
  //    drawStep += (float)10*mouseX/width; // += step*unitLength/60 * 2*mouseX/width;
  //    // frameRate(5);
  //  }
  //}
  
  //public void showFourierWave_Y() {
  //  if (this.doneFourier && !this.drawFourier) this.createFourier("all");
  //  else if (this.drawFourier) {     
  //    stroke(255);
  //    strokeWeight(1);
  //    this.fourierWaveY.showLine();
      
  //    if (drawStep >= width/2 * step) {
  //      noLoop();
  //      return;
  //    }
  //    // this.fourierWaveY.pos.x = width/2; //* unitsPerWindow;
  //    strokeWeight(2);
  //    this.fourierWaveY.show(true, false);
  //    //this.fourierWaveY.offsetPoints_X(1/step * 2*mouseX/width);
  //    this.fourierWaveY.update();
  //    this.fourierWaveY.points.get(this.fourierWaveY.points.size()-1).x += drawStep/step;
  //    this.fourierWaveY.deleteExcess();
  //    drawStep += (float)10*mouseX/width; // += step*unitLength/60 * 2*mouseX/width;
  //    // frameRate(5);
  //  }
  //}
  
  public void addPoint_Y(Complex _c) {
    this.complexWave_Y.add(_c);
  }
};
