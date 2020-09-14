/*
 * Copyright ©2015 Laurence Gonsalves <laurence@xenomachina.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to:
 *   Free Software Foundation, Inc.
 *   51 Franklin Street, Fifth Floor
 *   Boston, MA  02110-1301
 *   USA
 */

// TODO: add some sort of "keying" between top and bottom halves, so that they
// don't slide around if screws are missing
// TODO: angle key cutouts on bottom edges by about 11°

FLANGE_DIMENSIONS = [385, 126, 2.2];
NEAR_FLANGE_OFFSET = 13;
KEYBASE_DIMENSIONS = [385, 101, 21];

$fn=36;

KEY_CUTOUT_MAIN_WIDTH = 305.5;
KEY_CUTOUT_ROW_HEIGHT = 78/4;
KEY_CUTOUT_ROW_3_OFFSET = 5;
KEY_CUTOUT_SPACE_OFFSET = 52;
KEY_CUTOUT_SPACE_WIDTH = 173;
KEY_CUTOUT_FKEY_WIDTH = 30.44;
KEY_CUTOUT_FKEY_GAP = 21; // on top row
KEY_CUTOUT_X_OFFSET = 2.1;
KEY_CUTOUT_Y_OFFSET = 2.5; // between "top" row and keybase top
KEY_CUTOUT_HEIGHT = 20; // tall enough for key clearance

FKEY_EXTRA = 22; // that weird extra gap to the right of the f-keys
EPSILON = 0.02;

OCT = 9;
SKIN = 2;
BOTTOM_POST_HEIGHT = 2 * SKIN;
WIDTH = KEYBASE_DIMENSIONS[0] + KEY_CUTOUT_FKEY_GAP + 2*OCT + 4*SKIN;
DEPTH = FLANGE_DIMENSIONS[1] + 2*OCT + 2*SKIN;
HEIGHT = KEYBASE_DIMENSIONS[2] + SKIN + BOTTOM_POST_HEIGHT;

echo("WIDTH= ", WIDTH);
echo("HEIGHT=", HEIGHT);
echo("DEPTH= ", DEPTH);

SCREW_Y_EDGE_OFFSET = 6; // same distance from top and bottom edges of flange
SCREW_TOP_X_OFFSETS =    [34.5, 97.5, 142, 243, 287, 351];
SCREW_BOTTOM_X_OFFSETS = [34.5, 97.5, 161, 224, 287, 351];
SCREW_TAP_R = 3.0/2;
SCREW_HOLE_R = 4.65/2;

// these are intentionally larger to provide clearance
SCREW_HEAD_HEIGHT = 2.5;
SCREW_HEAD_WIDTH = 7.5;

BADGE_WIDTH = 77;
BADGE_HEIGHT = 12;
BADGE_Y_OFFSET = (FLANGE_DIMENSIONS[1] - NEAR_FLANGE_OFFSET -
    KEY_CUTOUT_Y_OFFSET - KEY_CUTOUT_ROW_HEIGHT * 4 - BADGE_HEIGHT) /2 + SKIN;
BADGE_DEPTH = .8;

PORT_WIDTH =
    // this brings it right up to the flange corner
    WIDTH - KEYBASE_DIMENSIONS[0] - 2*OCT 
    // and this brings it to the center of the first screw
    + SCREW_TOP_X_OFFSETS[0]
    // and this brings it back to the endge of the screw's post
    - SCREW_Y_EDGE_OFFSET - SKIN;
echo("port opening= ", PORT_WIDTH - 2*SKIN);

module cutout() {
    union() {
        cube(FLANGE_DIMENSIONS);
        translate([0, NEAR_FLANGE_OFFSET, 0])
            cube(KEYBASE_DIMENSIONS);

        translate([
                  KEY_CUTOUT_X_OFFSET,
                  NEAR_FLANGE_OFFSET + KEYBASE_DIMENSIONS[1] - KEY_CUTOUT_Y_OFFSET,
                  KEYBASE_DIMENSIONS[2]])
            // flip y-axis
            scale([1,-1,1]) {
                // rows 1 & 2
                translate([KEY_CUTOUT_ROW_3_OFFSET, 0, 0])
                    cube([KEY_CUTOUT_MAIN_WIDTH, KEY_CUTOUT_ROW_HEIGHT * 2 + EPSILON, KEY_CUTOUT_HEIGHT]);
                // rows 3 & 4
                translate([0, KEY_CUTOUT_ROW_HEIGHT * 2, 0])
                    cube([KEY_CUTOUT_MAIN_WIDTH, KEY_CUTOUT_ROW_HEIGHT * 2 + EPSILON, KEY_CUTOUT_HEIGHT]);
                // spacebar
                translate([KEY_CUTOUT_SPACE_OFFSET, KEY_CUTOUT_ROW_HEIGHT*4, 0])
                    cube([KEY_CUTOUT_SPACE_WIDTH, KEY_CUTOUT_ROW_HEIGHT, KEY_CUTOUT_HEIGHT]);
                // function keys
                fkey_x = KEY_CUTOUT_ROW_3_OFFSET + KEY_CUTOUT_MAIN_WIDTH + KEY_CUTOUT_FKEY_GAP;
                translate([fkey_x, 0, 0])
                    cube([KEY_CUTOUT_FKEY_WIDTH, KEY_CUTOUT_ROW_HEIGHT * 4, KEY_CUTOUT_HEIGHT]);

                // badge
                translate([fkey_x + KEY_CUTOUT_FKEY_WIDTH - BADGE_WIDTH,
                    KEY_CUTOUT_ROW_HEIGHT * 4 + BADGE_Y_OFFSET,
                    SKIN-BADGE_DEPTH])
                    cube([BADGE_WIDTH, BADGE_HEIGHT, HEIGHT]);
            }
    }
}

