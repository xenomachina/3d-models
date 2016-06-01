/*
 * Copyright ©2015 Laurence Gonsalves <laurence@xenomachina.com>
 *
 * Code licensed under the Creative Commons - Attribution - Share Alike license.
 * 
 * Thanks to Kit Wallace for his superellipse implementation.
 */

$fn = 36;

karma_width = 75.5;
karma_thickness = 13.1;
karma_edge_thickness = 9.8;

function dome_radius(h, w) = h + (w * w) / h;

/*
 * Based on http://kitwallace.co.uk/Blog/item/2013-02-14T00:10:00Z
 */
module superellipse(p, e=1 , r=1) {
    function x(r, p, e, a) =     r * pow(abs(cos(a)), 2/p) * sign(cos(a));
    function y(r, p, e, a) = e * r * pow(abs(sin(a)), 2/p) * sign(sin(a));
    dth = 360/$fn;
    union() for (i = [0:$fn-1])
        polygon([
                [0, 0],
                [x(r, p, e, dth*i),     y(r, p, e, dth*i)],
                [x(r, p, e, dth*(i+1)), y(r, p, e, dth*(i+1))]]);
}

module main() {
    intersection() {
        // A superellipse with p=4 is a squircle, twhich happens to be the
        // shape of the Karma Go.
        scale([1, 1, karma_thickness]) superellipse(4, r=karma_width/2);

        dr = dome_radius(karma_thickness - karma_edge_thickness,
                         karma_width / 2);
        translate([0, 0,   dr - karma_thickness / 2]) sphere(dr);
        translate([0, 0, - dr + karma_thickness / 2]) sphere(dr);
    }
}

main();
