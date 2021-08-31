include <spool_holder.scad>;

difference(){
    union(){
        translate([0,ARM_BASE_W,0]) base(display_jaw=true);
        *translate([0, -2, 0]) translate([0,ARM_BASE_W,0]) base(display_base=true);
        translate([0,-4, 0])arm(display="all");
        //spool();
    }
    //using joining hardware
    for (i=[10, 30]){
        translate([10, -3, i])
            rotate([270, 30, 0])
                bolt_nut(m8_bolt_len +2 , M8, flip=false);
    }
}

