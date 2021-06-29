/*
 * Taken from BU21-VS240 bear upgrade technical drawing
 * Bear Frame 2.1 Upgrade Aluminium Extrusion rev 1.0
 */


gap_thick = 1.8;
gap_wide = 7.22;
gap_narrow = 6.25;

gap_offset = (gap_wide  - gap_narrow)/2;
polygon(points=[
        [0,0],
        [gap_thick, gap_offset],
        [gap_thick, gap_narrow + gap_offset],
        [0, gap_wide]
    ]
);