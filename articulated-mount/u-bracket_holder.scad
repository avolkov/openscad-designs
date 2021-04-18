include <common.scad>;

$fn = 20;
//This whole thing should be 33 mm tall

//Diameter of a  4-20 hole
d_4_20 = 6;

cube_height = 32;
screw_mount_thickness = 12;

module mounting_base(base_thick, ){
    cube([total_len, ear_outer, base_thick]);
    //farther side column
    translate([total_len, 0, 0])
    rotate([0, 270, 0])
        cube([cube_height, ear_outer, screw_mount_thickness]);
    // closer side column
    translate([screw_mount_thickness, 0, 0])
    rotate([0, 270, 0])
        cube([cube_height, ear_outer, screw_mount_thickness]);
    //top panel with the hole 
    // TODO: move this into a separate func
    translate([0,0,cube_height-base_thick])
        difference(){
            cube([total_len, ear_outer, base_thick]);
            // move to the middle
            translate([total_len/2, ear_outer/2])
                cylinder(h=base_thick, d=d_4_20, $fn=20);
        }
    
}
base_thick = 3;

difference(){
    mounting_base(base_thick);
    mounting_holes(50, 0, "none");
}