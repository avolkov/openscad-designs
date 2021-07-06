include <../libs/hardware-recess.scad>;

    cube([39.5, 8.5, 4.5]);
    translate([-0.25, 0, 0])
        rotate([90, 0 ,0])
            alu_connector(4.5, 0);
    translate([19.75, 0, 0])
        rotate([90, 0 ,0])
            alu_connector(4.5, 0);
