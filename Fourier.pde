FourierTransform fourierTransform;
Waveform wave;
boolean run = false;

float step, unitLength, freqStep = 0.005, freqRange = 64, unitsPerWindow = 4, computeTime = 2;

void setup() { //<>//
  size(1200,800);
  noFill();
  stroke(255, 255, 255, 255/8);
  strokeWeight(1);
  
  //// Use this for the wave versions
  unitLength = width/2 / unitsPerWindow;
  step = 100/unitLength;
  
  println(step);
  
  //println(unitLength*unitsPerWindow);
  //println(unitLength/unitsPerWindow/step);
  //println(unitsPerWindow/unitLength*step);
  //fWave = new FourierWave(new FloatVec(width/2, height/2));
  
  //// Domain space, Amplitude, Frequency, Phase (cosine)
  //wave = new WaveForm(width*1/2, height/(16+random(-4,4)), random(1,5), random(-HALF_PI, HALF_PI));
  //wave.addFloatWave(new WaveForm(width*1/2, height/(16+random(-4,4)), random(1,freqRange), random(-HALF_PI, HALF_PI)));
  //wave.addFloatWave(new WaveForm(width*1/2, height/(16+random(-4,4)), random(1,freqRange), random(-HALF_PI, HALF_PI)));
  
  // Sqaure Wave
  wave = new Waveform(width*1/2, height/5);
  
  //// Circle
  //ArrayList<FloatVec> floatWave = new ArrayList<FloatVec>();
  //for (float i = 0; i < TWO_PI; i += 1/step) {
  //  floatWave.add(new FloatVec(height/5*cos(i)+width/4, height/5*sin(i)));
  //}
  //wave = new Waveform(floatWave, width/2);
  
  //// Line 
  //ArrayList<FloatVec> floatWave = new ArrayList<FloatVec>();
  //for (float i = 0; i < width/2; i += 1/step) {
  //  floatWave.add(new FloatVec(i, height/4 * i/(width/2)));
  //}
  //wave = new Waveform(floatWave, width/2);
  
  fourierTransform = new FourierTransform(wave, width/2);
  
  background(20);
  
  stroke(255);
  strokeWeight(1);
  wave.showFloatWave(0, height*1/4);  
}

void draw() {
  if (run) {
    background(20);
    
    
    // draw input wave
    stroke(255);
    strokeWeight(1);
    wave.showFloatWave(0, height*1/4);  
    
    //// draw backgrounds
    //stroke(20);
    //fill(20);
    //rect(width/2, 0, width, height/2);
    //rect(0, height/2, width/2, height);
    //rect(width/2, height/2, width, height);
    //noFill();  
    
    // separate windows
    stroke(255);
    strokeWeight(1);
    line(width/2, 0, width/2, height);
    line(0, height/2, width, height/2);
    line(0, height*4/6, width*1/2, height*4/6);
    line(0, height*5/6, width*1/2, height*5/6);
    
    // draw complex plane
    stroke(255, 255/2);
    strokeWeight(1);
    line(width*3/4, 0, width*3/4, height*1/2);
    line(width*1/2, height*1/4, width, height*1/4);
    
    // draw unit lines
    stroke(255, 255/4);
    strokeWeight(1);
    for (int i = 0; i*width/2/freqRange < width/2; i++) {
      line(i*width/2/freqRange, height/2, i*width/2/freqRange, height);
    }
    
    // draw zero reference and 1 unit tick marks
    stroke(255, 255/2);
    strokeWeight(1);
    line(0, height*7/12, width*1/2, height*7/12);
    line(0, height*9/12, width*1/2, height*9/12);
    line(0, height*11/12, width*1/2, height*11/12);
    
    
    // Fourier Illustration is Complete
    //if (run) {
    //  background(20, 20, 20);
    //  fWave.addCircle(new FourierCircle(scale/step, 0, time/step));
    //  fWave.show(true, false);
    //  fWave.showPoints();
    //  fWave.update();
      
    //  time++;
    //} 
    
    // Wrap Waveform around the complex plane
    fourierTransform.compute_Y(width*3/4, height*1/4);
    
    // draw frequency line
    stroke(255, 255/2);
    strokeWeight(1);
    if (fourierTransform.freq/freqRange*width/2 < width/2) line(fourierTransform.freq/freqRange*width/2, height/2, fourierTransform.freq/freqRange*width/2, height);
    
    // draw fourierTransform Components
    fourierTransform.showComplexMag_Y(0, height*7/12);
    fourierTransform.showComplexComponents_Y(0, height*9/12);
    fourierTransform.showComplexPhase_Y(0, height*11/12);
    
    // draw inverse fourier
    fourierTransform.showFourierWave_Y();
  }
}

void mouseClicked() {
  run = run == false;
}
