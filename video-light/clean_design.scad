include <NopSCADlib/lib.scad>
include <NopSCADlib/utils/core/core.scad>

include <NopSCADlib/printed/handle.scad>


HEATSINK = 23;
HEATSINK_FAN = 45;
LIGHTING_SECTION = HEATSINK + HEATSINK_FAN;
FLOOR_H = 2;
FLOOR_EXTRA_LIGHTING_SECTION = 4.5;



BODY_LEN = 208;
BODY_W = 90;
INNER_Z = 81 + FLOOR_EXTRA_LIGHTING_SECTION;
COVER_THICK = 3;


screw = M3_cap_screw;
insert = screw_insert(screw);


module light_base(){
    rotate([90, 90, 0]){
        difference(){
            cylinder(h=3, r=60, center=true, $fn=64);
            //bowen_mount_holes();
            cube([60,50.8,3], true);
            translate([85, 0, 0])
                cube([80,140,10], true);
            translate([-78 - FLOOR_EXTRA_LIGHTING_SECTION, 0, 0])
                cube([80,140,10], true);
            }
    }
}

module handle(){
    translate([90/2,BODY_LEN/2 + 23, COVER_THICK])
        rotate([0, 0, 90])
            handle_fastened_assembly(COVER_THICK);
}

module handle_wo_inserts(){
    pose([225, 0, 150], [0, 0, 14])
    assembly("handle", ngb = true) {
        translate_z(handle_height())
            stl_colour(pp1_colour) vflip() handle_stl();
    }

}


module venting_mesh(seg_len, width=60, center=true ){
    //Mesh for vens in for cooling
    for (mesh_offset = [0:7:seg_len]){
        //echo(mesh_offset);
        translate([0,mesh_offset,0])
            cube([width, 5, 20]);
    }
}

module cover_mount_pylon(extrude_len, cut_type){
    gap_thick = 18;
    gap_wide = 24;
    gap_narrow = 14;
    gap_offset = (gap_wide  - gap_narrow)/2;

    difference(){
        linear_extrude(extrude_len)
            polygon(points=[
                        [0,0],
                        [gap_thick, gap_offset],
                        [gap_thick, gap_narrow + gap_offset],
                        [0, gap_wide]
                    ]
                );
        translate([gap_narrow/2 + 1, gap_wide/2, 0]){
            if (cut_type == "nut_trap"){
                nut_trap(M8_cap_screw, M8_nut, depth=65, supported=true);
            }
            if (cut_type == "hole"){
                linear_extrude(extrude_len) poly_circle(4);
            }
        }
        if (cut_type == "nut_trap"){
            cube([20, 26, 35]);
            translate([0,0,35]){
                rotate([0,45, 0])
                cube([20, 26, 25]);
            }
        }
    }
}

module set_pylons(extrude_len, cut_type, cut_support){
    translate([0 , 20 ,0])mirror([1, 0, 0]) cover_mount_pylon(extrude_len, cut_type);
    translate([90 , 20 ,0]) cover_mount_pylon(extrude_len, cut_type);

    translate([0 , 208 - 40 ,0])mirror([1, 0, 0]) cover_mount_pylon(extrude_len, cut_type);
    translate([90 , 208 - 40 ,0]) cover_mount_pylon(extrude_len, cut_type);
}

module cut_board_support(){
    translate([66, LIGHTING_SECTION, 12])
        rotate([270,270,0])
            rotate_extrude(angle=90)
                square([22, 22]);
}

