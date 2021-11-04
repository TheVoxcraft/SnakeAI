class Matrix {

    float[][] data;
    int rows;
    int cols;

    // https://github.com/CodingTrain/Toy-Neural-Network-JS/blob/master/lib/matrix.js

    Matrix(int rows, int cols){
        data = new float[rows][cols];
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
        data = new float[rows][cols];
        for (int i = 0; i < cols; ++i){
            float e = arr[i];
            data[i][0] = e;
        }
    }

    float[] toArray(){
        float[] array = new float[this.rows * this.cols];
        for (int i = 0; i < cols; ++i) {
            for (int j = 0; j < rows; ++j) {
                array[i*this.cols+j] = data[i][j];
            }
        }
        return array;
    }

    void randomize(){
        for (int i = 0; i < rows; ++i) {
            for (int j = 0; j < cols; ++j) {
            data[i][j] = random(0.0, 1.0);
            }
        }
    }

    Matrix copy(){
        Matrix m = new Matrix(this.rows, this.cols);
        for (int i = 0; i < rows; ++i) {
            for (int j = 0; j < cols; ++j) {
            m.data[i][j] = data[i][j];
            }
        }
        return m;
    }

    void mapActivationFunction(){
        for (int i = 0; i < rows; ++i) {
            for (int j = 0; j < cols; ++j) {
            data[i][j] = activation(data[i][j]);
            }
        }
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

    @Override
    String toString(){
        return "Shape{"+cols+", "+rows+"}";
    }

}

class MatrixUtils {
    Matrix dot(Matrix A, Matrix B){
      // A: n*m    *    B: m*p
      if(A.rows != B.rows || A.cols != B.cols){
        println("Columns and rows of A must match columns and rows of B. - A: "+ A.toString() + ",  B: "+ B.toString());
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
}