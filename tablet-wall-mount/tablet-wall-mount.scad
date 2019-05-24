/*
 * Copyright ©2017 Laurence Gonsalves <laurence@xenomachina.com>
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

EPSILON = .01;

SLOT_WIDTH = 23;
SLOT_THICKNESS = 23.5;
SLOT_HEIGHT = 110;

WALL_THICKNESS = 3;

CUTOUT_BOTTOM_OFFSET = 28;
CUTOUT_HEIGHT = 72;
CUTOUT_WIDTH = 10;

$fn = 72;

module main() {
    intersection() {
        cube([
             SLOT_WIDTH + WALL_THICKNESS*2,
             SLOT_THICKNESS + WALL_THICKNESS*2,
             SLOT_HEIGHT + WALL_THICKNESS*2
        ]);

        difference() {
            minkowski()
            {

                sphere(WALL_THICKNESS/2);

                intersection () {
                    union() {
                        //back
                        translate([
                                  0, WALL_THICKNESS + SLOT_THICKNESS, 0
                        ])
                            cube([
                                 SLOT_WIDTH + WALL_THICKNESS*2,
                                 SLOT_THICKNESS + WALL_THICKNESS,
                                 SLOT_HEIGHT + WALL_THICKNESS*2
                            ]);

                        // bottom front
                        translate([
                                  0, 0, -SLOT_WIDTH
                        ])
                            cube([
                                 SLOT_WIDTH + WALL_THICKNESS*2,
                                 SLOT_THICKNESS + WALL_THICKNESS*2,
                                 SLOT_HEIGHT + WALL_THICKNESS/2
                            ]);

                        // top front
                        translate([
                                  WALL_THICKNESS/2,
                                  0,
                                  SLOT_HEIGHT - SLOT_WIDTH + WALL_THICKNESS/2
                        ])
                            rotate([-90, 90, 0])
                            cylinder(r=SLOT_WIDTH+WALL_THICKNESS, h=SLOT_THICKNESS + WALL_THICKNESS);
                    }

                    translate([WALL_THICKNESS/2, WALL_THICKNESS/2, WALL_THICKNESS/2])
                        difference() {
                            // shell
                            cube([
                                 SLOT_WIDTH + WALL_THICKNESS + EPSILON,
                                 SLOT_THICKNESS + WALL_THICKNESS + EPSILON + WALL_THICKNESS,
                                 SLOT_HEIGHT + WALL_THICKNESS + EPSILON
                            ]);

                            // slot
                            translate([EPSILON, EPSILON/2, EPSILON])
                                cube([
                                     SLOT_WIDTH + WALL_THICKNESS,
                                     SLOT_THICKNESS + WALL_THICKNESS,
                                     SLOT_HEIGHT + WALL_THICKNESS
                                ]);
                        }
                }
            }

            union() {
                translate([0, 0, CUTOUT_BOTTOM_OFFSET + WALL_THICKNESS + CUTOUT_WIDTH])
                    cube([
                         CUTOUT_WIDTH + WALL_THICKNESS,
                         SLOT_THICKNESS + WALL_THICKNESS + EPSILON * 2,
                         CUTOUT_HEIGHT - CUTOUT_WIDTH * 2
                    ]);

                translate([0, 0, CUTOUT_BOTTOM_OFFSET + WALL_THICKNESS + CUTOUT_WIDTH])
                rotate([-90, 90, 0])
                    cylinder(r=CUTOUT_WIDTH + WALL_THICKNESS, h=SLOT_THICKNESS + WALL_THICKNESS);
                translate([0, 0, CUTOUT_BOTTOM_OFFSET + WALL_THICKNESS + CUTOUT_HEIGHT - CUTOUT_WIDTH])
                rotate([-90, 90, 0])
                    cylinder(r=CUTOUT_WIDTH + WALL_THICKNESS, h=SLOT_THICKNESS + WALL_THICKNESS);
            }
        }
    }
}

main();
