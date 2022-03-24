class FloatVec {
  public float x, y;
  FloatVec() {
    this.x = 0;
    this.y = 0;
  }
  FloatVec(float i, float j) {
   this.set(i, j);
  }
  public void set(float i, float j) {
    this.x = i;
    this.y = j;
  }
  public void copy(FloatVec _fv) {
     this.x = _fv.x;
     this.y = _fv.y;
  }
  public void add(float _x, float _y) {
    this.x += _x;
    this.y += _y;
  }
  public void add(FloatVec _fv) {
    this.x += _fv.x;
    this.y += _fv.y;
  }
  public void sub(FloatVec _fv) {
    this.x -= _fv.x;
    this.y -= _fv.y;
  }
   public void mult(float _k) {
    this.x *= _k;
    this.y *= _k;
  }
  public void mult(FloatVec _fv) {
    this.x *= _fv.x;
    this.y *= _fv.y;
  }
  public void div(float _k) {
    if (_k != 0) {
      this.x /= _k;
      this.y /= _k;
    }
    else println("Division by Zero!");
  }
  public void div(FloatVec _fv) {
    if (_fv.x != 0) this.x /= _fv.x;
    else println("Division by Zero!");
    if (_fv.y != 0) this.y /= _fv.y;
    else println("Division by Zero!");
  }
  public float mag() {
    return sqrt(pow(this.x,2) + pow(this.y,2));
  }
};
