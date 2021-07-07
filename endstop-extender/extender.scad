include <../libs/hardware-recess.scad>;

endstop_offset=20;
extra_width = 6;

module endstop_mount(){
    translate([-4.75,0,0])hole_w_end(4, 1.4, "round", M2);
    // Front screw hole for endstop
    translate([4.75,0,0])hole_w_end(4, 1.4, "round", M2);
}

module endstop_nut(){
    translate([-4.75,0,0])hole_w_end(4, 1.4, "hex", M2);
    // Front screw hole for endstop
    translate([4.75,0,0])hole_w_end(4, 1.4, "hex", M2);
}


difference(){
    translate([-4.75 - extra_width/2, 0, -2]) 
        cube([4.75*2 + extra_width , endstop_offset, 6]);
    translate([-4.75 - extra_width/2, 0, -2]) 
            cube([4.75*2 + extra_width , endstop_offset/2, 2]);
    hull(){
        translate([-4.75 - extra_width/2, endstop_offset /2, 2]) 
            cube([4.75*2 + extra_width , endstop_offset, 2]);
        translate([-4.75 - extra_width/2, 3, 4]) 
            cube([4.75*2 + extra_width , endstop_offset, 0.5]);
    }
    
    translate([0, 3, 0])
        endstop_mount();
    translate([0, endstop_offset - 3, 0])
        endstop_nut();
}
