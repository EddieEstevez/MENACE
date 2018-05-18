void drawGameOver() {
  fill(0, 102, 153);
  textSize(width / 12);
  textAlign(CENTER, CENTER);
  switch(getWin()) {
    case 0:
      text("TIE!", width / 4, height / 4);
      break;
    case 1:
      text("MENACE WINS!", width / 4, height / 4);
      break;
    case -1:
      text("YOU WIN!", width / 4, height / 4);
      break;
  }
}

//Clears array of player and computer moves, resets player variable
void clearBoard() {
  //Set all cells to empty val
  for (int row=0; row<3; row++)
    for (int col=0; col<3; col++)
      board[row][col] = 0;
  //Reset Player
  player = 1;
  //cab.updateBoxes();
}

//Draws playing board
void drawBoard() {
  for (int row=0; row<3; row++) {
    for (int col=0; col<3; col++) {
      drawCell(row, col);
    }
  }
}

//Draws one individual cell in the board


void setupStatsBar() {
  textSize(50);
  textAlign(LEFT, BASELINE);
  float WLratio = 0.00;
  int gameC = (wins + losses + draws);
  if (gameC != 0) {
    WLratio = (float) wins/gameC;
  }
  int space = 60;
  fill(0, 203, 255);
  rect(500, 10 , 250, height-25, 25);
  fill(0);
  text("Games", 510, space);
  space = space + 60;
  text("Played", 510, space);
  fill(255);
  space = space + 60;
  text((wins + losses + draws), 560, space);
  fill(0);
  space = space + 60;
  text("AI Wins", 510, space);
  fill(255);
  space = space + 60;
  text(wins, 560, space);
  fill(0);
  space = space + 60;
  text("AI Losses", 510, space);
  fill(255);
  space = space + 60;
  text(losses, 560, space);
  fill(0);
  space = space + 60;
  text("Draws", 510, space);
  fill(255);
  space = space + 60;
  text(draws, 560, space);
  fill(0);
  space = space + 60;
  text("W/L Ratio", 510, space);
  fill(255);
  space = space + 60;
  text(WLratio, 560, space);
}

class Color {
  int r;
  int g;
  int b;
  public Color(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
}

//Colors the playing board based on computer probability
void colorBoard(Box box, int rot) {
  int total = box.beads.size();
  for (int row = 0; row < 3; row++) {
    for (int col = 0; col < 3; col++) {
      //Empty Square
      if (box.face[row][col] == 0) {
        int count = 0;
        //Count beads that match this square
        for (Bead bead : box.beads) {
          if (bead.row == row && bead.col == col) {
            count++;
          }
        }
        double ratio = (double)count/total;
        //Get green
        int g = (int)(ratio * 255);
        //Get red
        int r = 255 - g;
        //Get actual row and col of board and color
        Bead tempBead = new Bead(row, col);
        tempBead = tempBead.rotate(rot);
        colorCell(tempBead.row, tempBead.col, r, g);
      }
    }
  }
}

void colorCell(int row, int col, int r, int g) {
  //fill(r, g, 0);
  //rect (col * cellWidth, row * cellHeight, cellWidth, cellHeight);
  //noFill();
  cBoard[row][col] = new Color(r,g,0);
}
