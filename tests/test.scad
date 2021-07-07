include <../libs/hardware-recess.scad>;

/*
difference(){
    cube([20, 20, 20]);
    translate([10,10, 0]) bolt_nut(20, M5);
}
*/

//alu_connector(10, 1);

tooth_len = 25/ 2 - 8/2 - 3;

module tooth(tooth_len, tooth_width){
    blade_w = 0.2;
    tooth_depth = 2;

    hull(){
        cube([tooth_len, blade_w, blade_w]);
        translate([0, tooth_width - 1, 0])
            cube([tooth_len, 1, tooth_depth]);
            
    }
}



module rotate_teeth(count, tooth_len, tooth_width, r){
    // Post here solves rotation
    // http://forum.openscad.org/Re-Rotate-relative-or-make-spokes-td14882.html
    for (i=[0:count]){
        rotate([0,0, 360/count*i])
            translate([r, -tooth_width/2, 0])
                tooth(tooth_len, tooth_width);
    }
}

//tooth(5,2);
rotate_teeth(6, 5, 2, 3);

//tooth(tooth_len);

/*
NoArm = 7; // The number of arms / sides of the polygon
ArmWide = 3; // The width (short side) of the arms
ArmHigh = 3; // The height (along the Z axis) of the arms
ArmLong = 80; // The radial length of the arms

ArmsOnEdges = true; // Should the arms intersect the edge or vertices of the polygon

CircRadius = 2; // The radius of the polygon

union()  // Union isn't strictly necessary because everything at the top level is implicitly unioned
{
    for (i=[1:NoArm])
            rotate([0,0,360/NoArm*i]) // Rotate the arm after it's centered
            translate([0,-ArmWide/2,0]) // Center the arm around the X axis
            cube([ArmLong, ArmWide, ArmHigh]); // Make the arm extend along the X axis

}
*/