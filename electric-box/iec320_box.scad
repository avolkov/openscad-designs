include <../libs/hardware.scad>;
w = 80;
d = 80;
h = 64;

m5_offset = 8;
wiring_ledge_offset = 5;

module ledge(){
// Wiring ledge
    bolt_mount = 34;
    difference(){
        union(){
            translate([w/2 , 0, wiring_ledge_offset])rotate([0, 90, 0]){
                difference() {
                    // inner cylinder
                    cylinder(d=30, h=20);
                    // half-cutout cube
                    translate([-15, -15, 0]) cube([15, 30, 40]);
                }
                // Cube for M3 bolt mounts
                translate([-bolt_mount/2, -bolt_mount/2, 0]) cube([bolt_mount, bolt_mount, 3]);
            }
        }
        translate([w/2 - 4, 0, wiring_ledge_offset])rotate([0, 90, 0]){
            // cut out wire hole in the back
            ledge_cut();
        }
    }
}

module ledge_cut(){
    cylinder(d=20, h=50);
    z_offset = 0.5;
    bolt_pattern = 13;
    // upper fasteners
    translate([-bolt_pattern, -bolt_pattern, z_offset])
        hole_w_end(12, $M_DIM[M3][4] + 0.5, "hex", $M_DIM[3][0], flip=true);
    translate([-bolt_pattern, bolt_pattern, 0.5])
        hole_w_end(12, $M_DIM[M3][4] + 0.5, "hex", $M_DIM[3][0], flip=true);
    // lower fasteners
    translate([bolt_pattern, bolt_pattern, 0.5])
        hole_w_end(12, $M_DIM[M3][4], "hex", $M_DIM[3][0], flip=true);
    translate([bolt_pattern, -bolt_pattern, 0.5])
        hole_w_end(12, $M_DIM[M3][4], "hex", $M_DIM[3][0], flip=true);
}


module box_body(show_ledge=true){
    difference(){
        union(){
            difference(){
                cube([w,d, h], center=true);
                translate([0,0, 0])cube([w-4, d-4, h-12], center=true);
                translate([0,0, h/2-6])cube([w-20, d-40, 4], center=true);
                // woodscrew cutout
                for ( i = [ 0: 15 : 45 ] ){
                    translate([-23 + i, -10, h/2 - 4]) cylinder(d=3, h=4, $fn=20);
                    translate([-23 + i, 10, h/2 - 4]) cylinder(d=3, h=4, $fn=20);
               }
            }
            if (show_ledge){
                ledge();
            }
            side_d = 13;
            //Support columns for M5 bolts
            translate([0,0, -60/2]){
                translate([w/2 - m5_offset, d/2 - m5_offset]) cylinder(d=side_d, h=60);
                translate([w/2 - m5_offset, -d/2 + m5_offset]) cylinder(d=side_d, h=60);
                translate([-w/2 + m5_offset, d/2 - m5_offset]) cylinder(d=side_d, h=60);
                translate([-w/2 + m5_offset, -d/2 + m5_offset]) cylinder(d=side_d, h=60);
            }
        }
        // cut out IEC 320 C14 socket
        translate([-76/2 + 2, 0, 0])rotate([90, 180, -90]) iec320_keyed(4,lip=1);
        // Cut out mounting bolts
        translate([0,0, -64/2]){
            translate([w/2 - m5_offset, d/2 - m5_offset]) bolt_nut(60, M5, flip=true);
            translate([w/2 - m5_offset, -d/2 + m5_offset]) bolt_nut(60, M5, flip=true);
            translate([-w/2 + m5_offset, d/2 - m5_offset]) bolt_nut(60, M5, flip=true);
            translate([-w/2 + m5_offset, -d/2 + m5_offset]) bolt_nut(60, M5, flip=true);
        }
        
        translate([w/2 - 4, 0, wiring_ledge_offset])rotate([0, 90, 0]){
            ledge_cut();
        }
        
    }
}

offset = 6;
module top(){
    difference(){
        box_body(show_ledge=false);
        translate([0,0, -offset/2 ]) cube([w, d, h - offset], center=true);
    }
}
module bottom(){
    difference(){
        box_body(show_ledge=false);
        translate([0,0, h/2 - offset/2]) cube([w, d, offset], center=true);
    }
}
//top();
bottom();
//ledge();


