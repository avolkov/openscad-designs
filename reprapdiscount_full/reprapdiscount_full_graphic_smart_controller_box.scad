/*
Name: ReprapDiscount Full Graphic Smart Controller Box in OpenSCAD

Filename: reprapdiscount_full_graphic_smart_controller_box.scad

Author: Jons Collasius from Germany/Hamburg
Contact: reprap.org@metastasis.de
Website: http://www.metastasis.de

License: CC BY-NC-SA 4.0
License URL: https://creativecommons.org/licenses/by-nc-sa/4.0/

Software: OpenSCAD v2014.09.05 (http://www.openscad.org/)

NOTE:
This parts are designed to fit the RepRapDiscount Full Graphic Smart Controller and won't fit any other!

Updated lcdbox_top_switch_r to fit through the whole knob without disassembly. - Alex Volkov.
*/

// #####################################################################################################################################

single_wall	= 0.6;
small_wall	= 2*single_wall;
normal_wall = 4*single_wall;
stable_wall = 6*single_wall;

// resolution of circles and cylinders, in any "fnmodule", unless explicit declaration in module call. each line segment is fnr mm long. fnr = 1 crude and good for development (its faster), aim for fnr = 0.4 or smaller for a produtcion render. take a coffee break :)
fnr = 0.4;

// shrink perimeters by this to compensate over/underdepositing
compensate = 0.15;

lcd_total_hight = 18;
lcd_top_hight = 14.5;

lcd_width = 93.04;
lcd_depth = 86.95;

lcd_display_width = 73;
lcd_display_depth = 41;

lcd_display_width_outer = 80;
lcd_display_depth_outer = 53;

lcd_display_top_offset = 35.18;

lcd_mountoffset_bottom = 19.25;
lcd_mountoffset_sides = 2.5;

lcd_sdcard_offset = 51.78;
lcd_sdcard_depth = 25.55;
lcd_sdcard_hight = 3.31;

lcd_sockets_width = 21.35;
lcd_sockets_depth = 10;

lcd_socket_offset_top = 10.93;
lcd_socket_offset_center = 15.27;

lcdbox_bottom_hight = 10.64;
lcdbox_bottommount_hight = 9.11;

lcd_mountholes_r = 1.6;
lcd_backmount_holes_offset = 7.5;
lcd_mountholes_head_r = 2.85;
lcd_mountholes_head_h = 3.2;



lcd_top_hight = 23+small_wall;

lcdbox_topmount_hight = 8.40+small_wall;
lcd_sdcard_top_hight = 14.1+small_wall;
lcd_self_tapping_screw_r=1.45;

lcdbox_top_bottomparts_offset = 8.15;
lcdbox_top_beeper_offset = 27.88;
lcdbox_top_beeper_r = 6.5;

lcdbox_top_reset_offset = 42.5;
lcdbox_top_reset_button_r = 6;
lcdbox_top_reset_lever_width = lcdbox_top_reset_button_r*4;
lcdbox_top_reset_button_h = 7.75;

lcdbox_top_switch_offset = 10;
lcdbox_top_switch_r = 8;

lcdbox_knob_h = 15.15;
lcdbox_knob_r = 8;
lcdbox_knob_r2 = 6.5;
lcdbox_knob_inner_r = 3.1;
lcdbox_knob_inner_h = 11.5;

screw_m3		= [1.6,		2.84,	3,		"screw M3"];
screw_m4		= [2.15,		3.61,	4,		"screw M4"];
nut_m3			= [5.5,		3.04,	2.4,		6,	"nut M3"];
washer_m4		= [4.5,		0.8,		2.15,	"washer M4"];

extrusion_width = 20;
extrusion_screw_r	 = screw_m4[0];
extrusion_screw_head_h	 = screw_m4[2];
extrusion_washer_r = washer_m4[0];
extrusion_washer_h = washer_m4[1];

// #####################################################################################################################################

lcdbox_top();
*lcdbox_bottom();
*lcdbox_knob();
*translate([0,(nut_m3[0]+stable_wall*2)/2+1,0]) lcdbox_mount();
*translate([0,-extrusion_width/2-1,0]) lcdbox_mount_bottom();

