/*
 * Henry's razor base to safety razor adapter
 *
 * Project URL
 * https://github.com/avolkov/openscad-designs/
 *
 * Copyright 2021 Alex Volkov <alex@flamy.ca>
 * License: Attribution-ShareAlike 4.0 International (CC BY-SA)
 * https://creativecommons.org/licenses/by-sa/4.0/
 *
 * Version 1.0 2021-04-05 Initial publication
 */

$fn=50;
cyl_h=10;
difference(){
    cylinder(d=16.5, h=cyl_h);
    cylinder(d=13, h=cyl_h);
}