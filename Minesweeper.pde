import de.bezier.guido.*;
int NUM_ROWS = 25;
int NUM_COLS = 25;
boolean gameOver = false;   
private MSButton[][] buttons;           
private ArrayList<MSButton> mines = new ArrayList<MSButton>(); 

void setup() {
  size(400, 400);
  textAlign(CENTER, CENTER);
  
  Interactive.make(this);
  
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  
  while(mines.size() < NUM_ROWS) {
    setMines();
  }
}

public void setMines() {
  int rownum = (int)(Math.random() * NUM_ROWS);
  int colnum = (int)(Math.random() * NUM_COLS);
  MSButton button = buttons[rownum][colnum];
  if (!mines.contains(button))
    mines.add(button);
}

public void draw() {
  background(0);
  if (isWon()) {
    displayWinningMessage();
  }
}

public boolean isWon() {
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (!mines.contains(buttons[r][c]) && !buttons[r][c].clicked)
        return false;
    }
  }
  return true;
}

public void displayLosingMessage() {
  gameOver = true;
  for (int i = 0; i < mines.size(); i++) {
    MSButton b = mines.get(i);
    b.clicked = true;
    b.setLabel("M");
  }
}
public void displayWinningMessage() {
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c].setLabel("W");
    }
  }
}

public boolean isValid(int r, int c) {
  return (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS);
}

public int countMines(int row, int col) {
  int numMines = 0;
  for (int dr = -1; dr <= 1; dr++) {
    for (int dc = -1; dc <= 1; dc++) {
      if (dr == 0 && dc == 0) continue;
      int nr = row + dr;
      int nc = col + dc;
      if (isValid(nr, nc) && mines.contains(buttons[nr][nc])) {
        numMines++;
      }
    }
  }
  return numMines;
}

public class MSButton {
  private int myRow, myCol;
  private float x; 
  private float y; 
  private float width; 
  private float height;
  boolean clicked; 
  boolean flagged;
  private String myLabel;
  
  public MSButton(int row, int col) {
    width = 400.0 / NUM_COLS;
    height = 400.0 / NUM_ROWS;
    myRow = row;
    myCol = col;
    x = myCol * width;
    y = myRow * height;
    myLabel = "";
    clicked = false;
    flagged = false;
    Interactive.add(this); 
  }
  

  public void mousePressed() {
    if (gameOver) return;
    if (mouseButton == RIGHT) {
      flagged = !flagged;
      if (!flagged) {
        clicked = false;
      }
      return;
    }
    if (flagged) 
      return;
    

    clicked = true;
    
    if (mines.contains(this)) {
      displayLosingMessage();
      return;
    }

    int count = countMines(myRow, myCol);
    if (count > 0) {
      setLabel(count);
      return;
    }

    for (int dr = -1; dr <= 1; dr++) {
  for (int dc = -1; dc <= 1; dc++) {
    if (!(dr == 0 && dc == 0)) {
      int nr = myRow + dr;
      int nc = myCol + dc;
      if (isValid(nr, nc)) {
        MSButton neighbor = buttons[nr][nc];
        if (!neighbor.clicked && !neighbor.flagged && !mines.contains(neighbor)) {
          neighbor.mousePressed();
        }
      }
    }
  }
}
  }
  
  public void draw() {
    if (flagged)
      fill(0);
    else if (clicked && mines.contains(this))
      fill(255, 0, 0);
    else if (clicked)
      fill(200);
    else
      fill(100);
    
    rect(x, y, width, height);
    fill(0);
    text(myLabel, x + width/2, y + height/2);
  }
  
  public void setLabel(String newLabel) {
    myLabel = newLabel;
  }
  
  public void setLabel(int newLabel) {
    myLabel = "" + newLabel;
  }
  
  public boolean isFlagged() {
    return flagged;
  }
}
