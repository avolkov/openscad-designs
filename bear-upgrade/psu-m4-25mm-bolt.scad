/*
 *
 * Re-implementation of Bear Upgrade silver PSU connector in
 * OpenScad for 25mm M4 bolt
 *
 * Copyright 2021 Alex Volkov <alex@flamy.ca>
 * License: Attribution-ShareAlike 4.0 International (CC BY-SA)
 * https://creativecommons.org/licenses/by-sa/4.0/
 *
 * Version: 0.1 2021-05-26 Initial implementation
 */

include <../libs/hardware-recess.scad>;
$fn=30;




module make_connector(thick, part_len){
    alu_2020_w = 20;
    difference(){
        alu_connector(part_len, thick);
        translate([alu_2020_w/2, part_len/2, 0]){
            hole_w_end(thick+2, 2, "round", 5, flip=true);
            hull() {
                cylinder(h=1, d=M_DIM[5][1] + 1.1, $fn=60);
                translate([0, 10, 0])
                cylinder(h=1, d=M_DIM[5][1] + 1.1, $fn=60);
            }
        }
    }
}

module make_psu_mount(){
    buff_len = 22;
    buff_w = 20;
    difference(){
        
        cube([buff_len, buff_w, 30]);
        //Mount for M4 bolt
        translate([buff_len, buff_w/2, 10])
            rotate([0,270, 0])
                hole_w_end(buff_len, M_DIM[4][2] + 1, "round", 4);
        //Shave off angle
        
        translate([buff_len+5, 0, 15])
            rotate([0,-45,0])
                cube([15, buff_w, 25]);
        
        translate([2, buff_w, 15])
            rotate([90,0,0])
                linear_extrude(buff_w)
                    polygon(points=[[0,0], [0,14], [10,14], [9, 14],[18, 5], [18, 0]]);
    }
}


make_connector(thick=6, part_len=20);
translate([alu_2020_w, 0,0]){
    make_psu_mount();
}

