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

$fn=36;
module octo_ball(r) {
    module chunk() {
        difference() {
            sphere(r);
            translate([0,0,+(r*sqrt(2))]) rotate([0,45,0]) cube(r*2, center=true);
            translate([0,0,-(r*sqrt(2))]) rotate([0,45,0]) cube(r*2, center=true);

            translate([0,0,+(r*sqrt(2))]) rotate([0,45,90]) cube(r*2, center=true);
            translate([0,0,-(r*sqrt(2))]) rotate([0,45,90]) cube(r*2, center=true);
        }
    }
    union() {
        rotate([90,0,0]) chunk();
        chunk();
        rotate([0,90,0]) chunk();
    }
}

// A little demo of octo_ball showing how the polys line up with axis-aligned
// cylinders 
union() {
    octo_ball(50);
    cylinder(h=50, r=50);
    rotate([90,0,0]) cylinder(h=50, r=50);
    rotate([0,90,0]) cylinder(h=50, r=50);
}
