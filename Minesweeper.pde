import de.bezier.guido.*;

private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private static int NUM_ROWS = 20;
private static int NUM_COLS = 20;
private MSButton[][] buttons = new MSButton[NUM_ROWS][NUM_COLS];  //2d array of minesweeper buttons
private static String winMessage = "YOU WIN!";
private static String loseMessage = "GAME OVER!";
private boolean isLost = false;

public void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make( this );
    for(int r = 0; r < NUM_ROWS; r++)
    {
        for(int c = 0; c < NUM_COLS; c++)
        {
            buttons[r][c] = new MSButton(r, c);
        }
    }
    setBombs();
}

public void setBombs()
{
    int randRow;
    int randCol;
    int bombCount = 0;
    while(bombCount < (int)(NUM_ROWS * NUM_COLS * 0.2))
    {
        randRow = (int)(Math.random() * NUM_ROWS);
        randCol = (int)(Math.random() * NUM_COLS);
        if(!bombs.contains(buttons[randRow][randCol]))
        {
            bombs.add(buttons[randRow][randCol]);
            bombCount = bombCount + 1;
        }
    }

}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}

public boolean isWon()
{
    for(int r = 0; r < NUM_ROWS; r++)
    {
        for(int c = 0; c < NUM_COLS; c++)
        {
            if(!bombs.contains(buttons[r][c]) && !buttons[r][c].isClicked())
            {
                return false;
            }
        }
    }
    return true;
}

public void displayLosingMessage()
{
    isLost = true;
    for(int i = 5; i < 15; i++)
    {
      buttons[7][i].setLabel(loseMessage.substring(i - 5, i - 4));
    }
    for(int r = 0; r < NUM_ROWS; r++)
    {
        for(int c = 0; c < NUM_COLS; c++)
        {
            if(bombs.contains(buttons[r][c]))
            {
              buttons[r][c].setWin();
            }
        }
    }
}

public void displayWinningMessage()
{
    for(int i = 6; i < 14; i++)
    {
      buttons[7][i].setLabel(winMessage.substring(i - 6, i - 5));
    }
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked, clickedBefore;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400 / NUM_COLS;
        height = 400 / NUM_ROWS;
        r = rr;
        c = cc; 
        x = c * width;
        y = r * height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    public boolean isMarked()
    {
        return marked;
    }

    public boolean isClicked()
    {
        return clicked;
    }
    
    public void setWin()
    {
      clicked = true;
      marked = false;
    }
    
    // called by manager
    
    public void mousePressed () 
    {
        if(!isWon() && !isLost)
        {
          clicked = true;
          if(mouseButton == RIGHT && !clickedBefore)
          {
              marked = !marked;
              if(!marked)
              {
                  clicked = false;
              }
          }
          else if(bombs.contains(this) && !marked)
          {
              displayLosingMessage();
          }
          else if(!marked)
          {
            if(countBombs(r, c) > 0)
            {
                clickedBefore = true;
                setLabel("" + countBombs(r, c));
            }
            else
            {
                clickedBefore = true;
                for(int ccc = c - 1; ccc <= c + 1; ccc++)
                {
                    for(int rrr = r - 1; rrr <= r + 1; rrr++)
                    {
                        if(isValid(rrr, ccc) && !buttons[rrr][ccc].isClicked())
                        {
                            buttons[rrr][ccc].mousePressed();
                        }
                    }
                }
            }
          }
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label, x + width / 2, y + height / 2);
    }

    public void setLabel(String newLabel)
    {
        label = newLabel;
    }

    public boolean isValid(int r, int c)
    {
        if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
        {
          return true;
        }
        else
        {
          return false;
        }
    }

    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int c = col - 1; c <= col + 1; c++)
        {
            for(int r = row - 1; r <= row + 1; r++)
            {
                if(isValid(r, c) && bombs.contains(buttons[r][c]))
                {
                    numBombs = numBombs + 1;
                }
            }
        }
        return numBombs;
    }
}