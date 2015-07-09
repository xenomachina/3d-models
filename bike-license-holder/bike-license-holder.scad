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
thickness = 5;
connector_width = 55;

module mirrored() {
    children();
    scale([-1,1,1]) children();
}
module flipped() {
    children();
    scale([1,-1,1]) children();
}

function vecmul(x,y) = [for(i = [0:len(x)-1]) x[i] * y[i]];
function vecflip(x) = vecmul([1,-1,1], x);
function vecmirror(x) = vecmul([-1,1,1], x);

module main(w, h, r) {
    module node() {
        sphere(thickness/2);
    }
    top = [0, -h/2 + thickness/2, thickness/2];
    top_front = top + [w/2 - r - thickness/2, 0, 0];
    top_back = top + [connector_width/2 - r - thickness/2, 40, 75];
    bottom_back = [0, h/2 - thickness / 2, thickness] + [23,0,46];
    bottom_front = vecmul([1,-1,1], top_front);

    module plate_holes(cut) {
        mirrored() translate([132.3 / 2, 11.3 - h/2, 0]) cylinder(r=r, thickness);
        hole_r = 4.68/2;
        r = cut ? hole_r : hole_r + thickness;
    }
    module outer_face() {
        hull() flipped() mirrored() {
            translate([w/2 - r, h/2 - r, 0]) cylinder(r=r, h=thickness);
        }
    }
    module inner_face() {
        hull() flipped() mirrored() {
            translate([w/2 - r, h/2 - r, 0]) cylinder(r=r - thickness, h=thickness);
        }
    }

    module rod(a, b) {
        hull() {
            translate(a) node();
            translate(b) node();
        }
    }

    difference() {
        difference() {
            outer_face();
            difference() {
                inner_face();
                plate_holes(false);
            }
        }
        plate_holes(true);
    }
    mirrored() rod(top_front, top_back);
    rod(top_back, vecmirror(top_back));
    rod(bottom_back, vecmirror(bottom_back));
    mirrored() rod(top_back, bottom_back);
    mirrored() rod(top_front, bottom_back);
    mirrored() rod(bottom_front, bottom_back);
}

main(151, 71, 14);
