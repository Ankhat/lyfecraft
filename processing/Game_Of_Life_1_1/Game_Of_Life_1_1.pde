// Size of cells
int cellSize = 10;

// How likely for a cell to be alive at start (in percentage)
float probabilityOfAliveAtStart = 15;

// intiables for timer
int iinterval = 100;
int speedFactor = 4;
int interval = iinterval;
int lastRecordedTime = 0;

// Colors for active/inactive cells
color alive = color(199, 0, 209);
color dead = color(250,250,250);

// Array of cells
int[][] cells; 
// Buffer to record the state of the cells and use this while changing the others in the interations
int[][] cellsBuffer; 

// Pause
boolean pause = false;

void setup() {
  size (600, 600, P2D);

  // Instantiate arrays 
  cells = new int[width/cellSize][height/cellSize];
  cellsBuffer = new int[width/cellSize][height/cellSize];

  // This stroke will draw the background grid
  stroke(200);

  noSmooth();

  // Initialization of cells
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      int state = 0;
      
      /*float state = random (100);
      if (state > probabilityOfAliveAtStart) { 
        state = 0;
      }
      else {
        state = 1;
      }*/
      cells[x][y] = int(state); // Save state of each cell
    }
  }
  initPattern();
  background(0); // Fill in black in case cells don't cover all the windows
}


void draw() {

  //Draw grid
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      if (cells[x][y]==1) {
        fill(alive); // If alive
      }
      else {
        fill(dead); // If dead
      }
      rect (x*cellSize, y*cellSize, cellSize, cellSize);
    }
  }
  // Iterate if timer ticks
  if (millis()-lastRecordedTime>interval) {
    if (!pause) {
      iteration();
      lastRecordedTime = millis();
    }
  }

  // Create  new cells manually on pause
  if (pause && mousePressed) {
    // Map and avoid out of bound errors
    int xCellOver = int(map(mouseX, 0, width, 0, width/cellSize));
    xCellOver = constrain(xCellOver, 0, width/cellSize-1);
    int yCellOver = int(map(mouseY, 0, height, 0, height/cellSize));
    yCellOver = constrain(yCellOver, 0, height/cellSize-1);

    // Check against cells in buffer
    if (cellsBuffer[xCellOver][yCellOver]==1) { // Cell is alive
      cells[xCellOver][yCellOver]=0; // Kill
      fill(dead); // Fill with kill color
    }
    else { // Cell is dead
      cells[xCellOver][yCellOver]=1; // Make alive
      fill(alive); // Fill alive color
    }
  } 
  else if (pause && !mousePressed) { // And then save to buffer once mouse goes up
    // Save cells to buffer (so we opeate with one array keeping the other intact)
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cellsBuffer[x][y] = cells[x][y];
      }
    }
  }
}



void iteration() { // When the clock ticks
  // Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }
  int gridLength = (width/cellSize);
  int gridHeight = (height/cellSize);          
  // Visit each cell:
  for (int x=0; x<gridLength; x++) {
    for (int y=0; y<gridHeight; y++) {
    // And visit all the neighbours of each cell    
    int numNeighbors = 0;
    for (int i = -1; i <= 1; i +=1 ) {
        for (int j = -1; j <= 1; j += 1) {
            int neighborX = (x + i + gridLength) % gridLength;
            int neighborY = (y + j + gridLength) % gridLength;            
            if (neighborX != x || neighborY != y) {
                if (cellsBuffer[neighborX][neighborY] == 1) {
                    numNeighbors += 1;
                }
            }            
        }
    }
    int neighbours = numNeighbors;
      
      // We've checked the neigbours: apply rules!
      if (cellsBuffer[x][y]==1) { // The cell is alive: kill it if necessary
        if (neighbours < 2 || neighbours > 3) {
          cells[x][y] = 0; // Die unless it has 2 or 3 neighbours
        }
      } 
      else { // The cell is dead: make it live if necessary      
        if (neighbours == 3 ) {
          cells[x][y] = 1; // Only if it has 3 neighbours
        }
      } // End of if
    } // End of y loop
  } // End of x loop
} // End of function

