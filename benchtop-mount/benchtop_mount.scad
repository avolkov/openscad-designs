include <../libs/hardware-recess.scad>;
include <Round-Anything/polyround.scad>
/*
 * ATX mount for Benchtop Power Board
 *
 * Project URL
 * https://github.com/avolkov/openscad-designs/benchtop-mount
 *
 * Copyright 2021 Alex Volkov <alex@flamy.ca>
 * License: Attribution-ShareAlike 4.0 International (CC BY-SA)
 * https://creativecommons.org/licenses/by-sa/4.0/
 *
 * Version 1.0 2021-04-05 Initial publication
 */


$fn=50;
cube_y = 77;
cube_x = 71;
thick_z = 4;
edge_offset = 3/2 + 1;

c_y = 84;
c_x = 49;

module mount_pegs(peg_h, peg_d){
    translate([edge_offset, edge_offset, 0])cylinder(d=peg_d, h=peg_h);
    translate([edge_offset, c_y - edge_offset, 0]) cylinder(d=peg_d, h=peg_h);
    translate([c_x -edge_offset, c_y - edge_offset, 0]) cylinder(d=peg_d, h=peg_h);
    translate([c_x -edge_offset, edge_offset, 0]) cylinder(d=peg_d, h=peg_h);
}

module top_plate() {
    peg_h = 7;
    peg_d = 8;
    cube([c_x, c_y, thick_z]);
    mount_pegs(peg_h, peg_d);
}

module base_plate(){
    hole_d=4;
    difference() {
        translate([-2, -2, 0]) cube([cube_x + 4,cube_y + 11, thick_z]);
        translate([edge_offset, edge_offset, 0]) cylinder(d=hole_d, h=10);
        translate([edge_offset, cube_y - edge_offset, 0]) cylinder(d=hole_d, h=10);
        translate([cube_x - edge_offset, cube_y - edge_offset, 0]) cylinder(d=hole_d, h=10);
        translate([cube_x - edge_offset, edge_offset, 0]) cylinder(d=hole_d, h=10);
    }
    
}

module mount_holes(hole_d, hole_h) {
    translate([edge_offset, edge_offset, 0])hole_w_end(hole_h, M_DIM[3][0], "hex", hole_d, flip=true);
    translate([edge_offset, c_y - edge_offset, 0]) hole_w_end(hole_h, M_DIM[3][0], "hex", hole_d, flip=true);
    translate([c_x -edge_offset, c_y - edge_offset, 0]) hole_w_end(hole_h, M_DIM[3][0], "hex", hole_d, flip=true);
    translate([c_x -edge_offset, edge_offset, 0]) hole_w_end(hole_h, M_DIM[3][0], "hex", hole_d, flip=true);
}


module atx_benchtop_mount(){
    difference() {
        union(){
            base_plate();
            translate([10, 0, 0]) top_plate(3.6, 7);
        }
        translate([10, 0, 0]) mount_holes(3.6, 7);
        translate([10, 10, 0])cube([50, 66, thick_z]);
    }
}

module benchtop_mount_base(){
     

        /*
         * x offset math: (71 + 4 - 49 - 3/2 -1)/2
         * y offset math: (95 - 84 - 3/2 - 1)/2
         */
        
        radiiPoints=[
            [0, 0 , 2],
            [cube_x + 4, 0, 2],
            [cube_x + 4, cube_y + 18, 2],
            [0, cube_y + 18, 2],
        ];
        difference(){
            union(){
                linear_extrude(5)polygon(polyRound(radiiPoints,30));
                translate([11.75, 4.25, 0]) mount_pegs(3.6, 7);
            }
            /*
             * x offset math: (71 + 4 - 49 - 3/2 -1)/2
             * y offset math: (95 - 84 - 3/2 - 1)/2
             */
            translate([11.75, 4.25, 0]) mount_holes(3.6, 7);
        }

}

//atx_benchtop_mount();

benchtop_mount_base();