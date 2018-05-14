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