final int CELL_SIZE = 16;
final int FADE_RATE = 36;
final float COLOR_SPEED = 0.0001;
final float DENSITY = 0.1;

int sx, sy;
int[][][] world;
int[][] alpha_map;
color[][] color_map;

void setup() {
  // Display
  size(displayWidth, displayHeight, P2D);
  frameRate(30);
  orientation(PORTRAIT);

  // Grid
  sx = (int)displayWidth/CELL_SIZE;
  sy = (int)displayHeight/CELL_SIZE;

  // Grid backend
  world = new int[sx][sy][2];
  alpha_map = new int[sx][sy];
  color_map = new color[sx][sy];

  // Set random cells to 'on'
  for (int i = 0; i < sx * sy * DENSITY; i++) {
    int x = (int)random(sx);
    int y = (int)random(sy);
    world[x][y][1] = 1;
    alpha_map[x][y] = 255;
  }

  // Initialize color-changing gradient
  colorMode(HSB, 255);
}

void draw() {
  background(0);

  // Drawing and update cycle
  for (int x = 0; x < sx; x=x+1) {
    for (int y = 0; y < sy; y=y+1) {
      color_map[x][y] = color(127*(sin(frameCount*.05)*(float)x/sx)+127*(cos(frameCount*.05)*(float)y/sy) + 127, 255, 255);

      // if living or going to live draw square
      if ((world[x][y][1] == 1) || (world[x][y][1] == 0 && world[x][y][0] == 1)) {
        world[x][y][0] = 1;
        alpha_map[x][y] = 255;
      }
      // if dying fade-out
      if (world[x][y][1] == -1) {
        world[x][y][0] = 0;
        alpha_map[x][y] -= FADE_RATE;
      }
      world[x][y][1] = 0;
      alpha_map[x][y] -= FADE_RATE;

      if (alpha_map[x][y] > 0) {
        fill(color_map[x][y], alpha_map[x][y]);
        rectMode(CORNER);
        rect(x*CELL_SIZE, y*CELL_SIZE, CELL_SIZE, CELL_SIZE);
      }
    }
  }
  // Birth and death cycle
  for (int x = 0; x < sx; x=x+1) {
    for (int y = 0; y < sy; y=y+1) {
      int count = neighbors(x, y);
      if (count == 3 && world[x][y][0] == 0) {
        world[x][y][1] = 1;
      }
      if ((count < 2 || count > 3) && world[x][y][0] == 1) {
        world[x][y][1] = -1;
      }
    }
  }
}

void setCell(int x, int y) {
  world[min(sx-1, max(x/CELL_SIZE, 0))][min(sy-1, max(y/CELL_SIZE, 0))][1] = 1;
}

// Bring the current cell to life
void touchMoved() {
  setCell(mouseX, mouseY);
}

void mouseDragged() {
  setCell(mouseX, mouseY);
}

// Count the number of adjacent cells 'on'
int neighbors(int x, int y) {
  return world[(x + 1) % sx][y][0] + 
    world[x][(y + 1) % sy][0] + 
    world[(x + sx - 1) % sx][y][0] + 
    world[x][(y + sy - 1) % sy][0] + 
    world[(x + 1) % sx][(y + 1) % sy][0] + 
    world[(x + sx - 1) % sx][(y + 1) % sy][0] + 
    world[(x + sx - 1) % sx][(y + sy - 1) % sy][0] + 
    world[(x + 1) % sx][(y + sy - 1) % sy][0];
}
