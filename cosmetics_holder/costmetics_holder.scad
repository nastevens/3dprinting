// Horizontal slot count
n = 4;

// Vertical slot count
m = 5;

// Width of each slot
slot_width = 19;

// Width of cutout
cutout_width = 4;

// Length of each slot
slot_length = 18;

// Length of cutout
cutout_length = 4;

// Height of each slot
slot_height = 90;

// Height of cutout
cutout_height = 15;

// Outer wall thickeness
outer_wall = 1.6;

// Inner wall thickeness
inner_wall = 0.8;

module base() {
    let(
        t_outer = 2 * outer_wall,
        t_inner_width = (n - 1) * inner_wall,
        t_inner_length = (m - 1) * inner_wall,
        all_slots_width = n * slot_width,
        all_slots_length = m * slot_length,
        width = t_outer + t_inner_width + all_slots_width,
        length = t_outer + t_inner_length + all_slots_length,
        height = t_outer + slot_height
    ) {
        cube([width, length, slot_height]);
    }
}

difference() {
    base();

    for(x = [1:n]) {
        for(y = [1:m]) {
            let(
                x_shift = outer_wall + (x-1) * (inner_wall + slot_width),
                y_shift = outer_wall + (y-1) * (inner_wall + slot_length)
            )
            translate([x_shift, y_shift, outer_wall])
                cube([slot_width, slot_length, slot_height + 1]);

        }
    }

    for(x = [1:n]) {
        let(
            width = slot_width - (2 * cutout_width),
            x_shift = outer_wall + cutout_width + (x-1) * (inner_wall + slot_width),
            height = slot_height - 2 * cutout_height
        ) {
            translate([x_shift, -1, outer_wall + cutout_height])
                union() {
                    cube([width, 1000, height]);
                    translate([width/2, -1, 0]) rotate([270, 30, 0])
                        cylinder(1000, d=width/cos(30), center=false, $fn=6);
                    translate([width/2, -1, height]) rotate([270, 30, 0])
                        cylinder(1000, d=width/cos(30), center=false, $fn=6);
                }
        }
    }

    for(y = [1:m]) {
        let(
            length = slot_length - (2 * cutout_length),
            y_shift = outer_wall + cutout_length + (y-1) * (inner_wall + slot_length),
            height = slot_height - 2 * cutout_height
        ) {
            translate([-1, y_shift, outer_wall + cutout_height])
                union() {
                    cube([1000, length, height]);
                    translate([-1, length/2, 0]) rotate([0, 90, 0])
                        cylinder(1000, d=length/cos(30), center=false, $fn=6);
                    translate([-1, length/2, height]) rotate([0, 90, 0])
                        cylinder(1000, d=length/cos(30), center=false, $fn=6);
                }
        }
    }

}

%translate([outer_wall, outer_wall, outer_wall])
    cube([slot_width, slot_length, 75]);
