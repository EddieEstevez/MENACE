// Global variables
boolean page1 = true;
boolean page2 = false;
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

void restartBoxCode() {
  int a, c;
  a = c = 3;
   if (mouseX > 10 + (110 * a) && mouseX < 110 + (110 * a) && mouseY > 810 - (110 * c) && mouseY < 910 - (110 * c)) { //function highlights the box that the mouse is hovering over
  clearBoard();
  }
};

void sendFirst(String line) { 
one = line;
};

void sendSecond(String line) { 
two = line;
};

void sendThird(String line) { 
three = line;
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
