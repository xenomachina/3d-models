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


$fn = 72;
epsilon = 0.001;

depth = 56;
height = 30;
phi = (1 + sqrt(5)) / 2;
width = height * phi;
zip_tie_width = 6;
zip_tie_thickness = 1.5;
bottom_thickness = 3; // must be > zip_tie_thickness
zip_tie_offset = 15.5;

module main() {
    // The device bracket will rest on.
    %translate([width,0,0]) cube([12*254, depth, height]);

    difference() {
        union() {
            // "Side" bracket
            cube([width, depth, height]);

            // "Bottom" with zip tie slot
            translate([0,0,-bottom_thickness]) 
            difference(){
                cube([width + zip_tie_offset + 2*zip_tie_width, depth, bottom_thickness]);
                translate([width + zip_tie_offset,0,0])
                    cube([zip_tie_width, depth, zip_tie_thickness]);
            }
        }

        union() {
            // Arc cut-out
            translate([0,0,height])
                scale([width - 1, depth + epsilon, height])
                rotate([270,0,0])
                cylinder(r=1,h=1);

            // Screw holes
            for(i=[1,3]){
                translate([width/2, depth/4 * i, 0]) {
                    // screw head
                    cylinder(r=7.5, h=height);
                    // screw shaft
                    translate([0,0,-bottom_thickness]) cylinder(r=3.7, h=height);
                }
            }
        }
    }

}

rotate([90,0,0]) main();
