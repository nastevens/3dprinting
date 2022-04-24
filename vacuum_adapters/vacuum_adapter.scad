$fn=120;

// End A measurement is which adapter diameter?
end_a_measurement = "inner"; //[outer, inner]
end_a_diameter = 63.1;
end_a_length = 26.0;
end_a_flare = 1.0;

// End B measurement is which adapter diameter?
end_b_measurement = "inner"; //[outer, inner]
end_b_diameter = 44.6;
end_b_length = 26;
end_b_flare = -1.0;

// Wall thickness
wall_thickness = 3.0;

// Transition length
transition_length = 20.0;

// Creates a hollowed cylinder with starting OD d1 and ending OD d2.
module hollow_cylinder(od1, id1, od2, id2, h) {
    difference() {
        cylinder(d1=od1, d2=od2, h=h, center=false);
        translate([0, 0, -0.01]) cylinder(d1=id1, d2=id2, h=h+0.02, center=false);
    }
}

module vacuum_adapter() {
    end_a_diameter_out = end_a_diameter + end_a_flare / 2;
    end_a_id_1 = end_a_measurement == "inner" ? end_a_diameter_out : end_a_diameter_out - wall_thickness;
    end_a_od_1 = end_a_measurement == "inner" ? end_a_diameter_out + wall_thickness : end_a_diameter_out;
    end_a_diameter_in = end_a_diameter - end_a_flare / 2;
    end_a_id_2 = end_a_measurement == "inner" ? end_a_diameter_in : end_a_diameter_in - wall_thickness;
    end_a_od_2 = end_a_measurement == "inner" ? end_a_diameter_in + wall_thickness : end_a_diameter_in;

    end_b_diameter_out = end_b_diameter + end_b_flare / 2;
    end_b_id_1 = end_b_measurement == "inner" ? end_b_diameter_out : end_b_diameter_out - wall_thickness;
    end_b_od_1 = end_b_measurement == "inner" ? end_b_diameter_out + wall_thickness : end_b_diameter_out;
    end_b_diameter_in = end_b_diameter - end_b_flare / 2;
    end_b_id_2 = end_b_measurement == "inner" ? end_b_diameter_in : end_b_diameter_in - wall_thickness;
    end_b_od_2 = end_b_measurement == "inner" ? end_b_diameter_in + wall_thickness : end_b_diameter_in;

    transition_id_1 = end_a_id_2;
    transition_od_1 = end_a_od_2;
    transition_id_2 = end_b_id_1;
    transition_od_2 = end_b_od_1;

    union() {
        translate([0, 0, 0])
            hollow_cylinder(end_a_od_1, end_a_id_1, end_a_od_2, end_a_id_2, end_a_length);
        translate([0, 0, end_a_length])
            hollow_cylinder(transition_od_1, transition_id_1, transition_od_2, transition_id_2, transition_length);
        translate([0, 0, transition_length + end_a_length])
            hollow_cylinder(end_b_od_1, end_b_id_1, end_b_od_2, end_b_id_2, end_b_length);
    }
}

vacuum_adapter();
