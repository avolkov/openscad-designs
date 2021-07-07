// PRUSA iteration4
// X end motor
// GNU GPL v3
// Josef Průša <iam@josefprusa.cz> and contributors
// http://www.reprap.org/wiki/Prusa_Mendel
// http://prusamendel.org

include <../libs/hardware-recess.scad>;

endstop_offset=35;
extra_width = 6;

module endstop_mount(){
    translate([-4.75,0,0])hole_w_end(4, 1.4, "round", M2);
    // Front screw hole for endstop
    translate([4.75,0,0])hole_w_end(4, 1.4, "round", M2);
}

module endstop_nut(hole_len){
    translate([-4.75,0,-2])hole_w_end(hole_len, 1.4, "hex", M2, flip=true);
    // Front screw hole for endstop
    translate([4.75,0,-2])hole_w_end(hole_len, 1.4, "hex", M2, flip=true);
}


difference(){
    translate([-4.75 - extra_width/2, 0, -4]) 
        cube([4.75*2 + extra_width , endstop_offset, 8]);
    translate([-4.75 - extra_width/2 , 0, -5]) 
            cube([4.75*2 + extra_width , 12 , 5]);
    
    hull(){
        translate([-4.75 - extra_width/2, endstop_offset /2 + 6, -1]) 
            cube([4.75*2 + extra_width , endstop_offset, 3]);
        translate([-4.75 - extra_width/2, 2, 4]) 
            cube([4.75*2 + extra_width , endstop_offset, 0.5]);
    }
    
    translate([0, 3, 0])
        endstop_mount();
    translate([0, endstop_offset - 3, -2])
        endstop_nut(5);
}
