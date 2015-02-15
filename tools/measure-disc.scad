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
 * A collection of small discs, possibly useful for measuring the inside
 * diameter of things (particularly rounded rectangles, where it's hard to take
 * a measurement with calipers).
 *
 * Linear measurements are in millimetres.
 */

$fn = 360;
module measure_disc(diameter) {
    translate([x, y, 0])
    difference() {
        cylinder(r=r, h=1);

        for (i=[1:diameter]) {
            translate([
                    sin(360 * i / diameter) * (r-3+(i%2)),
                    cos(360 * i / diameter) * (r-3+(i%2)),
                    .4])
                cylinder(r=.5, h=1);
        }
        text("hello");
    }
    r=diameter/2;

    x = (diameter - min_diameter)  % per_row * (max_diameter + spacing);
    y = floor((diameter - min_diameter) / per_row) * (max_diameter + spacing);
}

for(d=[min_diameter:max_diameter]) measure_disc(d);

max_diameter = 22;
min_diameter = 8;
per_row = 5;
spacing = 2;
