/*
 * Copyright ©2016 Laurence Gonsalves <laurence@xenomachina.com>
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

$fn=72;

OUTER_DIAMETER = 9.4;
WALL_THICKNESS = 1.25;
HEIGHT = 3 - .22;

module main() {
    difference (){
        cylinder(r=OUTER_DIAMETER/2, h=HEIGHT);
        cylinder(r=OUTER_DIAMETER/2 - WALL_THICKNESS, h=HEIGHT);
    }
}

main();