// #####################################################################################################################################
module lcdbox_knob() {
	difference() {
		union() {
			fncylinder(r=lcdbox_knob_r+0.5, h=2.5);
			difference() {
				fncylinder(r=lcdbox_knob_r, r2=lcdbox_knob_r2, h=lcdbox_knob_h);
				for(i=[0:16]) hull() rotate([0,0,i*22.25]) {
					translate([lcdbox_knob_r,0,-1]) fncylinder(r=1, h=1);
					translate([lcdbox_knob_r2,0,lcdbox_knob_h]) fncylinder(r=lcdbox_knob_r2/lcdbox_knob_r, h=1);
				}
			}
		}
		translate([0,0,-1]) fncylinder(r=lcdbox_knob_inner_r+compensate, h=lcdbox_knob_inner_h+1);
		translate([0,0,lcdbox_knob_h-single_wall]) {
			difference() {
				fncylinder(r=lcdbox_knob_r2-single_wall*4, h=single_wall+1);
				fncylinder(r=lcdbox_knob_r2-single_wall*5, h=single_wall+1,enlarge=1);
			}
		}
	}
}

// #####################################################################################################################################
module lcdbox_mount_bottom() {
	difference() {
		union() {
			hull() {
				centercube([15+nut_m3[1]*2+2+compensate*2+stable_wall*2,extrusion_width,stable_wall],x=true,y=true);
					translate([0,0,(nut_m3[0]+stable_wall*2)/2+stable_wall+extrusion_screw_head_h+extrusion_washer_h+1]) rotate([0,90,0])
						fncylinder(r=(nut_m3[0]+stable_wall*2)/2,h=15+nut_m3[1]*2+2+compensate*2+stable_wall*2,center=true);
			}
		}
		translate([0,0,(nut_m3[0]+stable_wall*2)/2+stable_wall+extrusion_screw_head_h+extrusion_washer_h+1]) rotate([0,90,0])
			fncylinder(r=screw_m3[0],h=15+nut_m3[1]*2+2+compensate*2+stable_wall*2,center=true,enlarge=1);
		translate([0,0,stable_wall])
			centercube([15+nut_m3[1]*2+2+compensate*2,nut_m3[0]+stable_wall*2,(nut_m3[0]+stable_wall*2)/2+stable_wall+extrusion_screw_head_h+extrusion_washer_h+1],x=true,y=true);
		translate([0,0,stable_wall])
			centercube([15+nut_m3[1]*2+2+compensate*2,nut_m3[0]+stable_wall*2,(nut_m3[0]+stable_wall*2)/2+stable_wall+extrusion_screw_head_h+extrusion_washer_h+1],x=true);
		translate([0,0,(nut_m3[0]+stable_wall*2)/2+stable_wall+extrusion_screw_head_h+extrusion_washer_h+1]) rotate([0,90,0])
			fncylinder(r=(nut_m3[0]+stable_wall*2)/2+1,h=15+nut_m3[1]*2+2+compensate*2,center=true);
		for(i1=[-1,1]) translate([i1*lcd_backmount_holes_offset,0,0]) fncylinder(r=extrusion_screw_r+compensate,h=stable_wall,enlarge=1);

	}
}

module lcdbox_mount() {
	difference() {
		union() {
			centercube([15+nut_m3[1]*2+2,nut_m3[0]+stable_wall*2,extrusion_width/2+stable_wall],x=true,y=true);
			translate([0,0,extrusion_width/2+stable_wall]) rotate([0,90,0]) fncylinder(r=(nut_m3[0]+stable_wall*2)/2,h=15+nut_m3[1]*2+2,center=true);
		}
		translate([0,0,extrusion_width/2+stable_wall]) rotate([0,90,0]) fncylinder(r=screw_m3[0]+compensate,h=15+nut_m3[1]*2+2,center=true,enlarge=1);
		for(i1=[-1,1]) translate([i1*7.5,0,-1]) fncylinder(r=screw_m3[0]+compensate,h=extrusion_width/2+1);
		translate([0,0,stable_wall]) centercube([15+nut_m3[1]*2+4,nut_m3[0]+compensate*2,nut_m3[2]+1],x=true,y=true);
		translate([0,0,extrusion_width/2+stable_wall-nut_m3[1]-1]) centercube([nut_m3[2]+1,nut_m3[0]+compensate*2,(nut_m3[0]+stable_wall*2)/2+nut_m3[1]+2],x=true,y=true);
	}
}

