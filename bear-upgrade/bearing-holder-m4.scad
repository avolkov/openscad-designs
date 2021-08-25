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
BLOCK_H = 14.5;
LM8UU_tolerance =  ["LM8UU",   24, 15 +0.2,  8, 0.9, 14.3, 17.3];


module cube_holder(){
    translate([1, 0, 0])
        cube([LM8UU[1]-2, BLOCK_W, BLOCK_H]);
}

module mount_base(){
    linear_extrude(BLOCK_H+0.5)
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
    cubeshave=8;
    difference(){
        linear_extrude(BLOCK_H+0.5)
           polygon(points=[
                [(LM8UU[1]-2)*0.2,0],
                [(LM8UU[1]-2)*0.8 ,0],
                [(LM8UU[1]-2)*0.8 - 2, 9],
                [(LM8UU[1]-2)*0.2 + 2, 9],
            ]);
        *translate([2, 4.5, BLOCK_H])
            rotate([30, 45, 65])
                cube([cubeshave,cubeshave, cubeshave]);
        *mirror([-1,0,0])
            translate([-(LM8UU[1]-2)*0.8 - 2.4, 4.5, BLOCK_H])
                rotate([30, 45, 60])
                    cube([cubeshave,cubeshave, cubeshave]);
    }
}

module extruded_holder(){
    union(){
         mirror([0,1,0]){
            translate([0,13,0]){
                mount_base();
                //fastener_poly();
            }
        }
        mount_base();
        //fastener_poly();
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
    SCREW_LEN = 25;
    translate([(LM8UU[1])/2, 4,0]){
        translate([0,0,BLOCK_H])
            nut_trap(M4_cap_screw, M4_nut);
    }
    translate([(LM8UU[1])/2, 4 + 24, 0]){
        translate([0,0,BLOCK_H])
            nut_trap(M4_cap_screw, M4_nut);

        
    }
}

difference(){
    translate([1, 22.5, -2])
        extruded_holder();
    translate([LM8UU[1]/2, BLOCK_W/2, 5.25])
        rotate([0, 90, 0])
            linear_bearing(LM8UU_tolerance);
    fasteners();
    translate([0,0,-2])
        hull(){
            translate([-1, BLOCK_W/2, 5.25])
                rotate([0, 90, 0])
                    cylinder(h=LM8UU[1] + 2, d=LM8UU[2]-2);
            translate([-1, BLOCK_W/2, 0])
                rotate([0, 90, 0])
                    cylinder(h=LM8UU[1] + 2, d=LM8UU[2]-2);
        }
    
}


*fastener_poly();