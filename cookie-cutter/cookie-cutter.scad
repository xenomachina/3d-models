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

// Turns a (dxf) 2D outline into a cookie cutter. The model is intentionally
// "upside-down", as this completely eliminates overhangs, making for a really
// easy print.
//
// See README.md for detailed instructions on using this.

$fn=12;

// Full height of cookie cutter.
HEIGHT = 10;

// Rim around top for grip and stability.
RIM_HEIGHT = 2;
RIM_WIDTH = 10;

// The blade actually does the cutting.
BLADE_THICKNESS = 2;

// The bevel is what makes the blade sharp(ish).
BEVEL_HEIGHT = (HEIGHT - RIM_HEIGHT) * .9;
BEVEL_STEPS = 10;

DXF_FILE = "drawing.dxf";

// This is to work around https://bugs.launchpad.net/inkscape/+bug/1643383
// Create a 100mm square, export as dxf, and then reimport into Inkscape.
// Record the new size (in mm) here:
INKSCAPE_BUG_1643383 = 106.371;

module blade() {
    union() {
        translate([0,0,HEIGHT - BEVEL_HEIGHT])cylinder(h=BEVEL_HEIGHT, r1=BLADE_THICKNESS, r2=0);
        cylinder(h=HEIGHT - BEVEL_HEIGHT, r1=BLADE_THICKNESS, r2=BLADE_THICKNESS);
        cylinder(h=RIM_HEIGHT, r1=RIM_WIDTH, r2=RIM_WIDTH);
    }
}

module outline() {
    scale(100/INKSCAPE_BUG_1643383)
    mirror() import(file=DXF_FILE);
}

EPSILON = 0.01;

module main() {
    difference(){
        minkowski(){
            linear_extrude(EPSILON) outline();
            blade();
        }

        // cut-out interior
        linear_extrude(HEIGHT + EPSILON) outline();
    }
}

main();
