$fn = 50;

thickness = 3.0;
screw_cap_r = 6.0;
screw_cap_h = 7.4;
screw_thread_r = 1.7;
screw_thread_h = 11.1 - screw_cap_h;
screw_cap_tolerance = 0.5;
screw_hole_y = 11.2;
screw_hole_receiver = 2.0;

box_x = 62.0;
box_y = 12.25 + thickness;
box_z = 45.0;

lip_overhang = 5.0;

antenna_tolerance = 0.5;
antenna_x = 35.8 + antenna_tolerance;
antenna_y = 12.0;
antenna_z = 150.0;
antenna_recess = 10.0;

channel_width = 5.0;
spool_r = 15.0;
spool_channel_width = 8.5;

antenna_points = [
    [0, 0],
    [antenna_x, 0],
    [antenna_x + antenna_z / tan(80), antenna_z],
    [antenna_z / tan(75), antenna_z],
];

antenna_projection_points = [
    [antenna_z / tan(75), antenna_z],
    [antenna_x + antenna_z / tan(80), antenna_z],
    [antenna_x - antenna_z / tan(80), -antenna_z],
    [-antenna_z / tan(75), -antenna_z],
];

module screw() {
    rotate([0, 90, -90]) union() {
        cylinder(h=screw_thread_h, r=screw_thread_r);
        translate([0, 0, screw_thread_h]) cylinder(h=screw_cap_h, r=screw_cap_r, center=false);
    }
}

module antenna() {
    rotate([90, 0, 0])
        translate([0, 0, -antenna_y])
        linear_extrude(height=antenna_y)
        polygon(points=antenna_points);
}

module case() {
    difference() {
        union() {
            // Main box
            cube([box_x, antenna_y + thickness, box_z]);

            // Top lip
            translate([0, 0, box_z])
                cube([box_x, antenna_y + thickness + lip_overhang, thickness]);

            // Side lip
            translate([box_x, 0, 0])
                cube([thickness, antenna_y + thickness + lip_overhang, box_z + thickness]);
        }

        // Recess for case screw
        translate([thickness + screw_cap_r, antenna_y + thickness - screw_hole_receiver, box_z - screw_hole_y])
            rotate([90, 0, 0])
            cylinder(r=(screw_cap_r + screw_cap_tolerance), h=(antenna_y + thickness));

        // Hole for case screw. This is a slot instead of a circle to help out
        // the slicer (Prusa Slicer at least tries to path a circle in
        // mid-air).
        translate([thickness + screw_cap_r, antenna_y + 2 * thickness, box_z - screw_hole_y])
            intersection() {
                rotate([90, 0, 0]) cylinder(r=(screw_cap_r + screw_cap_tolerance), h=(antenna_y + thickness));
                cube([2 * (screw_cap_r + screw_cap_tolerance), antenna_y + thickness, 2 * (screw_thread_r + screw_cap_tolerance)], center=true);
            };

        // Screw (view only)
        *translate([thickness + screw_cap_r, antenna_y + thickness - screw_hole_receiver + screw_thread_h, box_z - screw_hole_y])
            screw();

        // Antenna cutout
        translate([2 * thickness + 2 * screw_cap_r, thickness, box_z - antenna_recess])
            scale([1, 2, 1])
            antenna();

        // Antenna (view only)
        %translate([2 * thickness + 2 * screw_cap_r, thickness, box_z - antenna_recess])
            antenna();

        // Cable spool cutout
        hull() {
            translate([2 * thickness + 2 * screw_cap_r + antenna_x - spool_r, thickness, box_z - antenna_recess - thickness - spool_r])
                rotate([-90, 0, 0])
                cylinder(r=spool_r, h=antenna_y * 2);
            translate([2 * thickness + (2 * spool_r / 3), thickness, thickness + 2 * spool_r / 3])
                rotate([-90, 0, 0])
                cylinder(r=(2 * spool_r / 3), h=antenna_y * 2);
        }

        // Channel from antenna to spool
        translate([2 * thickness + 2 * screw_cap_r + antenna_x - channel_width, thickness, box_z - antenna_recess - thickness - spool_r])
            scale([1, 2, 1])
            cube([channel_width, antenna_y, box_z]);

        // Channel from spool to back
        translate([2 * thickness + 2 * screw_cap_r + antenna_x - spool_r, thickness, box_z - antenna_recess - thickness - spool_r])
            scale([1, 2, 1])
            cube([box_x, antenna_y, channel_width]);

        // Decorate the front at the same angle as the antenna
        translate([2 * thickness + 2 * screw_cap_r, 0.6, box_z - antenna_recess])
            rotate([90, 0, 0])
            linear_extrude(height=antenna_y)
            difference() {
                polygon(points=antenna_projection_points);
                offset(delta=-1) polygon(points=antenna_projection_points);
            };
    }

    // Center pegs for wrapping cable around.
    hull() {
        translate([2 * thickness + 2 * screw_cap_r + antenna_x - spool_r, thickness, box_z - antenna_recess - thickness - spool_r])
            rotate([-90, 0, 0])
            cylinder(r=(spool_r - spool_channel_width), h=antenna_y);
        translate([2 * thickness + (2 * spool_r / 3), thickness, thickness + 2 * spool_r / 3])
            rotate([-90, 0, 0])
            cylinder(r=((2 * spool_r / 3) - spool_channel_width), h=antenna_y);
    }
}

// Rotate when exporting so correct face is down in STL
//rotate([90, 0, 90]) case();

case();