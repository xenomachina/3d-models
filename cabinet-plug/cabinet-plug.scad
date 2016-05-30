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
WIDTH = 39.54 - 2.28;
DEPTH = 81.17 - 20.78;
HEIGHT = 10;
TUBE_R = 5.15/2;

module main() {
    difference (){
        union(){
            difference (){
                cube([WIDTH, DEPTH, HEIGHT]);
                translate([.5,.5,0]) cube([WIDTH - 1 , DEPTH - 1, HEIGHT]);
            }
            translate([0,-1,0]) cube([WIDTH + 1 , DEPTH + 1, 1]);
        }
        translate([WIDTH/2, DEPTH/2, 0]) cylinder(r=TUBE_R + .2, h=HEIGHT);
    }
}

main();
