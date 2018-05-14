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
        //Add 3 beads to list for each empty spot
        if (face[i][j] == 0) { 
          for (int num = 0; num < 3; num++) {
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
      if(pickPos < beads.size())
        beads.remove(pickPos);
      break;

      //Win, add three of that bead
    case 1:
      beads.add(beads.get(pickPos));
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