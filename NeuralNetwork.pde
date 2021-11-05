MatrixUtils mxu = new MatrixUtils();
class Network{
  
  int in_size = 14;
  int h1_size = 12;
  int h2_size = 6;
  int out_size = 4;
  
  float MUTATION_RATE = 0.05;
  
  Matrix weights_ih;
  Matrix weights_ho;
  Matrix weights_hh;

  Matrix bias_h;
  Matrix bias_h2;
  Matrix bias_o;

  Matrix d_prevInput = new Matrix(0,0);
  Matrix d_prevHidden = new Matrix(0,0);
  Matrix d_prevOut = new Matrix(0,0);;

  Network(){
    // Weights
    weights_ih = new Matrix(h1_size, in_size);
    weights_hh = new Matrix(h2_size, h1_size);
    weights_ho = new Matrix(out_size, h2_size);
    weights_ih.randomize();
    weights_ho.randomize();

    // Bias
    bias_h = new Matrix(h1_size, 1);
    bias_h2 = new Matrix(h2_size, 1);
    bias_o = new Matrix(out_size, 1);
    bias_h.randomize();
    bias_o.randomize();
  }

  Network(Network other){ // Clone network
    // Weights
    weights_ih = other.weights_ih.copy();
    weights_hh = other.weights_hh.copy();
    weights_ho = other.weights_ho.copy();

    // Bias
    bias_h = other.bias_h.copy();
    bias_h2 = other.bias_h2.copy();
    bias_o = other.bias_o.copy();
  }
  
  float[] infer(float[] finputs){

    // Feed forward
    Matrix inputs = new Matrix(finputs);
    
    Matrix hidden = mxu.dot(weights_ih, inputs);
    hidden.add(bias_h);
    hidden.mapActivationFunction();

    Matrix hidden2 = mxu.dot(weights_hh, hidden);
    hidden2.add(bias_h2);
    hidden2.mapActivationFunction();

    Matrix out = mxu.dot(weights_ho, hidden2);
    out.add(bias_o);
    out.mapActivationFunction2();

    d_prevInput = inputs;
    d_prevHidden = hidden;
    d_prevOut = out;
    return out.toArray();
  }
  
  Network Reproduce(){
    // TODO: Add crossover (?)
    Network child = new Network(this);

    mxu.mutateMatrix(child.weights_ih, MUTATION_RATE);
    mxu.mutateMatrix(child.weights_hh, MUTATION_RATE);
    mxu.mutateMatrix(child.weights_ho, MUTATION_RATE);

    mxu.mutateMatrix(child.bias_h, MUTATION_RATE);
    mxu.mutateMatrix(child.bias_h2, MUTATION_RATE);
    mxu.mutateMatrix(child.bias_o, MUTATION_RATE);
    
    return child;
  }
}
