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

//$fn = 360;
e = 0.04; // epsilon

module rcube(size=[1,1,1], r=0) {
    hull()
        for(x=[0:1])
            for(y=[0:1])
                for(z=[0:1])
                    translate([
                              r + x * (width - d),
                              r + y * (length - d),
                              r + z * (height - d)])
                        sphere(r=r);
    width = size[0];
    length = size[1];
    height = size[2];
    d = r * 2;
}

saddle_length = 43;
thickness = 5;
min_thickness = 1;
lat_bar_length = 50;
bezel_depth = 11.5;
front_arm_thickness = 18.5;
bezel_width = 46;
front_arm_length = 67;
r = 5;
top_angle = 45;
top_length = 30;

full_saddle_length = saddle_length + 2 * front_arm_thickness;

module top_triangle() {
    hull() {
        translate([front_arm_thickness - r, -r, 0]) {
            cylinder(h=r, r=r);
            translate([my_saddle_length, 0, 0]) cylinder(h=r, r=r);
            translate([
                    (-top_length - 2*r) * cos(top_angle),
                    (-top_length - 2*r) * sin(top_angle), 0])
                cylinder(h=r, r=r);
        }
    }
    my_saddle_length = 2*r - saddle_length - 2 * front_arm_thickness;
}

module front_arm() {
    translate([front_arm_thickness - r, -r, 0]) hull() {
        cylinder(h=thickness, r=r);
        translate([2*r - front_arm_thickness, 0, 0]) cylinder(h=thickness, r=r);
        translate([2*r - front_arm_thickness, bezel_width + front_arm_thickness, 0]) cylinder(h=thickness, r=r);
    }
}

module bezel_hook() {
    translate([-bezel_depth, bezel_width, 0]) {
        cube([bezel_depth + r, front_arm_thickness, thickness]);
        hull() {
            cube([thickness, front_arm_thickness, thickness]);
            translate([0, 0, r-lat_bar_length])
                rotate([0, 90, 0]) cylinder(h=min_thickness, r=r);
        }
    }
}

module bracket() {
    top_triangle();
    front_arm();
    bezel_hook();
}

bracket();
