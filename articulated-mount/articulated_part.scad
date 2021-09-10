//include  <common.scad>;

$layer_height = 0.25;


include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/washers.scad>


use <NopSCADlib/utils/fillet.scad>
use <NopSCADlib/utils/horiholes.scad>


include <led_tube_mount.scad>;
$fn=32;

show_disc = true;
use_horihole = true;
thickness = 6;
length = 60;
height = 20;
overlap_x = 15;
overlap_y = 10;
//DERIVED GLOBAL VALUES


m5_mount_recess = 2;

module make_ear(ear_len, ear_thick){
    difference() {
        union(){
            translate([0,ear_len,0])
                cylinder(h=ear_thick, d=ear_outer);
            rotate([0, 0,180])
                translate([-ear_outer/2, -ear_len,0])
                    cube([ear_outer, ear_outer-10 + ear_len, ear_thick]);
        }
        translate([0,ear_len,0])
            cylinder(h=ear_thick, d=ear_inner);
    }
}
module ear_with_nut_trap(ear_len, ear_thick){
    //Use 5mm nut trapd
    
    difference(){
        make_ear(ear_len, ear_thick);
        translate([0,ear_len, - m5_mount_recess])
            m5_recess(ear_thick-m5_nut_thick, "hex");
    }
}

module ear_with_round_trap(ear_len, ear_thick){
        difference(){
        make_ear(ear_len, ear_thick);
        translate([0,ear_len, ear_thick - m5_mount_recess])
            m5_recess(ear_thick - m5_nut_thick, "round");
    }
}

module make_ears(ear_len, ear_thick){
    translate([0,0,16]){
        rotate([90, 0, 0]){
            //ear_with_round_trap(ear_len, ear_thick);
            make_ear(ear_len, ear_thick);
            translate([0, 0, -ear_thick - mounting_gap ])
                ear_with_nut_trap(ear_len, ear_thick);
        }
    }
}




module base_and_ears(base_thick, ear_extra_len, nut_height, ear_thick=8){
    /*
    base_tick -- given base thickness
    ear_extra_len -- ear length(reach) 
    nut_height -- M5 nut height (for regular, locknut, cap)
    ear_thickness -- ear thickness 8mm default
    build base with ears for mount
    
    sample params base_thick=15, ear_extra_len 5, nut_height=5
    */
   
    // Base and ears
    union() {
    translate([0, ear_thick, base_thick])
        make_ears(ear_extra_len, ear_thick);
    translate([ ear_outer/2, -screw_mount_space, 0])
        rotate([0, 0, 90]){
            difference(){
                cube([total_len, ear_outer, base_thick]);
                mounting_holes(base_thick, nut_height, end_type="round");
            }
            
        }
    }
}

module single_ear(base_thick, ear_extra_len, nut_height, ear_thick){
    translate([0,ear_thick/2,ear_extra_len+ ear_outer/2+ear_reach*2])
        rotate([90, 0, 0])
            make_ear(ear_extra_len, ear_thick);

}
module make_base_m3(width, depth, height){
    translate([-width/2, -depth/2, -height]){
        difference(){
            cube([width, depth, height]);
            dummy_side_mounts(width, depth, 5, "round", center_hole=false, side_holes=false);
        }
    }
}



module make_base_m5(width, depth, height, base_thick){
    //echo(total_len);
    translate([ -total_len/2, -ear_outer/2, 0])
        rotate([0, 0, 0]){
            difference(){
                cube([total_len, ear_outer, base_thick]);
                    set_mounting_hole(6, ear_outer/2, 10, 5, end_type="hex");
                    set_mounting_hole(total_len - 6, ear_outer/2, 10, 5, end_type="hex");
                        
            }
            
        }
    }

