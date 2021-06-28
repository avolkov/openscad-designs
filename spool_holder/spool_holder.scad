include <../libs/hardware-recess.scad>;

spool_d = 25;

module base(){
    cube([10, 20, 40]);
}

module spool(){
    rotate([90, 0,0]){
        cylinder(d=spool_d, h=100);
        translate([0,0,90]){
            cylinder(d1=spool_d, d2=spool_d + 10, h=5);
            translate([0,0,5])
                cylinder(d=spool_d + 10, h=5);
        }
    }
}

module arm(){
    hull(){
        cube([20, 10, 40]);
        translate([0, 0, 150])
            rotate([90, 0,0])
                cylinder(d=spool_d, h=10, center=true);
    }
    translate([0,0, 150]) spool();
    
}



base();
translate([0,0, 40]) rotate([0, 15, 0]) arm();
//translate([39, 0, 160 + 20 + 5]) rotate([90, 0,0]) spool();
