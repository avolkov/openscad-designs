/*
 * Ultimate customizable spool holder for 2040 frame (bear upgrade)
 * 
 * Project URL
 * https://github.com/avolkov/openscad-designs/spool-holder
 *
 * Copyright 2021 Alex Volkov <alex@flamy.ca>
 * License: Attribution-ShareAlike 4.0 International (CC BY-SA)
 * https://creativecommons.org/licenses/by-sa/4.0/
 *
 * Version 0.1 2021-06-28 Initial work started WIP
 */


include <../libs/hardware-recess.scad>;

spool_d = 25;
//Total lenght of a 40mm M8 capscrew bolt (including the head)
m8_bolt_len = 47;

ARM_LEN = 150;
ARM_BASE_W = 15;
ARM_TOP_W = 12;

// some of this value is due to bug in hole_w_end function that doesn't calculate
// bolt trap/nut trap offset correctly
SPOOL_BOLT_OFFSET = 4.7;

DISPLAY_SPOOL = true;

SPOOL_ANGLE = 30;
SPOOL_LEN = 100;

BASE_LEN = 36;

module jaw_strain_relief(){
    rotate([0, 45, 0])cube([4, BASE_LEN, 4]);
}


module jaw() {
    cube([24, BASE_LEN, 4]);
    translate([-20, 0, 0]) alu_connector(BASE_LEN, 4);
    translate([22, 0, 0]) cube([29, BASE_LEN, 14]);
    translate([20.4, 0, 4])jaw_strain_relief();
}

module base_imp(){
    // joining part
    // TODO: possibly bring things closer by a mm
    tolerance_offset = 0;
    translate([0, 0, 2 - tolerance_offset])
        cube([20, BASE_LEN, 38 - tolerance_offset]);
    // overhead_part
    translate([0, 0, 40]){
        cube([20, BASE_LEN, 4]);
        translate([-20, 0, 0])
            alu_connector(BASE_LEN, 4, flip=true);
    }
    // Jaw connector
    translate([20, 0, 40 - 10]){
        cube([29, BASE_LEN, 14]);
        // Strain relief
        translate([-3, 0, 0]) jaw_strain_relief();
    }
}


module base(){
    difference() {
        union(){
            base_imp();
            // bottom part -> jaw
            translate([0, 0, -3]) jaw();
        }
        translate([36, 27, -3]) bolt_nut(m8_bolt_len + 2, M8, flip=true);
        translate([36, 9, -3]) bolt_nut(m8_bolt_len + 2, M8, flip=true);
    }
}

module spool(){
    fn=50;
    rotate([90, 0,0]){
        difference(){
            union(){
                cylinder(d=spool_d, h=SPOOL_LEN, $fn=fn);
                translate([0,0,90]){
                    cylinder(d1=spool_d, d2=spool_d + 10, h=5, $fn=fn);
                    translate([0,0,5])
                    cylinder(d=spool_d + 10, h=5, $fn=fn);
                }
            }
            // hole for the bolt
            translate([0,0, m8_bolt_len - ARM_TOP_W + SPOOL_BOLT_OFFSET])
                cylinder(
                    d1=M_DIM[8][3] + 0.2,
                    d2=M_DIM[8][3] + 5,
                    h=ARM_LEN - (m8_bolt_len - ARM_TOP_W + SPOOL_BOLT_OFFSET),
                    $fn=fn);
       }
    }
}
//TODO: make arm thicker, not enough meat holding m8 bolts to the base
module arm(display_spool=DISPLAY_SPOOL){
    SPOOL_X_ADJUST = 10 + ARM_LEN * cos(90 - SPOOL_ANGLE);
    difference(){
        union(){
            hull(){
                cube([20, ARM_BASE_W, 40]);
                translate([SPOOL_X_ADJUST, 0, ARM_LEN])
                    rotate([90, 0, 0])
                        cylinder(d=spool_d, h=ARM_TOP_W, center=true);
            }
            if (display_spool){
                translate([SPOOL_X_ADJUST,0, ARM_LEN]) spool();
            }
            
        }
    // hardware for mating spool to an arm
        translate([SPOOL_X_ADJUST, ARM_TOP_W - SPOOL_BOLT_OFFSET, ARM_LEN])
            rotate([90, 0, 0])
                bolt_nut(m8_bolt_len, M8, flip=true);
    }
}




//translate([0,0, 40]) rotate([0, 15, 0]) arm();
//translate([39, 0, 160 + 20 + 5]) rotate([90, 0,0]) spool();
difference(){
    union(){
        translate([0,ARM_BASE_W,0]) base();
        arm();
        rotate([0, 270, 0]) alu_connector(BASE_LEN + ARM_BASE_W, 0);
        translate([0,0, 20]) rotate([0, 270, 0]) alu_connector(BASE_LEN + ARM_BASE_W, 0);
    }
    //using joining hardware
    translate([10, -2, 10]) rotate([270, 0, 0]) bolt_nut(m8_bolt_len + 1, M8, flip=true);
    translate([10, -2, 30]) rotate([270, 0, 0]) bolt_nut(m8_bolt_len + 1, M8, flip=true);
}
