include <../libs/hardware-recess.scad>;

module base(){
    cube([10, 20, 40]);
}

module arm(){
    cube([10, 10, 160]);
}

module spool(){
    cylinder(d=25, h=100);
    
}

base();
translate([0,0, 40]) rotate([0, 15, 0]) arm();
translate([44, 0, 160 + 20 + 5])rotate([90, 0,0]) spool();
