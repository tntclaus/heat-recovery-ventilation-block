include <NopSCADlib/utils/core/core.scad>


module vent() {
    h = 100;
    w = 55.5;
    l = 110.5;

    module pyramid() {
        hull() {
            translate_z(5)
            cube([.1, .1, .1], center = true);
            cube([10, 10, .1], center = true);
        }
    }

    translate_z(h / 2)
    difference() {
        cube([l + 5.5, w + 5.5, h], center = true);
        cube([l, w, h + 1], center = true);
    }


    module wall_sides(off) {
        for(z = [0 : 7])
        translate([off/2, 0, 10 * z + z + 1 + 10])
        hull() for (y = [0, 4]) {
            translate([0, 10 * y + y + 1 - w / 2 + 4.75, 0])
                rotate([0,-90,0])
                pyramid();
        }
    }

    mirror([1,0,0])
    wall_sides(l);

    wall_sides(l);

//    translate_z((h-7) / 2)
//    cube([0.8, w, h - 7], center = true);
//    wall_sides(0);
//    mirror([1,0,0])
//    wall_sides(0);


    translate([-w/2,w/2])
    rotate([0,0,90])
    wall_sides(0);

    translate([ w/2,w/2])
    rotate([0,0,90])
    wall_sides(0);


    translate([ w/2,-w/2])
    rotate([0,0,270])
    wall_sides(0);


    translate([-w/2,-w/2])
    rotate([0,0,270])
    wall_sides(0);


}


vent();