module post() {
    // top post
    cylinder(r = SKIN + SCREW_HOLE_R, h = HEIGHT);

    // reinforcement
    // the z on this translation is a bit of a hack, but it gets us above the
    // center seam
    translate([-SKIN/2, 0, KEYBASE_DIMENSIONS[2]+FLANGE_DIMENSIONS[2]-HEIGHT/2])
        cube([SKIN, DEPTH, HEIGHT]);

    // bottom post
    scale([1, 1, -1])
        cylinder(r = SCREW_HEAD_WIDTH/2 + SKIN, h = HEIGHT);
}

module screw_holes() {
    cylinder(r = SCREW_TAP_R, h = KEYBASE_DIMENSIONS[2]);
    scale([1, 1, -1]) {
        cylinder(r = SCREW_HOLE_R, h = HEIGHT);
        translate([0, 0, SKIN])
            cylinder(r = SCREW_HEAD_WIDTH/2, h = HEIGHT);
    }
}


// creates an (irregular variant of a) rhombicuboctahedron, the shape of the
// Commodore 64GS case
module octo(x, y, z, o) {
    hull() {
        translate([0, o, o]) cube([x      , y - 2*o, z - 2*o]);
        translate([o, 0, o]) cube([x - 2*o, y      , z - 2*o]);
        translate([o, o, 0]) cube([x - 2*o, y - 2*o, z      ]);
    }
}

// Creates a rounded "skin" around its child objects
module bounds(thickness) {
    minkowski() {
        union() children();
        sphere(r=thickness);
    }
}

module skin(thickness) {
    difference() {
        bounds(thickness) children();
        union() children();
    }
}

module place_posts() {
    for (x = SCREW_TOP_X_OFFSETS) {
        translate([x, FLANGE_DIMENSIONS[1] - SCREW_Y_EDGE_OFFSET, 0]) union() children();
    }
    for (x = SCREW_BOTTOM_X_OFFSETS) {
        translate([x, SCREW_Y_EDGE_OFFSET, 0]) union() scale([1, -1, 1]) children();
    }
}

KEYBASE_TRANSLATION = [
            KEY_CUTOUT_FKEY_GAP + OCT + 2*SKIN,
            OCT,
            HEIGHT - SKIN - KEYBASE_DIMENSIONS[2] - EPSILON
        ];

module case() {
    intersection () {
        difference() {
            union() {
                translate([0, 0, SKIN]) skin(SKIN) difference() {
                    octo(WIDTH-SKIN*2, DEPTH-SKIN*2, HEIGHT - SKIN*2, OCT);
                    translate([OCT, DEPTH - OCT - 2*SKIN + EPSILON, -SKIN])
                        cube([
                            PORT_WIDTH,
                            OCT,
                            HEIGHT - OCT - SKIN]);

                }
                translate(KEYBASE_TRANSLATION) place_posts() post();

                // block above ports to act as printing supprt
                translate([OCT, DEPTH - OCT - 2*SKIN , HEIGHT - OCT - 1.5 * SKIN]) {
                    cube([PORT_WIDTH, OCT, HEIGHT]);
                    translate([0, 0, -SKIN]) cube([PORT_WIDTH, SKIN, HEIGHT]);
                }
            }
            union() {
                translate(KEYBASE_TRANSLATION) cutout();
                translate(KEYBASE_TRANSLATION) place_posts() screw_holes();
            }
        }

        translate([0, 0, SKIN]) bounds(SKIN) octo(WIDTH-SKIN*2, DEPTH-SKIN*2, HEIGHT - SKIN*2, OCT);
    }
}
module top_region() {
    union() {
        // top half
        translate([-SKIN, -SKIN, HEIGHT/2]) cube([WIDTH+2*SKIN, DEPTH+2*SKIN, HEIGHT]);

        // include anything above keyboard's bottom (particulary the flanges)
        // as being in the top region.
        translate(KEYBASE_TRANSLATION)
            translate([0, EPSILON, EPSILON])
            cube([FLANGE_DIMENSIONS[0], FLANGE_DIMENSIONS[1] - 2*EPSILON, HEIGHT]);
    }
}

module main() {
    //top
    intersection() {
        case();
        top_region();
    }

    //bottom
    translate([0, 0, -.25])
    difference() {
        case();
        top_region();
    }
}

// test chunk of right side. Good enough for verifying key cutout placement
module test_right() {
    difference() {
        main();
        translate([-SKIN, -SKIN, -SKIN])
        cube([WIDTH - 90+ 4*EPSILON, DEPTH+ 4*EPSILON, HEIGHT+ SKIN]);
    }
}

main();
