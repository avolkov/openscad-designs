//GLOBAL VALUES


ear_outer=32; // Outer diameter of each ear
ear_inner=5; // hole for each ear M5

mounting_gap = 6.9; // gap between two ears to mount the light



ear_thick=8;

stacked_len = ear_thick*3;
screw_mount_space = 20;
screw_mount_offset =7;
total_len = stacked_len + screw_mount_space*2;
mounting_diff = 8;

//M3 fastener values

m3_nut_trap_d = 6.7;
m3_nut_thick= 2.4;

m3_bolt_head_d = 5.6;
m3_bolt_thick = 3;

//M5 fastener values

m5_nut_thick = 4;
m5_locknut_thick = 5;
nut_trap_d = 9.7;
bolt_head_d = 8.6;



module bolt_nut(hole_len, bolt_d, flip=false){
    /*
        Create a model for a hole with bolt end on one end and nut hole on the other end.
    Note, this functions doesn't subtract the model it only makes the model
    */
    // currently only implemented for 3mm
    if (flip){
        hole_w_end(hole_len, m3_nut_thick, "hex", bolt_d);
        translate([0,0, hole_len]){
            rotate([180, 0, 0]){
                hole_w_end(hole_len, m3_bolt_thick, "round", bolt_d);
            }
        }
    } else {
        hole_w_end(hole_len, m3_bolt_thick, "round", bolt_d);
        translate([0,0, hole_len]){
            rotate([180, 0, 0]){
                hole_w_end(hole_len, m3_nut_thick, "hex", bolt_d);
            }
        }
    }
}

// More generic functions replacing m5_ hole-making functions
module hole_w_end(hole_len, trap_height, type, bolt_d, flip=false){
    /*
       bolt_d - bolt diameter, i.e. 3, 5 mm
        type -- type of the head hole: 'none', 'hex', 'round
    */
    if (type != "none"){
        cylinder(h=hole_len-trap_height, d=bolt_d, $fn=20);
        if (flip){
            m_recess(trap_height, type, bolt_d);
            translate([0,0,trap_height])
                cylinder(h=hole_len-trap_height, d=bolt_d, $fn=20);

        } else {
                translate([0,0, hole_len - trap_height])
                    m_recess(trap_height, type, bolt_d);
        }
    } else {
        cylinder(h=hole_len, d=bolt_d);
    }
}

module m_recess(height, end_type, bolt_d) {
    // nut/bolt capture hole
    /*
       bolt_d - bolt diameter, i.e. 3, 5 mm
        type -- type of the head hole: 'none', 'hex', 'round
    */
    if (bolt_d >= 3 && bolt_d <= 4){
        //M3
        make_recess(height, end_type, m3_nut_trap_d);
    } else if (bolt_d >= 5 && bolt_d <= 6){
        // M5
        make_recess(height, end_type, nut_trap_d);
    }

}

module make_recess(height, end_type, trap_d){
    rotate([0, 0,90]){
        if (end_type == "hex"){
            cylinder(h=height, d=trap_d, $fn=6);
        } else if (end_type == "round"){
            cylinder(h=height, d=trap_d, $fn=20);
        }
    }
}


//Functions specific to M5 size,
// TODO rewrite as hole_w_end m_recess
module m5_recess(height, end_type) {
    // nut/bolt capture hole
    rotate([0, 0,90]){
        if (end_type == "hex"){
            cylinder(h=height, d=nut_trap_d, $fn=6);
        } else if (end_type == "round"){
            cylinder(h=height, d=nut_trap_d, $fn=20);
        }
    }
}



module m5_hole_w_end(hole_len, trap_height, type){
    //Given hole lenght and trap height create a nut trap hole
    if (type != "none"){
        cylinder(h=hole_len-trap_height, d=5.3, $fn=20); // M5 hole;
            translate([0,0, hole_len-trap_height])
                m5_recess(trap_height, type);
    } else {
        cylinder(h=hole_len, d=5.3); // M5 hole;
    }
}
module m5_hole_w_ends(hole_len, nut_extra=0){
    m5_hole_w_end(hole_len, m5_nut_thick, "round");
    rotate([0, 180, 0])
        translate([0, 0, - hole_len])
            m5_hole_w_end(hole_len, m5_nut_thick + nut_extra, "hex");

}
module set_mounting_hole(x_offset, y_offset, thickness, nut_height, end_type, flip=false){
    /*
    end_type -- end types: - hex, round, none
    */
    translate([x_offset, y_offset, 0]){
        hole_w_end(thickness, nut_height, end_type, 5.3, flip);
    }
}



module mounting_holes_2(fastener_len, nut_height, end_type){
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

module mounting_holes(fastener_len, nut_height, end_type, flip=false){
    width_offset = 16;
    // Side towards the beginning
    set_mounting_hole(
        screw_mount_offset,
        width_offset + mounting_diff,
        fastener_len,
        nut_height,
        end_type,
        flip);

    set_mounting_hole(
        screw_mount_offset,
        width_offset - mounting_diff,
        fastener_len,
        nut_height,
        end_type,
        flip);

    // Side towards the end
    set_mounting_hole(
        total_len - screw_mount_offset,
        width_offset + mounting_diff,
        fastener_len,
        nut_height,
        end_type,
        flip);

    set_mounting_hole(
        total_len - screw_mount_offset,
        width_offset - mounting_diff,
        fastener_len,
        nut_height,
        end_type,
        flip);
}