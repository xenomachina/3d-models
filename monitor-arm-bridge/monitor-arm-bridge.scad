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

//////////////////////////////////////////////////////////////////////////////
// NOTE: I haven't actually printed this yet, so it's a completely untested
// design.
//
// I have two Monoprice monitor stands that each have a vertical shaft that
// mounts onto the desk. My desk has a cable port in the center, so rather than
// have the stands mounted centered under their respective monitor, I have them
// mounted on either side of this port. This off-center placement means the two
// stands tend to bow away from each other slightly, but noticeably.
//
// This design is a "bridge" that goes between the two monitor stands. It would
// be held in place by cable ties. There is a "tunnel" through the center for
// cable management.
//
// As mentioned earlier, I have not printed this yet. For now I'm just using
// cable ties, which prevents the bowing, but it does mean that my monitors can
// wobble a tiny bit (mostly noticeable from the webcam mounted on top of one
// of my monitors., so I may end up printing this after all, as it should make
// the setup a lot more rigid than it currently is.
//
// Caveats aside, for the most part I think this design should work well, but
// the measurements will most certainly need adjusting for different mounts
// diameters, mount placements, and cable tie widths.
//////////////////////////////////////////////////////////////////////////////


$fn=72;

guide_r = 11;
guide_width = 69;
pipe_r = 25.5/2;
pipe_spacing = 150;
edge_r = 2;
height = 80;
strap_width = 7;
num_straps = 3;
e = 0.001;
depth = pipe_r * 2 + 6;

module main() {
    difference() {
        // bevelled box
        hull() {
            for(axis=[[1,0,0],[0,1,0],[0,0,1]])
                cube([pipe_spacing - edge_r*2, depth, height] + 2 * edge_r * axis,
                     center=true);
        }

        union() {
            // pipe slots with bevelled ends
            for(xs=[1,-1])
                for(zs=[1,-1])
                    scale([xs,1,zs]) {
                        translate([pipe_spacing/2, 0, -height/2]) {
                            minkowski() {
                                union() {
                                    cylinder(r=pipe_r, h=height);
                                    translate([0,0,-edge_r]) cylinder(r1=pipe_r + edge_r,r2=pipe_r, h=edge_r);
                                }
                                cube([pipe_r, e, e]);
                            }
                        }
                    }

            // strap slots
            for(ys=[1,-1])
                scale([1,ys,1])
                    for(i=[1:num_straps])
                        translate([-pipe_spacing/2 - edge_r, depth/2,
                                  -height/num_straps/2-height / 2 + height / num_straps * i - strap_width / 2])
                            cube([pipe_spacing + 2 * edge_r, edge_r, strap_width]);

            // cable guides
            minkowski() {
                translate([-1/2 *(guide_width/2 + guide_r), 0, -height/2]) 
                    union() {
                        cylinder(r=guide_r, h=height + 2 * edge_r + 2*e);
                        translate([0,0,-edge_r]) cylinder(r1=guide_r + edge_r,r2=guide_r, h=edge_r);
                        translate([0,0,height]) cylinder(r2=guide_r + edge_r,r1=guide_r, h=edge_r);
                    }
                cube([e + 1*(guide_width - 2*guide_r), e, e]);
            }
        }
    }
}

main();
