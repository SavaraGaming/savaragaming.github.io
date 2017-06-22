//Game of Life
//Miles Raphael
//CS 7492

int cellSize = 6;                               //num of pixels in each cell
int gridSize = 100;                             //num of cells in grid cols and rows
int gridSquared = gridSize*gridSize;            //total num of cells
boolean[] lifeGrid = new boolean[gridSquared];  //stores life of each cell
boolean[] ruleGrid = new boolean[gridSquared];  //stores next state of each cell
boolean stepMode = true;                        //toggle for continuous update mode

int XY(int x, int y) { return x+y*gridSize; }   //map 2D coord to 1D index
int getX(int xy) { return (int)(xy%gridSize); }        //map 1D index to 2D x
int getY(int xy) { return (int)(xy/gridSize); }        //map 1D index to 2D y


void setup()
{
  size(601, 601, P2D);
}

void draw()
{
  drawGrid();
  if(!stepMode) updateGrid();
}


//***LOGIC***

void updateGrid()
{
  for(int i = 0; i < gridSquared; i++)
  {
    int count = countNeighbors(getX(i), getY(i));
    if(lifeGrid[i])
    {
      if(count != 2 && count != 3)
        ruleGrid[i] = false;
      else
        ruleGrid[i] = true;
    }
    else
    {
      if(count == 3)
        ruleGrid[i] = true;
      else
        ruleGrid[i] = false;
    }
  }
  for(int i = 0; i < gridSquared; i++)
    lifeGrid[i] = ruleGrid[i];
  for(int i = 0; i < gridSquared; i++)
    ruleGrid[i] = false;
}

int countNeighbors(int x, int y)
{
  int count = 0;
  int xMinus, xPlus, yMinus, yPlus;
  int NW, N, NE, W, E, SW, S, SE;
  
  if(x-1 < 0)
    xMinus = gridSize - 1;
  else
    xMinus = x - 1;
  if(y-1 < 0)
    yMinus = gridSize - 1;
  else
    yMinus = y - 1;
  if(x+1 >= gridSize)
    xPlus = 0;
  else
    xPlus = x + 1;
  if(y+1 >= gridSize)
    yPlus = 0;
  else
    yPlus = y + 1;
  
  NW = XY(xMinus, yMinus);
  N = XY(x, yMinus);
  NE = XY(xPlus, yMinus);
  W = XY(xMinus, y);
  E = XY(xPlus, y);
  SW = XY(xMinus, yPlus);
  S = XY(x, yPlus);
  SE = XY(xPlus, yPlus);
  
  if(lifeGrid[NW]) count++;
  if(lifeGrid[N]) count++;
  if(lifeGrid[NE]) count++;
  if(lifeGrid[W]) count++;
  if(lifeGrid[E]) count++;
  if(lifeGrid[SW]) count++;
  if(lifeGrid[S]) count++;
  if(lifeGrid[SE]) count++;
  
  return count;
}

void stepGrid()
{
  if(!stepMode) toggleMode();
  updateGrid();
}

void clearGrid()
{
  for(int i = 0; i < gridSquared; i++)
    lifeGrid[i] = false;
}

void randomizeGrid()
{
  for(int i = 0; i < gridSquared; i++)
    lifeGrid[i] = random(1) >= .5 ? true : false;
}

void toggleMode()
{
  stepMode = !stepMode;
}


//***DRAW***

void drawGrid()
{
  stroke(64);
  for(int i = 0; i < gridSquared; i++)
  {
    if(lifeGrid[i])
      fill(255);
    else
      fill(0);
    rect((int)(i%gridSize)*cellSize, (int)(i/gridSize)*cellSize, cellSize, cellSize);
  }
}


//***GUI***

void mousePressed()
{
  int loc = XY((int)(mouseX/cellSize), (int)(mouseY/cellSize));
  lifeGrid[loc] = !lifeGrid[loc];
}

void keyPressed()
{
  if(key=='c' || key=='C') clearGrid();
  if(key=='r' || key=='R') randomizeGrid();
  if(key=='g' || key=='G') toggleMode();
  if(key==' ') stepGrid();
}