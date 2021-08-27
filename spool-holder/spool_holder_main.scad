include <spool_holder.scad>;

difference(){
    union(){
        translate([0,ARM_BASE_W,0]) base();
        arm();
    }
    //using joining hardware
    for (i=[10, 30]){
        translate([10, -ARM_BASE_MEAT, i])
            rotate([270, 30, 0])
                bolt_nut(m8_bolt_len + 1, M8, flip=true);
    }
}

arm();