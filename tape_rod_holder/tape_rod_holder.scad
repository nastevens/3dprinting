// Rod diameter
rod = 19.2;

// Wall thickness
wall = 10.0;

// Back plate height (area against wall)
h_back = 4.0;

// Support height
h_support = 20.0;

// Diameter of screw head
d_screw_head = 6.6;

// Diameter of screw shaft
d_screw_shaft = 3.5;

// Height of screw head
h_screw_head = 3.2;

$fn = 50;

union() {
    difference() {
        let(
            d = rod + wall,
            h = h_back
        ) {
            cylinder(h=h, d=d);
        }
        let(
            d1 = d_screw_shaft,
            d2 = d_screw_head,
            h1 = h_back - h_screw_head,
            h2 = h_screw_head
        ) {
            cylinder(h=h1, d=d1);
            translate([0, 0, h1]) cylinder(h=h2, d1=d1, d2=d2);
        }
    }

    translate([0, 0, h_back]) {
        let(
            d_outer = rod + wall,
            d_inner = rod,
            h = h_support,
            cube_x = -d_inner / 2.0,
            cube_w = d_inner,
            cube_d = d_outer,
            cube_h = h_support
        ) {
            difference() {
                cylinder(h=h, d=d_outer);
                cylinder(h=h, d=d_inner);
                translate([cube_x, 0, 0]) cube([cube_w, cube_d, cube_h]);
            }
        }
    }
}
