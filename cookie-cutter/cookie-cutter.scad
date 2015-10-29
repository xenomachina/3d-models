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

$fn=360;

// Full height of cookie cutter.
HEIGHT = 10;

// Rim around top for grip and stability.
RIM_HEIGHT = 2;
RIM_WIDTH = 10;

// The blade actualld does the cutting.
BLADE_THICKNESS = 2;

// The bevel is what makes the blade sharp(ish).
BEVEL_HEIGHT = HEIGHT / 2;
BEVEL_STEPS = 10;

module outline() {
    import(file="drawing.dxf");
}

module offset_outline(r){
    offset(delta=r, r=r) outline();
}

module main() {
    difference(){
        union(){
            // rim 
            linear_extrude(RIM_HEIGHT) offset_outline(RIM_WIDTH);

            // blade
            for(q=[0:1/BEVEL_STEPS:1])
                linear_extrude(HEIGHT-BEVEL_HEIGHT*q)
                    offset_outline(BLADE_THICKNESS * q);
        }

        // cut-out interior
        linear_extrude(HEIGHT) outline();
    }
}

main();
