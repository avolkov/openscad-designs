include <common.scad>;

$fn = 20;


//Diameter of a  4-20 hole
quarter_20_inner_d = 8;
quarter_20_outer_d = 14;

screw_mount_thickness = 12;

module mounting_base(quarter_20_height, quarter_20_space){
    cube_height = quarter_20_height + quarter_20_space;
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
        difference(){
            cube([total_len, ear_outer, cube_height]);
            // move to the middle
            union() {
                translate([total_len/2, ear_outer/2, 0]){
                    cylinder(h=quarter_20_space, d=quarter_20_inner_d, $fn=20);
                    translate([0,0, quarter_20_space])
                        cylinder(h=quarter_20_height, d=quarter_20_outer_d, $fn=6);
                }
                
            }
        }
    
}

// spacers
//Thickness 3mm base

quarter_20_height = 6;
/*
Total thickness: 

6mm height of 1/4-20 nut
3mm base
*/

difference(){
    
    //Regular config
    quarter_20_space = 3;
    mounting_base(quarter_20_height, quarter_20_space);
    mounting_holes(quarter_20_height + quarter_20_space, 0, "none");
    
    
    /* //Tripod config */
    /*
    quarter_20_space = 1;
    mounting_base(quarter_20_height, quarter_20_space);
    mounting_holes(quarter_20_height + quarter_20_space, 5, "hex", flip=true);
    */
}
