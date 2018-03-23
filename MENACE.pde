import java.util.*;

// Global variables
int board [][] = new int [3][3]; // Game board 3x3 array
int cellWidth, cellHeight;       // Cell size computed from window size
int player = 1;
Cabinet cab;

//Called upon program start
void setup() {
  size (800, 800);
  rectMode(CORNER);
  ellipseMode(CORNER);
  cab = new Cabinet();
  // Divide window in 3 by 3 cells

  //cellWidth = width / 3; 
  //cellHeight = height / 3;

  //New Dimension gives room for more data and buttons
  cellWidth = 400/3;
  cellHeight = 400/3;
  clearBoard();
}

//Updates during program run
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
   //cab.updateBoxes();
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
  //Computer move
  if (player == 1) {
    Bead bead = cab.pickBox(board).pickBead();
    board[bead.row][bead.col] = player;
    player = oppositePlayer();
  }
  //Human move
  else {
    int row = mouseY / cellHeight;
    int col = mouseX / cellWidth;
    //Bounds check
    if (row >= 3 || col >= 3) {
      return;
    }
    if (board[row][col] == 0) {
      board[row][col] = player;
      player = oppositePlayer();
    }
  }
}

//Switch player, 2 is human, 1 is computer
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

//One full MENACE Macine filled with boxes
class Cabinet {
  //Boxes in this Cabinet
  ArrayList<Box> boxes;
  //Boxes chosen in given game
  ArrayList<Box> picked;
  
  Cabinet() {
    boxes = new ArrayList<Box>();
    picked = new ArrayList<Box>();
  }

  //Searches arraylist for box with face
  //If not found, create new box
  //Afterwards, add to picked
  Box pickBox(int[][] face) {
    if (boxes.size() > 0) {
      for (Box box : boxes) {
        Box tempBox = new Box(box.face);
        //Check all rotations of given box
        for (int k = 0; k <= 4; k++) {
          if (Arrays.deepEquals(tempBox.face, face)) {
            picked.add(box);
            return box;
          }
          tempBox = tempBox.rotated();
        }
      }
    }
    //Box not found, create new one and add to list
    Box newBox = new Box(face);
    boxes.add(newBox);
    picked.add(newBox);
    return newBox;
  }

  //Update all boxes picked, then clear picked ArrayList
  void updateBoxes(int winstatus) {
    for (Box pick : picked) {
      for (Box box : boxes) {
        if (Arrays.deepEquals(pick.face, box.face)) {
          box = pick;
          box.update(winstatus);
          break;
        }
      }
    }
    //Empty picked ArrayList
    picked.clear();
  }
}

//A matchbox filled with position beads
class Box {
  //Board face of this box, unique
  int[][] face;
  //Beads contained inside this box
  ArrayList<Bead> beads;
  //Position of bead picked from this box, used for learning
  int pickPos;

  Box(int[][] board) {
    face = board;
    beads = new ArrayList<Bead>();
    generate();
  }

  //Create beads for this box
  private void generate() {
    //Iterate through face board to locate empty spots
    for (int i = 0; i < face.length; i++) {
      for (int j = 0; j < face[0].length; j++) {
        //Add 10 beads to list for each empty spot
        if (face[i][j] == 0) { 
          for (int num = 0; num < 10; num++) {
            Bead bead = new Bead(i, j);
            beads.add(bead);
          }
        }
      }
    }
  }

  //Picks a random bead from this box and save position
  Bead pickBead() {
    float index = random(beads.size());
    pickPos = (int) index;
    return beads.get((int)index);
  }

  //Returns a rotated version of this box
  //Used to minmize created boxes
  //Will re-generate beads for this temp box
  //Must ensure to use original for bead checking
  Box rotated() {
    int[][] temp = new int[3][3];
    temp[0][0] = face[2][0];
    temp[0][1] = face[1][0];
    temp[0][2] = face[0][0];
    temp[1][0] = face[2][1];
    temp[1][1] = face[1][1];
    temp[1][2] = face[0][1];
    temp[2][0] = face[2][2];
    temp[2][1] = face[1][2];
    temp[2][2] = face[0][2];
    Box rotBox = new Box(temp);
    return rotBox;
  }

  //Updates beads contents based on win
  //  0 is tie, 1 is computer win, -1 is player win
  void update(int winStatus) {
    switch(winStatus) {
      //Lose, remove bead if beads exist
    case -1:
      if (beads.size() == 0) {
        break;
      }
      beads.remove(pickPos);
      break;

      //Win, add two of that beads
    case 1:
      beads.add(beads.get(pickPos));
      beads.add(beads.get(pickPos));

      //Tie, add one of that bead
    default:
      beads.add(beads.get(pickPos));

      break;
    }
  }
}

//Position tracking bead
class Bead {
  int row;
  int col;
  Bead(int row, int col) {
    this.row = row;
    this.col = col;
  }
}
