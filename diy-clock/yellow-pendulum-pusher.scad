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

/* This is a replacement part for a "Do-It-Yourself Clock My First Clock" kit.
 * In our kit this part was yellow, and its job was to push the pendulum. The
 * small rod snapped off of ours, so this is an attempt at a replacement part.
 */

$fn = 36;

ring_dialmeter = 8;
square_hole_length = 4;
main_thickness = 3.01;
main_width = 3.18;
main_length = 43.89;
rod_diameter = 2.4;
rod_length = 18.75;

module pendulum_pusher() {
    difference() {
        union() {
            cylinder(d=ring_dialmeter, h=main_thickness);
            translate([square_hole_length/2, -main_width/2, 0])
                cube([main_length - (square_hole_length + ring_dialmeter + main_width)/2,
                     main_width, main_thickness]);
            translate([main_length - (ring_dialmeter + main_width)/2, 0, 0]) {
                cylinder(d=rod_diameter, h=rod_length);
                cylinder(d=main_width, h=main_thickness);
            }

        }
        translate([-square_hole_length/2, -square_hole_length/2, 0])
            cube([square_hole_length, square_hole_length, main_thickness]);
    }
}

pendulum_pusher();