// #####################################################################################################################################

module lcdbox_top() {
	difference() {
		union() {
			// center cube with cutout
			difference() {
				translate([-compensate*3-small_wall*2,-compensate*3-small_wall*2,0])
					centercube([lcd_width+compensate*6+small_wall*4,lcd_depth+compensate*6+small_wall*4,lcd_top_hight-normal_wall]);
				translate([-compensate*3-small_wall*2,-compensate*3-small_wall*2,0])
					filletring_diff([lcd_width+compensate*6+small_wall*4,lcd_depth+compensate*6+small_wall*4,lcd_top_hight-normal_wall],r=1);
				difference() {
					translate([-compensate*3-small_wall,-compensate*3-small_wall,normal_wall]) 
						centercube([lcd_width+compensate*6+small_wall*2,lcd_depth+compensate*6+small_wall*2,lcd_top_hight-normal_wall]);
					translate([-compensate*3-small_wall,-compensate*3-small_wall,normal_wall]) 
						filletring_diff([lcd_width+compensate*6+small_wall*2,lcd_depth+compensate*6+small_wall*2,lcd_top_hight-normal_wall],r=1);
				}
			}
			// mount posts
			for(i1=[	[lcd_mountoffset_sides,lcd_mountoffset_bottom],
						[lcd_width-lcd_mountoffset_sides,lcd_mountoffset_bottom],
						[lcd_mountoffset_sides,lcd_depth-lcd_mountoffset_sides],
						[lcd_width-lcd_mountoffset_sides,lcd_depth-lcd_mountoffset_sides]]) 
						translate(i1) fncylinder(r=lcd_mountoffset_sides+compensate+small_wall,h=lcdbox_topmount_hight);

			translate([lcdbox_top_reset_offset,lcdbox_top_bottomparts_offset,0])
				fncylinder(r=lcdbox_top_reset_button_r, r2=lcdbox_top_reset_button_r*2/3,h=lcdbox_top_reset_button_h+small_wall);
		}
		// sd card cut out
		translate([lcd_width+compensate*3+small_wall-1,lcd_sdcard_offset,lcd_sdcard_top_hight])
			centercube([small_wall+2,lcd_sdcard_depth,lcd_top_hight-normal_wall-lcd_sdcard_top_hight+1],y=true); 
		// mount holes
		for(i1=[	[lcd_mountoffset_sides,lcd_mountoffset_bottom,small_wall],
					[lcd_width-lcd_mountoffset_sides,lcd_mountoffset_bottom,small_wall],
					[lcd_mountoffset_sides,lcd_depth-lcd_mountoffset_sides,small_wall],
					[lcd_width-lcd_mountoffset_sides,lcd_depth-lcd_mountoffset_sides,small_wall]]) 
					translate(i1) fncylinder(r=lcd_self_tapping_screw_r-0.2+compensate,h=lcdbox_topmount_hight);
		// beeper hole
		translate([lcdbox_top_beeper_offset,lcdbox_top_bottomparts_offset,0]) fncylinder(r=1,h=normal_wall,enlarge=1); 
		translate([lcdbox_top_beeper_offset,lcdbox_top_bottomparts_offset,small_wall]) fncylinder(r=lcdbox_top_beeper_r,h=normal_wall); 
		// reset button cutout
		difference() {
			union() {
				translate([lcdbox_top_reset_offset,lcdbox_top_bottomparts_offset,0]) fncylinder(r=lcdbox_top_reset_button_r+compensate*2,h=normal_wall,enlarge=1);
				translate([lcdbox_top_reset_offset,lcdbox_top_bottomparts_offset,-1])
					centercube([lcdbox_top_reset_lever_width,lcdbox_top_reset_button_r*3/2+compensate*4,normal_wall+2],y=true);
			}
			difference() {
				union() {
					translate([lcdbox_top_reset_offset,lcdbox_top_bottomparts_offset,0]) fncylinder(r=lcdbox_top_reset_button_r,h=normal_wall,enlarge=2);
					translate([lcdbox_top_reset_offset,lcdbox_top_bottomparts_offset,-2])
						centercube([lcdbox_top_reset_lever_width+1,lcdbox_top_reset_button_r*3/2,normal_wall+4],y=true);
				}
				translate([lcdbox_top_reset_offset+lcdbox_top_reset_button_r,lcdbox_top_bottomparts_offset,small_wall])
					centercube([lcdbox_top_reset_lever_width+1,lcdbox_top_reset_button_r*3/2+single_wall*2,normal_wall+4],y=true);
			}
		}
		// rotary switch hole
		translate([lcdbox_top_switch_offset,lcdbox_top_bottomparts_offset,0]) fncylinder(r=lcdbox_top_switch_r,h=normal_wall,enlarge=1);
		// lcd cutout
		translate([lcd_width/2,lcd_depth-lcd_display_top_offset,-1]) {
			centercube([lcd_display_width+compensate*2,lcd_display_depth+compensate*2,normal_wall+2],x=true,y=true); 
			translate([0,0,1+small_wall]) 
				centercube([lcd_display_width_outer+compensate*2,lcd_display_depth_outer+compensate*2,normal_wall],x=true,y=true); 
		}
	}

}

