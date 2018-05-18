import java.util.*;
import java.io.*;

// Global variables
int board [][] = new int [3][3]; // Game board 3x3 array
Color cBoard [][] = new Color[3][3]; // Color values for board
int cellWidth, cellHeight;       // Cell size computed from window size
int player = 1;
int wins, losses, draws;
Cabinet cab;

//Called upon program start
void setup() {
  for (Color[] row : cBoard) {
    Arrays.fill(row, new Color(255, 255, 255));
  }

  //Try to load from cabinet file and create new one
  try {
    File cabFile = new File("cab.sav");
    //Load Cabinet
    if (cabFile.exists()) {
      FileInputStream loadFile = new FileInputStream("cab.sav");
      ObjectInputStream load = new ObjectInputStream(loadFile);

      cab = (Cabinet) load.readObject();
      load.close();
    }
  } 
  catch (Exception e) {
    e.printStackTrace();
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

  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run() {
      System.out.println("SHUTDOWN HOOK; SAVING CABINET");
      try {
        //Create save files

        FileOutputStream saveFile = new FileOutputStream("cab.sav");
        ObjectOutputStream save = new ObjectOutputStream(saveFile);
        save.writeObject(cab);
        save.close();
      } 
      catch (Exception e) {
        e.printStackTrace();
      }
    }
  }
  , "Shutdown-thread"));
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
