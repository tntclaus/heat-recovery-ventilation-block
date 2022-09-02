include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>

include <NopSCADlib/vitamins/fans.scad>


include <config.scad>

h = 100;
//difference() {
//    rounded_cube_xy([WIDTH_O, HEIGTH_O, h], r = 2, xy_center = true, z_center = true);
//    rounded_cube_xy([WIDTH_I, HEIGTH_I, h + .1], r = 2, xy_center = true, z_center = true);
//}


module extra_fan_shtuzer(type, d_i, d_o, count = 0) {
    w = fan_width(type);
    difference() {
        union() {
            translate_z(20)
            cylinder(d = d_o, h = 10);
            hull() {
                translate_z(20)
                cylinder(d = d_o, h = 1);
                cylinder(d = fan_bore(type) + 2, h = 1);
            }
        }

        cylinder(d = d_i, h = 100, center = true);
        hull() {
            translate_z(20)
            cylinder(d = d_i, h = 1);
            cylinder(d = fan_bore(type), h = 1, center = true);
        }
    }
    difference() {
        cube([w, w, 4], center = true);
        cylinder(d = fan_bore(type), h = 10, center = true);
        fan_holes(type);
    }
}



translate([-30,0,0])
fan(fan60x20);
translate([30,0,0])
fan(fan60x20);

extra_fan_shtuzer(fan60x20, 50, 54, 2);
