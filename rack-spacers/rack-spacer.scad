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

h=11;
screw_hole_r = (4.7+.5)/2;
width=16;
depth=12;
bevel_r = 1;

module main() {
    difference() {
        hull()
            for(i=[-1,1])
            for(j=[-1,1])
            translate([(width/2-bevel_r) * i, (depth/2-bevel_r) * j, 0])
            cylinder(r=bevel_r, h=h);
        cylinder(r=screw_hole_r, h);
    }
}

// To generate a 4x4 grid of spacers, uncomment the following.
/*
for(i=[0:3])
    for(j=[0:3])
        translate([(width+1)*i, (depth+1)*j, 0])
            if(i*4+j<14)
*/

main();
