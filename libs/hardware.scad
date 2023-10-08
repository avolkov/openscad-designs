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
 * Version 0.6 2022-12-19 Fixing offset bug in bolt_nut and hole_w_end
 * Version 0.5 2022-11-14 Add more generic hole_w_ends module
 * Version 0.4 2022-10-06 Make M_DIM into overridable variable
 * Version 0.3 2021-08-14 Added gradation when making hole_w_end to reduce overhangs
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

// List defined hardware
M2 = 2;
M3 = 3;
M4 = 4;
M5 = 5;
M8 = 8;

// Dimensional info for metric capscrew hardware
//             [0,      1,            2,     3,          4,     5        ]
// List values [bolt_d, bolt_head_d, bolt_h, nut_trap_d, nut_h, locknut_h]
$M_DIM = [
    [], // spacing
    [], // M1
    [1.95, 3.8, 2, 4.3, 1.5, 1.5*2], // M2 don't know actual locknut height
    //[3.2, 5.6, 3.2, 6.6, 2.4, 3], // M3
    [3.2, 5.6, 3.2, 6.2, 2.4, 3], // M3
    [4.1, 7.1, 4.05, 9.0, 3.9, 4], // M4
    [5.25, 8.6, 4.90, 9.05, 4, 5],  // M5
    [], // M6
    [], // M7
    [8.1, 13.2, 7.98, 15, 6.3, 8] // M8
];


function get_trap_d(head_type, bolt) =(head_type == "round") ? $M_DIM[bolt][1]
    : (head_type == "hex") ? $M_DIM[bolt][3] : $M_DIM[bolt[0]];

module m_recess(length, end_type, bolt_d) {
    /*
    Create nut or bolt capture hole

    :height: length of a mounting hole, including end-mounting hardware
    :end_type: type of the head hole: 'none', 'hex', 'round
    :bolt_d: bolt diameter, i.e. 3, 5 mm
    */
    make_recess(length, end_type, $M_DIM[bolt_d][1]);

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

module grade_end(hole_len, trap_height, type, bolt_d){
    /*
     * Grade between hex hole and bolt hole when bigger hole is on the bottom
     * This reduces overhangs
     */

    hull(){
        make_recess(trap_height - 0.4, type, get_trap_d(type, bolt_d));
        translate([0,0,trap_height+0.5])
            cylinder(h=0.1, d=$M_DIM[bolt_d][0], $fn=20);
    }
    translate([0,0,trap_height+0.5])
        cylinder(h=hole_len-trap_height, d=$M_DIM[bolt_d][0], $fn=20);
}

// There's a bug in this function when it comes to calculation trap len /bolt len
module hole_w_end(hole_len, trap_height, type, m_thread_size, flip=false, grade=false){
    /*
    Make a hole with an end for bolt or a nut.
    This is a more generic function replacing m5_ hole-making functions.

    :m_thread_size: bolt thread diameter, i.e. 3, 5 mm
    :type: type of the head hole: 'none', 'hex', 'round'
    
    Grade for non-filip bot/nut ends not implemented yet
    */
    if (type != "none"){
        cylinder(h=hole_len, d=$M_DIM[m_thread_size][0], $fn=20);
        if (flip){
            if(grade){
                //Round up ceiling where 
                grade_end(hole_len, trap_height, type, m_thread_size);
            } else {
                // TODO: account for trap height here -- extra bolt_h for bolt
                make_recess(trap_height, type, get_trap_d(type, m_thread_size));
                if (type == "round"){
                    translate([0,0,trap_height])
                        cylinder(h=hole_len-trap_height, d=$M_DIM[m_thread_size][0], $fn=20);
                } else {
                    translate([0,0,trap_height])
                        cylinder(h=hole_len-trap_height, d=$M_DIM[m_thread_size][0], $fn=20);
                }
            }
        } else {
            
            if (type == "round"){
                translate([0,0, hole_len+trap_height])
                    rotate([0,180,0])
                    // TODO: account for trap height here -- extra bolt_h for bolt
                        make_recess(trap_height, type, get_trap_d(type, m_thread_size));
            } else {
                translate([0,0, hole_len])
                    rotate([0,180,0])
                    // TODO: account for trap height here -- extra bolt_h for bolt
                        make_recess(trap_height, type, get_trap_d(type, m_thread_size));
            }
        }
    } else {
        cylinder(h=hole_len, d=m_thread_size);
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
       hole_w_end(hole_len+ $M_DIM[bolt_d][4], $M_DIM[bolt_d][4], "hex", $M_DIM[bolt_d][0]);
       hole_w_end(hole_len, $M_DIM[bolt_d][2], "round", $M_DIM[bolt_d][0], flip=true);
    } else {
        hole_w_end(hole_len, $M_DIM[bolt_d][2], "round", $M_DIM[bolt_d][0]);
        hole_w_end(hole_len, $M_DIM[bolt_d][4], "hex", $M_DIM[bolt_d][0], flip=true);
    }
}

//Functions specific to M5 size,
// TODO rewrite as hole_w_end m_recess
module m5_recess(height, end_type) {
    // nut/bolt capture hole
    make_recess(height, end_type, $M_DIM[5][0]);
}

module m5_hole_w_end(hole_len, trap_height, type){
    //Given hole lenght and trap height create a nut trap hole
    hole_w_end(hole_len, trap_height, type, 5);
}

module hole_w_ends(size, hole_len, extra=0, equal=false){
    if(equal){
        hole_w_end(hole_len, $M_DIM[size][2] + extra/2, "round", size);
    } else {
        hole_w_end(hole_len, $M_DIM[size][2] + extra/2, "round", size);
    }
    rotate([0, 180, 0]){
        translate([0, 0, - hole_len]) {
            if (equal){
                hole_w_end(hole_len,$M_DIM[size][4] + extra/2, "hex", size);
            } else {
                hole_w_end(hole_len,$M_DIM[size][4] + extra, "hex", size);
            }
        }
    }

}

module m5_hole_w_ends(hole_len, extra=0, equal=false){
    if(equal){
        m5_hole_w_end(hole_len, $M_DIM[5][2] + extra/2, "round");
    } else {
        m5_hole_w_end(hole_len, $M_DIM[5][2], "round");
    }
    rotate([0, 180, 0]){
        translate([0, 0, - hole_len]) {
            if (equal){
                m5_hole_w_end(hole_len,$M_DIM[5][4] + extra/2, "hex");
            } else {
                m5_hole_w_end(hole_len,$M_DIM[5][4] + extra, "hex");
            }
        }
    }
}

module m5_hole_w_ends(hole_len, nut_extra=0){
    m5_hole_w_end(hole_len, $M_DIM[5][2], "round");
    rotate([0, 180, 0])
        translate([0, 0, - hole_len])
            m5_hole_w_end(hole_len,$M_DIM[5][4] + nut_extra, "hex");
}


module m3_hole_w_ends(hole_len, nut_extra=0){
    hole_w_end(hole_len, $M_DIM[M3][4], "round", $M_DIM[M3][2]);
    if (nut_extra > 0){
        hole_w_end(hole_len, nut_extra, "hex", M3, flip=true);
    } else {
        hole_w_end(hole_len, $M_DIM[M3][4], "hex", M3, flip=true);
    }
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
    cylinder(h=height, d=$M_DIM[5][0], center=true, $fn=16);
}

module m3_thread(height){
    // TODO: Rewrite this with actual threads
    cylinder(h=height, d=$M_DIM[3][0], center=true, $fn=16);
}

module m3_square_nut(depth, height){
    translate([0,0,1])
        cylinder(h=height, d=$M_DIM[3][0], center=true, $fn=16);

