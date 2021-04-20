include <../libs/hardware-recess.scad>;
use <../libs/gopro_mounts_mooncactus.scad>;
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

MOUNT_H = 14.7;
MOUNT_W = 14.7;

module tube_mount(lock_d, mount_h, mount_cube_len){
    /*
        Add a tightening mout around the tube of a specified diameter
        lock_d -- locking diameter of a tube
        mount_h -- mount height (height of the part)
        mount_cube_len -- length of a joining cube
    */
    
    mount_w = MOUNT_W;
    connector_base_offset = 1.2;
    difference() {
        union(){
            translate([connector_base_offset, 0, 0]) 
                cylinder(d=lock_d+5, h=mount_h);
            translate([-4, 0,0])
                cube([mount_w,mount_cube_len,mount_h]);
        }
        translate([connector_base_offset, 0, 0]) cylinder(d=lock_d, h=mount_h);
        // cut to tighten the round thingy
        translate([0, 2, 0])
            cube([2,23,mount_h]);
        //Cut on the right
        translate([2, 23, 0])
            rotate([0,0,90])
                cube([2,10,mount_h]);
        //recess for the bolt
        translate([-4, 15, mount_h/2])
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
    z_offset = 5;
    x_offset=4.5;
    x_len = 20; // block len of the part
    thick = 4;
    difference(){
        cube([20, thick, 10]);
        translate([x_offset, 0, z_offset]){
            rotate([270, 0, 0])
                cylinder(d=m3_bolt_thick, h=thick, $fn=20);
        }
        translate([x_len - x_offset, 0, z_offset]){
            rotate([270, 0, 0])
                cylinder(d=m3_bolt_thick, h=thick, $fn=20);
        }
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
            rotate([270, 0, 0]) cylinder(20);
        }
    }
}

module base_w_gopro_mount(){
    // Base around the tube with triple gopro mount
    tube_mount(14, MOUNT_H, 27);
    translate([3.35,37.3, 7.35])
        rotate([0, 90, 180])
            gopro_connector("triple");
}

module filter_w_gopro_mount() {
    // Filter connector 
    gopro_connector("triple");
    translate([7.35, 10.8, 10])
        rotate([0, 90, 90])
        pop_filter_mount_points();

}

module rod_connector(){
    gopro_connector("double");
    gopro_extended(len=140, th=3)
        scale([1,-1,1])
            gopro_connector("double");
}

//filter_w_gopro_mount();
base_w_gopro_mount();

//rod_connector();