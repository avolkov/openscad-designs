/*
 * Saucer for tomato cans
 *
 * Project URL
 * https://github.com/avolkov/openscad-designs/tomato-can-saucer
 *
 * Copyright 2021 Alex Volkov <alex@flamy.ca>
 * License: Attribution-ShareAlike 4.0 International (CC BY-SA)
 * https://creativecommons.org/licenses/by-sa/4.0/
 *
 * Version 1.0 2021-04-05 Initial publication
 */


$fn=100;
inner_radius = 53;
saucer_height = 25;
bottom_thick = 1.5;
top_offset = 8;
side_thick = 2;
difference(){
        union(){
            cylinder(h=bottom_thick, r1=inner_radius, r2=inner_radius);
            cylinder(
                h=saucer_height,
                r1=inner_radius+side_thick,
                r2=inner_radius+top_offset + side_thick);
        }
        translate([0,0,bottom_thick])
            cylinder(h=saucer_height - bottom_thick , r1=inner_radius, r2=inner_radius+top_offset);
    }