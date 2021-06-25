/*
 * non-adjustable, permanent 30 degree mount foot for
 * reprapdiscount_full_graphic_smart_controller_box.scad
 * see https://www.thingiverse.com/thing:861091
 *
 * Use 2x 10mm M3 bolts to attach to the screen housing
 * Use 1x 10mm M5 bolt to attach to a T-nut in a 20mm V-slot
 *
 * Copyright 2021 Alex Volkov <alex@flamy.ca>
 * 
 * License: Attribution-ShareAlike 4.0 International (CC BY-SA)
 * https://creativecommons.org/licenses/by-sa/4.0/
 *
 * Version 1.0 2021-06-24 Initial publication
 */


include <../libs/hardware-recess.scad>;

mat_thick = 5;
top_shave=27;
module mountcube(x=22, y=30, z=mat_thick){
    cube([x, y, z]);
}


module mount_foot(){
    difference(){
        mountcube(y=40);
        translate([10, 7, 0])cylinder( h=mat_thick, d=M_DIM[5][0]);
    }
}
module connector(){
    // Connector foot
    rotate([90,0,0])mountcube(z=mat_thick*2);
}

module pedestal(x, y){
    difference(){
        mountcube(x=x, y=y);
        translate([0,2,0]){
            translate([10, 7.5, 0]) hole_w_end(mat_thick, 1, "hex", M_DIM[3][0], flip=true);
            translate([10, 7.5*3, 0]) hole_w_end(mat_thick, 1, "hex", M_DIM[3][0], flip=true);
        }
    }
}



difference(){
    union(){
        mount_foot();
        
        difference(){
            union(){
                translate([0,30,0])connector();
                translate([0, 25, top_shave])rotate([0, 30, 0])pedestal(x=22,y=35);
                // fill in gap between podium and base
                translate([0, 25, top_shave])cube([10, 35, 10]);
            }
            //shave of f the top
            translate([0, 20, top_shave+mat_thick+0.7])rotate([0, 30, 0])mountcube(x=25, y=40, z=10);
        }
        
    }
    //Shaving off front to simplify printing
    translate([20, 0, 0])
        cube([30, 60, 30]);
    //Shaving off top to simplify printing
    translate([0, 0, 30])
        cube([30, 60, 30]);

}