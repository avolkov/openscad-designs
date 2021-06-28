/*
 * Modifications for mounting on the left side of the printer,
 * and adjustments for Bear Upgrade mounts
 * GNU GPL v3
 * Alex Volkov <alex@flamy.ca> 2021-06-27
 *
 * PRUSA iteration3
 * PSU Cover
 * GNU GPL v3
 * Josef Průša <iam@josefprusa.cz> and contributors
 * http://www.reprap.org/wiki/Prusa_Mendel
 * http://prusamendel.org
 *
 */
PRUSA iteration3
// PSU Cover
// GNU GPL v3
// Josef Průša <iam@josefprusa.cz> and contributors
// http://www.reprap.org/wiki/Prusa_Mendel
// http://prusamendel.org

module left_shelf_cutout(){
    //top cutout
    translate([101+2,50-16.4-17.6+15+0.9-2.5,2])cube([10,100,50-0.7]);
    //angle cutout
    translate([101+2,10,2])rotate([0,0,45]) cube([10*sqrt(2),10*sqrt(2),50-0.7]);
    //bottom cutout
    translate([101+2,2,2]) cube([10,18,50-0.7]);
}

module right_shelf_cutout(){
    //top cutout
    translate([-1.4, 50-16.4-17.6+15+0.9-2.5,2])cube([6.4,70 - 2,53.78 - 4.5]);
    //angle cutout
    translate([4.6,14,2])rotate([0,0,45]) cube([6*sqrt(2),6*sqrt(2),53.78 - 4.5]);
    //bottom cutout
    translate([-1.4,2,2])cube([6.4,18,53.78 - 4.5]);
}

module PSU_COVER(){
difference(){
    union(){
        // Base
        translate([0,0,-0.46])cube([116,50+15+5,54.25]);
        translate([23.5,0,-3.5])cube([14-0.5,50+15+5,5]); // Back pillar 1
        translate([66-0.5+8,0,-3.5])cube([14,50+15+5,5]); // Back pillar 2
        translate([91+4,0,-0.46])cube([6,50+15,54.25]); // Base for bracket
        //my customization of the right side of the enclosure
        translate([-4.5,0,0])cube([6,70,53.78]);
        }
    right_shelf_cutout();
    //pretty corners
    translate([-12 - 3,-2,-3.6])rotate([0,0,-45])cube([10,10,59]); // right bottom
    translate([95+21-5,-2,-2])rotate([0,0,-45])cube([10,10,58]); // left bottom
    translate([-3,-9,-4.46])rotate([-45,0,0])cube([130,10,10]); // back bottom

    translate([-3,-12,54.9])rotate([-45,0,0])cube([130,10,10]); // bottom front edge
    translate([-3,45+15+5,-4.46])rotate([-45,0,0])cube([130,10,10]); // bottom edge
    translate([-3,48+15+5,54.78])rotate([-45,0,0])cube([130,10,10]); // top front edge

    translate([113-3,70+5,-2])rotate([0,0,-45])cube([10,10,58]); // top left edge

    translate([111,0-10,-20])rotate([0,-45,-45])cube([20,20,20]); // back left bottom corner
    translate([111,0-10,45])rotate([0,-45,-45])cube([20,20,20]); // front left bottom corner
    translate([-11,-20,60]) rotate([0,45,45])cube([20,20,20]); // front right bottom corner
    translate([-7,-17,-11])rotate([0,45,45])cube([20,20,20]); // back right bottom corner
    
    translate([79+13.5,-5,67.28])rotate([0,45,0])cube([20,90,20]); // front left line
    translate([79+13.5,-5,-13.96])rotate([0,45,0])cube([20,90,20]); // back left line
    translate([-7,-5,67.28])rotate([0,45,0])cube([20,90,20]); // front right line
    // main cutout
    translate([3,2,2])cube([106.02,50.02+15+5,50.02-0.7]); 
    
    left_shelf_cutout();
    // Front Vent cutout
    translate([20,60.5,50])cube([73,10,10]); 
    
    SOCKET_OFFSET = 10;

    translate([5.5,0,0]){
        translate([40 - SOCKET_OFFSET,5,50])cube([47.5,27.5,10]); // socket cutout
        translate([40 - SOCKET_OFFSET,4,50])cube([15,29.5,2.8]);
        translate([72.5 - SOCKET_OFFSET,4,50])cube([15,29.5,2.8]);
    }
    
    //right back mounthole cutout
    translate([7-0.5-0.5+18+6,43.5-1+15+0.5+4.5,-10])cylinder(r=2,h=50,$fn=15); 
    translate([7-0.5-0.5+18+6,43.5-1+15+0.+4.5,-3.7])cylinder(r2=2, r1=3.7,h=2,$fn=15);
    //left back mounthole cutout
    translate([67.5-0.7-0.5+8+6,43.5-1+15+0.5+4.5,-10])cylinder(r=2,h=50,$fn=15); 
    translate([67.5-0.7-0.5+8+6,43.5-1+15+0.5+4.5,-3.7])cylinder(r2=2, r1=3.7,h=3,$fn=15);
    // Left side bracket screw hole L
    translate([130+16,32+26+4.5,55-4-25+11.5])rotate([0,-90,0])cylinder(r=2,h=50,$fn=35);
    translate([117,32+26+4.5,55-4-25+11.5])rotate([0,-90,0])cylinder(r2=2, r1=4.1,h=3,$fn=15);
    //Gap for power adapter
    translate([113,45,2]){
        translate([0,25,21]) rotate([45,0,0]) cube([5,5,5]);
        difference(){
            cube([5, 25, 25]);
            translate([0,0,-4]) rotate([45,0,0]) cube([5,5,5]);
            translate([0,0,22]) rotate([45,0,0]) cube([5,5,5]);
        }
    }
    //New screw hole on the right
    //Thread
    translate([15, 32+26+4.5,55-4-25-11.5])
        rotate([0,-90,0])
            cylinder(r=2,h=50,$fn=35);
    //Flat top
    translate([-2,32+26+4.5,55-4-25-11.5])
        rotate([0,-90,0])
            cylinder(r2=4.1, r1=2,h=3,$fn=15);

    //back power wire cutout
    hull(){
        translate([10,10,-10]) cylinder(r=7,h=50);
        translate([10 + 4,10,-10]) cylinder(r=7,h=50);
        }
        
    }
}

