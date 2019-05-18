/*
 * [CalsignLabs]
 * This example taken from the Processing distribution.
 */

/**
 * Conway's Game of Life
 * by Mike Davis.
 * 
 * This program is a simple version of Conway's 
 * game of Life.  A lit point turns off if there 
 * are fewer than two or more than three surrounding 
 * lit points.  An unlit point turns on if there 
 * are exactly three lit neighbors.  The 'density' 
 * parameter determines how much of the board will 
 * start out lit.
 */

int sx, sy;
float density = 0.5;
int[][][] world;
int cell_size = 16;

void setup()
{
  size(displayWidth, displayHeight, P2D);
  frameRate(30);
  sx = (int)displayWidth/cell_size;
  sy = (int)displayHeight/cell_size;
  world = new int[sx][sy][2];

  // Set random cells to 'on'
  for (int i = 0; i < sx * sy * density; i++) {
    world[(int)random(sx)][(int)random(sy)][1] = 1;
  }
}

void draw()
{
  background(0);

  // Drawing and update cycle
  for (int x = 0; x < sx; x=x+1) {
    for (int y = 0; y < sy; y=y+1) {
      //if (world[x][y][1] == 1)
      // Change recommended by The.Lucky.Mutt
      if ((world[x][y][1] == 1) || (world[x][y][1] == 0 && world[x][y][0] == 1))
      {
        world[x][y][0] = 1;
        //set(x, y, #FFFFFF);
        rectMode(CORNER);
        rect(x*cell_size, y*cell_size, cell_size, cell_size);
      }
      if (world[x][y][1] == -1)
      {
        world[x][y][0] = 0;
      }
      world[x][y][1] = 0;
    }
  }
  // Birth and death cycle
  for (int x = 0; x < sx; x=x+1) {
    for (int y = 0; y < sy; y=y+1) {
      int count = neighbors(x, y);
      if (count == 3 && world[x][y][0] == 0)
      {
        world[x][y][1] = 1;
      }
      if ((count < 2 || count > 3) && world[x][y][0] == 1)
      {
        world[x][y][1] = -1;
      }
    }
  }
}

// Bring the current cell to life
void touchMoved() {
  world[min(sx-1, max(mouseX/cell_size, 0))][min(sy-1, max(mouseY/cell_size, 0))][1] = 1;
}

// Count the number of adjacent cells 'on'
int neighbors(int x, int y)
{
  return world[(x + 1) % sx][y][0] + 
    world[x][(y + 1) % sy][0] + 
    world[(x + sx - 1) % sx][y][0] + 
    world[x][(y + sy - 1) % sy][0] + 
    world[(x + 1) % sx][(y + 1) % sy][0] + 
    world[(x + sx - 1) % sx][(y + 1) % sy][0] + 
    world[(x + sx - 1) % sx][(y + sy - 1) % sy][0] + 
    world[(x + 1) % sx][(y + sy - 1) % sy][0];
}
