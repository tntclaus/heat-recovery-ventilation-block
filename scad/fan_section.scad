include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>

include <NopSCADlib/vitamins/nuts.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/fans.scad>

include <square_vent_channels.scad>


include <config.scad>

h = 100;


//square_vent208x64 = ["square_vent_208x64", "Обвод вокруг канала 204x60", 208, 64, 204, 60, 5];

module place_fans4square_vent(w) {
    translate([w, 0, 0])
        children();

    children();

    translate([- w, 0, 0])
        children();
}

/**
* Заглушка на канал
*/
module fan_holder_square_vent_assembly(fan_type, vent_type) {
    assembly("fan_holder_square_vent204x60") {
        translate_z(- 15.01 - 14.4 / 2)
        fan4square_vent_cap(fan_type, vent_type);

        translate_z(15.01 + 14.4 / 2)
        vflip()
        fan4square_vent_cap(fan_type, vent_type);

        fan4square_vent204x60_middle(square_vent204x60, 30);
    }

}

module fan4square_vent204x60_middle(type, length) {
    wall_thickness = PRINTED_WALL_THICKNESS;

    w_o = square_vent_channel_width(type) + wall_thickness * 2;
    h_o = square_vent_channel_heigth(type) + wall_thickness * 2;
    w = square_vent_channel_width(type);
    h = square_vent_channel_heigth(type);

    stl(str(
    "ABS_fan4square_vent204x60_middle_", square_vent_channel_fun_name(type), "_",
    "l", length));

    difference() {
        rounded_cube_xy([w_o, h_o, length], r = 2, xy_center = true, z_center = true);
        rounded_cube_xy([w, h, length * 2], r = 2, xy_center = true, z_center = true);

        translate([0, h, 0])
            cube([w, h * 2, length], center = true);
    }
}

module fan4square_vent_cap(fan_type, vent_type) {
    stl(str("ABS_fan4",square_vent_channel_fun_name(vent_type),"_cap_fan", fan_width(fan_type), "x", fan_depth(fan_type)));

    bigger_type = change_type(vent_type, dw=4,dh=4);
    module fan_base() {
        difference() {
            square_vent_channel_cube(bigger_type, 2);

            place_fans4square_vent(65){
                fan_holes(fan_type);
            }
        }
    }

    translate_z(6)
    fan_base();
    square_vent_channel_model(bigger_type, 10);
}

module fan4square_vent_base(fan_type, vent_type) {
    stl(str("ABS_fan4",square_vent_channel_fun_name(vent_type),"_base_fan", fan_width(fan_type), "x", fan_depth(fan_type)));

    w = fan_width(fan_type);
    module fan_base() {
        difference() {
            square_vent_channel_cube(square_vent204x60, 10);

            place_fans4square_vent(65){
                fan_holes(fan_type);
            }

            translate_z(5 + .1)
            place_fans4square_vent(65){
                fan_hole_positions(fan_type) {
                    translate_z(- fan_depth(fan_type) / 2)
                    vflip()
                    cylinder(r = nut_radius(M4_nut), h = nut_trap_depth(M4_nut), $fn = 6);
                }
            }
        }
    }

    fan_base();
}

module fan_outblower_assembly(vent_type) {
    w = fan_width(fan60x20);

    assembly("fan_outblower") {
        translate_z(30 / 2) {
            translate_z(- 20)
            place_fans4square_vent(60)
            fan(fan60x20);

            translate_z(- 5.01)
            fan4square_vent_base(fan60x20, vent_type);
        }

        fan_holder_square_vent_assembly(fan60x20,vent_type);
    }
}


module ABS_fan4square_vent_cap_fan60x20_stl() {
    fan4square_vent_cap(fan60x20);
}

module ABS_fan4square_vent204x60_middle_square_vent_204x60_l30_stl() {
    fan4square_vent204x60_middle(square_vent204x60, 30);
}

module ABS_fan4square_vent_base_fan60x20_stl() {
    fan4square_vent_base(fan60x20);
}
