FourierTransform fourierTransform;
Waveform wave;
boolean run = false, drawing;

float step, unitLength, freqStep = 0.005, freqRange = 64, unitsPerWindow = 1, computeTime = 6, stepConst = 1000;
String method = "all";

ArrayList<FloatVec> floatWave = new ArrayList<FloatVec>();

void setup() { //<>// //<>// //<>//
  size(1200,800);
  noFill();
  stroke(255, 255, 255, 255/8);
  strokeWeight(1);
  
  // Use this for the wave versions
  unitLength = width/2 / unitsPerWindow;
  println(unitLength);
  step = stepConst/unitLength;
  
  println(freqStep*unitLength);
  
  //println(unitLength*unitsPerWindow);
  //println(unitLength/unitsPerWindow/step);
  //println(unitsPerWindow/unitLength*step);
  //fWave = new FourierWave(new FloatVec(width/2, height/2));
  
  //// Domain space, Amplitude, Frequency, Phase (cosine)
  //wave = new Waveform(width*1/2, height/(16+random(-4,4)), random(1,5), random(-HALF_PI, HALF_PI));
  //wave.addFloatWave(new Waveform(width*1/2, height/(16+random(-4,4)), random(1,16), random(-HALF_PI, HALF_PI)));
  //wave.addFloatWave(new Waveform(width*1/2, height/(16+random(-4,4)), random(1,16), random(-HALF_PI, HALF_PI)));
  
  //// Sqaure Wave
  //wave = new Waveform(width*1/2, height/5);
  
  //// Circle
  //floatWave = new ArrayList<FloatVec>();
  //for (float i = 0; i < width/2; i += 1/step) {
  //  floatWave.add(new FloatVec(height/5*cos(TWO_PI * i/(width/2)), height/5*sin(TWO_PI * i/(width/2))));
  //}
  //wave = new Waveform(floatWave, width/2);
  
  //// Line 
  //floatWave = new ArrayList<FloatVec>();
  //for (float i = 0; i < width/2; i += 1/step) {
  //  floatWave.add(new FloatVec(i, height/4 * i/(width/2)));
  //}
  //wave = new Waveform(floatWave, width/2);
  
  // draw
  drawing = true;
  
  background(20);
  
  // separate windows
  stroke(255);
  strokeWeight(1);
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
  
  //stroke(255);
  //strokeWeight(1);
  //wave.showFloatWave(width/4, height*1/4);
  //fourierTransform = new FourierTransform(wave, width/2);
}

void draw() {
  if (run) {
    background(20);
    
    
    // draw input wave
    stroke(255);
    strokeWeight(1);
    wave.showFloatWave(width*1/4, height*1/4);  
    
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
    fourierTransform.compute(width*3/4, height*1/4);
    
    // draw frequency line
    stroke(255, 255/2);
    strokeWeight(1);
    if (fourierTransform.freq/freqRange*width/2 < width/2) line(fourierTransform.freq/freqRange*width/2, height/2, fourierTransform.freq/freqRange*width/2, height);
    
    // draw fourierTransform Components
    fourierTransform.showComplexMag(0, height*7/12);
    fourierTransform.showComplexComponents(0, height*9/12);
    fourierTransform.showComplexPhase(0, height*11/12);
    
    // draw reference
    stroke(255,50);
    strokeWeight(4);
    wave.showFloatWave(width*3/4, height*3/4);  
    
    //// draw inverse fourier
    //fourierTransform.showFourierWave_X();
    
    fourierTransform.updateFourierWave();
  }
  else if (drawing == true) {
    beginShape();
    for (int i = 0; i < floatWave.size(); i++) vertex(floatWave.get(i).x + width/4, -(floatWave.get(i).y - height/4));
    endShape();
  }
}

void mouseClicked() {
  println("IN MOUSECLICKED");
  run = run == false;
}

void mouseDragged() {
  println("IN MOUSEDRAGGED");
  if (drawing == true) {
    floatWave.add(new FloatVec(mouseX - width/4, -(mouseY - height/4)));
  }
}

void mouseReleased() {
  if (drawing == true) {
    drawing = false;
    wave = new Waveform(floatWave, width/2);
    
    println("IN MOUSERELEASED");
    
    stroke(255);
    strokeWeight(1);
    wave.showFloatWave(width/4, height*1/4); 
    fourierTransform = new FourierTransform(wave, width/2);
    
    run = true;
  }
}
