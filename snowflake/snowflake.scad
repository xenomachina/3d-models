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

RADIUS = 30;
CRYSTAL_RADIUS = 3;

HOLDER_THICKNESS = 2.5;
HOLDER_GAP = .75;
HOLDER_RADIUS = RADIUS/3;
BASE_HEIGHT = 1;

// Random seed. These are some nice values.
SEED = 136;
SEED = 139;
SEED = 149;
//SEED = 150;
//SEED = 151;

// These affect how "freezing" moves between neighboring cells. Larger values
// tend to increase thickness of snowflake.
X_BIAS = .5;
Y_BIAS = .7;

$fn=6;
SIN60 = sin(60);

// Computes index into a triangular array
function index(x, y) = (y+y*y)/2 + x;

function freeze(left, x, y, prev, n) =
    max(0, (
    min(1, (
    (x + 1 < len(prev))
    ?  min(left+X_BIAS, min(prev[x] + Y_BIAS, prev[x + 1] + Y_BIAS))
    : (
        (x < len(prev))
        ? min(left+X_BIAS, prev[x] + Y_BIAS)
        : left+X_BIAS
    )))));

function rfreeze(left, x, y, prev, n, rnd) =
    (x < n)
    ? let(first = freeze(left, x, y, prev, n) * rnd[index(x, y)])
        concat([first], rfreeze(first, x + 1, y, prev, n, rnd))
    : [];

function stretch0(x) = (sin(x*180-90)+1)/2;
function stretch(x) = stretch0(stretch0(x));

module r_snowflake(rnd, y, radius, prev) {
    // The second half of this min is so cells are bounded to a hexagon, rather
    // than to a 6-pointed star.
    n = min(y + 1, radius - y);

    if (n > 0) {
        froz = rfreeze(1, 0, y, prev, n, rnd);
        cells = [for (x=[0:n-1]) stretch(froz[x])];
        for(x=[0:n-1]) {
            translate([SIN60 * (x + y/2), 3/4 * y, 0])
                rotate([0,0,30]) cylinder(r2=.5, r1=.75, h=cells[x]);
        }

        // Recurse to next row
        r_snowflake(rnd, y + 1, radius, cells);
    }
}

module snowflake(radius, seed) {
    rnd = rands(0, 1, index(0, radius), seed);

    for (scl = [-1, 1])
        for (theta = [0:60:360])
            rotate([0,0,theta])
                scale([1,scl,1])
                    r_snowflake(rnd, 0, radius, []);
}

module main() {
    difference() {
        union() {
            // card holder
            intersection() {
                translate([0, HOLDER_THICKNESS/2, 0])
                    rotate([90, 0, 0])
                        cylinder(r=HOLDER_RADIUS, h=HOLDER_THICKNESS);
                translate([-RADIUS, -RADIUS, 0]) cube(RADIUS*2);
            }
            // base
            translate([0, 0, -BASE_HEIGHT]) cylinder(r=SIN60 * RADIUS + .25, h=BASE_HEIGHT);

            // snowflake
            scale(CRYSTAL_RADIUS) snowflake(floor(RADIUS/CRYSTAL_RADIUS), SEED);
        }

        // slot for holding card
        translate([-RADIUS, -HOLDER_GAP/2, 0]) cube([RADIUS*2, HOLDER_GAP, RADIUS*2]);
    }
}

main();
