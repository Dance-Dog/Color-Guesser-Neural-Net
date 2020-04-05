enum Color {
  RED(255, 0, 0),
  ORANGE(222, 122, 9),
  YELLOW(224, 198, 49),
  GREEN(69, 201, 32),
  BLUE(39, 147, 214),
  PINK(214, 36, 205),
  PURPLE(84, 25, 212),
  BROWN(128, 89, 32);
  
  final int r;
  final int g;
  final int b;
  
  private Color(int red, int green, int blue) {
    this.r = red;
    this.g = green;
    this.b = blue;
  }
  
  float[] getAsInputs() {
    return new float[]{
      this.r,
      this.g,
      this.b
    };
  }
  
  float[] getAsTargets() {
    Color[] colors = Color.values();
    float[] result = new float[colors.length];
    for (int i = 0; i < colors.length; i++) {
      result[i] = colors[i] == this ? 1.0 : 0.0;
    }
    return result;
  }
}

Color randomColor() {
  int rand = floor(random(Color.values().length));
  return Color.values()[rand];
}

NeuralNetwork brain;

void setup() {
  size(750, 750);
  brain = new NeuralNetwork(3, 60, Color.values().length);
  
  for (int i = 0; i < 1000000; i++) {
    Color c = randomColor();
    brain.train(c.getAsInputs(), c.getAsTargets());
  }
}

float[] lastColor = new float[]{0, 0, 0};

void keyPressed() {
  // Check spacebar
  if (key == 32) {
    lastColor = new float[]{
      floor(random(256)),
      floor(random(256)),
      floor(random(256))
    };
  }
}

void draw() {
  background(lastColor[0], lastColor[1], lastColor[2]);
  float[] outputs = brain.feedForward(lastColor);
  fill(0);
  rect(0, 0, width / 2, height);
  
  fill(255);
  textSize(20);
  text("(" + lastColor[0] + ", " + lastColor[1] + ", " + lastColor[2] + ")", 5, 25);
  
  float[] guesses = brain.feedForward(lastColor);
  int topGuess = 0;
  for (int i = 0; i < Color.values().length; i++) {
    if (topGuess < 0 || guesses[i] > guesses[topGuess]) {
      topGuess = i;
    }
  }
  for (int i = 0; i < Color.values().length; i++) {
    fill(255);
    if (i == topGuess) {
      fill(0, 255, 0);
    }
    Color c = Color.values()[i];
    text(c.name() + ": " + floatToPercent(guesses[i]), 5, 65 + 25 * i);
  }
}

String floatToPercent(float f) {
  return (floor(f * 10000) / 100f) + "%";
}
