include <spool_holder.scad>;

//Minimum bolt len -> 47mm

exploded_view = true;


difference(){
    union(){
        if (exploded_view){
            translate([0, -ARM_BASE_W - 8, 0]) arm_mount();
            translate([0, -ARM_BASE_W - 22, 0]) jaw();
            translate([0, -4, 0]) arm(dual_spool=true, display="all", spool_bolt_len=47);
        } else {
            //translate([0,ARM_BASE_W,0]) jaw(display_jaw=true);
            //translate([0,ARM_BASE_W,0]) jaw(display_base=true);
            arm(
                dual_spool=true,
                display="arm",
                spool_bolt_size=M5,
                spool_bolt_len=73);
        }

    }
    //using joining hardware
    for (i=[10, 30]){
        translate([10, 0, i])
            rotate([270, 30, 0])
                bolt_nut(CONN_BOLT_LEN , BOLT_SIZE, flip=false);
    }
}