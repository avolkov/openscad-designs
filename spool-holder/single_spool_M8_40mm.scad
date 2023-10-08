include <spool_holder.scad>;
use <spool_holder.scad>;
include <../libs/hardware-recess.scad>;

SPOOL_MOUNT_HW = M8;
SPOOL_MOUNT_HW_LEN = 47;

BOLT_SIZE=M8;

difference(){
    union(){
            // jaw model (lower part)
            translate([0, -ARM_BASE_W - 8, 0]) arm_mount();
            translate([0, -ARM_BASE_W - 22, 0]) jaw();
            // arm model
           arm(
                dual_spool=true,
                display="arm",
                spool_bolt_size=SPOOL_MOUNT_HW,
                spool_bolt_len=SPOOL_MOUNT_HW_LEN);
            // left spool holder
            arm(
                dual_spool=false,
                display="single_spool",
                spool_bolt_size=SPOOL_MOUNT_HW,
                spool_bolt_len=SPOOL_MOUNT_HW_LEN);
        }
    translate([10,-10,2]) bolt_nut(CONN_BOLT_LEN + 2, BOLT_SIZE);
    translate([10,-10, -5]) make_recess(10, "hex", $M_DIM[M8][3]);
}