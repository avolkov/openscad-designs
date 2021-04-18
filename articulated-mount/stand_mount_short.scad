include <common.scad>

// mount for the side of the stand

// Vertical dimensions
stand_mount_h=28;
top_segment=5;
mid_cutout=10;
bottom_segment=13;

// distance under the thread of the stand
under_thread_dist = 4;

//horizontal dimensions
cutout_width = 12;
inner_width = 17;
outer_width = 22;

module stand_hole(h, outer_d, inner_d, attach_offset){
    difference(){
        cyl_w_m5_side_attach(h, outer_d, attach_offset);
        cylinder(h=h, d=inner_d);
        
    }
}

module stand_base(base_thick, outer_d){
        difference(){
            cube([total_len, ear_outer, base_thick]);
            translate([total_len/2, ear_outer/2, 0])
                cylinder(h=base_thick, d=outer_d);
        }
}

module cyl_w_base(base_thick, outer_d, inner_d, cyl_h, attach_offset){
    //Create base and cylinder mount
    // base_thick -- base thickness
    // outer_d -- outer diameter shell
    // inner_d -- inner diameter of a light mount
    // attach_offset - z offset
    stand_base(base_thick, outer_d);
    translate([total_len/2, ear_outer/2, 0])
        stand_hole(cyl_h, outer_d, inner_d, attach_offset);
    
    }

module cyl_w_m5_side_attach(cyl_h, outer_d, attach_offset){
    // Given mounting height, outer diameter of the sylinder and z-height attach offset
    // Build an attachement to fastening cylinder to the stand using m5 bolt and semi-captured nut
    flat_w = 12;
    extra_thick= 8;
    difference(){
        union() {
            cylinder(h=cyl_h, d=outer_d);
            if (attach_offset > 0){
                translate([-flat_w/2, inner_width/2, 0])
                        cube([flat_w, inner_width/2, attach_offset]);
            }
            translate([-flat_w/2, inner_width, attach_offset]){
                rotate([90, 0, 0])
                        cube([flat_w, flat_w, m5_nut_thick+extra_thick]);
                        
            }
        }
        translate([0, flat_w+extra_thick-1, nut_trap_d/2 + attach_offset])
            rotate([90, 0, 0])
                // nut needs extra room inside the cylinder (m5_nut_thick+3)
                m5_hole_w_end(m5_nut_thick+extra_thick, m5_nut_thick+3, "hex");
    }
}

//side_m5_attach();


base_thick = 5;
difference(){
    cyl_w_base(base_thick, outer_width, inner_width, stand_mount_h, top_segment-m5_nut_thick/2);
    mounting_holes(base_thick, m5_nut_thick-3, "hex");
}

//stand_hole(stand_mount_h, outer_width, inner_width, top_segment);



