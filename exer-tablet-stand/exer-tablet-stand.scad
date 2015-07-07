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

// Width of area stand will be mounted in. This is the interior width of the
// bezel on the exercise machine.
total_width = 228;

// This is the size of the gap between the two halves of the shelf, so you want
// it to be less than the width of the narrowest tablet you plan on using.
min_tablet_width = 170;

// Increasing this increases strength. It should be no greater than
// shelf_width.
min_thickness = 5;

// The length from front to back over the top of the exercise machine's screen.
// This does not to be precise, but should probably be within a cm or or so of
// the actual screen depth.
saddle_length = 53;

// Height of top part of exercise machine's bezel.
bezel_height = 46;

// How "thick" the exercise machine's bezel is. If this is zero (ie: bezel is
// flush with display) then you may need to use double-sided tape for
// additional support, as this design expects to be able to "hook onto" the
// bezel.
bezel_depth = 9.5;

// Radius of holes for threaded rod.
screw_r = 5/2;

// Radius on (most) corners. This also determines the width of the support
// arms. (They'll be twice r.)
r = 10.78 / 2; // must be greater than screw_r

// This should be greater than the thickness of the thickest tablet you plan on
// using (including it's case).
shelf_depth = 18.5;

// Increasing this adds strength.
shelf_thickness = r*2;

// This you can set based on the height of your tablets. The taller the safer,
// but the more material used, of course.
stand_height = 90;

shelf_width = (total_width - min_tablet_width) / 2;

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
                cylinder(h=holes?shelf_width:min_thickness, r=holes?screw_r:r);
            translate([r - saddle_length, -r, 0])
                cylinder(h=min_thickness, r=holes?screw_r:r);
        }
        translate([r,-r,0])
            cylinder(h=shelf_width, r=holes?screw_r:r);

    }

    module front_arm() {
        hull() {
            // top
            translate([r , -r, 0])
                cylinder(h=min_thickness, r=r);
            // bottom
            translate([r , bezel_height, 0])
                cylinder(h=min_thickness, r=r);
        }
    }

    module bezel_hook() {
        module ridge(h) {
            hull(){
                translate([0,-h,0])
                    cylinder(r=screw_r, h=shelf_width);
                cylinder(r=screw_r, h=shelf_width);
            }
        }

        // front arc
        translate([0, bezel_height, 0]) {
            intersection() {
                cube([full_shelf_depth, shelf_thickness, shelf_width]);
                union() {
                    translate([full_shelf_depth - shelf_depth,0,0])
                        scale([shelf_depth, shelf_thickness, shelf_width]) cylinder();
                    cube([full_shelf_depth - shelf_depth, shelf_thickness,
                    shelf_width]);
                }
            }
        }
        // front ridge
        translate([full_shelf_depth-screw_r,bezel_height,0]) ridge(2.5*r);
        translate([2*r - screw_r,bezel_height,0]) ridge(r);
        // back cube
        translate([-bezel_depth, bezel_height, 0]) {
            cube([bezel_depth, shelf_thickness, shelf_width]);
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
                translate([2*r - screw_r,bezel_height + shelf_thickness / 2,0]) 
                    cylinder(r=screw_r, h=shelf_width);
            }
        }
    }
}

translate([0, 0, -shelf_width]) bracket();
