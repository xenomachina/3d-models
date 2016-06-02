/*
 * Copyright ©2015 Laurence Gonsalves <laurence@xenomachina.com>
 *
 * Code licensed under the Creative Commons - Attribution - Share Alike license.
 * 
 * Thanks to Kit Wallace for his superellipse implementation.
 */

$fn = 60;

karma_width = 75.5;
karma_thickness = 13.1;
karma_edge_thickness = 10.3;
shell_thickness = 2;
port_r = 7.5;

function dome_radius(h, w) = h + (w * w) / h;

/*
 * Based on http://kitwallace.co.uk/Blog/item/2013-02-14T00:10:00Z
 */
module superellipse(p, e=1 , r=1) {
    function x(r, p, e, a) =     r * pow(abs(cos(a)), 2/p) * sign(cos(a));
    function y(r, p, e, a) = e * r * pow(abs(sin(a)), 2/p) * sign(sin(a));
    dth = 360/$fn;
    union() for (i = [0:$fn-1])
        linear_extrude(height=1)
        polygon([
                [0, 0],
                [x(r, p, e, dth*i),     y(r, p, e, dth*i)],
                [x(r, p, e, dth*(i+1)), y(r, p, e, dth*(i+1))]]);
}
module squircle(h) {
    // A superellipse with p=4 is a squircle, which happens to be the
    // shape of the Karma Go.
    translate([0, 0, -h/2]) scale([1, 1, h]) superellipse(4, r=karma_width/2);
}

module karma_go() {
    hull() {
        intersection() {
            squircle(karma_thickness);
            dr = dome_radius(karma_thickness - karma_edge_thickness,
                             karma_width / 2);
            translate([0, 0,   dr - karma_thickness / 2]) sphere(dr);
            translate([0, 0, - dr + karma_thickness / 2]) sphere(dr);
        }
        squircle(karma_edge_thickness);
    }
}

module karma_slot() {
    // minus slot for Karma Go
    hull() {
        karma_go();
        translate([0, karma_width + shell_thickness, 0]) karma_go();
    }
}

module main() {
    % karma_go();

    difference() {
        union () {
            difference () {
                intersection() {
                    // shaped shell around slot
                    minkowski() {
                        karma_slot();
                        h = karma_thickness - karma_edge_thickness + 2*shell_thickness;
                        translate([0,0,shell_thickness-h])cylinder(r=shell_thickness, h=h);
                    }

                    // trim to bounding box (mostly flattens back)
                    translate([
                              -karma_width/2-shell_thickness,
                              -karma_width/2-shell_thickness,
                              -karma_thickness/2-shell_thickness])
                        cube([karma_width + 2*shell_thickness,
                             karma_width + 2*shell_thickness,
                             karma_thickness + 2*shell_thickness]);
                }

                // cut out slot
                karma_slot();

                translate([0, 0, -karma_thickness/2]) {
                    // top cutout and finger slot
                    translate([-karma_width/2 - shell_thickness, -karma_width/2 - shell_thickness, -shell_thickness])
                        difference() {
                            cube([karma_width + 2*shell_thickness,
                                 4* karma_width + 2*shell_thickness,
                                 karma_thickness + 2*shell_thickness]);
                            for(x = [0, karma_width + 2 * shell_thickness])
                                translate([x, karma_width/2, 0])
                                    hull() for(y = [0, -karma_width])
                                    translate([0, y, 0])
                                    cylinder(r=karma_width/4 + shell_thickness/2, h=karma_thickness + 2*shell_thickness);
                        }

                }


            }

            // back plate
            intersection() {
                hull()
                    for(z = [0, -karma_thickness])
                        translate([0, 0, z])
                            minkowski() {
                                karma_go();
                                cylinder(r=shell_thickness, h=shell_thickness);
                            }
                translate([
                          -karma_width/2-shell_thickness,
                          -karma_width/2-shell_thickness,
                          -karma_thickness/2-shell_thickness])
                    cube([
                         karma_width + 2*shell_thickness,
                         karma_width + 2*shell_thickness,
                         shell_thickness]);
            }
        }


        // button and port holes
        for (y = [30, 55])
            translate([karma_width/2, karma_width / 2 - y, -karma_thickness/2 - shell_thickness])
                hull()
                for (x2 = [0, shell_thickness])
                    for (y2 = [-port_r + shell_thickness, port_r - shell_thickness])
                        translate([x2, y2, 0])
                            #cylinder(r=shell_thickness, h=karma_thickness + 2*shell_thickness);
    }
}

rotate([90, 0, 0])
    main();
