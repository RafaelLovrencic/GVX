#include "terminal.h"

short col_ind, row_ind;
short char_color;



void set_color(short fg, short bg) {
    char_color = fg | bg << 4;
}

void terminal_putchar(char ch) {
    if (ch == '\n') {
        row_ind++;
        row_ind %= VGA_ROW_NUMS;
        col_ind = 0;

        return;
    }

    VGA_START[row_ind * VGA_COL_NUMS + col_ind] = (char_color << 8) | ch;

    col_ind++;
    if (col_ind >= VGA_COL_NUMS) {
        row_ind++;
        row_ind %= VGA_ROW_NUMS;
    }
    col_ind %= VGA_COL_NUMS;

    terminal_set_cursor_at(col_ind, row_ind);
}

void terminal_printf(char *str) {
    while (*str) {
        terminal_putchar(*str);
        str++;
    }
}

void terminal_init() {
    set_color(VGA_COLOR_WHITE, VGA_COLOR_BLACK);
    terminal_set_cursor_at(0, 0);

    for (int y = 0; y < VGA_ROW_NUMS; y++) {
        for (int x = 0; x < VGA_COL_NUMS; x++) {
            VGA_START[y * VGA_COL_NUMS + x] = (char_color << 8) | ' ';
        }
    }
}

void terminal_set_cursor_at(short x, short y) {
    col_ind = x;
    row_ind = y;
}
