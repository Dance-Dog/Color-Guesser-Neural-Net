void sigmoidMatrix(Matrix m) {
  for (int i = 0; i < m.data.length; i++) {
      for (int j = 0; j < m.data[i].length; j++) {
        float x = m.data[i][j];
        m.data[i][j] = 1 / (1 + (float)Math.exp(-x));
      }
    }
}

Matrix dSigmoidMatrix(Matrix m) {
  // sigmoid(x) * (1 - sigmoid(x))
  Matrix result = new Matrix(m.rows, m.cols);
  for (int i = 0; i < m.data.length; i++) {
    for (int j = 0; j < m.data[i].length; j++) {
      float y = m.data[i][j];
      result.data[i][j] = y * (1 - y);
    }
  }
  return result;
}

class NeuralNetwork {
  
  final int inputNodes;
  final int hiddenNodes;
  final int outputNodes;
  Matrix weightsIH;
  Matrix weightsHO;
  Matrix hiddenBias;
  Matrix outputBias; 
  float  learningRate;
  
  NeuralNetwork(int inputNodes, int hiddenNodes, int outputNodes) {
    this.inputNodes = inputNodes;
    this.hiddenNodes = hiddenNodes;
    this.outputNodes = outputNodes;
    
    // Initialize random weights
    this.weightsIH = new Matrix(hiddenNodes, inputNodes);
    this.weightsHO = new Matrix(outputNodes, hiddenNodes);
    this.weightsIH.randomize(); 
    this.weightsHO.randomize();
    
    this.hiddenBias = new Matrix(hiddenNodes, 1);
    this.outputBias = new Matrix(outputNodes, 1);
    this.hiddenBias.randomize();
    this.outputBias.randomize();
    
    this.learningRate = 0.1f;
  }
  
  float[] feedForward(float[] inputArray) {
    Matrix inputs = arrayToMatrix(inputArray);
    Matrix hidden = matrixProduct(weightsIH, inputs);
    hidden.add(this.hiddenBias);
    sigmoidMatrix(hidden);
    
    Matrix outputs = matrixProduct(weightsHO, hidden);
    outputs.add(outputBias);
    sigmoidMatrix(outputs);
    
    return outputs.toArray();
  }
  
  void train(float[] inputArray, float[] targetArray) {
    Matrix inputs = arrayToMatrix(inputArray);
    Matrix hidden = matrixProduct(weightsIH, inputs);
    hidden.add(this.hiddenBias);
    sigmoidMatrix(hidden);
    
    Matrix outputs = matrixProduct(weightsHO, hidden);
    outputs.add(outputBias);
    sigmoidMatrix(outputs);
    
    // ==================== OUTPUT/HIDDEN LAYER ====================
    
    // Convert target to matrix
    Matrix targets = arrayToMatrix(targetArray);
    
    // Calculate output layer errors
    // ERROR = TERGETS - OUTPUTS
    Matrix outputErrors = subtractMatrices(targets, outputs);
    
    // gradient = outputs * (1 - outputs)
    Matrix outputGradients = dSigmoidMatrix(outputs);
    outputGradients.multiply(outputErrors);
    outputGradients.multiply(this.learningRate);
    
    // Calculate deltas for HO weights
    Matrix hiddenTransposed = transposeMatrix(hidden);
    Matrix weightsHODeltas = matrixProduct(outputGradients, hiddenTransposed);
    
    //  Adjust deltas by HO weights
    this.weightsHO.add(weightsHODeltas);
    // Adjust bias by output gradients
    this.outputBias.add(outputGradients);
    
    // ==================== HIDDEN/INPUT LAYER ====================
    
    // Calculate hidden layer errors
    Matrix transposedWeightsHO = transposeMatrix(this.weightsHO);
    Matrix hiddenErrors = matrixProduct(transposedWeightsHO, outputErrors);
    
    // Calculate hidden gradient
    Matrix hiddenGradient = dSigmoidMatrix(hidden);
    hiddenGradient.multiply(hiddenErrors);
    hiddenGradient.multiply(this.learningRate);
    
    // Calculate deltas for IH weights
    Matrix transposedInputs = transposeMatrix(inputs);
    Matrix weightsIHDeltas = matrixProduct(hiddenGradient, transposedInputs);
    
    //  Adjust deltas by IH weights
    this.weightsIH.add(weightsIHDeltas);
    // Adjust bias by output gradients
    this.hiddenBias.add(hiddenGradient );
    // println(targetsMatrix);
    // println(outputs);
    // println(outputErrors);
  }
}
