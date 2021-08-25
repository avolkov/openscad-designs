/*
 * Bearing holder for bear upgrade and reprap-style carriage for prusa i3 V2
 * Using 2x M4 25mm bolts and 2x M4 nuts
 * Copyright 2021 Alex Volkov <alex@flamy.ca>
 * 
 * License: Attribution-ShareAlike 4.0 International (CC BY-SA)
 * https://creativecommons.org/licenses/by-sa/4.0/
 *
 * Version 1.0 2021-08-24 Initial draft
 */

include <NopSCADlib/lib.scad>
include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/layout.scad>

include <NopSCADlib/vitamins/linear_bearings.scad>
use <NopSCADlib/vitamins/linear_bearings.scad>

include <NopSCADlib/vitamins/bearing_blocks.scad>
use <NopSCADlib/vitamins/bearing_blocks.scad>


BLOCK_W = 32;
BLOCK_H = 16;
bolt_len = BLOCK_H;


module cube_holder(){
    translate([1, 0, 0])
        cube([LM8UU[1]-2, BLOCK_W, BLOCK_H]);
}

module mount_base(){
    linear_extrude(BLOCK_H-8)
        polygon(points=[
            [0,0],
            [LM8UU[1]-2,0],
            [LM8UU[1]-2,6],
            [(LM8UU[1]-2) - (LM8UU[1]-2)*0.2, 9],
            [(LM8UU[1]-2)*0.2, 9],
            [0, 6]
        ]);
}

module fastener_poly(){
    linear_extrude(BLOCK_H)
       polygon(points=[
            [(LM8UU[1]-2)*0.2,0],
            [(LM8UU[1]-2)*0.8,0],
            [(LM8UU[1]-2)*0.8, 9],
            [(LM8UU[1]-2)*0.2, 9],
        ]);
}

module extruded_holder(){
    union(){
         mirror([0,1,0]){
            translate([0,13,0]){
                mount_base();
                *fastener_poly();
            }
        }
        mount_base();
        fastener_poly();
    }
    translate([0, -13/2, BLOCK_H/2 -2])
        rotate([90, 0, 90])
            rotate_extrude(angle=180){
                translate([13/2, 0, 0])
                polygon(points=[
                        [0,0],
                        [0, LM8UU[1]-2],
                        [6, LM8UU[1]-2],
                        [9, (LM8UU[1]-2) - (LM8UU[1]-2)*0.2],
                        [9, (LM8UU[1]-2)*0.2],
                        [6, 0]
                    ]);
            }
}

module fasteners(){
    translate([(LM8UU[1])/2, 4, BLOCK_H - 3])
            screw(M4_hex_screw, BLOCK_H);
    translate([(LM8UU[1])/2, 4 + 24, BLOCK_H - 3])
            screw(M4_hex_screw, BLOCK_H);
}

/*
translate([(LM8UU[1]-2)/2,30/7, 17.5])
            screw(M4_hex_screw, bolt_len)
*/
difference(){
    translate([1, 22.5, -2])
        extruded_holder();
    translate([LM8UU[1]/2, BLOCK_W/2, 6.75])
        rotate([0, 90, 0])
            linear_bearing(LM8UU);
    translate([0,0,-2])
        hull(){
            translate([-1, BLOCK_W/2, 6.75])
                rotate([0, 90, 0])
                    cylinder(h=LM8UU[1] + 2, d=LM8UU[2]-2);
            translate([-1, BLOCK_W/2, 0])
                rotate([0, 90, 0])
                    cylinder(h=LM8UU[1] + 2, d=LM8UU[2]-2);
        }
    fasteners();
    //scs_screw(SCS8LUU);
    
}