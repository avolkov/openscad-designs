/*
 * LM8UU Bearing Pusher
 * Copyright 2021 Alex Volkov <alex@flamy.ca>
 * License: Attribution-ShareAlike 4.0 International (CC BY-SA)
 * https://creativecommons.org/licenses/by-sa/4.0/
 */

include <../libs/hardware-recess.scad>;

TOTAL_LEN=65;
BEARING_D=13.8;

cylinder(h=4, d=BEARING_D);
translate([0,0,TOTAL_LEN/2]){
    cube([12,2, TOTAL_LEN], center=true);
    cube([2,12, TOTAL_LEN], center=true);
}
translate([0,0,TOTAL_LEN-6])
    cylinder(h=4, d1=1, d=BEARING_D);
translate([0,0,TOTAL_LEN-2])
    cylinder(h=2, d=BEARING_D);