// #####################################################################################################################################
module lcdbox_bottom() {
	difference() {
		union() {
			// bottom plate
			translate([-compensate*3-small_wall*2,-compensate*3-small_wall*2,0])
				centercube([lcd_width+compensate*6+small_wall*4,lcd_depth+compensate*6+small_wall*4,normal_wall]);
			// center cube with cutout
			difference() {
				translate([-compensate-small_wall,-compensate-small_wall,0])
					centercube([lcd_width+compensate*2+small_wall*2,lcd_depth+compensate*2+small_wall*2,lcdbox_bottom_hight]);
				translate([-compensate,-compensate,normal_wall]) centercube([lcd_width,lcd_depth,lcdbox_bottom_hight]);
			}
			// mount posts
			intersection() {
				union() for(i1=[	[lcd_mountoffset_sides,lcd_mountoffset_bottom],
								[lcd_width-lcd_mountoffset_sides,lcd_mountoffset_bottom],
								[lcd_mountoffset_sides,lcd_depth-lcd_mountoffset_sides],
								[lcd_width-lcd_mountoffset_sides,lcd_depth-lcd_mountoffset_sides]]) 
								translate(i1) fncylinder(r=lcd_mountholes_head_r+compensate+small_wall,h=lcdbox_bottommount_hight);
				translate([-compensate-small_wall,-compensate-small_wall,0])
					centercube([lcd_width+compensate*2+small_wall*2,lcd_depth+compensate*2+small_wall*2,lcdbox_bottom_hight]);
			}
			// sd card support
			translate([-compensate*3-small_wall*2,lcd_sdcard_offset,0])
				centercube([compensate*2+small_wall*2,lcd_sdcard_depth,lcdbox_bottommount_hight-lcd_sdcard_hight],y=true); 
		}
		// sockets cut out
		for(i1=[-1,1]) translate([lcd_width/2+i1*lcd_socket_offset_center,lcd_depth-lcd_socket_offset_top,-1])
			centercube([lcd_sockets_width,lcd_sockets_depth,stable_wall+2],x=true,y=true);
		// sd card cut out
		translate([-compensate*3-small_wall*2-1,lcd_sdcard_offset,lcdbox_bottommount_hight-lcd_sdcard_hight])
			centercube([compensate*3+small_wall*2+2,lcd_sdcard_depth+compensate*2,lcdbox_bottom_hight-lcdbox_bottommount_hight+lcd_sdcard_hight+1],y=true); 
		// mount holes
		for(i1=[	[lcd_mountoffset_sides,lcd_mountoffset_bottom],
					[lcd_width-lcd_mountoffset_sides,lcd_mountoffset_bottom],
					[lcd_mountoffset_sides,lcd_depth-lcd_mountoffset_sides],
					[lcd_width-lcd_mountoffset_sides,lcd_depth-lcd_mountoffset_sides]]) translate(i1) {
						fncylinder(r=lcd_mountholes_r+compensate,h=lcdbox_bottommount_hight,enlarge=1);
						difference() {
							translate([0,0,-1]) fncylinder(r=lcd_mountholes_head_r+compensate,h=lcd_mountholes_head_h+1);
							fncylinder(r=lcd_mountholes_r+compensate+single_wall,h=lcdbox_bottommount_hight,enlarge=1);
						}
					}
		// edge cuts
		for(i1=[	[0,0,lcdbox_bottommount_hight],
					[0,lcd_depth,lcdbox_bottommount_hight],
					[lcd_width,0,lcdbox_bottommount_hight],
					[lcd_width,lcd_depth,lcdbox_bottommount_hight]]) translate(i1) centercube([small_wall*3,small_wall*3,10],x=true,y=true); 

		// backmount holes
		for(i1=[-1,1]) translate([lcd_width/2+i1*lcd_backmount_holes_offset,lcd_mountoffset_bottom+10,0]) fncylinder(r=screw_m3[0]+compensate,h=stable_wall,enlarge=1);
	}
}

