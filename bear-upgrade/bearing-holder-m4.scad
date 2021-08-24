include <NopSCADlib/lib.scad>
include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/layout.scad>

include <NopSCADlib/vitamins/linear_bearings.scad>
use <NopSCADlib/vitamins/linear_bearings.scad>


//linear_bearing(linear_bearings["LM8UU"]);



module linear_bearings()
    layout([for(b = linear_bearings) 2 * bearing_radius(b)]) {
        linear_bearing(linear_bearings[8]);
        echo($i);
       

        translate([0, 30])
            linear_bearing(long_linear_bearings[$i]);
    }

linear_bearings();
