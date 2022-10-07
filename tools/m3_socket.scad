/* M3 Socket driver bit
 * Copyright 2021 Alex Volkov <alex@flamy.ca>
 * License: Attribution-ShareAlike 4.0 International (CC BY-SA)
 * https://creativecommons.org/licenses/by-sa/4.0/
 */

SOCKET_LEN=25;
difference(){
    union(){
        cylinder(d=7, h=60, $fn=6);
        cylinder(d=10, h=SOCKET_LEN, $fn=50);
    }
    cylinder(d=6.5, h=SOCKET_LEN - 1, $fn=6);
}
