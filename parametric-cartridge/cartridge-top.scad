/*
 * Copyright ©2015 Laurence Gonsalves <laurence@xenomachina.com>
 *
 * Code licensed under the Creative Commons - Attribution - Share Alike license.
 * 
 * Thanks to Makerboost for their Commodore 64 Cartridge design.
 */

// TODO: fix weirdness in screw hole (bottom)
// TODO: make compatible with Thingiverse customizer

//HOLE_Y = 43.36;
HOLE_Y = 17.17 +.5*9;
TOP = false;
$fn=36;
HOLE_DIAMETER = 10;

module original() {
    // This translate moves the center hole to the origin
    if (TOP) {
        translate([0,.4,-10]) import("Cartridge_Embossed_TOP.stl", convexity=3);
    } else {
        translate([0,.4,10]) rotate([0, 180, 0]) import("Cartridge_Embossed_BOTTOM.stl", convexity=3);
    }
}

module post() {
    intersection (){
        union () {
            original();
            hull() {
                intersection (){
                    original();
                    cylinder(r=1.7, h=9);
                }
            }
        }
        cylinder(r=7, h=9);
    }
}

module hole() {
    difference (){
        cylinder(r1=1.6, r2=4, h=11);
        original();
    }
}

module blank() {
    module subst() {
        cube([17, 17, 20], center=true);
    }
    union() {
        // remove post
        difference(){
            original();
            subst();
        }
        // replace surface with surface from elsewhere
        intersection(){
            translate([0,17,0]) original();
            subst();
        }
    }
}

module extended_blank(len) {
    normal_len = 84;
    slice_start = -30;
    slice_len = 38;
    union() {
        // label end
        translate([0, len - normal_len, 0]) {
            intersection () {
                translate([-35, slice_start + slice_len, -3]) cube([70, 100, 15]);
                blank();
            }
        }

        // middle
        translate([0, slice_start, 0])
        scale([1, (len - normal_len + slice_len) / slice_len, 1])
        translate([0, -slice_start, 0])
        intersection () {
            translate([-35, slice_start, -3]) cube([70, slice_len, 15]);
            blank();
        }

        // port end
        intersection () {
            translate([-35, slice_start - 100, -3]) cube([70, 100, 15]);
            blank();
        }
    }
}

module main() {
    difference () {
        union() {
            extended_blank(64);
            translate([0, HOLE_Y - 43.36, 0])
                scale([HOLE_DIAMETER/5, HOLE_DIAMETER/5, 1])
                post();
        }
        translate([0, HOLE_Y - 43.36, 0])
            hole();
    }
}

main();
