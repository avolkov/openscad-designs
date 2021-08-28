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



/*
 * TODOs:
 * DONE. Add connector ridges for the part when spool holder mates with the arm
 * Add teeth that go in between base and jaw (5-8mm long or so) to add vertical rigidity
 * NOPE. Make arm thicker, not enough meat holding m8 bolts to the base
 * Add 'cups' that hold m8 threads for jaw and base bolts
 * Figure out how to cut the edges (45 degree cubes?) 
 * - check out https://github.com/rcolyer/smooth-prim
 */

/*
 * Testing
 * 1) create a simplified model of base and jaws to fix fitting
 * 2) Try fixing ALU tolerances in the library
 *
 *
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
SPOOL_BOLT_OFFSET = 8;

DISPLAY_SPOOL = true;

SPOOL_ANGLE = 30;
SPOOL_LEN = 75;
SPOOL_Y_OFFSET = ARM_TOP_W - 3; // from the arm, this is probably calculation error coming from somewhere

BASE_LEN = 28;

DISPLAY_JAW = true;

//TODO: to be moved in common library

module tooth(tooth_len, tooth_width){
    blade_w = 0.2;
    tooth_depth = 2;

    hull(){
        cube([tooth_len, blade_w, blade_w]);
        translate([0, tooth_width - 1, 0])
            cube([tooth_len, 1, tooth_depth]);
            
    }
}


module rotate_teeth(count, tooth_len, tooth_width, r){
    // Post here solves rotation
    // http://forum.openscad.org/Re-Rotate-relative-or-make-spokes-td14882.html
    for (i=[0:count]){
        rotate([0,0, 360/count*i])
            translate([r, -tooth_width/2, 0])
                tooth(tooth_len, tooth_width);
    }
}

//Implementation


module jaw_strain_relief(){
    rotate([0, 45, 0])cube([4, BASE_LEN, 4]);
}

module journal_key(k_len, tolerance=0){
    //Journal and key for jaw/base alignment
    translate([0, tolerance/2, 0])
    linear_extrude(k_len){
        polygon(points=[
            [0 ,0 - tolerance],
            [6 + tolerance , 2 - tolerance],
            [6 + tolerance, 6 + tolerance],
            [0, 8 + tolerance]
        ]);
    }
}

module outer_holder(){
    linear_extrude(BASE_LEN){
                polygon(points=[
                    [0, 0],
                    [0, 2.5],
                    [4.6, 2.5],
                    [5.5, 1.5],
                    [5.5, 0]
                ]);
            }
}


module jaw() {
    
    base_w = 40;
    translate([-20, 0, 0])
        cube([40, BASE_LEN, 4]);
    // lip that goes around 2020 bit
    translate([-22, 0, 0]){
        rotate([270, 270, 0])
            outer_holder();
        //cube([2, BASE_LEN, 5.5]);
    }
    translate([0, BASE_LEN/2, ]){
        cube([20, BASE_LEN/2, base_w]);
        for (i=[0, 20]){
            translate([0,0, i]) rotate([0, 270, 0]) alu_connector(BASE_LEN/2, 0);
        }
    }
    translate([-20, 0, 0]) alu_connector(BASE_LEN, 4);
}

module base_imp(){
    // joining part
    // TODO: possibly bring things closer by a mm
    base_w = 40;
    JAW_MOUNT_BIT_H = 14;
    cube([20, BASE_LEN/2, base_w]);
    
    // overhead_part
    translate([-20, 0, 40]){
        cube([40, BASE_LEN, 8]);
        alu_connector(BASE_LEN, 4, flip=true);
    }
    
    // lip that goes around 2020 bit
    translate([-22.5, 0, 44])
        rotate([270, 90, 0])
            mirror([0, 1, 0])
            outer_holder();
    // fill out bit of space
    translate([-22.5, 0, 44])
        cube([3, BASE_LEN, 4]);
    // 2040 connectors
    for (i=[0, 20]){
        translate([0,0, i]) rotate([0, 270, 0]) alu_connector(BASE_LEN/2, 0);
    }
}


module base(display_jaw, display_base){
    difference() {
        union(){
            if (display_base){
                base_imp();
            }
            // bottom part -> jaw
            if (display_jaw){
                translate([0, 0, 0]) jaw();
            }
        }
        //Jaw mounting hardware
        for (i = [9, 27]) {
            translate([36, i, -3]) bolt_nut(m8_bolt_len + 2, M8, flip=true);
        }
    
        //extra meat compensator
        for (i=[10, 30]){
            translate([10, 30, i])
               rotate([270, 0, 0])
                    cylinder(d=M_DIM[8][3], h=20, $fn=6);
        }
    }
}

module spool(){
    fn=50;
    rotate([90, 0,0]){
        difference(){
            union(){
                cylinder(d=spool_d, h=SPOOL_LEN, $fn=fn);
                translate([0,0,SPOOL_LEN - 10]){
                    cylinder(d1=spool_d, d2=spool_d + 10, h=5, $fn=fn);
                    translate([0,0,5])
                    cylinder(d=spool_d + 10, h=5, $fn=fn);
                }
            }
            // hole for the bolt
            translate([0, 0, m8_bolt_len - ARM_TOP_W + SPOOL_BOLT_OFFSET - SPOOL_Y_OFFSET -1]){
                hull($fn=50){
                    rotate([0,0,30])
                        cylinder(d=M_DIM[8][3], h=1, $fn=6);
                    translate([
                        0,
                        0,
                        SPOOL_LEN - (m8_bolt_len - ARM_TOP_W + SPOOL_BOLT_OFFSET - SPOOL_Y_OFFSET + 16)])
                        cylinder(d=M_DIM[8][3] + 3, h=20, $fn=40);
                }
                
            }
            rotate_teeth(6, 5, 3, 5);
       }
    }
}


module reinforcement_holes(base_d=14, chamfer_extra=3){
    for(i= [0.42:0.14:1]){
        translate([
            ARM_LEN*cos(90-SPOOL_ANGLE) *i  - 1.5 ,
            ARM_BASE_W,
            ARM_LEN * sin(90 - SPOOL_ANGLE)*i])
            rotate([90, 0, 0]){
                cylinder(h=ARM_BASE_W/3, d1=base_d + chamfer_extra, d2=base_d, $fn=30);
                cylinder(h=ARM_BASE_W, d=base_d, $fn=30);
                translate([0, 0, ARM_BASE_W - ARM_BASE_W/3])
                    cylinder(h=ARM_BASE_W/3, d1=base_d, d2=base_d + chamfer_extra, $fn=30);
            }
    }
}

module arm(display_spool=DISPLAY_SPOOL){
    
    SPOOL_X_ADJUST = 10 + ARM_LEN * cos(90 - SPOOL_ANGLE);
    //reinforcement_holes();
    difference(){
        union(){
            difference(){
                hull(){
                    cube([20, ARM_BASE_W, 40]);
                    echo([SPOOL_X_ADJUST, ARM_BASE_W, ARM_LEN])
                    translate([SPOOL_X_ADJUST, ARM_BASE_W/2, ARM_LEN])
                        rotate([90, 0, 0]){
                            cylinder(d=spool_d, h=ARM_BASE_W, center=true);
                        }
                }
                // Flat area for spool holder mating
                translate([SPOOL_X_ADJUST, ARM_BASE_W/2-ARM_TOP_W, ARM_LEN])
                    rotate([90, 0, 0])
                        cylinder(d=spool_d+2, h=ARM_TOP_W, center=true);
                
                *translate([0, ARM_BASE_W,0])
                    cube([200, ARM_BASE_W, ARM_LEN+140]);
            } 
                if (display_spool){
                    translate([SPOOL_X_ADJUST, SPOOL_Y_OFFSET-ARM_BASE_W/2, ARM_LEN]) spool();
                }
                for (i=[0, 20]){
                    translate([0,0, i]) rotate([0, 270, 0]) alu_connector(ARM_BASE_W, 0);
                }
        }

        //hardware for mating spool to an arm
        translate([SPOOL_X_ADJUST, ARM_BASE_W/2 + SPOOL_BOLT_OFFSET, ARM_LEN])
            rotate([90, 0, 0])
                bolt_nut(m8_bolt_len, M8, flip=true);

        // Cutting reinforcement holes
        reinforcement_holes();
    }
    // Spool mating teeth
    translate([SPOOL_X_ADJUST,
        SPOOL_Y_OFFSET-ARM_BASE_W/2 + 0.2, // Adjusting tolerances for mating teeth
        ARM_LEN
        ])
        rotate([90, 0, 0])
            rotate_teeth(6, 4, 3, 5.5);
}


*arm(display_spool=false);
*base(display_jaw=true, display_base=false);

base_imp();

