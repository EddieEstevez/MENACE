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
    String line1, line2, line3;
line1 = line2 = line3 = "";
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
               if (i == 0) {
                  line1 = line1 + convertNumtoChar(tempBox.face[i][j]) + " ";
              } else if (i == 1) {
                line2 = line2 + convertNumtoChar(tempBox.face[i][j]) + " ";
              } else if (i == 2) {
                line3 = line3 + convertNumtoChar(tempBox.face[i][j]) + " ";
              };
              };
              System.out.println();
            }
            System.out.println();
             sendFirst(line1);
              sendSecond(line2);
              sendThird(line3);
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
        System.out.println("CREATED BOX");
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        System.out.print(newBox.face[i][j] + " ");
           if (i == 0) {
             line1 = line1 + convertNumtoChar(newBox.face[i][j]) + " ";
            } else if (i == 1) {
             line2 = line2 + convertNumtoChar(newBox.face[i][j]) + " ";
            } else if (i == 2) {
             line3 = line3 + convertNumtoChar(newBox.face[i][j]) + " ";
           };
         }
      System.out.println();
            }
      sendFirst(line1);
      sendSecond(line2);
      sendThird(line3);
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
