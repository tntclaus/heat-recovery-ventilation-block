include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/core/rounded_rectangle.scad>

include <square_vent_channels.scad>

include <config.scad>

function inside_type(type, wth = PRINTED_WALL_THICKNESS*2+1) = [str("square_vent_",type[2]-wth,"x",type[3]-wth),"",type[2]-wth,type[3]-wth,type[4]-wth,type[5]-wth,type[6]+1];

module channel_cap_model(type, wall_thickness, length) {
    w = square_vent_channel_width(type) + wall_thickness * 2;
    h = square_vent_channel_heigth(type) + wall_thickness * 2;
    w_i = square_vent_channel_width_inner(type) - wall_thickness * 2;
    h_i = square_vent_channel_heigth_inner(type) - wall_thickness * 2;

    difference() {
        rounded_cube_xy([w, h, length], r = 2, xy_center = true, z_center = true);
        translate_z(2)
        square_vent_channel_cube(type, length);
        rounded_cube_xy([w_i, h_i, length * 2], r = 2, xy_center = true, z_center = true);
    }
}

//module t_joint_166x92_to_114x59_adaptor() {
//    square_vent_channel_adaptor(square_vent166x92, square_vent114x59, 50, expand = 10);
//}
//
//module t_joint_166x92_to_D100_adaptor() {
//    square_to_circular_vent_channel_adaptor(square_vent166x92, circular_vent100, 50, expand = 10);
//}

module t_joint_140x100_to_D100_adaptor() {
    square_to_circular_vent_channel_adaptor(square_vent148x108_t_joint, circular_vent100, 40, expand = 10);
}

module D125_to_D100_adaptor() {
    circular_to_circular_eccentric_vent_channel_adaptor(circular_vent125, circular_vent100, 50, expand = 10);
}

module D125_to_D100_flex_adaptor() {
    color("red")
    circular_to_circular_flex_adaptor(circular_vent125, circular_vent100, 55, expand = 10);
}

module D100_to_D100_flex_adaptor() {
    color("red")
    circular_to_circular_flex_adaptor(circular_vent100, circular_vent100, 60, expand = 10);
}

