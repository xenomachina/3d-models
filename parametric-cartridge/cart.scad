// Copyright ©2015 Laurence Gonsalves <laurence@xenomachina.com>
//
// Code licensed under the Creative Commons - Attribution - Share Alike license.

// Which part do you want to see?
part = "bottom"; // [top:Top,bottom:Bottom]

// Which style case would you like?
style = "embossed"; // [embossed:Embossed, labeled:Embossed with label hole, smooth:Smooth]

// Length of PCB (including edge connector). Use 84 to get a normal-length
// cartridge.
pcb_len = 84; // [50: 200]

// Distance between edge connector and center of post + screw hole. 43.36 is for standard Commodore cartridges.
post_y = 43.36; // [20: 180]

// Size of the post hole in PCB. Use 0 to remove post and hole entirely.
post_diameter = 0; // [0 : 15]

/* [Hidden] */

$fn=18;
EPSILON = 1/128;
ORIGINAL_PCB_LEN = 84;
ORIGINAL_POST_Y = 43.36;
ORIGINAL_POST_DIA = 5;

// Good values for Gyruss (Parker Brothers) cart:
// post_y = 17.17 +.5 * 9;
// pcb_len = 64;
// post_diameter = 9

module z(z) {
    translate([0, 0, z]) children();
}

module torus(r1, r2) {
    rotate_extrude(convexity = 10)
    translate([r2 + r1, 0, 0])
    circle(r=r2);
}

HOLE_DEPTH = 18;
COUNTERSINK_DIAMETER = 6.25;
COUNTERSINK_TOP_DEPTH = .5;
SCREW_HEAD_DIAMETER = 4.93;
SCREW_OUTER_DIAMETER = 2.5;
SCREW_INNER_DIAMETER = 2.3;
SCREW_HEAD_HEIGHT = 1.67;
CART_DEPTH = 20;

PCB_THICKNESS = 1.5748;
SKIN = 2;
EDGE_R = 2.4;
END_R = 6;

COUNTERSINK_HEIGHT = (COUNTERSINK_DIAMETER - SCREW_OUTER_DIAMETER) / (SCREW_HEAD_DIAMETER - SCREW_OUTER_DIAMETER) * SCREW_HEAD_HEIGHT;

module hole() {
    translate([0, 0, -CART_DEPTH/2])
    union() {
        cylinder(r=COUNTERSINK_DIAMETER/2, h=COUNTERSINK_TOP_DEPTH);
        z(COUNTERSINK_TOP_DEPTH) {
            cylinder(r1=COUNTERSINK_DIAMETER/2, r2=SCREW_OUTER_DIAMETER/2, h=COUNTERSINK_HEIGHT);
        }
        cylinder(r=SCREW_OUTER_DIAMETER/2, h=CART_DEPTH/2);
        cylinder(r=SCREW_INNER_DIAMETER/2, h=HOLE_DEPTH);
    }
}

POST_DIAMETER = 5;
POST_HEIGHT = CART_DEPTH - 2*SKIN;
LEDGE_DIAMETER = POST_DIAMETER + 1;
POST_FILLET_R = EDGE_R * 2;

module post() {
    translate([0,0,-POST_HEIGHT/2])
    union() {
        cylinder(r=LEDGE_DIAMETER/2, h=POST_HEIGHT);

        for(i=[0,1])
            rotate([0,180*i,0])
            translate([0,0,-POST_HEIGHT*i])
            difference() {
                cylinder(r=LEDGE_DIAMETER/2 + POST_FILLET_R, h=POST_FILLET_R);
                translate([0,0,POST_FILLET_R]) torus(LEDGE_DIAMETER/2, POST_FILLET_R);
            }
    }
}

PCB_WIDTH = 58.12;
CART_WIDTH = 68.38;
CART_LENGTH = 88.5;

module pcb() {
    difference() {
        translate([-PCB_WIDTH / 2, 0, -PCB_THICKNESS])
            cube([PCB_WIDTH, pcb_len, PCB_THICKNESS]);
        translate([0, post_y, -PCB_THICKNESS-EPSILON])
            cylinder(r=POST_DIAMETER/2, h=PCB_THICKNESS + 2* EPSILON);
    }
}

WALL_THICKNESS = 1.6;
CONNECTOR_LENGTH = 10;
LIP_THICKNESS = 5;

module box() {
    module form() {
        translate([-CART_WIDTH/2 + EDGE_R, EDGE_R, -CART_DEPTH/2 + EDGE_R]) {
            cube([CART_WIDTH - 2 * EDGE_R, CART_LENGTH - END_R - EDGE_R, CART_DEPTH - 2 * EDGE_R]);
            translate([0, 0, END_R - EDGE_R])
                cube([CART_WIDTH - 2 * EDGE_R, CART_LENGTH - 2 * EDGE_R, CART_DEPTH - 2 * END_R]);
        }
        for (z=[1,-1])
            translate([-CART_WIDTH/2 + EDGE_R, CART_LENGTH - END_R, z*(-CART_DEPTH/2 + END_R)])
                rotate([0, 90, 0])
                cylinder(r=END_R - EDGE_R, h=CART_WIDTH - 2 * EDGE_R);
    }

    union() {
        // main shell
        difference() {
            minkowski() {
                form();
                sphere(r=EDGE_R);
            }
            difference() {
                minkowski() {
                    union() {
                        form();
                        translate([0, -EDGE_R, 0]) form();
                    }
                    sphere(r=EDGE_R - SKIN);
                }
                // top lip
                translate([-CART_WIDTH/2, 0, CART_DEPTH/2 - LIP_THICKNESS])
                    cube([CART_WIDTH, EDGE_R, LIP_THICKNESS]);

                // edge connector wall
                translate([-CART_WIDTH/2, CONNECTOR_LENGTH, -CART_DEPTH/2])
                    cube([CART_WIDTH, WALL_THICKNESS, CART_DEPTH]);
            }
        }

    }
}


module cart() {
    difference() {
        union() {
            translate([0, post_y, 0]) post();
            box();
        }
        union() {
            translate([0, post_y, 0]) hole();
            # pcb();
        }
    }
}

module main() {
    module top_mask() {
        translate([-CART_WIDTH/2-EPSILON, -EPSILON, -EPSILON])
            difference() {
                cube([CART_WIDTH + 2*EPSILON, CART_LENGTH + 2*EPSILON, CART_DEPTH + 2*EPSILON]);

                // top/bottom interlock
                translate([SKIN/2, CONNECTOR_LENGTH + WALL_THICKNESS + EPSILON, 0])
                    difference() {
                        xl = CART_WIDTH - SKIN;
                        yl = CART_LENGTH - CONNECTOR_LENGTH - WALL_THICKNESS - SKIN/2 - EPSILON;
                        zl = SKIN/2;
                        cube([xl, yl, zl]);
                        translate([SKIN/2, 0, -EPSILON]) {
                            cube([xl - SKIN, yl - SKIN/2, zl + 2*EPSILON]);
                        }
                    }
            }
    }
    if (part == "top") {
        intersection() {
            cart();
            top_mask();
        }
    } else {
        difference() {
            cart();
            top_mask();
        }
    }
}

//rotate([90, 0, 180]) // rotate so edge connector is on build-plate
main();
