interface MatrixOperation {
  void apply(int row, int col, float value);
}

class Matrix {
  
  int rows;
  int cols;
  float[][] data;
  
  Matrix(int rows, int columns) {
    this(rows, columns, false);
  }
  
  Matrix(int rows, int columns, boolean random) {
    this.rows = rows;
    this.cols = columns;
    this.data = new float[rows][];
    
    for (int i = 0; i < rows; i++) {
      data[i] = new float[cols];
      for (int j = 0; j < cols; j++) {
        data[i][j] = 0f;
      }
    }
    
    if (random) {
      this.randomize();
    }
  }
  
  void map(MatrixOperation operation) {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        operation.apply(i, j, this.data[i][j]);
      }
    }
  }
  
  /**
   * Set this matrix's contents to random values between -1 and 1
   */
  void randomize() {
    map((row, col, value) -> {
      this.data[row][col] = random(-1, 1);
    });
  }
  
  /**
   * Add another matrix to this one (elementwise)
   */
  void add(Matrix n) {
    map((row, col, value) -> {
      data[row][col] += n.data[row][col];
    });
  }
  
  /**
   * Add a number to the matrix (scalar)
   */
  void add(float n) {
    map((row, col, value) -> {
      data[row][col] += n;
    });
  }
  
  /**
   * Multiply this matrix by another (elementwise)
   */
  void multiply(Matrix n) {
    map((row, col, value) -> {
      data[row][col] *= n.data[row][col];
    });
  }
  
  /**
   * Multiply this matrix by a number (scalar)
   */
  void multiply(float n) {
    map((row, col, value) -> {
      data[row][col] *= n;
    });
  }
  
  float[] toArray() {
    float[] result = new float[data.length];
    for (int row = 0; row < rows; row++) {
      result[row] = data[row][0]; //<>// //<>// //<>//
    }
    return result;
  }
  
  String toString() {
    String rowStr = "[\n";
    for (int i = 0; i < rows; i++) {
      String colStr = "\t[ ";
      for (int j = 0; j < cols; j++) {
        colStr += data[i][j];
        if (j != cols - 1) {
          colStr += ", ";
        }
      }
      colStr += " ]\n";
      rowStr += colStr;
    }
    rowStr += "]";
    return rowStr;
  }
}

void mapToMatrix(Matrix a, MatrixOperation operation) {
  for (int i = 0; i < a.rows; i++) {
    for (int j = 0; j < a.cols; j++) {
      operation.apply(i, j, a.data[i][j]);
    }
  }
}

Matrix subtractMatrices(Matrix a, Matrix b) {
  if (a.rows != b.rows || a.cols != b.cols) {
    println("A and B must have the same dimensions");
    return null;
  }
  
  Matrix result = new Matrix(a.rows, a.cols);
  mapToMatrix(a, (row, col, value) -> {
    result.data[row][col] = a.data[row][col] - b.data[row][col];
  });
  return result;
}

Matrix transposeMatrix(Matrix m) {
  Matrix result = new Matrix(m.cols, m.rows);
  mapToMatrix(m, (row, col, value) -> {
    result.data[col][row] = m.data[row][col];
  });
  return result;
}

Matrix matrixProduct(Matrix a, Matrix b) {
  if (a.cols != b.rows) { //<>// //<>// //<>//
    println("Columns of A must equal rows of B");
    return null;
  }
  
  Matrix result = new Matrix(a.rows, b.cols);
  mapToMatrix(result, (row, col, value) -> {
    // Dot product of this row i and n column j
    float sum = 0;
    for (int i = 0; i < a.cols; i++) {
      sum += a.data[row][i] * b.data[i][col];
    }
    result.data[row][col] = sum;
  });
  return result;
}

/**
 * Convert a n x 1 matrix into an n-long array
 */
Matrix arrayToMatrix(float[] array) {
  Matrix result = new Matrix(array.length, 1);
  for (int row = 0; row < array.length; row++) {
    result.data[row][0] = array[row];
  }
  return result; 
}
