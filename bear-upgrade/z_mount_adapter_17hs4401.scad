include <../libs/hardware-recess.scad>;

adapter_height = 4.5 + 3;
cutout_thick = 4.2;

difference() {
    cube([39.5, 8.5, adapter_height]);
    translate([(39.5 - 32.5)/2, 8.5 - cutout_thick, 0])
        cube([32.5, cutout_thick, adapter_height]);
}
translate([-0.25, 0, 0])
    rotate([90, 0 ,0])
        alu_connector(adapter_height, 0);
translate([19.75, 0, 0])
    rotate([90, 0 ,0])
        alu_connector(adapter_height, 0);
