/*
 * Taken from BU21-VS240 bear upgrade technical drawing
 * Bear Frame 2.1 Upgrade Aluminium Extrusion rev 1.0
 */


gap_thick = 1.8;
gap_cover = 5.5;
gap_len = 6.25;

offset = (gap_cover * 2 - gap_len)/2;
polygon(points=[
        [0,0],
        [gap_thick,offset],
        [gap_thick, gap_len],
        [0, gap_len + offset]
    ]
);