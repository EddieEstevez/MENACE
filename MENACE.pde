import java.util.*;

// Global variables
int board [][] = new int [3][3]; // Game board 3x3 array
Color cBoard [][] = new Color[3][3]; // Color values for board
int cellWidth, cellHeight;       // Cell size computed from window size
int player = 1;
int wins, losses, draws;
Cabinet cab;

//Called upon program start
void setup() {
  for(Color[] row : cBoard) {
    Arrays.fill(row, new Color(255,255,255));
  }
  size (800, 800);
  rectMode(CORNER);
  ellipseMode(CORNER);
  cab = new Cabinet();
  
  wins = 0;
  losses = 0;
  draws = 0;

  //New Dimension gives room for more data and buttons
  cellWidth = 400/3;
  cellHeight = 400/3;
  clearBoard();
}

//Updates during program run
void draw() {
  background(240, 255, 255);
  drawBoard();
  if (boardFilled() || getWin() != 0) {
    drawGameOver();
  }
  setupStatsBar();
  setupMatchBoxes();
}

void drawGameOver() {
  fill(0, 102, 153);
  textSize(width / 12);
  textAlign(CENTER, CENTER);
  text("Game Over!", width / 4, height / 4);
}

void mouseClicked() {
  if (mouseX> 0 && mouseX<800 && mouseY>0 && mouseY<800) {
  if (boardFilled() || getWin() != 0) {
    //Update boxes according to win status
    cab.update(getWin());
    //Update win/lose/draw counts, where wins are AI wins
    switch(getWin()) {
      case 0:
        draws++;
        break;
      case 1:
        wins++;
        break;
      case -1:
        losses++;
        break;
    }
    System.out.println("WINS: " + wins + " LOSSES: " + losses + " DRAWS: " + draws);
    clearBoard();
  } else
    playerMove();
  }
}

void clearBoard() {
  //Set all cells to empty val
  for (int row=0; row<3; row++)
    for (int col=0; col<3; col++)
      board[row][col] = 0;
  //Reset Player
  player = 1;
  //cab.updateBoxes();
}

void drawBoard() {
  for (int row=0; row<3; row++) {
    for (int col=0; col<3; col++) {
      drawCell(row, col);
    }
  }
}

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
    ellipse(col * cellWidth, row * cellHeight, cellWidth, cellHeight);
    break;
  case 2:
    line(col * cellWidth, row * cellHeight, (col+1) * cellWidth, (row+1) * cellHeight);
    line((col+1) * cellWidth, row * cellHeight, col * cellWidth, (row+1) * cellHeight);
    break;
  }
}

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

