class Network{
  
  int in_size = 12;
  int h1_size = 10;
  //int h2_size = 10;
  int out_size = 4;
  
  float mutationRate = 0.05;
  
  Matrix weights_ih;
  Matrix weights_ho;

  MatrixUtils mxu = new MatrixUtils();

  Network(){
    weights_ih = new Matrix(h1_size, in_size);
    weights_ho = new Matrix(out_size, h1_size);
    weights_ih.randomize();
    weights_ho.randomize();
  }
  
  float[] infer(float[] finputs){

    // Feed forward
    
    Matrix inputs = new Matrix(finputs);
    Matrix hidden = mxu.dot(weights_ih, inputs);
    hidden.mapActivationFunction();
    //Matrix hidden2 = mxu.dot(weights_hh, inputs);

    Matrix out = mxu.dot(weights_ho, hidden);
    out.mapActivationFunction();

    return out.toArray();
  }
  
  Network Reproduce(){
    //Network child = new Network();
    
    return this;
  }
}
