// Zip ties are 8in, 6in, 4in

// Heights of inner bins in decending order.
heights = [140, 105, 70];

// Inner width of each bin
width = 40;

// Inner depth of each bin
depth = 60;

// Wall thickness
wall = 1.4;

// Base thickness
base = 2;

for(i = [0:len(heights)-1]) {
    let(
        t_wall = i == 0 ? 2*wall : wall,
        x_off = i == 0 ? 0 : wall+i*(width+wall),
        x_off_inner = i == 0 ? wall : x_off
    ) {
        difference() {
            translate([x_off, 0, 0]) cube([width+t_wall, depth+2*wall, heights[i]+base]);
            translate([x_off_inner, wall, base]) cube([width, depth, heights[i]+base]);
        }
            
    }
}