module bottom_reinf(placement_diff, x_mount_offset, x_reinf_offset){
    Z_DIFF = 1;
    difference(){
        union(){
            // Distance from the corner
            // reinforcement plate
            translate([59.5 - placement_diff - x_mount_offset, 0, -18 ])
                cube([ 33, 6, 19 ]);
            // vertical_reinforcement right
            translate([ 73.5 - placement_diff, 5, -18 ]) cube([ 5, 16, 19 ]);
            // vertical_reinforcement left
            translate([ 73.5 - placement_diff - x_reinf_offset, 5, -18 ])
                cube([ 5, 16, 19 ]);
        }
        // cutouts
        union (){
            //vertical reinf cutout right
            translate([ 68.5 - placement_diff, 20, -34 + Z_DIFF ])
                rotate([ 45, 0, 0 ])
                    cube([ 15, 23, 20 ]);
            //vertical reinf cutout left
            translate([ 68.5 - placement_diff - x_reinf_offset, 20, -34 + Z_DIFF ])
                rotate([45, 0, 0 ])
                    cube([ 15, 23, 20 ]);
            mount_hole_angle = 90;
            // Redesigned mount for Bear Upgrade bottom PS mount
            hull(){
                translate([71.5 - placement_diff, 8, -11.5 ])
                    rotate([mount_hole_angle, 0, 0 ])
                        cylinder( h = 10, r = 1.8, $fn=30 );
                translate([52.5 - placement_diff, 8, -11.5 ])
                    rotate([mount_hole_angle, 0, 0 ])
                        cylinder( h = 10, r = 1.8, $fn=30 );
            }
        }
    }
}

module PSU_Y_REINFORCEMENT(){
    PLACEMENT_DIFF = 21.5;
    X_MOUNT_OFFSET = 14;
    REINF_OFFSET = 28;
    difference(){
        // base shape
        union(){
            bottom_reinf(PLACEMENT_DIFF, X_MOUNT_OFFSET, REINF_OFFSET);
        }
    }
}

module FINAL_PART(){
    union(){
        PSU_COVER();
        PSU_Y_REINFORCEMENT();
    }
}

FINAL_PART();
