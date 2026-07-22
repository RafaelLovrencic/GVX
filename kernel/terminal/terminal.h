#ifndef TERMINAL_H
#define TERMINAL_H

#define VGA_COLOR_BLACK 0
#define VGA_COLOR_BLUE 1
#define VGA_COLOR_GREEN 2
#define VGA_COLOR_CYAN 3
#define VGA_COLOR_RED 4
#define VGA_COLOR_MAGENTA 5
#define VGA_COLOR_BROWN 6
#define VGA_COLOR_LIGHT_GREY 7
#define VGA_COLOR_DARK_GREY 8
#define VGA_COLOR_LIGHT_BLUE 9
#define VGA_COLOR_LIGHT_GREEN 10
#define VGA_COLOR_LIGHT_CYAN 11
#define VGA_COLOR_LIGHT_RED 12
#define VGA_COLOR_LIGHT_MAGENTA 13
#define VGA_COLOR_LIGHT_BROWN 14
#define VGA_COLOR_WHITE 15

#define VGA_START ((volatile short*) 0xb8000)
#define VGA_COL_NUMS 80
#define VGA_ROW_NUMS 25


extern short col_ind, row_ind;
extern short char_color;


void terminal_init();
void set_color(short fg, short bg);

void terminal_putchar(char ch);
void terminal_printf(char *str);

void terminal_set_cursor_at(short x, short y);

#endif
