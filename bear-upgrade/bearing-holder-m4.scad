include <NopSCADlib/lib.scad>
include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/layout.scad>

include <NopSCADlib/vitamins/linear_bearings.scad>
use <NopSCADlib/vitamins/linear_bearings.scad>

include <NopSCADlib/vitamins/bearing_blocks.scad>
use <NopSCADlib/vitamins/bearing_blocks.scad>

//linear_bearing(linear_bearings["LM8UU"]);


//scs_bearing_block_assembly(SCS8LUU);
echo("hello");
//screw(screw_nut(SCS8LUU[11]), 10);
bolt_len = 25;


echo(screw_nut_radius(M4_cap_screw));
difference(){
    translate([1, 0, 0])
        cube([LM8UU[1]-2, 30, 20]);
    translate([LM8UU[1]/2, 30/2, 6.75])
        rotate([0, 90, 0])
            linear_bearing(LM8UU);
    hull(){
        translate([-1, 30/2, 6.75])
            rotate([0, 90, 0])
                cylinder(h=LM8UU[1] + 2, d=LM8UU[2]-2);
        translate([-1, 30/2, 0])
            rotate([0, 90, 0])
                cylinder(h=LM8UU[1] + 2, d=LM8UU[2]-2);
        
    }
    translate([(LM8UU[1]-2)/2,30/7, 2.9])
        rotate([0,180, 0])
            screw(M4_hex_screw, bolt_len);
    //scs_screw(SCS8LUU);
    
}