void setupMatchBoxes() {
  fill(#C34A4A);
  rect(10 + (110 * 3), 700, 100, 100);
  textSize(30);
  fill(255);
  text("See All Boxes", 10 + (110 * 3), 700, 100, 100);
}


void playerMove() {
  //Computer move
  if (player == 1) {
    Box pickedBox = cab.pickBox(board);
    //Create temporary box for use of rotation checking
    int[][] newFace = new int[pickedBox.face.length][];
    for (int r = 0; r < pickedBox.face.length; r++) {
      newFace[r] = pickedBox.face[r].clone();
    }
    Box tempBox = new Box(newFace);

    //Get number of times rotated
    int rotNum = 0;
    for (int k = 0; k <= 3; k++) {
      if (Arrays.deepEquals(tempBox.face, board)) {
        rotNum = k;
        break;
      } else tempBox.rotate();
    }

    //Color board based on chances computer will pick it
    colorBoard(pickedBox, rotNum);

    //Wait so user can see, replace with button to click


    //Get bead using rotated board state
    Bead bead = pickedBox.pickBead().rotate(rotNum);
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
      //Automatically have computer play
      if (getWin() != -1) {
        Box pickedBox = cab.pickBox(board);
        //Create temporary box for use of rotation checking
        int[][] newFace = new int[pickedBox.face.length][];
        for (int r = 0; r < pickedBox.face.length; r++) {
          newFace[r] = pickedBox.face[r].clone();
        }
        Box tempBox = new Box(newFace);

        //Get number of times rotated
        int rotNum = 0;
        for (int k = 0; k <= 3; k++) {
          if (Arrays.deepEquals(tempBox.face, board)) {
            rotNum = k;
            break;
          } else tempBox.rotate();
        }

        //Color board based on chances computer will pick it
        colorBoard(pickedBox, rotNum);
      }
      //  playerMove();
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

//Returns 1 if computer wins
//Return -1 if player wins
//Returns 0 if tie or no win yet
int getWin() {
  //Check rows
  for (int i = 0; i < 3; i++) {
    int last = board[i][0];
    for (int j = 0; j < 3; j++) {
      //Empty spot or conflict, go to next row
      if (board[i][j] == 0 || board[i][j] != last) {
        break;
      }
      //Update last
      last = board[i][j];
      //Get win if found
      if (j == 2) {
        if (board[i][j] == 1) {
          return 1;
        } else return -1;
      }
    }
  }
  //Check columns
  for (int j = 0; j < 3; j++) {
    int last = board[0][j];
    for (int i = 0; i < 3; i++) {
      //Empty spot or conflict, go to next row
      if (board[i][j] == 0 || board[i][j] != last) {
        break;
      }
      //Update last
      last = board[i][j];
      //Get win if found
      if (i == 2) {
        if (board[i][j] == 1) {
          return 1;
        } else return -1;
      }
    }
  }
  //Check diagnols
  if (board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[1][1] != 0) {
    if (board[1][1] == 1) {
      return 1;
    } else return -1;
  }
  if (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[1][1] != 0) {
    if (board[1][1] == 1) {
      return 1;
    } else return -1;
  }
  return 0;
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
        Box tempBox = new Box(box.face, box.beads);
        //Check all rotations of given box
        for (int k = 0; k <= 4; k++) {
          if (Arrays.deepEquals(tempBox.face, face)) {
            picked.add(tempBox);
            System.out.println("FOUND BOX");
            for (int i = 0; i < 3; i++) {
              for (int j = 0; j < 3; j++) {
                System.out.print(tempBox.face[i][j] + " ");
              }
              System.out.println();
            }
            System.out.println();

            return tempBox;
          }
          tempBox.rotate();
        }
      }
    }
    //Box not found, create new one and add to list
    int[][] newFace = new int[face.length][];
    for (int r = 0; r < face.length; r++) {
        newFace[r] = face[r].clone();
    }
    Box newBox = new Box(newFace);
    boxes.add(newBox);
    picked.add(newBox);
    return newBox;
  }

  //Update all boxes picked, then clear picked ArrayList
  void update(int winstatus) {
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

  Box(int[][] board, ArrayList<Bead> beads) {
    face = board;
    this.beads = beads;
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
          System.out.println("Added Bead: [" + i + "," + j + "]");
        }
      }
    }
  }

  //Picks a random bead from this box and save position
  Bead pickBead() {
    float index = random(beads.size());
    pickPos = (int) index;
    //Print Bead
    System.out.println(beads.get((int)index).row + " , "
      + beads.get((int)index).col);
    return beads.get((int)index);
  }

  //Rotates this box clockwise 90 degrees
  //Used to minmize created boxes
  void rotate() {
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
    this.face = temp;
  }

  //Updates beads contents based on win
  //  0 is tie, 1 is computer win, -1 is player win
  void update(int winStatus) {
    switch(winStatus) {
      //Lose, remove bead if beads exist
    case -1:
      if (beads.size() == 0) {
        //Regenerate beads if box is empty
        generate();
        break;
      }
      beads.remove(pickPos);
      break;

      //Win, add two of that beads
    case 1:
      beads.add(beads.get(pickPos));
      beads.add(beads.get(pickPos));
      break;

      //Tie, add one of that bead
    case 0:
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
  
  //Returns a rotated version of this bead
  //Used when current board is a rotated version of given box
  //Rotates a temp bead to correct position for X / O placement only
  Bead rotate(int times) {
    
    Bead temp = new Bead(this.row,this.col);
    //If center, no rotation needed
    if(row == 1 && col == 1) {
      return temp;
    }
    
    //Rotate bead 
    for(int k = 0; k < times; k++) {
      if(temp.row == 0) {
        if(temp.col == 0)
          temp.col = 2;
        else if(temp.col == 1) {
          temp.col = 2;
          temp.row = 1;
        }
        else temp.row = 2;
      }
      else if(temp.row == 1) {
        if(temp.col == 0) {
          temp.row = 0;
          temp.col = 1;
        }
        else {
          temp.row = 2;
          temp.col = 1;
        }
      }
      else {
        if(temp.col == 0)
          temp.row = 0;
        else if(temp.col == 1) {
          temp.row = 1;
          temp.col = 0;
        }
        else temp.col = 0;
      }
    }
    return temp;
  }
}
