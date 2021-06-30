include <spool_holder.scad>;

//Checking fittings.

module 001_test_fitting_base(){
    difference(){
        union(){
            translate([0,ARM_BASE_W,0]) base();
            *arm();
        }
        //using joining hardware
        for (i=[10, 30]){
            translate([10, -ARM_BASE_MEAT, i])
                rotate([270, 30, 0])
                    bolt_nut(m8_bolt_len + 1, M8, flip=true);
        }
        translate([-20, 0, -10]) cube([100, 48.8, 60]);
    }
}
*001_test_fitting_base();

module 002_test_fitting_spool_arm(){
    *difference(){
        spool();
        translate([0,-3, 0]) rotate([90, 0, 0])cylinder(d=40, h=100);
    }
    rotate([180,0,0]){
        translate([0, 3, 40]){
            rotate([90, 0, 0]){
                cylinder(d=spool_d, h=3);
                translate([0,0, 3 - 0.2])
                    rotate_teeth(6, 4, 3, 5.5);
            }
        }
    }
}
002_test_fitting_spool_arm();