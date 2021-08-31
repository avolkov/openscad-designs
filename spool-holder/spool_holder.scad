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
 * fix vertical cuts for nuts/bolts in spool
 
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
CONN_BOLT_LEN = 47;
BOLT_SIZE = M8;

ARM_LEN = 150;
ARM_BASE_W = 15;
ARM_TOP_W = 12;


// some of this value is due to bug in hole_w_end function that doesn't calculate
// bolt trap/nut trap offset correctly
SPOOL_BOLT_OFFSET = 16;

DISPLAY_SPOOL = true;

SPOOL_ANGLE = 30;
SPOOL_LEN = 75;
SPOOL_Y_OFFSET = ARM_TOP_W - 3; // from the arm, this is probably calculation error coming from somewhere

BASE_LEN = 28;

DISPLAY_JAW = true;

module outer_holder(){
    linear_extrude(BASE_LEN){
        polygon(points=[
            [0, 0],
            [0, 1],
            [4.2, 1],
            [5.5, 0.5],
            [5.5, 0]
        ]);
    }
}

module jaw() {
    bottom_offset = 4;
    base_w = 40;
    
    // Jaw
    translate([-21, 0, -bottom_offset])
        cube([41, BASE_LEN, 4]);
    // lip that goes around 2020 bit
    translate([-21.5, 0, -bottom_offset]){
        rotate([270, 270, 0])
            outer_holder();
    }
    // Jaw body implementation
    translate([0, BASE_LEN/2, 0]){
        cube([20, BASE_LEN/2, 40 - 0.4]);
        for (i=[0, 20]){
            translate([0,0, i]) rotate([0, 270, 0]) alu_connector(BASE_LEN/2, 0);
        }
    }
    translate([-20, 0, -bottom_offset]) alu_connector(BASE_LEN, 4);
    
}

module base_imp(){
    // joining part
    base_w = 40;
    JAW_MOUNT_BIT_H = 14;
    // body
    translate([0,0, 0.2])
        cube([20, BASE_LEN/2, 40 - 0.2]);
    
    // overhead_part
    translate([-20.5, 0, 39.8]) cube([40.5, BASE_LEN, 8]);
    translate([-20, 0, 39.8]) alu_connector(BASE_LEN, 4, flip=true);
    
    // lip that goes around 2020 bit
    translate([-21.5, 0, 44])
        rotate([270, 90, 0])
            mirror([0, 1, 0])
            outer_holder();
    // fill out bit of space
    translate([-21.5, 0, 44])
        cube([3, BASE_LEN, 4]);
    // 2040 connectors
    for (i=[0, 20]){
        translate([0,0, i])
            rotate([0, 270, 0])
                alu_connector(BASE_LEN/2, 0);
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
                jaw();
            }
        }
        //Jaw mounting hardware
        for (i = [9, 27]) {
            translate([36, i, -3]) bolt_nut(CONN_BOLT_LEN + 2, BOLT_SIZE, flip=true);
        }
        //extra meat compensator
        for (i=[10, 30]){
            translate([10, 30, i])
               rotate([270, 0, 0])
                    cylinder(d=M_DIM[BOLT_SIZE][3], h=20, $fn=6);
        }
    }
}

module spool(bolt_len, bolt_size, cutout_type, custom_offset=SPOOL_BOLT_OFFSET){
    fn=50;
    rotate([90, 0,0]){
        difference(){
            union(){
                cylinder(d=spool_d, h=SPOOL_LEN, $fn=fn);
                translate([0,0,SPOOL_LEN - 10]){
                    cylinder(d1=spool_d, d2=spool_d + 10, h=5, $fn=fn);
                    translate([0, 0, 5]) cylinder(d=spool_d + 10, h=5, $fn=fn);
                }
            }
            // hole to pass through the head or bolt.
            spool_cutout(bolt_len, custom_offset, bolt_size, cutout_type);
       }
    }
}