void keyPressed() {
  if (key=='r' || key == 'R') {
    // Restart: reinitialization of cells
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        float state = random (100);
        if (state > probabilityOfAliveAtStart) {
          state = 0;
        }
        else {
          state = 1;
        }
        cells[x][y] = int(state); // Save state of each cell
      }
    }
  }
  if (key=='c' || key == 'C') {
    // Clear: Clear all Cells
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cells[x][y] = 0; // Save state of each cell
      }
    }
  }
  
  if (key==' '||key=='p'||key=='P') { // On/off of pause
    pause = !pause;
  }
  if (key=='c' || key == 'C') { // Clear all
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cells[x][y] = 0; // Save all to zero
      }
    }
  }
  if (key=='f' || key == 'F') {
    // Fast Forward
    interval = int(iinterval/speedFactor);
    
  }
  if (key=='q'||key=='Q')
    {
      //Super Fast Forward
      interval = int(iinterval/(speedFactor*4));
    }
  if (key=='w'||key=='W')
    {
      //Mega (max) Fast Forward
      interval = 0;
    }
  if (key=='s' || key == 'S') {
    // Slow Motion
    interval = int(iinterval*speedFactor);
  }
}

void keyReleased() {
  if (key=='f' || key == 'F') {
    // Fast Forward
    interval = iinterval;
  }
  if (key=='s' || key == 'S') {
    // Fast Forward
    interval = iinterval;
  }
}

// add a live cell when you click on it
void mouseClicked() {
    int x = floor(mouseX / cellSize);
    int y = floor(mouseY / cellSize);
    try
    {
      if (cells[x][y]==0)
      {
        cells[x][y] = 1;
      }
      
  
      // draw the new cell
      fill(199, 0, 209);
      rect(x * cellSize, y * cellSize,
          cellSize, cellSize);
      }
    catch (Exception e)
    { }
}

// do the same thing when you click and drag
void mouseDragged() {
    int x = floor(mouseX / cellSize);
    int y = floor(mouseY / cellSize);
    try
    {
      cells[x][y] = 1;
  
      // draw the new cell
      fill(199, 0, 209);
      rect(x * cellSize, y * cellSize,
          cellSize, cellSize);
      }
    catch (Exception e)
    { }
}
void initPattern()
{
    // initialize a "glider gun". Try picking different cells
    // and see what happens!
    cells[1][5]=1;
    cells[1][6]=1;
    cells[2][5]=1;
    cells[2][6]=1;
    cells[11][5]=1;
    cells[11][6]=1;
    cells[11][7]=1;
    cells[12][4]=1;
    cells[12][8]=1;
    cells[13][3]=1;
    cells[13][9]=1;
    cells[14][3]=1;
    cells[14][9]=1;
    cells[15][6]=1;
    cells[16][4]=1;
    cells[16][8]=1;
    cells[17][5]=1;
    cells[17][6]=1;
    cells[17][7]=1;
    cells[18][6]=1;
    cells[21][3]=1;
    cells[21][4]=1;
    cells[21][5]=1;
    cells[22][3]=1;
    cells[22][4]=1;
    cells[22][5]=1;
    cells[23][2]=1;
    cells[23][6]=1;
    cells[25][1]=1;
    cells[25][2]=1;
    cells[25][6]=1;
    cells[25][7]=1;
    cells[35][3]=1;
    cells[35][4]=1;
    cells[36][3]=1;
    cells[36][4]=1;
    cells[35][22]=1;
    cells[35][23]=1;
    cells[35][25]=1;
    cells[36][22]=1;
    cells[36][23]=1;
    cells[36][25]=1;
    cells[36][26]=1;
    cells[36][27]=1;
    cells[37][28]=1;
    cells[38][22]=1;
    cells[38][23]=1;
    cells[38][25]=1;
    cells[38][26]=1;
    cells[38][27]=1;
    cells[39][23]=1;
    cells[39][25]=1;
    cells[40][23]=1;
    cells[40][25]=1;
    cells[41][24]=1;
}