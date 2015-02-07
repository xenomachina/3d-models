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

/*
 * Single-piece stand for "slim" PlayStation 2. Styling tries to mimic the
 * styling of the PS2 slim. The design attempts to minimize overhang, and
 * provide both good airflow and solid support to PS2.
 *
 * Linear measurements are in millimetres.
 *
 * PlayStation and PS2 are trademarks or registered trademarks of Sony Computer
 * Entertainment Inc. The author of this file has no affiliation with Sony
 * Computer Entertainment Inc.
 */
ps2_thickness = 28; // Includes rubber feet.
ps2_top_thickness = 15; // the layer that juts out on the front and top.
ps2_ridge_thickness = 2.85; // thickness of 3 cosmetic ridges on top layer.
ps2_ridge_height = 2.45; // height of 3 cosmetic ridges on top layer.
ps2_length = 150; // Length from front to back.

module stand(
    leg_width,
    leg_height,
    leg_thickness,
    base_length,
    base_height
){
    module leg(width, height, thickness) {
        cube(size=[width * 2 + ps2_thickness, thickness, height], center=true);
    }

    base_width = ps2_thickness + ps2_ridge_thickness * 2;

    difference() {
        union() {
            // back leg
            translate([0, base_length / 2 - leg_thickness, 0]) leg(leg_width, leg_height, leg_thickness);

            // front leg
            translate([0, -(base_length / 2 - leg_thickness), 0]) leg(leg_width, leg_height, leg_thickness);

            translate([0, 0, -(base_height * 2)]) cube([base_width, base_length, base_height], center=true);
        }

        // slot for PS2 to fit into
        translate([0, 0, base_height - ps2_ridge_height]) cube(size=[ps2_thickness, ps2_length, leg_height], center=true);
    }
}

stand(
  60,                   // leg_width
  100,                  // leg_height
  ps2_top_thickness,    // leg_thickness
  ps2_length - 20,      // base_length
  20                    // base_height
);
