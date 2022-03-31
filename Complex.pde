class Complex {
  public float a, b;
  Complex() {}
  Complex(float _a, float _b) {
    this.a = _a;
    this.b = _b;
  }
  public float magnitude() { 
    return sqrt(pow(this.a,2) + pow(this.b,2)); 
  }
  public float phase(/* float threshold */) {
    float offset = 0;
    if (this.a < 0 && this.b > 0) offset += PI;
    if (this.a < 0 && this.b < 0) offset -= PI;
    if (this.a == 0 && this.b > 0) return PI;
    if (this.a == 0 & this.b == 0) return 0;
    if (this.a == 0 && this.b < 0) return -PI;
    return atan(this.b / this.a) + offset; 
  }
  public void add(float _a, float _b) {
    this.a += _a;
    this.b += _b;
  }
  public void div(float _k) {
    this.a /= _k;
    this.b /= _k;
  }
};
