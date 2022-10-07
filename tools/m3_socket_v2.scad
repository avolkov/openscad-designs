/* M3 Socket driver bit
 * Copyright 2021 Alex Volkov <alex@flamy.ca>
 * License: Attribution-ShareAlike 4.0 International (CC BY-SA)
 * https://creativecommons.org/licenses/by-sa/4.0/
 */
include <../libs/hardware-recess.scad>;

TOTAL_LEN=30;
SOCKET_LEN=10;
difference(){
    union(){
        cylinder(d=7.25, h=TOTAL_LEN, $fn=6);
        cylinder(d=11, h=SOCKET_LEN, $fn=50);
    }
    cylinder(d=M_DIM[M3][3] + 0.25 , h=SOCKET_LEN - 2, $fn=6);
    cylinder(d=3.4, h=TOTAL_LEN, $fn=50);
}
