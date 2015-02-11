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

/*
 * Single-piece stand for "slim" PlayStation 2. Styling tries to mimic the
 * styling of the PS2 slim. The design attempts to minimize overhang, and
 * provide both good airflow and solid support to PS2.
 *
 * Linear measurements are in millimetres.
 *
 * PlayStation and PS2 are trademarks or registered trademarks of Sony Computer
 * Entertainment Inc. The author of this file has no affiliation with Sony
 * Computer Entertainment Inc.
 */
e = 0.04; // epsilon
phi = (1 + sqrt(5)) / 2;

ps2_thickness = 28; // Includes rubber feet.
ps2_top_thickness = 15; // the layer that juts out on the front and top.
ps2_ridge_thickness = 2.85; // thickness of 3 cosmetic ridges on top layer.
ps2_ridge_height = 2.45; // height of 3 cosmetic ridges on top layer.
ps2_length = 150; // Length from front to back.
ps2_rear_to_vent_rear = 68;
ps2_rear_to_vent_front = 131;

ps2_vent_length = ps2_rear_to_vent_front - ps2_rear_to_vent_rear;
ps2_ridge_spacing = (ps2_top_thickness - 3 * ps2_ridge_thickness) / 2;

module stand(
    leg_width,
    leg_height,
    leg_thickness,
    leg_spacing,
    base_height
){
    module leg(width, height, thickness) {
        module half_leg(width, height, thickness) {
            translate([(ps2_thickness) / 2, -thickness / 2, 0])
                difference() {
                    cube(size=[width, thickness, height]);
                    translate([width, thickness + e, height])
                        rotate([90,0,0])
                        union(){
                            scale([width - ps2_ridge_thickness - ps2_ridge_height,
                                  height - ps2_ridge_thickness - ps2_ridge_height,
                                  thickness + 2 * e])
                                cylinder($fn=72);

                            for (i = [0 : 1]) {
                                translate([0, 0,
                                          ps2_ridge_thickness + i *
                                          (ps2_ridge_thickness +
                                           ps2_ridge_spacing)]) {
                        scale([width - ps2_ridge_thickness,
                              height - ps2_ridge_thickness,
                              thickness + 2 * e])
                        cylinder($fn=72);
                }
                            }
                        }
                }

        }
        half_leg(width, height, thickness);
        mirror([1, 0, 0]) half_leg(width, height, thickness);
    }

    module base(width, length, height) {
        scale([1, -1, -1])
        translate([ps2_ridge_thickness - width / 2,
                  (leg_spacing + leg_thickness) / 2 - length + ps2_ridge_thickness, 0])
            // From here, the top back left corner of the base (inside the
            // inset) is the origin. Positive x is right, and positive z is
            // down.
            difference() {
                union() {
                    // Main base slab.
                    translate([-ps2_ridge_thickness, -ps2_ridge_thickness, -ps2_ridge_height])
                        cube(size=[width, length, height + ps2_ridge_height]);

                     // Front outset.
                    cube(size=[ps2_thickness, length, height]);
                }

                translate([0, 0, -e])
                union() {
                    // Main vent area.
                    translate([0, ps2_rear_to_vent_rear + height, 0]) {
                        cube(size=[ps2_thickness, ps2_vent_length - height, height + 2*e]);
                        rotate([0,90,0])
                            cylinder(h=ps2_thickness, r=height);
                    }

                    // Front vent slots.
                    for (i = [0 : num_slots - 1]) {
                        translate([vent_offset + i * (ps2_ridge_thickness + ps2_ridge_spacing), ps2_rear_to_vent_front - e, 0])
                            cube(size=[ps2_ridge_thickness, ps2_length, height - ps2_ridge_thickness]);
                    }
                }
            }

        num_slots =
            floor((ps2_thickness - ps2_ridge_spacing - 2 * ps2_ridge_thickness) /
                  (ps2_ridge_thickness + ps2_ridge_spacing)) + 1;
        vent_offset = (ps2_thickness
            - num_slots * ps2_ridge_spacing
            - (num_slots - 1) * ps2_ridge_thickness) / 2;
    }

    base_width = ps2_thickness + ps2_ridge_thickness * 2;
    base_length = (ps2_length + leg_spacing + leg_thickness) / 2 + ps2_ridge_thickness;

    difference() {
        union() {
            // back leg
            translate([0, leg_spacing / 2, -base_height]) leg(leg_width, leg_height, leg_thickness);

            // front leg
            translate([0, -(leg_spacing / 2), -base_height]) leg(leg_width, leg_height, leg_thickness);

            base(base_width, base_length, base_height);
        }

        // slot for PS2 to fit into
        translate([0, 0, leg_height / 2])
            cube(size=[ps2_thickness, ps2_length, leg_height], center=true);
    }
}

shade = .5;
color([shade,shade,shade])
stand(
  100 / phi,                                   // leg_width
  100,                                  // leg_height
  ps2_top_thickness,                    // leg_thickness
  ps2_length - 20 - ps2_top_thickness,  // leg_spacing
  20                                    // base_height
);

/* Origin marker. Handy for debugging.
cube([100,100,.01], center=true);
cube([.01,100,100], center=true);
cube([100,.01,100], center=true);
*/
