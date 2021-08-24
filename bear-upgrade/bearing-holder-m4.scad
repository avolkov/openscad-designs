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



bolt_len = 18;
BLOCK_W = 32;
BLOCK_H = 18;
*translate([(LM8UU[1]-2)/2,30/7, 17.5])
            screw(M4_hex_screw, bolt_len)

echo(screw_nut_radius(M4_cap_screw));
difference(){
    translate([1, 0, 0])
        cube([LM8UU[1]-2, BLOCK_W, BLOCK_H]);
    translate([LM8UU[1]/2, BLOCK_W/2, 6.75])
        rotate([0, 90, 0])
            linear_bearing(LM8UU);
    hull(){
        translate([-1, BLOCK_W/2, 6.75])
            rotate([0, 90, 0])
                cylinder(h=LM8UU[1] + 2, d=LM8UU[2]-2);
        translate([-1, BLOCK_W/2, 0])
            rotate([0, 90, 0])
                cylinder(h=LM8UU[1] + 2, d=LM8UU[2]-2);
        
    }
    translate([(LM8UU[1])/2, 4, bolt_len - 2])
            screw(M4_hex_screw, bolt_len);
    translate([(LM8UU[1])/2, 4 + 24, bolt_len - 2])
            screw(M4_hex_screw, bolt_len);
    //scs_screw(SCS8LUU);
    
}