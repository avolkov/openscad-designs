/*
 * A library to make capture holes in material for M3 & M5 hardware and some
 * common mounting patterns.
 * Copyright 2021 Alex Volkov <alex@flamy.ca>
 *
 * Project URL
 * https://github.com/avolkov/openscad-designs
 *
 * License: Attribution-ShareAlike 4.0 International (CC BY-SA)
 * https://creativecommons.org/licenses/by-sa/4.0/
 *
 * Version 0.2 2021-05-26 Refactoring variables into M_DIM list
 * Version 0.1 2021-04-05 Initial publication
 */

 // Common mounting patterns
ear_thick=8;
stacked_len = ear_thick*3;
screw_mount_space = 20;
screw_mount_offset =7;
total_len = stacked_len + screw_mount_space*2;
mounting_diff = 8;


ALU_PROFILE_H = 6.5;

// Dimensional info for metric capscrew hardware
//             [0,      1,            2,     3,          4,     5        ]
// List values [bolt_d, bolt_head_d, bolt_h, nut_trap_d, nut_h, locknut_h]
M_DIM = [
    [], // spacing
    [], // M1
    [], // M2
    [3.2, 5.6, 3.2, 6.7, 2.4, 3], // M3
    [4.1, 7.1, 4.05, 9.0, 3.9, 4], // M4
    [5.2, 8.6, 4.90, 9.7, 4, 5]  // M5
];


function get_trap_d(head_type, bolt) =(head_type == "round") ? M_DIM[bolt][1]
    : (head_type == "hex") ? M_DIM[bolt][3] : M_DIM[bolt[0]];

module m_recess(length, end_type, bolt_d) {
    /*
    Create nut or bolt capture hole

    :height: length of a mounting hole, including end-mounting hardware
    :end_type: type of the head hole: 'none', 'hex', 'round
    :bolt_d: bolt diameter, i.e. 3, 5 mm
    */
    make_recess(length, end_type, M_DIM[bolt_d][1]);

}

module make_recess(height, end_type, head_d){
    /*
    Make recess to capture
    */
    outer_chamfer = 1.2;
    local_fn = 60;
    rotate([0, 0,90]){
        if (end_type == "hex"){
            cylinder(h=height, d=head_d, $fn=6);
        } else if (end_type == "round"){
            cylinder(h=height/2, d=head_d + outer_chamfer, $fn=local_fn);
            translate([0,0, height/2])
                cylinder(
                    h=height/2 + 0.1,
                    d1=head_d + outer_chamfer,
                    d2=head_d, $fn=local_fn);
        }
    }
}



module hole_w_end(hole_len, trap_height, type, bolt_d, flip=false){
    /*
    Make a hole with an end for bolt or a nut.
    This is a more generic functions replacing m5_ hole-making functions.

    :bolt_d: bolt diameter, i.e. 3, 5 mm
    :type: type of the head hole: 'none', 'hex', 'round'
    */
    if (type != "none"){
        cylinder(h=hole_len-trap_height, d=M_DIM[bolt_d][0], $fn=20);
        if (flip){
            make_recess(trap_height, type, get_trap_d(type, bolt_d));
            translate([0,0,trap_height])
                cylinder(h=hole_len-trap_height, d=M_DIM[bolt_d][0], $fn=20);

        } else {
                translate([0,0, hole_len])
                    rotate([0,180,0])
                        make_recess(trap_height, type, get_trap_d(type, bolt_d));
        }
    } else {
        cylinder(h=hole_len, d=bolt_d);
    }
}

module bolt_nut(hole_len, bolt_d, flip=false){
    /*
    Create a model for a hole with bolt end on one end and nut hole on the other end.
    Note, this functions doesn't subtract the model it only makes the model

    :hole_len: total length of the hole
    :bolt_d: diameter of a blot
    :flip: flip the side with bolt recess
    */
    // currently only implemented for 3mm
    if (flip){
        hole_w_end(hole_len, M_DIM[bolt_d][4], "hex", M_DIM[bolt_d][0]);
        translate([0,0, hole_len]){
            rotate([180, 0, 0]){
                hole_w_end(hole_len, M_DIM[bolt_d][2], "round", M_DIM[bolt_d][0]);
            }
        }
    } else {
        hole_w_end(hole_len, M_DIM[bolt_d][2], "round", M_DIM[bolt_d][0]);
        translate([0,0, hole_len]){
            rotate([180, 0, 0]){
                hole_w_end(hole_len, M_DIM[bolt_d][4], "hex", M_DIM[bolt_d][0]);
            }
        }
    }
}






