include <common.scad>

thickness = 5;
hinge_d = 15;
cut_cube_len = 7;

side = thickness*2;
length = 40;

wheel_x_offset = 2;
wheel_z_offset = 8;

space_between_mounts = (length - cut_cube_len)/4;
echo("Space between", space_between_mounts);

module hinge_shape(hole_type){
    difference(){
        union(){
            cube([length, side, thickness]);
            //cube([side, thickness, thickness+2]);
            translate([wheel_x_offset,thickness, wheel_z_offset]){
                rotate([90,0,0]){
                        cylinder(h=thickness, d=hinge_d); 
                }
            }
        }
        // Create hole in the wheel
        translate([wheel_x_offset,thickness, wheel_z_offset])
            rotate([90,0,0])
                hole_w_end(thickness, 2 , hole_type, bolt_d=3);
       translate([0, thickness, 0])
            cube([cut_cube_len,thickness, thickness]);
    }
}

module mount_hole(x_offset, y_offset, bolt_shape){
    // given offsets, and bolt shape, create M3 mount holes for this hinge object
    
        translate([x_offset, y_offset, 0])
            rotate([0, 0, 90])
                hole_w_end(thickness, 2, bolt_shape, bolt_d=3);
    
}


module simple_hinge(hole_type, mounting_shape){
    // Create a simple hinge with given hole shape in the hinge
    difference(){
        difference(){
            hinge_shape(hole_type);
            
            //first mount hole
            mount_hole(
                cut_cube_len + space_between_mounts, side/2, mounting_shape);
            
            // Second mount hole
            mount_hole(
                cut_cube_len+ space_between_mounts*3, side/2, mounting_shape);
        }
    
    }
}
simple_hinge("hex", "hex");