// #####################################################################################################################################
// a rewritten cylinder, with enlarge and dynamic fn
// 2015 cc by nc sa 4.0, Jons Collasius, Hamburg, Germany
module fncylinder(r,r2,d,d2,h,fn,center=false,enlarge=0,pi=3.1415926536){
	translate(center==false?[0,0,-enlarge]:[0,0,-h/2-enlarge]) {
		if (fn==undef) {
			if (r2==undef && d2==undef) {
				cylinder(r=r?r:d/2,h=h+enlarge*2,$fn=floor(2*(r?r:d/2)*pi/fnr));
			} else {
				cylinder(r=r?r:d/2,r2=r2?r2:d2/2,h=h+enlarge*2,$fn=floor(2*(r?r:d/2)*pi/fnr));
			}
		} else {
			if (r2==undef && d2==undef) {
				cylinder(r=r?r:d/2,h=h+enlarge*2,$fn=fn);
			} else {
				cylinder(r=r?r:d/2,r2=r2?r2:d2/2,h=h+enlarge*2,$fn=fn);
			}
		}
	}
}

// #####################################################################################################################################
// this cube can be centered on any axis
// 2015 cc by nc sa 4.0, Jons Collasius, Hamburg, Germany
module centercube(xyz=[10,10,10],x=false,y=false,z=false) {
	translate([x==true?-xyz[0]/2:0,y==true?-xyz[1]/2:0,z==true?-xyz[2]/2:0]) cube(xyz);
}

// #####################################################################################################################################
module filletring_diff(xyz, r, x=false, y=false, z=false) {
	translate([x==true?-xyz[0]/2:0,y==true?-xyz[1]/2:0,z==true?-xyz[2]/2:0]) union() {
		translate([0,xyz[1]/2,0]) rotate([0,45,0]) centercube([r*3,xyz[1],r*2],x=true,y=true,z=true);
		translate([xyz[0],xyz[1]/2,0]) rotate([0,-45,0]) centercube([r*3,xyz[1],r*2],x=true,y=true,z=true);

		translate([xyz[0]/2,0,0]) rotate([0,45,90]) centercube([r*3,xyz[0],r*2],x=true,y=true,z=true);
		translate([xyz[0]/2,xyz[1],0]) rotate([0,-45,90]) centercube([r*3,xyz[0],r*2],x=true,y=true,z=true);
	} 
}
