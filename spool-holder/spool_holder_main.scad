include <NopSCADlib/utils/core/core.scad>;
include <NopSCADlib/vitamins/screws.scad>;

include <spool_holder.scad>;

ARM_FRICTION_OFFSET = 0.8;

preview = false;


module arm_body(){
        arm(
            dual_spool=true,
            //display="single_spool",
            display="left",
            //display="arm",
            spool_bolt_size=M5,
            spool_bolt_len=50);
        translate([0, -ARM_BASE_W - 8, 0]) arm_mount();
        
}

difference(){
    
   arm_body();
   *translate([0, -ARM_BASE_W - 22, 0]) jaw();
   translate([10,-10,2]) bolt_nut(CONN_BOLT_LEN + 2, BOLT_SIZE);
   translate([10,-10, -5]) make_recess(10, "hex", $M_DIM[M8][3]);
   
}
 
if (preview){
    translate([10,-10,40]) screw(M8_cap_screw, 40);
    translate([10,-10,1.8])rotate([0,0,30] )nut(M8_nut, nyloc=false);
    
    translate([56.5 ,15, 180]){
        rotate([270, 0, 0]) screw(M5_cap_screw, 45);
        translate([0, -37.5, 0])
            rotate([90, 30, 0]) nut(M5_nut, nyloc=true);
    }
}