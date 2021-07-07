include <../libs/hardware-recess.scad>;

endstop_offset=20;

module endstop_mount(){
    translate([-4.75,0,0])cylinder(r=1,h=10,$fn=20);
    // Front screw hole for endstop
    translate([4.75,0,0])cylinder(r=1,h=10,$fn=20);
}

difference(){
    translate([-4.75 - 2, 0, 0]) 
        cube([4.75*2 + 4, endstop_offset, 4]);
    translate([0, 3, 0])
        endstop_mount();
    translate([0, endstop_offset - 3, 0])
        endstop_mount();
}
