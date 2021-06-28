include <../libs/hardware-recess.scad>;

spool_d = 25;
m8_bolt_len = 47;
arm_thick = 10;

DISPLAY_SPOOL = false;
SPOOL_ANGLE = 30;
ARM_LEN = 150;

module base(){
    // joining part
    translate([0, 0, 2])
        cube([20, 36, 38]);
    // overhead_part
    translate([0, 0, 40]){
        cube([20, 36, 4]);
        translate([-20, 0, 0])
            alu_connector(36, 4, flip=true);
    }
}

module spool(){
    ARM_LEN = 100;
    rotate([90, 0,0]){
        difference(){
            union(){
                cylinder(d=spool_d, h=ARM_LEN);
                translate([0,0,90]){
                    cylinder(d1=spool_d, d2=spool_d + 10, h=5);
                    translate([0,0,5])
                    cylinder(d=spool_d + 10, h=5);
                }
            }
            translate([0,0, m8_bolt_len - arm_thick])
                cylinder(d=M_DIM[8][3], h=ARM_LEN );
       }
    }
}

module arm(display_spool=DISPLAY_SPOOL){
    SPOOL_X_ADJUST = 10 + ARM_LEN * cos(90 - SPOOL_ANGLE);;
    difference(){
        union(){
            hull(){
                cube([20, 10, 40]);
                translate([SPOOL_X_ADJUST, 0, ARM_LEN])
                    rotate([90, 0, 0])
                        cylinder(d=spool_d, h=10, center=true);
            }
            if (display_spool){
                translate([SPOOL_X_ADJUST,0, ARM_LEN]) spool();
            }
        }
    // hardware for mating spool to an arm
    translate([SPOOL_X_ADJUST, arm_thick, ARM_LEN])
        rotate([90, 0, 0])
            bolt_nut(m8_bolt_len, M8, flip=true);
    }
}




//translate([0,0, 40]) rotate([0, 15, 0]) arm();
//translate([39, 0, 160 + 20 + 5]) rotate([90, 0,0]) spool();
difference(){
    union(){
        translate([0,10,0]) base();
        arm();
    }
    //using joining hardware
    translate([10, -1, 10]) rotate([270, 0, 0]) bolt_nut(m8_bolt_len, M8, flip=true);
    translate([10, -1, 30]) rotate([270, 0, 0]) bolt_nut(m8_bolt_len, M8, flip=true);
}
