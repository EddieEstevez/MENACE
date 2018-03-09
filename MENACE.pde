// Global variables
 
int board [][] = new int [3][3]; // Game board 3x3 array
int cellWidth, cellHeight;       // Cell size computed from window size
int player = 1;
 
void setup() {
  size (400, 400);
  rectMode(CORNER);
  ellipseMode(CORNER);
  // Divide window in 3 by 3 cells
  cellWidth = width / 3; 
  cellHeight = height / 3;
 
  clearBoard();
}
 
void draw() {
  background(255);
  drawBoard();
  if (boardFilled())
    drawGameOver();
}
 
void drawGameOver() {
  fill(0, 102, 153);
  textSize(width / 7);
  textAlign(CENTER, CENTER);
  text("Game Over!", width / 2, height / 2);
}
 
void mouseClicked() {
  if (boardFilled())
    clearBoard();
  else
    playerMove();
}
 
void clearBoard() {
  for (int row=0; row<3; row++)
    for (int col=0; col<3; col++)
      board[row][col] = 0;
}
 
void drawBoard() {
  for (int row=0; row<3; row++)
    for (int col=0; col<3; col++)
      drawCell(row, col);
}
 
void drawCell(int row, int col) {
 
  noFill();
  stroke(0);
  rect (col * cellWidth, row * cellHeight, cellWidth, cellHeight);
 
  switch (board[row][col]) {
    case 1:
      ellipse(col * cellWidth, row * cellHeight, cellWidth, cellHeight);
    break;
    case 2:
      line(col * cellWidth, row * cellHeight, (col+1) * cellWidth, (row+1) * cellHeight);
      line((col+1) * cellWidth, row * cellHeight, col * cellWidth, (row+1) * cellHeight);
    break;
 
  }
}
 
 
void playerMove() {
  int row = mouseY / cellHeight;
  int col = mouseX / cellWidth;
 
  if (board[row][col] == 0) {
    board[row][col] = player;
    player = oppositePlayer();
  }
}
 
int oppositePlayer() {
  return player = 3 - player;
}
 
boolean boardFilled() {
  for (int row = 0; row < 3; row++) {
    if (!rowFilled(row))
      return false;
  }
  return true;
}
 
boolean rowFilled(int row) {
  for (int col = 0; col < 3; col++) {
    if (board[row][col] == 0) return false;
  }
  return true;  
}