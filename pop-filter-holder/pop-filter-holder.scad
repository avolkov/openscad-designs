include <../libs/hardware-recess.scad>;

/*
 * Adapter for Simple Microphone Pop filter -- https://www.thingiverse.com/thing:1108999
 * and Ammon MS-12 Mini Foldable Desktop Microphone Stand
 *
 * Project URL
 * https://github.com/avolkov/openscad-designs/pop-filter-holder
 *
 * Copyright 2021 Alex Volkov <alex@flamy.ca>
 * License: Attribution-ShareAlike 4.0 International (CC BY-SA)
 * https://creativecommons.org/licenses/by-sa/4.0/
 *
 * Version 1.0 2021-04-05 Initial publication
 */

MOUNT_H = 15;
MOUNT_W = 12;

module tube_mount(lock_d, mount_h, mount_cube_len){
    /*
        Add a tightening mout around the tube of a specified diameter
        lock_d -- locking diameter of a tube
        mount_h -- mount height (height of the part)
        mount_cube_len -- length of a joining cube
    */
    
    mount_w = MOUNT_W;
    difference() {
        union(){
            cylinder(d=lock_d+5, h=mount_h);
            translate([-4, 0,0])cube([mount_w,mount_cube_len,mount_h]);
        }
        cylinder(d=lock_d, h=mount_h);
        // cut to tighten the round thingy
        translate([0, 2, 0])
            cube([2,25,mount_h]);
        //Cut on the right
        translate([2, 26, 0])
            rotate([0,0,90])
                cube([2,10,mount_h]);
        //recess for the bolt
        translate([-4, 18, mount_h/2])
            rotate([0, 90, 0])
                m3_hole_w_ends(mount_w);
    }
}

module base_model(){
    difference(){
        tube_mount(14, MOUNT_H, 120);
    }
    translate([-8, 112, 0])
        cube([20, 8, 130]);
    
}

module pop_filter_mount_points() {
    // Mount points for Simple Microphone Pop filter
    cube([20, 4, 10]);
    translate([4.5, 0, 7]){
        rotate([270, 0, 0])
            m3_hole_w_ends(20);
    }
    translate([15.5, 0, 7]){
        rotate([270, 0, 0])
            m3_hole_w_ends(20);
    }
}

module base_with_mounts(){
    // Add mounting points by subtracting material from base_model
    difference () {
        base_model();
        translate([-8, 112, 120]){
            pop_filter_mount_points();
        }
    }
}

module dummy_adjust_tolerances() {
    /*
        dummy part to test tolerances without printing the whole model
        usually disabled
    */
    difference() {
        cube([20, 8, 20]);
        cube([20, 4, 10]);
        translate([4.5, -3, 4.5]){
            rotate([270, 0, 0]) m3_hole_w_ends(20);
        }

        translate([15.5, -3, 4.5]){
            rotate([270, 0, 0]) m3_hole_w_ends(20);
        }
    }
}

base_with_mounts();
