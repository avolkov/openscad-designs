include <NopSCADlib/lib.scad>
include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/layout.scad>

include <NopSCADlib/vitamins/linear_bearings.scad>
use <NopSCADlib/vitamins/linear_bearings.scad>


//linear_bearing(linear_bearings["LM8UU"]);



difference(){
    translate([1, 0, 0])
        cube([LM8UU[1]-2, 30, 20]);
    translate([LM8UU[1]/2, 30/2, 6.75])
        rotate([0, 90, 0])
            linear_bearing(linear_bearings[4]);
    hull(){
        translate([-1, 30/2, 6.75])
            rotate([0, 90, 0])
                cylinder(h=LM8UU[1] + 2, d=LM8UU[2]-2);
        translate([-1, 30/2, 0])
            rotate([0, 90, 0])
                cylinder(h=LM8UU[1] + 2, d=LM8UU[2]-2);
        
    }
    
}