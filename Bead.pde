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