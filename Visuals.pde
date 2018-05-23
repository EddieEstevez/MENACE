// Global variables
int GameCounter = 0;
float OldGameCounter = 5;
int prevX, prevY;
ArrayList<Float> GameCounterArray = new ArrayList<Float>();
boolean page1 = true;
boolean page2 = false;
boolean page3 = false;
String firstS, secondS;
int secondSpace = 275;
int counterPage = 1;
Boolean runOnce = true;
Boolean nextBoxGone = false;
String matchBoxChar = " ";
int BoxCounter = 0;
String one ="_ _ _\n";
String two ="_ _ _\n";
String three ="_ _ _\n";



void createMatchBox() {
  int a, b, c;
  a = b = c = 1;
  String s = matchBoxChar;
  fill(#C34A4A);
  rect(10 + (110 * a), 810 - (110 * c), 100, 100);
  textSize(30);
  fill(255);
  text(s, 10 + (110 * a), 700, 100, 100);
  
  if (mouseX > 10 + (110 * a) && mouseX < 110 + (110 * a) && mouseY > 700 && mouseY < 800) { //function highlights the box that the mouse is hovering over
  fill(255,255,255, 30);
  rect(5 + (110 * a), 695, 110, 110);
  }
}

void setupMatchBoxes(int a, String s, int b) { //this is a function that creates a "match box" on the bottom of the page
                                //a is an integer that dictates when on the x axis it will be placed, s is the string that will be on the actual box, b is text size
  fill(#C34A4A);
  rect(10 + (110 * a), 700, 100, 100);
  textSize(b);
  fill(255);
  text(s, 10 + (110 * a), 700, 100, 100);
  
  if (mouseX > 10 + (110 * a) && mouseX < 110 + (110 * a) && mouseY > 700 && mouseY < 800) { //function highlights the box that the mouse is hovering over
  fill(255,255,255, 30);
  rect(5 + (110 * a), 695, 110, 110);
  }
}
void setupMatchBoxes(int a, String s, int b, int c) { //this is a function that creates a "match box" on the bottom of the page, but this one adds a verticle aspect
                                //a is an integer that dictates when on the x axis it will be placed, s is the string that will be on the actual box, b is text size, c is verticle level
  fill(#C34A4A);
  rect(10 + (110 * a), 810 - (110 * c), 100, 100);
  textSize(b);
  fill(255);
  text(s, 10 + (110 * a), 810 - (110 * c), 100, 100);
  
  if (mouseX > 10 + (110 * a) && mouseX < 110 + (110 * a) && mouseY > 810 - (110 * c) && mouseY < 910 - (110 * c)) { //function highlights the box that the mouse is hovering over
  fill(255,255,255, 30);
  rect(5 + (110 * a), 805 - (110 * c), 110, 110);
  }
}

void pageBoxCode() { 
    if ((mouseX > 10 + (110 * 3) && mouseX < 110 + (110 * 3) && mouseY > 700 && mouseY < 800) && (page1)) { //function highlights the box that the mouse is hovering over
    page1 = false;
    page2 = true;
  }
    if ((mouseX > 10 + (110 * 2) && mouseX < 110 + (110 * 2) && mouseY > 700 && mouseY < 800) && (page2)) { //function highlights the box that the mouse is hovering over
    page1 = true;
    page2 = false;
}
    if ((mouseX > 10 + (110 * 4) && mouseX < 110 + (110 * 4) && mouseY > 700 && mouseY < 800) && (page2)) { //function highlights the box that the mouse is hovering over
    if (runOnce) {
    firstS ="There are different colored beads in each match box that represents different possible moves and positions. When it's the computers turn, it picks a random bead from the box of the current game state. At the end of the game,";
    secondSpace = 500;
    secondS="if the computer wins, the matchboxes that led to the win get beads of that same color of the move.";
    runOnce = false;
} else { 
    secondSpace = 400;
    nextBoxGone = true;
    firstS = "If the computer loses, however, then some of the beads from the matchboxes that led to the loss then get taken away from the box.";
    secondS = "In this way, the computer gets 'punished' and 'rewarded' and 'learns' how to play the game, even though it's actually not programs to play it.";} 
}
};

void nerdInfoCode() { 
    if ((mouseX > 10 + (110 * 3) && mouseX < 110 + (110 * 3) && mouseY > 810 - (110 * 2) && mouseY < 910 - (110 * 2))) { //function highlights the box that the mouse is hovering over
    page3 = true;
    page1 = false;
    System.out.println("Current array list is:"+ GameCounterArray);
  }
      if ((mouseX > 10 + (110 * 2) && mouseX < 110 + (110 * 2) && mouseY > 700 && mouseY < 800) && page3) { 
    page3= false;
    page1 = true;
    };
};

void nerdVisuals() {
  background(240, 255, 255);
  fill(0);
  textSize(width / 12);
  textAlign(LEFT);
  text("     WIN/LOSS GRAPH", 10, 75);
  fill(56, 121, 226);
  textSize(width / 20);
  textAlign(CENTER);
  setupMatchBoxes(2, "Back to Main Page", 40);
  //set up of the graph
  strokeWeight(10);
  line(100, 100, 100, 650);
  line(100, 650, 650, 650);
  //get the text
  fill(#000000);
  text("Ratio", 50, 650/1.5);
  strokeWeight(1);
  text("Number of Games", 550, 700);
  //draws the line
  int nextX, nextY;
  int arraySize = GameCounterArray.size();
  strokeWeight(5);
  stroke(#3399ff);
  nextX = prevX;
  nextY = prevY;
  if (arraySize > 1) {
  for(int i = 0; i < arraySize; i++) { 
  nextY = (int) (650 - (GameCounterArray.get(i) * 550));
  nextX = ((550/arraySize) * i) + 100;
  if (i == 0) {
    stroke(#000000, 00); 
  } else {
    stroke(#3399ff); }
  line(prevX, prevY, nextX, nextY);
  stroke(#0066cc);
  ellipse(nextX, nextY, 10, 10);
  prevX = nextX;
  prevY = nextY;
  };
  };  
  strokeWeight(1);
}

void restartBoxCode() {
  int a, c;
  a = c = 3;
   if (mouseX > 10 + (110 * a) && mouseX < 110 + (110 * a) && mouseY > 810 - (110 * c) && mouseY < 910 - (110 * c)) { //function highlights the box that the mouse is hovering over
  clearBoard();
  }
};

void sendFirst(String line) { 
one = line + "\n";
};

void sendSecond(String line) { 
two = line + "\n";
};

void sendThird(String line) { 
three = line + "\n";
};

String convertNumtoChar(int character) { 
String newString = "_";
if (character == 2) {
  newString = "X"; 
} else if (character == 1) {
  newString = "O";
}
return newString;
};



void drawVisualMatchBoxes() {
  int a = 0;
  int c = 3;
  fill(#C34A4A);
  rect(10 + (110 * a), 810 - (110 * c), 100, 100);
  fill(255);
  text(one + two + three, 10 + (110 * a), 810 - (110 * c), 100, 100); 
  if (mouseX > 10 + (110 * a) && mouseX < 110 + (110 * a) && mouseY > 810 - (110 * c) && mouseY < 910 - (110 * c)) { //function highlights the box that the mouse is hovering over
  fill(255,255,255, 30);
  rect(5 + (110 * a), 805 - (110 * c), 110, 110);
  }
};

void drawCell(int row, int col) {
  noFill();
  stroke(0);
  rect (col * cellWidth, row * cellHeight, cellWidth, cellHeight);

  switch (board[row][col]) {
  case 0:
    // If empty square and computer move, color squares based on probability
    if(player == 1) {
      Color c = cBoard[row][col];
      fill(c.r, c.g, c.b);
      rect (col * cellWidth, row * cellHeight, cellWidth, cellHeight);
      noFill();
    }
    break;
  case 1:
    strokeWeight(4);
    ellipse(col * cellWidth + 10, row * cellHeight + 10, cellWidth - 20, cellHeight - 20);
    strokeWeight(1);
    break;
  case 2:
    strokeWeight(4);
    line(col * cellWidth + 10, row * cellHeight + 10, (col+1) * cellWidth - 20, (row+1) * cellHeight- 20);
    line((col+1) * cellWidth  - 10, row * cellHeight + 10, col * cellWidth + 10, (row+1) * cellHeight - 20);
    strokeWeight(1);
    break;
  }
}
