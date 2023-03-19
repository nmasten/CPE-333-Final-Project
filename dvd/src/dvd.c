volatile int * const VG_ADDR = (int *)0x11100000;
volatile int * const VG_COLOR = (int *)0x11140000;


static void draw_dot(int X, int Y, int color);
static void draw_horizontal_line(int X, int Y, int toX, int color);
static void draw_background();
static void draw_dvd(int x, int y);
void wait(int seconds);
static int checkY(int y, int vy);
static int checkX(int x, int vx);

volatile int const color_index = 1;
unsigned int const colors[7] = {0xFF, 0x09, 0x0A, 0x0C, 0x0D, 0x0E, 0x29};
unsigned int pattern[5][16] = {
	{0xFF, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x00},
	{0xFF, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0x00},
	{0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00},
	{0xFF, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0x00},
	{0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x00}
};

void main(){
	int x = 1, y = 1;
	int vx = 1, vy = 1;
	unsigned int curr_color = 36;
	while(1){
		
		draw_background();
		draw_dvd(x,y);
		x+=vx;
		y+=vy;
		vx = (x <= 0 || x >= 65) ? -vx : vx;
		vy = (y <= 0 || y >= 55) ? -vy : vy;

		if (x == 65 || y == 55 || x == 0 || y == 0) {
			for (int i = 0; i < 5; i++) {
				for (int j = 0; j < 16; j++) {
					if (pattern[i][j] != 0x00) {
						pattern[i][j] = curr_color;
					}
				}
			}
			curr_color = curr_color + 10;
		}
		
		wait(1);
	}

}

static int checkY(int y, int vy) {
	if (y < 0 || y >= 56){
		vy = -vy;
	}
	return vy;
}

static int checkX(int x, int vx) {
	if (x < 0 || x >= 65){
		vx = -vx;
	}
	return vx;
}

static void draw_horizontal_line(int X, int Y, int toX, int color) {
	toX++;
	for (; X != toX; X++) {
		draw_dot(X, Y, color);
	}
}

static void draw_background() {
	for (int Y = 0; Y != 60; Y++) {
		draw_horizontal_line(0, Y, 79, 0x00);
	}
}

static void draw_dvd(int x, int y) {
	for (int i = y; i < y + 5; i++) {
		for (int j = x; j < x + 16; j++) {
			draw_dot(j, i, pattern[i-y][j-x]);
		}
	}
}

static void draw_dot(int X, int Y, int color) {
	*VG_ADDR = (Y << 7) | X;  // store into the address IO register
	*VG_COLOR = color;  // store into the color IO register, which triggers
			// the actual write to the framebuffer at the address
			// previously stored in the address IO register
					   		                    	                    }


void wait( int seconds )
{   // this function needs to be finetuned for the specific microprocessor
    int i, j, k;
    int wait_loop0 = 100;
    int wait_loop1 = 600;
    for(i = 0; i < seconds; i++)
    {
        for(j = 0; j < wait_loop0; j++)
        {
            for(k = 0; k < wait_loop1; k++)
            {   // waste function, volatile makes sure it is not being optimized out by compiler
                int volatile t = 120 * j * i + k;
                t = t + 5;
            }
        }
    }
}
					  
					  

