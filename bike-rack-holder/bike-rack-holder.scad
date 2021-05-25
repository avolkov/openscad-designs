/*
 * Bike rack adapter for Merin Ignacio & Axiom Slim rack.
 * This should work for in place of any aluminium short rack adapter.
 * 
 * Project URL
 * https://github.com/avolkov/openscad-designs/tomato-can-saucer
 *
 * Copyright 2021 Alex Volkov <alex@flamy.ca>
 * License: Attribution-ShareAlike 4.0 International (CC BY-SA)
 * https://creativecommons.org/licenses/by-sa/4.0/
 *
 * Version 1.1 2021-05-24 Replaced cylinder joints with rotate_extrude
 * Version 1.0 2018-06-10 Initial Design
 */

$fa=0.8;

width=30;
thick=4.8;
m5_d=5.3;
//Segment lengths
first_seg_l= 30;
second_seg_l=135;
fourth_seg_l=25;

rail_hole_offset = 8;

frame_hook_deg = 110;

module rack_mount(){
    difference(){
        cube([width, first_seg_l, thick]);
        translate([width/2, first_seg_l - rail_hole_offset - 13, 0])
            cylinder(h=thick +2, d=m5_d);
        translate([width/2, first_seg_l - rail_hole_offset, 0])
            cylinder(h=thick + 2, d=m5_d);
    }
}


module 15_deg_bend(){
    rotate([15, 0, 0]){
        cube([width, second_seg_l -13, thick]);
    }
}

module u_bend(){
    translate([0,-13.5,8.8])
        rotate([0, 90, 0])
            rotate_extrude(angle=frame_hook_deg)
                translate([6,0,0])
                    square([thick, width]);

    rotate([frame_hook_deg, 0, 0]){
        translate([0, 10, -0.8]){
            difference(){
                cube([width, 15, thick]);
                translate([width/2, 6, 0]) cylinder(h=thick+3, d=m5_d);
            }
        }
    }
}

union(){
    rack_mount();
    translate([0, first_seg_l, 0,]){
        15_deg_bend();
        rotate([15, 0, 0]) //add initial bend to position u-bend
            translate([0, second_seg_l, 2]){
                difference(){
                    u_bend();
                    rotate([frame_hook_deg, 0, 0])
                        translate([0, 8, -thick -0.7])
                            cube([width, 18, thick]);
                }
            }
    }
}