include <../libs/hardware-recess.scad>;

/*
Hook  for curtain holder that attaches to door frame 
Uses M8 bolt to grip door frame

WIP
*/

module u_bracket() {
    union(){
        difference(){ 
            cube([10, 40, 40]);
            translate([10, 20, 20]){
                rotate([0,270,0]){
                    cylinder(d=16, h=7, $fn=6);
                    cylinder(d=8.5, h=10, $fn=20);
                }
            }
        }
        translate([52 + 10, 0, 0])
        difference() {
            cube([40, 40, 40]);
            //TODO: add M3 nut hole for fixing the rail in place
            translate([20, 40, 35]){
                rotate([90, 0, 0]) { 
                    cylinder(h=40, d=20, $fn=20);
                }
            }
            translate([41, 20, 35]){
                rotate([0, 270, 0]){
                    hole_w_end(12, m3_nut_thick, "hex", m3_bolt_thick);
                }
            }
            translate([40, 20, 28]){
                rotate([0, 270, 0]){
                    hole_w_end(15, m3_nut_thick, "hex", m3_bolt_thick);
                }
            }
        }
        translate([0, 0, -5])
            cube([102, 40, 10]);
    }
}


u_bracket();