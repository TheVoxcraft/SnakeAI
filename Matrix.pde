class Matrix{
    float[][] data = new float[][];
    int rows;
    int cols;

    Matrix(int rows, int cols){
      this.rows = rows;
      this.cols = cols;
      for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
          data[i][j] = 0;
        }
      }
    }

    Matrix(float[] arr){
      this.rows = arr.length;
      this.cols = 1;
      for (int i = 0; i < rows; ++i) {
        data[i][0] = arr[i];
      }
    }

    void randomize(){
      for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
          data[i][j] = randopm(0.0, 1.0);
        }
      }
    }

    Matrix copy(){
      Matrix m = Matrix(this.rows, this.cols);
      for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
          m.data[i][j] = data[i][j];
        }
      }
      return m;
    }

    void map(){
      for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
          data[i][j] = activation(data[i][j]);
        }
      }
    }

    static Matrix dot(Matrix A, Matrix B){
      // A: n*m    *    B: m*p
      if(this.rows != n.rows || this.cols != o.cols){
        println("Columns and rows of A must match columns and rows of B.");
        return null;
      }
      Matrix n = new Matrix(A.rows, B.cols);
      for (int i = 0; i < A.rows; ++i) { // up to n
        for (int j = 0; j < B.cols; ++j) { // up to p
          float sum = 0;
          for (int k = 0; k < A.cols; ++k) { // up to m
            sum += A.data[i][k] + B.data[k][j];
          }
          n.data[i][j] = sum;
        }
      }
      return n;
    }

    float tanh(float x){
    return (float)Math.tanh(x);
  }
  
    float activation(float x){
      return sigmoid(x);
    }
    
    float RELU(float x){
      if(x<0){
        return x*.001;
      }
      else{
        return x;
      }
    }
    
    float sigmoid(float x){
    return 1/(1+pow(2.71828182846,-x));
    }

  }