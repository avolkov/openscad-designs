/* Copyright 2021 Alex Volkov <alex@flamy.ca>
 * License: Attribution-ShareAlike 4.0 International (CC BY-SA)
 * https://creativecommons.org/licenses/by-sa/4.0/
 */

include <../libs/hardware-recess.scad>;
$fn=30;

module cable_mount(cable_len, out_d, in_d){
    rotate([0, 90, 0 ]){
    difference(){
        cylinder(d=out_d, h=cable_len);
        cylinder(d=in_d, h=cable_len);
        translate([-out_d/2, 0, cable_len/2])
            cube([out_d, out_d, cable_len], center=true);
        }
    }
}

BASE_L = 30;

CABLE_MOUNT_X_OFFSET=22;
CABLE_MOUNT_Z_OFFSET=7;

CABLE_MOUNT_L=40;
CABLE_MOUNT_INNER_D=10;
CABLE_MOUNT_OUTER_D=18;

//cube([9, 9, 2]);
difference() {
    cube([9, BASE_L, 4]);
    translate([4.5, 4, 0])
        hole_w_end(5, 3, "hex", 3.3, flip=false);
    translate([0, CABLE_MOUNT_X_OFFSET, CABLE_MOUNT_Z_OFFSET-1])
        rotate([0,90, 0])
            cylinder(h=20, d=9);
}
translate([-CABLE_MOUNT_L, CABLE_MOUNT_X_OFFSET, CABLE_MOUNT_Z_OFFSET]){
    difference(){
        union(){
            cable_mount(CABLE_MOUNT_L, CABLE_MOUNT_OUTER_D, CABLE_MOUNT_INNER_D);
            cable_mount(1, CABLE_MOUNT_OUTER_D+2, CABLE_MOUNT_INNER_D+2);
            translate([6, 0, 0])
                cable_mount(1, CABLE_MOUNT_OUTER_D+2, CABLE_MOUNT_INNER_D+2);
            
            translate([20, 0, 0])
                cable_mount(1, CABLE_MOUNT_OUTER_D+2, CABLE_MOUNT_INNER_D+2);
            translate([26, 0, 0])
                cable_mount(1, CABLE_MOUNT_OUTER_D+2, CABLE_MOUNT_INNER_D+2);
        }
        translate([0, -10, -CABLE_MOUNT_Z_OFFSET - 3])
            cube([CABLE_MOUNT_L, CABLE_MOUNT_OUTER_D+5, 3]);
    }
}