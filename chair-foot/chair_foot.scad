/*
 * Chair foot/peg for a certain chairs sold in supermarkets in Canada
 * Outer diameter of metal tube is 16mm inner diameter 12mm
 * This is s press-fit part so you may need to use a hammer or other tool to nudge it in
 * If the printed part doesn't fit (mostly due to printer resolution), decrease ball_support diameter.
 * This part should print fine on rough settings, but do use at least 4 vertical shells.
 *
 * License: Attribution-ShareAlike 4.0 International (CC BY-SA)
 * https://creativecommons.org/licenses/by-sa/4.0/
 * Copyright Alex Volkov <alex@flamy.ca>
*/
inner_diameter = 12.1;
outer_diameter = 19;
ball_support_diameter = inner_diameter+ 0.1;
$fn=50; // Smooth faces, slow performance

difference() {
    union(){
        cylinder(h=4, d=outer_diameter);
        cylinder(h=6, d=inner_diameter);
        translate([0, 0, 9]) sphere(d=ball_support_diameter);
        translate([0, 0, 19]) sphere(d=ball_support_diameter);
        
    }
    translate([-10, -0.5, 6])cube([20, 1, 20]);
}