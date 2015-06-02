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

// Measurements from original part.
shaft_diameter = 6.87;
shaft_length = 8.35;
above_ridge_length = 1.93;
below_ridge_length = 5.08;
gripper_length = 7.03;
gripper_width = 9.24;
gripper_depth = 7.05;
gripper_corner_radius = 2.5;
gripper_inner_diameter = 5.15;
shaft_inner_diameter = 2.31;
gripper_inner_height = 0.97;
gripper_opening_width = 4.00;

//This was just eye-balled.
egg_factor = 1.5;

// Calculated measurements.
gripper_opening_height = gripper_length - gripper_inner_height -
    gripper_inner_diameter/2;
ridge_radius = (shaft_length - above_ridge_length - below_ridge_length)/2;

// Cruft.
e = 0.01;
$fn = 72;

module top_rounded_cube(w,d,h,r) {
    rotate([0,90,0]) {
        translate([r-h, r, 0]) cylinder(r=r, h=w);
        translate([r-h, d-r, 0]) cylinder(r=r, h=w);
    }
    cube([w,d,h-r]);
    translate([0,r,0]) cube([w,d-r-r,h]);
}

module torus(r1, r2) {
    rotate_extrude(convexity = 10)
        translate([r1, 0, 0])
            circle(r=r2);
}
module cycube(w,d,h) {
    translate([-w/2,-d/2,0]) cube([w,d,h]);
}

module main() {
    difference() {
        union() {
            cylinder(d=shaft_diameter, h=shaft_length);
            translate([0,0,below_ridge_length + ridge_radius])
                torus(shaft_diameter/2, ridge_radius);

            translate([0,0,shaft_length]) {
                difference() {
                    translate([-gripper_width/2,-gripper_depth/2,0])
                        top_rounded_cube(gripper_width,gripper_depth,gripper_length,gripper_corner_radius);
                    union() {
                        rotate([90,0,0]) {
                            union() {
                                translate([0,gripper_inner_height+gripper_inner_diameter/2,-gripper_depth/2])
                                    cylinder(d=gripper_inner_diameter, h=gripper_depth + e);
                                // The gripper's hole isn't quite cylindrical.
                                // The part closer to the opening is stretched,
                                // making the profile somewhat egg-shaped. This
                                // makes the elliptical "pointy end" of that
                                // egg-shape.
                                translate([0,gripper_inner_height+gripper_inner_diameter/2,-gripper_depth/2]) {
                                    difference() {
                                        scale([1,egg_factor,1])
                                            cylinder(d=gripper_inner_diameter, h=gripper_depth + e);
                                        translate([0,0,gripper_depth/2])
                                            rotate([90,0,0])
                                            cycube(gripper_width,gripper_depth,gripper_inner_diameter*egg_factor);
                                    }
                                }
                            }
                        }
                        translate([-gripper_opening_width/2,-gripper_depth/2,gripper_length-gripper_opening_height])
                            cube([gripper_opening_width,gripper_depth,gripper_opening_height]);
                    }
                }
            }
        }
        cylinder(d=shaft_inner_diameter, h=shaft_length + gripper_length);
    }
}

// Rotate it to lay on the bed to maximize gripper's strength.
rotate([90,0,0]) main();