// Code related to LED T8 tube mount
module make_base_led_mid_m5(width, depth, height, display=false){
    translate([-width/2, -depth/2, -height]){
        if (display){
            translate([width/2,10 , 5]){
                screw(M5_cap_screw, 30);
            }
            translate([width/2, depth-10 , 5]){
                screw(M5_cap_screw, 30);
                washer(M5_washer);
            }
        }
        difference(){
            cube([width, depth, height]);
            translate([width/2,10 , 0])
                cylinder(d=5.2, h=height);
            translate([width/2, depth-10, 0])
                cylinder(d=5.2, h=height);
                //m5_hole_w_ends(end_height, nut_extra=5);
            
        }
    }
}

module m5_ear_correct_orientation(){
    single_ear(base_thickness, ear_reach, m3_nut_thick, 6);
    rotate([0,0,90])
        make_base_led_mid_m5(end_width, led_driver_h, 5);
}


module m8_rods_led(base_thick, base_len){
    make_base_led_mid_m5(end_width, led_driver_h, 5);
    translate([-ear_outer/2, -total_len/2, 0]){
        difference(){
            cube([ear_outer, total_len, base_thick]);
            translate([40, 0, 0])
                dual_m8_rod_cutout(base_thick);
        }
    }
}


module m8_rods_led_short(base_thick){
    make_base_led_mid_m5(total_len/2, led_driver_h, 5);
    translate([-ear_outer/2, -(total_len - 6)/2, 0]){
        translate([ear_outer, total_len - 6, 0,]) rotate([0, 270, 0]) fillet(3, ear_outer);
        translate([0, 0, 0,]) rotate([90, 270, 90]) fillet(3, ear_outer);
        difference(){
            cube([ear_outer, total_len - 6, base_thick]);
            
            translate([40, 0, 0])
                dual_m8_rod_cutout(base_thick);
        }
    }
}
// code related to dual overhead rod mount

module m8_rod_mount_center(base_thick, ear_extra_len, nut_height, ear_thick=8){
    //mount m8 rod through an non-articulating mount
    
        translate([ ear_outer/2, -screw_mount_space, 0])
            difference(){
                rotate([0, 0, 90]){
                    difference(){
                        cube([total_len, ear_outer, base_thick]);
                        mounting_holes(base_thick, nut_height, end_type="round");
                        }
                    }
            translate([-50, (total_len/2), base_thick/2])
                rotate([0, 90, 0])
                    cylinder(d=8.2, h=50);
            }
        
}

module dual_m8_rod_cutout(base_thick){
    translate([-50, 15, base_thick/2])
        rotate([90, 0, 90])
            linear_extrude(50) horihole(4.1, 0.2, center=true);
    /*
     * total_len - 15 = 49
     * gap between rods is 49 - 15 = 34mm
     */
    translate([-50, total_len-15, base_thick/2])
        rotate([90, 0, 90])
            linear_extrude(50) horihole(4.1, 0.2, center=true);
            //cylinder(d=8.2, h=50);
}

module m8_rods_mount(base_thick, ear_extra_len, nut_height, ear_thick=8){
    //mount m8 rod through an non-articulating mount
    
    translate([ ear_outer/2, -screw_mount_space, 0])
        difference(){
            rotate([0, 0, 90]){
                difference(){
                    cube([total_len, ear_outer, base_thick]);
                    mounting_holes(base_thick, nut_height, end_type="round");
                    }
                }
            dual_m8_rod_cutout(base_thick);
        }
}





base_thickness = 8;
ear_reach = 2;


//m5_ear_correct_orientation();
// Mounting gap for the new single-ear setup (old 6.9mm)
mounting_gap = 8;

// Default setup
//base_and_ears(base_thickness, ear_reach, m5_nut_thick);

// M8 mount

*m8_rods_mount(8*2, ear_reach, m5_nut_thick);
*m8_rods_led(8*2);
m8_rods_led_short(8*2);
//make_base_m3(end_width, led_driver_h, 5);

    
// single mount
/*
single_ear(base_thickness, ear_reach, m5_nut_thick, 6);
translate([0,0,-7])
make_base_m5(base_thickness, ear_reach, m5_nut_thick, 8);
*/
//make_base_m5(base_thickness, ear_reach, m5_nut_thick, 8);
// led mounts
*m5_ear_correct_orientation();