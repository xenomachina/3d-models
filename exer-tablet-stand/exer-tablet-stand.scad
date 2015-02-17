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
phi = (1 + sqrt(5)) / 2;

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
bracket_thickness = 7;
stand_thickness = 2;
front_arm_thickness = 18.5;
bezel_width = 46;
front_arm_length = 67;
r = 5;
top_angle = 45;
top_length = 30;
screw_r = 2;

// Measurements from your exercise machine.
bezel_depth = 11.5;

// This you can set based on the height of your tablets. The taller the safer,
// but the more material used, of course.
stand_height = 90;

// Set these based on the tablets you intend to use.
max_tablet_width = 230;
min_tablet_bottom_bezel = 9;
min_tablet_screen_width = 190;
max_tablet_thickness = 15;

full_saddle_length = saddle_length + 2 * front_arm_thickness;

module top_triangle() {
    hull() {
        translate([front_arm_thickness - r, -r, 0]) {
            cylinder(h=bracket_thickness, r=r);
            translate([my_saddle_length, r-front_arm_thickness/2, 0])
                cylinder(h=bracket_thickness, r=front_arm_thickness/2);
            translate([
                    (-top_length - 2*r) * cos(top_angle),
                    (-top_length - 2*r) * sin(top_angle), 0])
                cylinder(h=bracket_thickness, r=r);
        }
    }
    my_saddle_length = 2*r - saddle_length - 2 * front_arm_thickness;
}

module top() {
    difference() {
        top_triangle();
        translate([-saddle_length, 0, 0]) {
            rotate([0, 0, top_angle]) {
                translate([-front_arm_thickness/2, -front_arm_thickness/2, -e])
                    cylinder(r=screw_r, h=bracket_thickness+2*e);
            }
        }
    }
    peak_x = front_arm_thickness - r + (-top_length - 2*r) * cos(top_angle);
}

module front_arm() {
    translate([front_arm_thickness - r, -r, 0]) hull() {
        cylinder(h=bracket_thickness, r=r);
        translate([2*r - front_arm_thickness, 0, 0]) cylinder(h=bracket_thickness, r=r);
        translate([2*r - front_arm_thickness, bezel_width + front_arm_thickness, 0]) cylinder(h=bracket_thickness, r=r);
    }
}

module bezel_hook() {
    translate([-bezel_depth, bezel_width, 0]) {
        cube([bezel_depth + r, front_arm_thickness, bracket_thickness]);
    }
}

module bracket() {
    top();
    front_arm();
    bezel_hook();
}

module stand() {
    translate([-stand_depth/2 - stand_thickness, -stand_height, 0]) {
        difference() {
            cube([stand_depth, stand_height, stand_width]);
            union() {
                translate([stand_thickness, -e, stand_thickness]) {
                    cube([stand_depth - 2*stand_thickness + e,
                         stand_height - stand_thickness + e, 
                         stand_width - 2*stand_thickness + e]);
                    cube([stand_depth - stand_thickness + e,
                         stand_height - stand_thickness - stand_flange_height + e, 
                         stand_width - 2*stand_thickness + e]);
                    translate([0, 0,
                              (stand_width - min_tablet_screen_width) / 2 - stand_thickness])
                    cube([stand_depth - stand_thickness + e,
                         stand_height - stand_thickness - min_tablet_bottom_bezel + e, 
                         min_tablet_screen_width]);
                }
            }
        }
    }
    stand_width = max_tablet_width + stand_thickness * 2;
    stand_flange_height = stand_height / phi;
    stand_depth = max_tablet_thickness + stand_thickness * 2;
}

rotate([0, 0, -top_angle]) translate([0, 0, -bracket_thickness]) bracket();
render(convexity=2) stand();
