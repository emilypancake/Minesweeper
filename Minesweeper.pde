import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final int NUM_ROWS = 20;
public final int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
public boolean won = false;
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    //your code to initialize buttons goes here
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r,c);
      }
    }
    
    
    
    setMines();
}
public void setMines()
{
    int rr, rc; 
    for(int i = 0; i < 40; i++){
      rr =  (int)(Math.random()*NUM_ROWS);
      rc =  (int)(Math.random()*NUM_COLS);
      if(!mines.contains(buttons[rr][rc])){
        mines.add(buttons[rr][rc]);
      }
    }
    
}

public void draw ()
{
    background( 0 );
    if(isWon() == true){
    won = true;
        displayWinningMessage();
    }
}

public boolean isWon()
{
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
  
        if(buttons[r][c].clicked == false)
          return false;
        if(mines.contains(buttons[r][c])){
          if(buttons[r][c].flagged == false)
          return false;
        }
        
       
      }
    }
    //for(int r = 0; r < NUM_ROWS; r++){
    //  for(int c = 0; c < NUM_COLS; c++){
    //    buttons[r][c].fillGreenOthers();
    //  }
    //}
     return true;
    
}
public void displayLosingMessage()
{
  for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0 ; c<NUM_COLS;c++){
        buttons[r][c].setLabel("!");
      }
    }
}
public void displayWinningMessage()
{
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0 ; c<NUM_COLS;c++){
        buttons[r][c].setLabel(".u.");
        //buttons[r][c].fillGreenOthers();
      }
    }
   
}
public boolean isValid(int r, int c)
{
    return r >= 0 && c >= 0 && r < NUM_ROWS && c < NUM_COLS;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    
    for(int r = row - 1; r <= row + 1; r++){
      for(int c = col - 1; c <= col + 1; c++){
        if(isValid(r, c) == true && mines.contains(buttons[r][c])){
           numMines++; 
        }
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
          flagged = !flagged;
        }else if(mines.contains(this)){
          displayLosingMessage();
        }else if(countMines(myRow, myCol) > 0){
          setLabel(countMines(myRow, myCol));
        }else{
           for(int R = myRow - 1; R <= myRow + 1; R++){
             for(int C = myCol - 1; C <= myCol + 1; C++){
               if(isValid(R,C)==true && buttons[R][C].clicked == false){
                 buttons[R][C].mousePressed();
               }
             }
           }
        }
        //your code here
    }
    public void draw () 
    {    
        if (flagged){
            fill(0);//isva
        } else if( clicked && mines.contains(this) ) {
             fill(255,0,0);
        }else if(clicked){
            fill( 200 );
            if(won){
              fill(0, 255, 0);
            }
        } else {
            fill( 100 );
        }
        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public void reset() {
        won = false;
      for(int r = 0; r < NUM_ROWS; r++){
        for(int c = 0; c < NUM_COLS; c++){
           
        
          buttons[r][c].setLabel("");
          buttons[r][c].clicked = false;
          buttons[r][c].flagged = false;
        
          fill( 100 );
    
          rect(x, y, width, height);
          fill(0);
          text(myLabel,x+width/2,y+height/2);
        }
        
      }
    mines = new ArrayList <MSButton>();
    setMines();
   }
    
    //public void fillGreenOthers(){
    
    //      if(!mines.contains(buttons[myRow][myCol])){
    //        fill(0, 255, 0);
    //      }
 
    //    rect(x, y, width, height);
    //  fill(0);
    //  text(myLabel,x+width/2,y+height/2);
    //}
}


public void keyPressed(){
  if(key == ' '){
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0;c < NUM_COLS; c++){ 
        buttons[r][c].reset();
      }
    }
  }
}
