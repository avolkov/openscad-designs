include <common.scad>

side_offset = 14;

tolerance = 1;
narrow_bit = 25;
wide_bit_d = 27;
wide_bit_h = 26;
narrow_bit_h = 8;

tube_trap_wired_len = tolerance*3 + wide_bit_h + narrow_bit_h*2;

end_height = 30;
end_width= 65;
end_depth = 65;

led_driver_h = 95;
led_driver_w = 39;

module tube_trap() {
    cylinder(h=narrow_bit_h, d=narrow_bit+tolerance);
    translate([0,0,narrow_bit_h])
        cylinder(h=wide_bit_h, d=wide_bit_d+tolerance);
    translate([0, 0, wide_bit_h+narrow_bit_h])
        cylinder(h=narrow_bit_h, d=narrow_bit + tolerance);
    translate([-15/2, -3/2, wide_bit_h+narrow_bit_h*2])
        cube([15, 3,10]);
}

module led_end_wired(){
    tube_trap();
    //conduit bit
    translate([-22/2, -15+5 ,41]){
        //bump tolerances here
        cube([20+tolerance*4, 15+tolerance*4, 19+tolerance*3]);

    }
}

module punch_led_tube(x_offset, enclosure_height, length){
    translate([x_offset , 0, enclosure_height]){
        rotate([270, 0, 0]){
            cylinder(h=length, d=narrow_bit+tolerance);
        }
    }
}

module punch_led_end(x_offset, enclosure_height, type){
    translate([x_offset , 0, enclosure_height]){
        rotate([270, 0, 0]){
            if (type == "wired"){
                led_end_wired();
                 translate([0, 0, tube_trap_wired_len])
                    cylinder(h=10, d=10);
            } else if (type == "dummy"){
                tube_trap();
            }

         }
    }
}

module wired_catch(end_width, side_offset){
    difference(){
        cube([end_width, end_depth, end_height]);
        punch_led_end(wide_bit_d/2 + side_offset, end_height/2, "wired");
        punch_led_end(
            end_width - wide_bit_d/2 - side_offset,
            end_height/2,
            "wired");
        //first wiring hole
        translate([
            wide_bit_d/2 + side_offset/2+2,
            wide_bit_h+narrow_bit_h*2+9,
            wide_bit_d/2]){
            cube([10, 12 ,50]);
        }
        // second wiring hole
        translate([
            wide_bit_d*2 + 8,
            wide_bit_h+narrow_bit_h*2+9,
            0]){
            cube([10, 12 ,20]);
        }
        // hole for mounting wire
        translate([
            led_driver_h/2,
            end_depth+10,
            5]){
        rotate([45, 0 ,0])
            cylinder(h=50, d=10, $fn=20);
    }
    }


}

module dummy_catch(end_width, side_offset) {
    difference(){
        cube([end_width, end_depth, end_height]);
        punch_led_end(wide_bit_d/2 + side_offset, end_height/2, "dummy");
        punch_led_end(end_width - wide_bit_d/2 - side_offset, end_height/2, "dummy");
    }
}


module make_hole(x_offset, y_offset, hole_len, bolt_d, type, flip){
    translate([x_offset, y_offset, 0])
        if (type == "both"){
            bolt_nut(hole_len, bolt_d, flip);
        } else if (type == "hex"){
            rotate([0, 0, 90])
                hole_w_end(hole_len, m3_nut_thick, "hex", bolt_d, flip);
        } else if (type == "round"){
             hole_w_end(hole_len, m3_nut_thick, "round", bolt_d, flip);
        }
}

module m5_mount_holes(){
        translate([10, end_depth/2, 0])
            m5_hole_w_end(end_height, m5_nut_thick, "round");
            //m5_hole_w_ends(end_height, nut_extra=5);

        translate([led_driver_h-10, end_depth/2, 0])
            m5_hole_w_end(end_height, m5_nut_thick, "round");
            //m5_hole_w_ends(end_height, nut_extra=5);
}


module build_dummy_side() {
    difference() {
        dummy_catch(led_driver_h, side_offset);
                // Holes to fasten two pieces of the model
        m5_mount_holes();
    }
}

module build_mid_mount(end_width, end_depth, end_height, side_offset) {
    difference(){
        cube([end_width, end_depth, end_height]);
        //cylinder(h=narrow_bit_h, d=narrow_bit+tolerance);
        punch_led_tube(
            wide_bit_d/2 + side_offset,
            end_height/2,
            100);
        punch_led_tube(
            end_width - wide_bit_d/2 - side_offset,
            end_height/2,
            100);
        // Place to mount M8 Rod for supporting leds
        translate([end_width/2, 0, end_height/2]){
            rotate([270, 0, 0]){
                cylinder(h=200, d=8.5);
            }
        }
        // Holes to fasten two pieces of the model
        m5_mount_holes();
    }


}

module set_led_driver_mounts(total_width, total_depth, hole_len){
    bolt_d = 3;
    corner_offset = m3_bolt_thick + 1;

    // Add holes to front corners
    translate([corner_offset, corner_offset, 0]){
        //bolt_nut(hole_len, bolt_d);
        hole_w_end(hole_len, m3_nut_thick, "hex", bolt_d, flip=true);
    }
    translate([total_width - corner_offset, corner_offset, 0]){
        hole_w_end(hole_len, m3_nut_thick, "hex", bolt_d);
    }
    // back corners

    translate([corner_offset, led_driver_w + corner_offset, 0]){
        hole_w_end(hole_len, m3_nut_thick, "hex", bolt_d);
    }
    translate([total_width - corner_offset, led_driver_w + corner_offset, 0]){
        hole_w_end(hole_len, m3_nut_thick, "hex", bolt_d, flip=true);
    }
}

module build_wired_side(){
    difference(){
        wired_catch(led_driver_h, side_offset);
        set_led_driver_mounts(led_driver_h, side_offset, end_height);
    }
}


module simple_wired_side(){
    difference(){
        wired_catch(led_driver_h, side_offset);
        m5_mount_holes();
    }
}

module mid_mount(side){
    difference(){
        build_mid_mount(led_driver_h,end_depth, end_height, side_offset);
        if (side == "bottom"){
            translate([0,0, end_height/2])
                cube([led_driver_h, end_depth, end_height/2]);
        } else if (side == "top") {
            cube([led_driver_h, end_depth, end_height/2]);
        }
    }
}

module mid_mount_winglets(end_depth){
    difference(){
        build_mid_mount(led_driver_h,end_depth, end_height, side_offset);
        translate([0,0, end_height/2])
            cube([led_driver_h, end_depth, end_height/2]);
    }


}

module dummy_mount(side){
    difference(){
        build_dummy_side();
        if (side == "bottom"){
            translate([0,0, end_height/2])
                cube([led_driver_h, end_depth, end_height/2]);
        } else if (side == "top"){
            cube([led_driver_h, end_depth, end_height/2]);
        }
    }
}

module wired_mount(side){
    difference(){
        //build_dummy_side();
        simple_wired_side();
        if (side == "top"){
            cube([led_driver_h, end_depth, end_height/2]);
        }else if (side == "bottom"){
            translate([0,0, end_height/2])
                cube([led_driver_h, end_depth, end_height/2]);
        }
    }
}



// Top level geometry called here

*mid_mount_winglets(12);
*dummy_mount("top");
wired_mount("top");
mid_mount("bottom");
