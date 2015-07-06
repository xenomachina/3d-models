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

$fn = 360;
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
min_thickness = 5;
max_thickness = 40;
stand_thickness = 2;
bezel_width = 46;
top_angle = 45;
top_length = 30;

screw_r = 5/2;
r = 10.78 / 2; // must be greater than screw_r

shelf_depth = 18.5;
shelf_thickness = r*2;

// Measurements from your exercise machine.
bezel_depth = 11.5;

// This you can set based on the height of your tablets. The taller the safer,
// but the more material used, of course.
stand_height = 90;

// Set these based on the tablets you intend to use.
max_tablet_width = 230;
min_tablet_bottom_bezel = 9;
max_tablet_screen_width = 190;
max_tablet_thickness = 15;

// Maybe hull, otherwise union.
module mhull(condition) {
    if (condition) {
        hull() children();
    } else {
        union() children();
    }
}

module bracket() {
    module top(holes) {
        mhull(!holes) {
            translate([r,-r,0])
                cylinder(h=holes?max_thickness:min_thickness, r=holes?screw_r:r);
            translate([r - saddle_length, -r, 0])
                cylinder(h=min_thickness, r=holes?screw_r:r);
        }
        translate([r,-r,0])
            cylinder(h=max_thickness, r=holes?screw_r:r);

    }

    module front_arm() {
        hull() {
            // top
            translate([r , -r, 0])
                cylinder(h=min_thickness, r=r);
            // bottom
            translate([r , bezel_width, 0])
                cylinder(h=min_thickness, r=r);
        }
    }

    module bezel_hook() {
        module ridge() {
            hull(){
                translate([0,-r,0])
                    cylinder(r=screw_r, h=max_thickness);
                cylinder(r=screw_r, h=max_thickness);
            }
        }

        // front arc
        translate([0, bezel_width, 0]) {
            intersection() {
                cube([full_shelf_depth, shelf_thickness, max_thickness]);
                union() {
                    translate([full_shelf_depth - shelf_depth,0,0])
                        scale([shelf_depth, shelf_thickness, max_thickness]) cylinder();
                    cube([full_shelf_depth - shelf_depth, shelf_thickness, max_thickness]);
                }
            }
        }
        // front ridge
        translate([full_shelf_depth-screw_r,bezel_width,0]) ridge();
        translate([2*r - screw_r,bezel_width,0]) ridge();
        // back cube
        translate([-bezel_depth, bezel_width, 0]) {
            cube([bezel_depth, shelf_thickness, max_thickness]);
        }
        full_shelf_depth = shelf_depth + 2 * (r + screw_r);
    }

    union() {
        difference() {
            union() {
                top(false);
                front_arm();
                bezel_hook();
            }
            union() {
                top(true);
                translate([2*r - screw_r,bezel_width + shelf_thickness / 2,0]) 
                    cylinder(r=screw_r, h=max_thickness);
            }
        }
    }
}

//rotate([0, 0, -top_angle]) 
translate([0, 0, -max_thickness]) bracket();
