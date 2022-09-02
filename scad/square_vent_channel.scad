include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>


function square_vent_channel_fun_name(type) = type[0];
function square_vent_channel_name(type) = type[1];
function square_vent_channel_width(type) = type[2];
function square_vent_channel_heigth(type) = type[3];
function square_vent_channel_width_inner(type) = type[4];
function square_vent_channel_heigth_inner(type) = type[5];
function square_vent_channel_radius(type) = type[6];



module square_vent_channel_cube_inner(type, length) {
    w_i = square_vent_channel_width_inner(type);
    h_i = square_vent_channel_heigth_inner(type);
    r = square_vent_channel_radius(type);
    rounded_cube_xy([w_i, h_i, length], r = 2, xy_center = true, z_center = true);
}

module square_vent_channel_cube(type, length) {
    w = square_vent_channel_width(type);
    h = square_vent_channel_heigth(type);
    r = square_vent_channel_radius(type);
    rounded_cube_xy([w, h, length], r = 2, xy_center = true, z_center = true);
}

module square_vent_channel_model(type, length) {
    difference() {
        square_vent_channel_cube(type, length);
        square_vent_channel_cube_inner(type, length * 2);
    }
}


module square_vent_channel(type, length) {
    vitamin(str(
    square_vent_channel_fun_name(type), "(", length, "): ",
    square_vent_channel_name(type), "x", length));

    square_vent_channel_model(type, length);
}
