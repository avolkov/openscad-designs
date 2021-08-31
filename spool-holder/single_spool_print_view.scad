include <spool_holder.scad>;
use <spool_holder.scad>;


SPOOL_MOUNT_HW = M5;
SPOOL_MOUNT_HW_LEN = 47;

BOLT_SIZE=M8;

difference(){
    union(){
            // jaw model (lower part)
            *translate([0,ARM_BASE_W,0]) base(display_jaw=true);
            // base model(upper part)
            *translate([0,ARM_BASE_W,0]) base(display_base=true);
            // arm model
            arm(
                dual_spool=false,
                display="arm",
                spool_bolt_size=SPOOL_MOUNT_HW,
                spool_bolt_len=SPOOL_MOUNT_HW_LEN);
            // spool model
            *arm(
                dual_spool=false,
                display="single_spool",
                spool_bolt_size=SPOOL_MOUNT_HW,
                spool_bolt_len=SPOOL_MOUNT_HW_LEN);
        }
    //using joining hardware
    for (i=[10, 30]){
        translate([10, 0, i])
            rotate([270, 30, 0])
                bolt_nut(CONN_BOLT_LEN , BOLT_SIZE, flip=false);
    }
}