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

// This is the bracket for the Commodore 128's power LED. It looks like a tiny
// armchair with a tail, so the measurements are named as such.

// I have not actually printed this part. It should print pretty easily with
// support under the tail. The part isn't visible, so any ugnliness caused by
// removing support should be inconsequential.

ARM_WIDTH = 1.86;
ARM_DEPTH = 8.05;
ARM_HEIGHT = 5.34;
SEAT_DEPTH = 5.04;
SEAT_HEIGHT = 1.85;
BACK_WIDTH = 10.11;
BACK_HEIGHT = 6.54;
BACK_DEPTH = 1.78;
TAIL_WIDTH = 3.21;
TAIL_DEPTH = 4.35;
TAIL_HEIGHT = 2.04;

module main() {
    union() {
        cube([BACK_WIDTH, BACK_DEPTH, BACK_HEIGHT]);
        translate([BACK_WIDTH/2 - TAIL_WIDTH/2, 0, 0])
            cube([TAIL_WIDTH, TAIL_DEPTH, TAIL_HEIGHT]);
        translate([0, BACK_DEPTH - ARM_DEPTH, BACK_HEIGHT - ARM_HEIGHT])
            cube([ARM_WIDTH, ARM_DEPTH, ARM_HEIGHT]);
        translate([BACK_WIDTH - ARM_WIDTH, BACK_DEPTH - ARM_DEPTH, BACK_HEIGHT - ARM_HEIGHT])
            cube([ARM_WIDTH, ARM_DEPTH, ARM_HEIGHT]);
        translate([0, - SEAT_DEPTH, BACK_HEIGHT - SEAT_HEIGHT])
            cube([BACK_WIDTH, SEAT_DEPTH, SEAT_HEIGHT]);
    }
}

main();
