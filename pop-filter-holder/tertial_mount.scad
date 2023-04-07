include <../libs/hardware-recess.scad>;
use <../libs/gopro_mounts_mooncactus.scad>;

//bolt_nut(20, 3)
conn_h = 19;

difference(){
    union(){
        rotate([270, 0, 0])gopro_connector("triple");
        translate([0,0, -10 - conn_h])rotate([0,0, 45])cylinder(h=conn_h, d1=25, d2=21, $fn=4);
    }

    translate([0,0, -17]){
        bottom_bolt_mt_offset=-8;
        cube([30,10.2, 10.2], center=true);
        translate([0,1,-5])cube([30, 8, conn_h], center=true);
        translate([-4,9, bottom_bolt_mt_offset])rotate([90,30,0])bolt_nut(16, 3, flip=true);
        translate([4,9, bottom_bolt_mt_offset])rotate([90,30,0])bolt_nut(16, 3, flip=true);
    }
}