module body_shell(){
    // TODO Add holes for mount (52mm distance) at 78mm and 130mm
    venting_mesh_w = 60;
    venting_mesh_l = 31;
    difference(){
        // body shell
        cube([90, BODY_LEN, INNER_Z]);

        // Mounting holes for articulated mount
        translate([90/2, 78 + 10, 0])
            linear_extrude(5) poly_circle(2.5);
        translate([90/2, 130 + 10, 0])
            linear_extrude(5) poly_circle(2.5);
        // front venting mesh
        translate([(90 - 60)/2, 4 ,0])
            venting_mesh(venting_mesh_l, width=venting_mesh_w, center=false);
        
        //heatsink
        translate([(90 - 69)/2, 0, FLOOR_H + FLOOR_EXTRA_LIGHTING_SECTION])
            cube([69, HEATSINK, 90]);
        translate([(90 - 86)/2, 2, FLOOR_H + 12])
            cube([86, HEATSINK- 6, 90]);
        //heatsink & fan
        translate([(90 - 82)/2, HEATSINK, FLOOR_H + FLOOR_EXTRA_LIGHTING_SECTION])
            cube([82.5, HEATSINK_FAN, 90]);
        // material saving & wiring for the floor
        translate([(90 - venting_mesh_w)/2, 4, FLOOR_H])
            cube([venting_mesh_w, venting_mesh_l , 90]);
        translate([(90 - 2)/2, venting_mesh_l , FLOOR_H])
                cube([2, 9, 90]);
        translate([(90 - venting_mesh_w)/2, 8 + venting_mesh_l + 1, FLOOR_H])
            cube([venting_mesh_w, HEATSINK_FAN, 90]);
        // cutout for wiring from 
       
        // connector spacing
        translate([(90 - 60)/2, LIGHTING_SECTION, FLOOR_H])
            cube([60, 22, 90]);
        // cut walls below to the thickness of power section
        translate([2, LIGHTING_SECTION, FLOOR_H])
            cube([86, 22, 10]);
        // use rotate extrude below to save filament
        cut_board_support();
        translate([90, 0, 0])
            mirror([1,0,0]) cut_board_support();
        //slot in prototyping board here
        translate([(90 - 70)/2, LIGHTING_SECTION + 10, FLOOR_H + (INNER_Z - 50)]){
            cube([70, 2, 50]);
        }
        //cut below to save filament
        translate([(90 - 60)/2, LIGHTING_SECTION + 10, FLOOR_H]){
            cube([60, 2, 50]);
        }        
        //back section
        translate([2, 23 + HEATSINK_FAN + 10 + 2 + 10, FLOOR_H])
            cube([86, 116, 90]);
        
        // Power cord out
        translate([20, BODY_LEN + 2, 15])
            rotate([90, 0, 0])
                cylinder(d=15, h=10);
                
        // venting mesh at the back
        translate([10/2, BODY_LEN + 2, 60])
        rotate([90, 90, 0])
            venting_mesh(80, width=30, center=false);
    }
    set_pylons(INNER_Z, "nut_trap");
    
}

module toggle_hole(){
    cylinder(d=6.2, h=5);
}

module cover(show_handle=true){
    y_toggle_offset = 105;
    x_toggle_offset= 12;
    difference(){
        cube([90, BODY_LEN, COVER_THICK]);
        handle();
        // venting mesh
        translate([(90 - 60)/2, 4 ,0]) venting_mesh(31, width=60, center=false);
        // toggle switches
        translate([x_toggle_offset ,y_toggle_offset, 0]) toggle_hole();
        translate([ 90 - x_toggle_offset, y_toggle_offset, 0]) toggle_hole();
    }
    if (show_handle){
        handle();
    }
    set_pylons(3, "hole");
}

module ps_12v(){
    cube([19, 62.5, 38]);
}

module ps_12v_cover(){
    difference(){
        translate([0, 15, -12])
            cube([24, 30, 60]);
        ps_12v();
    }
    
}

module led_driver(){
    cube([24.5, 88, 37]);
}

module led_driver_cover(){
    difference() {
        translate([-6, 25, -13])
            cube([30, 30, 60]);
        led_driver();
    }
}

module toggle_hole(){
    cylinder(d=6.2, h=5);
}

module shell(){
    translate([0,-1.5,30+15]) light_base();
    translate([-45, 0, 0]){
        body_shell();
        *translate([0, 0, INNER_Z]) cover(show_handle=true);
    }
}

module power_mounting_holes(){
// set mounting holes
        translate([-18, 140, 0]){
            translate([0,0, 13]) rotate([0, 90, 0]) nut_trap(M3_cap_screw, M3_nut, depth=3, h=55);
            translate([0,0, 63]) rotate([0, 90, 0]) nut_trap(M3_cap_screw, M3_nut, depth=3, h=55);
        }
        translate([12, 140, 0]){
            translate([0,0, 13]) rotate([0, 90, 0]) nut_trap(M3_cap_screw, M3_nut, depth=3, h=70);
            translate([0,0, 63]) rotate([0, 90, 0]) nut_trap(M3_cap_screw, M3_nut, depth=3, h=70);
        }
    }


module complete_body(){
    shell();
    translate([0, 100, 20]){
        translate([18, 0, 0]) {
            led_driver();
            led_driver_cover();
        }
        translate([-41.5, 10, 0]){
            ps_12v();
            ps_12v_cover();
        }
        
    }
}



module led_driver_w_holes(){
    difference(){
        translate([0, 100, 20]){
            translate([18, 0, 0]) {
                led_driver_cover();
            }
        }
        power_mounting_holes();
    }
}

module ps_12v_cover_w_holes(){
    difference(){
        translate([0, 100, 20]){
            translate([-41.5, 10, 0]){
                ps_12v_cover();
            }
        }
        power_mounting_holes();
    }
}



module light_body(){
    difference(){
        shell();
        power_mounting_holes();
    }
}


module fix_for_first_product(){
    // fix for the product #1
    difference(){
        body_shell();
        translate([-20, 0, -FLOOR_EXTRA_LIGHTING_SECTION])
            cube([90+40, BODY_LEN, INNER_Z]);
    }
}

//Definitions to generate stl of complete object or render each part 

*fix_for_first_product();
*handle_wo_inserts();
*cover(show_handle=false);
*ps_12v_cover_w_holes();
*led_driver_w_holes();
*led_driver_cover();
light_body();