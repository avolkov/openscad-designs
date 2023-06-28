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

ARM_LEN = 180;
ARM_BASE_W = 15;
ARM_TOP_W = 12;

CLAMPING_TOLERANCE = 0.5;

// some of this value is due to bug in hole_w_end function that doesn't calculate
// bolt trap/nut trap offset correctly
SPOOL_BOLT_OFFSET = 16;

DISPLAY_SPOOL = true;

SPOOL_ANGLE = 15;
SPOOL_LEN = 75;
SPOOL_Y_OFFSET = ARM_TOP_W - 3; // from the arm, this is probably calculation error coming from somewhere

BASE_LEN = 28;

DISPLAY_JAW = true;

module outer_holder(holder_len, lip_h){
    linear_extrude(holder_len){
        polygon(points=[
            [0, 0],
            [0, 1],
            [lip_h+ 0.2, 1],
            [lip_h + 1.5, 0.5],
            [lip_h + 1.5, 0]
        ]);
    }
}

module jaw() {
    bottom_offset = 4;
    base_w = 40;
    clamp_len=36;
    jaw_body_offset = 4.6 + CLAMPING_TOLERANCE;
    jaw_body=21.6 - CLAMPING_TOLERANCE;
    
    // Jaw
    translate([-21, jaw_body - jaw_body_offset, -1])
        hull(){
            max_hull = 3;
            translate([21,0, -max_hull]) cube([20, clamp_len, max_hull]);
            cube([41, clamp_len, 1]);
        }
    // lip that goes around 2020 bit
    translate([-21.5, jaw_body - jaw_body_offset , -1]){
        rotate([270, 270, 0])
            outer_holder(clamp_len, 1);
    }
    // Jaw body implementation
    translate([0, jaw_body - 5 , 0]){
        cube([20, jaw_body, 40 - CLAMPING_TOLERANCE]);
        for (i=[0, 20]){
            translate([0,0, i]) rotate([0, 270, 0]) alu_connector(jaw_body, 0);
        }
    }
    //bottom alu connector
    translate([-20, jaw_body - jaw_body_offset, -bottom_offset]) alu_connector(clamp_len, 4);
    
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
                    cylinder(d=$M_DIM[bolt_size][3], h=1, $fn=6);
                } else {
                    cylinder(d=$M_DIM[bolt_size][3], h=1);
                }
            }
        translate([
            0,
            0,
            SPOOL_LEN])
            cylinder(
                d=$M_DIM[bolt_size][3] + 3,
                h=10,
                $fn=40);
    }
}


module reinforcement_holes(base_d=14, chamfer_extra=3){
    for(i= [0.36:0.12:0.88]){
        translate([
            ARM_LEN * cos(90 - SPOOL_ANGLE - 1) * i +6,
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
                            translate([0, 0, CLAMPING_TOLERANCE]) cube([20, ARM_BASE_W, 40 - CLAMPING_TOLERANCE]);
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
module arm_mount(){
    // overhead_part
    hull(){
        translate([2, 23, 39.8]) cube([15, ARM_BASE_W , 8]);
        translate([-20.5, 2, 39.8]) cube([40.5, BASE_LEN + 8, 2]);
    }
    translate([-20, 2, 39.8]) alu_connector(BASE_LEN + 8, 4, flip=true);
    
}