//Functions specific to M5 size,
// TODO rewrite as hole_w_end m_recess
module m5_recess(height, end_type) {
    // nut/bolt capture hole
    make_recess(height, end_type, M_DIM[5][0]);
}



module m5_hole_w_end(hole_len, trap_height, type){
    //Given hole lenght and trap height create a nut trap hole
    hole_w_end(hole_len, trap_height, type, 5);
}
module m5_hole_w_ends(hole_len, nut_extra=0){
    m5_hole_w_end(hole_len, M_DIM[5][2], "round");
    rotate([0, 180, 0])
        translate([0, 0, - hole_len])
            m5_hole_w_end(hole_len,M_DIM[5][4] + nut_extra, "hex");
}

module m3_hole_w_ends(hole_len, nut_extra=0){
    hole_w_end(hole_len, m3_nut_thick, "round", m3_bolt_thick);
    hole_w_end(hole_len, m3_nut_thick, "hex", m3_bolt_thick, flip=true);
}

module set_mounting_hole(x_offset, y_offset, thickness, nut_height, end_type){
    /*
    Make a hole in an existing material
    end_type: one of hex, round, none
    */
    translate([x_offset, y_offset, 0]){
        m5_hole_w_end(thickness, nut_height, end_type);
    }
}


module m5_thread(height){
    // TODO: Rewrite this with actual threads
    cylinder(h=height, d=M_DIM[5][0], center=true, $fn=16);
}

module m3_thread(height){
    // TODO: Rewrite this with actual threads
    cylinder(h=height, d=M_DIM[3][0], center=true, $fn=16);
}

module m3_square_nut(depth, height){
    translate([0,0,1])
        cylinder(h=height, d=M_DIM[3][0], center=true, $fn=16);

    make_recess(M_DIM[3][4], "hex", M_DIM[3][0]);
    translate([0,0,-1])
        cylinder(h=depth, d=M_DIM[3][0], center=true, $fn=16);
}



//Mounting Patterns
module mounting_holes_2(fastener_len, nut_height, end_type){
    /* Two-hole mounting pattern for M5 bolts*/
    width_offsetn = 16;
    set_mounting_hole(
        screw_mount_offset,
        width_offset + mounting_diff,
        fastener_len,
        nut_height,
        end_type);

    set_mounting_hole(
        total_len - screw_mount_offset,
        width_offset + mounting_diff,
        fastener_len,
        nut_height,
        end_type);


 }

module mounting_holes(fastener_len, nut_height, end_type){
    /*Four-hole mounting pattern for M5 bolts*/
    width_offset = 16;
    set_mounting_hole(
        screw_mount_offset,
        width_offset + mounting_diff,
        fastener_len,
        nut_height,
        end_type);

    set_mounting_hole(
        screw_mount_offset,
        width_offset - mounting_diff,
        fastener_len,
        nut_height,
        end_type);

    // Side towards the end
    set_mounting_hole(
        total_len - screw_mount_offset,
        width_offset + mounting_diff,
        fastener_len,
        nut_height,
        end_type);

    set_mounting_hole(
        total_len - screw_mount_offset,
        width_offset - mounting_diff,
        fastener_len,
        nut_height,
        end_type);
}


// Aluminium profile connectors

module alu_connector(face_len, thickness){

    face_w = 20;
    flat_gap = 5;
    alu_2020_base = 8.2;

    union(){
        cube([face_w, face_len, thickness]);
        translate([face_w/2 + alu_2020_base/2, face_len, thickness])
            rotate([0,270,90])
                linear_extrude(face_len)
                    polygon(points=[[0,0], [2,1.5], [2,ALU_PROFILE_H], [0,alu_2020_base]]);
    }
}