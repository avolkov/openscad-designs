include <../libs/hardware-recess.scad>;

spool_d = 25;
m8_bolt_len = 47;
arm_thick = 10;

DISPLAY_SPOOL = true;

module base(){
    cube([10, 20, 40]);
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
    difference(){
        union(){
            hull(){
                cube([20, 10, 40]);
                translate([0, 0, 150])
                    rotate([90, 0,0])
                        cylinder(d=spool_d, h=10, center=true);
            }
            if (display_spool){
                translate([0,0, 150]) spool();
            }
        }
    // hardware for mating spool to an arm
    translate([0, arm_thick, 150])
        rotate([90, 0, 0])
            bolt_nut(m8_bolt_len, 8, flip=true);
    }
}



base();
translate([0,0, 40]) rotate([0, 15, 0]) arm();
//translate([39, 0, 160 + 20 + 5]) rotate([90, 0,0]) spool();

//arm();

