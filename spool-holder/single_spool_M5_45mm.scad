include <spool_holder.scad>;
use <spool_holder.scad>;


SPOOL_MOUNT_HW = M5;
SPOOL_MOUNT_HW_LEN = 49;
CONN_BOLT_LEN = 49;

BOLT_SIZE=M5;

difference(){
    union(){
            // jaw model (lower part)
            translate([0, -ARM_BASE_W - 8, 0]) arm_mount();
            translate([0, -ARM_BASE_W - 22, 0]) jaw();
            // arm model
            arm(
                dual_spool=false,
                display="arm",
                spool_bolt_size=SPOOL_MOUNT_HW,
                spool_bolt_len=SPOOL_MOUNT_HW_LEN);
            // spool model
            arm(
                dual_spool=false,
                display="single_spool",
                spool_bolt_size=SPOOL_MOUNT_HW,
                spool_bolt_len=SPOOL_MOUNT_HW_LEN);
        translate([10,-10, -4]) bolt_nut(CONN_BOLT_LEN + 2, BOLT_SIZE);
    }
    translate([10,-10, -4]) bolt_nut(CONN_BOLT_LEN + 2, BOLT_SIZE);
   
}