    make_recess($M_DIM[3][4], "hex", $M_DIM[3][0]);
    translate([0,0,-1])
        cylinder(h=depth, d=$M_DIM[3][0], center=true, $fn=16);
}



//Mounting Patterns
module mounting_holes_2(fastener_len, nut_height, end_type){
    /* Two-hole mounting pattern for M5 bolts*/
    width_offset = 16;
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

module alu_profile(){
    /* Make aluminium profile to be inserted into 2020 slot
     * Taken from BU21-VS240 bear upgrade technical drawing
     * Bear Frame 2.1 Upgrade Aluminium Extrusion rev 1.0
     * Then taking out caliper and doing some math
     * 6.25 mm is also distance from the bottom of the slot to the top.abs
     * Which is the height of equalateral triangle. distance at the surfac
     * is 7.22mm
     */
    gap_thick = 1.8;
    gap_wide = 7.5;
    gap_narrow = 6.25;

    gap_offset = (gap_wide  - gap_narrow)/2;
    polygon(points=[
            [0,0],
            [gap_thick, gap_offset],
            [gap_thick, gap_narrow + gap_offset],
            [0, gap_wide]
        ]
    );
}


module alu_connector(face_len, thickness, flip=false){

    face_w = 20;
    flat_gap = 5;
    //TODO: Base can still be slightly increased 2020-06-24
    alu_2020_base = 7.22;
    *cube([face_w, face_len, thickness]);
    if (flip) {
        translate([face_w/2 + alu_2020_base/2, 0, 0])
            rotate([0,90,90])
                linear_extrude(face_len)
                    alu_profile();
    } else {
        translate([face_w/2 + alu_2020_base/2, face_len, thickness])
            rotate([0,270,90])
                linear_extrude(face_len)
                    alu_profile();
    }
}
outer_w = 47.8;
outer_h = 27.8;
module _iec_body_cut(thickness, center=false){
    
    if (!center){
        polygon(points=[
                [0,0], [41.4, 0],
                [outer_w, 6.15], [outer_w, 6.15 + 15.4],
                [41.4, outer_h], [0, outer_h]
        ]);
    } else {
        translate([-47.8/2, -27.8/2, 0])
            polygon(points=[
                    [0,0], [41.4, 0],
                    [outer_w, 6.15], [outer_w, 6.15 + 15.4],
                    [41.4, outer_h], [0, outer_h]
            ]);
    }
}
module iec320_simple(obj_thickness, lip=0.8){
    linear_extrude(obj_thickness - lip) square([outer_w, 34], center=true);
    linear_extrude(obj_thickness) square([outer_w, outer_h], center=true);
}


module iec320_keyed(obj_thickness, lip=1){
    linear_extrude(obj_thickness - lip) square([47.8, 34], center=true);
        linear_extrude(obj_thickness){
            _iec_body_cut(obj_thickness, center=true);
    }
}

module poly_outline(){
 polygon(points=[
            [0,0],
            [4, 5.5],
            [6.5, 5.5],
            [6.5, 23.5],
            [4, 23.5],
            [0, 29],
            [-1.2, 29],
            //[0, 24],
            //[-2, 24],
            [-1.2, 0]
            //[-0.5, 24],
            //[-0.5, 6],
            //[0, 6],
        ]);
}
module photoflex_connector(conn_len){
    linear_extrude(conn_len)
       poly_outline();
}