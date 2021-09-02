
/*
You can check and fix the normals of an STL with the --normal-directions option of ADMesh:
https://admesh.readthedocs.io/en/latest/cli.html#options
*/
// see https://forum.openscad.org/openScad-STL-cannot-render-td23088.html
// Solution ld lib path missing fix -- https://github.com/admesh/admesh/issues/30

// tried formware too. didn't work
//https://www.formware.co/onlinestlrepair

// Extruder cover v2 works!
//cube([20, 20, 20]);

module lower_fan_mount(){
    difference(){
        union(){
            translate([-37.75,-38.5, 0]) rotate([0,0,0]) cylinder( h=5, r=5.9, $fn=6 );
            translate([-34,-41.5, 0]) rotate([0,0,20]) cube([30,8,4]); 
        }
        // lower cooling fan screw
        translate([-37.75,-38.5,-2]) cylinder( h=20, r=1.6, $fn=30 );
        translate([-37.75,-38.5,0.6]) cylinder( h=4, r=3.1, $fn=6 );
        translate([-37.75,-38.5, 2.5]) cylinder( h=3, r1=3.1, r2=4.0, $fn=6 );
    }
}


translate([220, -100, 0])import("extruder-cover_v2.stl");
lower_fan_mount();