module spool_cutout(bolt_len, custom_offset, bolt_size, cutout_type){
    hull($fn=50){
        translate([0, 0, custom_offset ])
            rotate([0,0,30]){
                if (cutout_type == "hex"){
                    cylinder(d=M_DIM[bolt_size][3], h=1, $fn=6);
                } else {
                    cylinder(d=M_DIM[bolt_size][3], h=1);
                }
            }
        translate([
            0,
            0,
            SPOOL_LEN])
            cylinder(
                d=M_DIM[bolt_size][3] + 3,
                h=10,
                $fn=40);
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

module arm(
    dual_spool=false,
    spool_bolt_size=BOLT_SIZE,
    spool_bolt_len=CONN_BOLT_LEN,
    display){
    
    SPOOL_X_ADJUST = 10 + ARM_LEN * cos(90 - SPOOL_ANGLE);
    //reinforcement_holes();
    difference(){
        union(){
            if (display == "all" || display == "arm"){
                    difference(){
                        hull(){
                            cube([20, ARM_BASE_W, 40]);
                            translate([SPOOL_X_ADJUST, ARM_BASE_W/2, ARM_LEN])
                                rotate([90, 0, 0]){
                                    cylinder(d=spool_d, h=ARM_BASE_W, center=true);
                                }
                        }
                        // Cut reinforcement holes
                        reinforcement_holes();
                        // Cut area for spool holder mating
                        translate([SPOOL_X_ADJUST, ARM_BASE_W/2-ARM_TOP_W, ARM_LEN])
                            rotate([90, 0, 0])
                                cylinder(d=spool_d+2, h=ARM_TOP_W, center=true);
                    }
                    
                    
                    for (i=[0, 20]){
                        translate([0,0, i]) rotate([0, 270, 0]) alu_connector(ARM_BASE_W, 0);
                    }
                }
                    if (dual_spool){
                        if ( display == "right" || display == "all") {
                            translate([SPOOL_X_ADJUST, SPOOL_Y_OFFSET-ARM_BASE_W/2, ARM_LEN])
                                spool(
                                    spool_bolt_len/2 + 6,
                                    spool_bolt_size,
                                    custom_offset=spool_bolt_len/2 - ARM_TOP_W/2 - 2,
                                    cutout_type="hex");
                        }
                        if ( display == "left" || display == "all") {
                            mirror([0, 1, 0])
                                translate([SPOOL_X_ADJUST, SPOOL_Y_OFFSET-ARM_BASE_W/2 - ARM_BASE_W - 2, ARM_LEN])
                                    spool(
                                        spool_bolt_len/2 + 8,
                                        spool_bolt_size,
                                        custom_offset=spool_bolt_len/2 - ARM_TOP_W/2 - 1,
                                        cutout_type="round");
                        }
                    } else {
                        if (spool_bolt_len >= 47){
                            if (display == "all" || display == "single_spool"){
                                translate([SPOOL_X_ADJUST, SPOOL_Y_OFFSET-ARM_BASE_W/2, ARM_LEN])
                                    spool(
                                        spool_bolt_len,
                                        spool_bolt_size,
                                        custom_offset=spool_bolt_len/2 - ARM_TOP_W/2 + 7,
                                        cutout_type="hex");
                            }
                        } else {
                            echo("Minimum bolt length required is 47mm");
                        }
                    }
                
        }
        //hardware for mating spool to an arm
        if (dual_spool){
            translate([SPOOL_X_ADJUST, spool_bolt_len/2 + SPOOL_Y_OFFSET , ARM_LEN])
                rotate([90, 0, 0])
                    bolt_nut(spool_bolt_len, spool_bolt_size, flip=true);
        } else {
            translate([SPOOL_X_ADJUST, ARM_BASE_W/2 + SPOOL_BOLT_OFFSET , ARM_LEN])
                rotate([90, 0, 0])
                    bolt_nut(spool_bolt_len, spool_bolt_size, flip=true);
        }
    }
}


