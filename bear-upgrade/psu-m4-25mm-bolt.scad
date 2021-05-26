/*
 *
 * Re-implementation of PSU connector in OpenScad for 25mm M4 bolt
 *
 *Copyright 2021 Alex Volkov <alex@flamy.ca>
 * License: Attribution-ShareAlike 4.0 International (CC BY-SA)
 * https://creativecommons.org/licenses/by-sa/4.0/
 */

include <../libs/hardware-recess.scad>;
$fn=30;



difference(){
    thick = 6;
    part_len = 20;
    alu_connector(part_len, thick);
    translate([18/2, part_len/2, 0])
        hole_w_end(thick+2, 2, "round", 5, flip=true);
}

translate([18, 0,0])
    cube([20, 22, 15]);