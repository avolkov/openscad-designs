include <NopSCADlib/utils/core/core.scad>;
include <NopSCADlib/vitamins/screws.scad>;

include <spool_holder.scad>;

ARM_FRICTION_OFFSET = 0.8;

preview = true;

difference(){
    union(){
        arm(
                dual_spool=false,
                display="all",
                spool_bolt_size=M8,
                spool_bolt_len=73);

        translate([0, -ARM_BASE_W - 8, 0])arm_mount();
        translate([0, -ARM_BASE_W - 22, 0]) jaw();
    }

   translate([10,-10,2]) {
       bolt_nut(CONN_BOLT_LEN + 2, BOLT_SIZE);
       
   }
   translate([10,-10, -5]) make_recess(10, "hex", M_DIM[M8][3]);
   
}
 
if (preview){
    translate([10,-10,40]) screw(M8_cap_screw, 40);
    translate([10,-10,1.8])rotate([0,0,30] )nut(M8_nut, nyloc=false);
}