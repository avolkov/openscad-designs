include <spool_holder.scad>;

ARM_FRICTION_OFFSET = 0.8;


difference(){
    union(){
        translate([ARM_FRICTION_OFFSET,ARM_BASE_W,0]) base(display_base=true);
        translate([ARM_FRICTION_OFFSET,ARM_BASE_W,0]) base(display_jaw=true);
        
        arm(
            dual_spool=false,
            display="all",
            spool_bolt_size=M5,
            spool_bolt_len=73);
    }
    //using joining hardware
    for (i=[10, 30]){
        translate([10, 0, i])
            rotate([270, 30, 0])
                bolt_nut(CONN_BOLT_LEN , BOLT_SIZE, flip=false);
    }
}

 