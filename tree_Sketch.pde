// Data for steps walked (20 Oct 2024 - 20 Nov 2024)
int[] steps = {
  11673, 11055, 28941, 9809, 5905, 
  11256, 8765, 11051, 1371, 9766, 
  3382, 3388, 2482, 2975, 2195, 
  10589, 9394, 4885, 8420, 1123, 
  12422, 1823, 2048, 13842, 27407, 
  893, 6925
};
String[] dates = {
  "20 Oct", "21 Oct", "22 Oct", "23 Oct", "24 Oct",
  "25 Oct", "26 Oct", "27 Oct", "28 Oct", "29 Oct",
  "30 Oct", "31 Oct", "1 Nov", "2 Nov", "3 Nov",
  "4 Nov", "5 Nov", "6 Nov", "7 Nov", "8 Nov",
  "9 Nov", "10 Nov", "11 Nov", "12 Nov", "13 Nov",
  "14 Nov", "15 Nov"
};

// Sleep data (aligned to the same dates)
float[] asleepDurations = {415, 481, 320, 603, 288, 460, 561, 368, 676, 316, 574, 480, 360, 425, 390, 520, 405, 450, 440, 470, 590, 490, 510, 615, 470, 580, 620};
float[] sleepPerformances = {72, 78, 65, 99, 53, 72, 85, 65, 88, 59, 82, 73, 69, 76, 71, 85, 76, 78, 79, 81, 88, 75, 77, 89, 81, 90, 92};

// Animation settings
float[] trunkHeights;
float[] circleSizes;
boolean[] fullyGrown;

int margin = 50;
float growthSpeed = 5;       // Speed of growth animation

void setup() {
  size(1400, 800);  // Increased canvas size for title and legend
  background(255);

  // Initialize animations
  trunkHeights = new float[steps.length];
  circleSizes = new float[steps.length];
  fullyGrown = new boolean[steps.length];
  for (int i = 0; i < steps.length; i++) {
    trunkHeights[i] = 0;      // Start with no trunk height
    circleSizes[i] = 0;       // Start with no circle size
    fullyGrown[i] = false;    // Trees start ungrown
  }
}

void draw() {
  background(255);

  // Draw title and legend
  drawTitleAndLegend();

  translate(margin, height - margin); // Start drawing trees from the bottom-left corner

  float spacing = (width - 2 * margin) / steps.length; // Space between trees

  for (int i = 0; i < steps.length; i++) {
    pushMatrix();
    translate(i * spacing, 0); // Move to the position of each tree
    drawTree(i, i * spacing);
    popMatrix();
  }
}

void drawTitleAndLegend() {
  // Title
  textAlign(CENTER);
  textSize(24);
  fill(0);
  text("Steps and Sleep Visualization", width / 2, 30);

  // Subtitle
  textSize(14);
  fill(100);
  text("Daily steps visualized as tree trunks with circular tops, scaled to represent steps and sleep data.", width / 2, 50);

  // Legend
  textAlign(LEFT);
  textSize(12);
  fill(0);
  text("Legend:", margin, 70);
  text("- Trunk Height: Steps taken", margin, 90);
  text("- Trunk Width: Sleep duration", margin, 110);
  text("- Trunk Color: Sleep performance (light = poor, dark = excellent)", margin, 130);
  text("- Circle Size: Larger circle = more steps", margin, 150);
}

void drawTree(int index, float treeXPosition) {
  // Map step count to tree properties
  float targetTrunkHeight = map(steps[index], 0, 30000, 50, 200); // Final trunk height
  float trunkWidth = map(asleepDurations[index], 0, 700, 5, 20); // Trunk width
  float targetCircleSize = map(steps[index], 0, 30000, 10, 50); // Final circle size

  // Grow the trunk
  if (trunkHeights[index] < targetTrunkHeight) {
    trunkHeights[index] += growthSpeed;
  } else {
    trunkHeights[index] = targetTrunkHeight;
    fullyGrown[index] = true; // Mark tree as fully grown
  }

  // Grow the circle
  if (circleSizes[index] < targetCircleSize) {
    circleSizes[index] += growthSpeed * 0.5;
  } else {
    circleSizes[index] = targetCircleSize;
  }

  // Map sleep performance to shades of brown for the trunk
  int trunkColor = lerpColor(color(139, 69, 19), color(101, 45, 13), sleepPerformances[index] / 100.0); // Shades of brown

  // Sway effect for the circle
  float sway = sin(frameCount * 0.05 + index) * 5;

  // Draw trunk
  stroke(trunkColor);
  strokeWeight(trunkWidth);
  line(0, 0, 0, -trunkHeights[index]);

  // Draw circle top
  fill(34, 139, 34); // Green circle color
  noStroke();
  ellipse(0 + sway, -trunkHeights[index], circleSizes[index] * 2, circleSizes[index] * 2);

  // Add day label
  fill(0);
  textAlign(CENTER);
  text(dates[index], 0, 20);

  // Check for hover and show details
  if (mouseX > treeXPosition - trunkWidth && mouseX < treeXPosition + trunkWidth) {
    displayHoverDetails(index, treeXPosition, -trunkHeights[index]);
  }
}

void displayHoverDetails(int index, float x, float y) {
  fill(255, 255, 255, 200); // Semi-transparent background
  rect(mouseX + 10, mouseY - 70, 180, 80, 5); // Rounded rectangle for tooltip
  fill(0);
  textAlign(LEFT);
  textSize(12);
  text("Date: " + dates[index], mouseX + 15, mouseY - 55);
  text("Steps: " + steps[index], mouseX + 15, mouseY - 40);
  text("Sleep: " + asleepDurations[index] + " min", mouseX + 15, mouseY - 25);
  text("Performance: " + sleepPerformances[index] + "%", mouseX + 15, mouseY - 10);
}
