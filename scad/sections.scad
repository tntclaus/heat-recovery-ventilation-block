include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/core/rounded_rectangle.scad>

include <square_vent_channels.scad>
include <fan_section.scad>

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

module recuperator_cross() {
    ABS_recuperation_cross_half_stl();

    hflip() vflip()
    ABS_recuperation_cross_half_stl();
}

module ABS_recuperation_cross_half_stl() {
    stl("ABS_recuperation_cross_half");
    square_vent_channel_t_joint_custom_top(heatexchanger_face_type, RECUPERATOR_IN_CHANNEL, heatexchanger_face_type, extra_walls = [10, 10, 10]);
}


module ABS_airduct_inlet_fan_adaptor_stl() {
    stl("ABS_airduct_inlet_fan_adaptor");

    square_vent_channel_adaptor(square_vent148x108_t_joint, fan_to_vent(fan92x25), 30, expand = 10, expand_exit = 1);

    translate_z(-22) {
        fan4square_vent_cap(fan92x25, fan_to_vent(fan92x25), fan_cuts = false, material = "");
    }
}

module ABS_airduct_outlet_fan_adaptor_stl() {
    stl("ABS_airduct_outlet_fan_adaptor");

    square_vent_channel_adaptor(square_vent148x108_t_joint, fan_to_vent(fan92x25), 30, expand = 10, expand_exit = 1);

    translate_z(-22) {
        fan4square_vent_cap(fan92x25, fan_cuts = false);
    }
}

module FLEX_outlet_fan_2_tube_adaptor_stl() {
    stl("FLEX_outlet_fan_2_tube_adaptor");

    h = 30;
    color("red") {
        circular_vent92 = fan_to_vent(FAN_TYPE);
        square_vent_channel_adaptor(circular_vent92, square_vent113x58, h, expand = 10);
        translate_z(h / 2 + 2){
            fan4square_vent_cap(fan92x25);

            translate_z(- 8.5)
            fan_hole_positions(fan92x25)
            cylinder(d = 4.5, h = 4);
        }
    }
}

module FLEX_inlet_fan_2_tube_adaptor_stl() {
    stl("FLEX_inlet_fan_2_tube_adaptor");
    color("red") {

        h = 60;
        circular_vent92 = fan_to_vent(FAN_TYPE);
        square_to_square_flex_adaptor(circular_vent92, square_vent110x55, h, sections = 8);
        translate_z(h / 2 + 2){
            fan4square_vent_cap(FAN_TYPE);

            translate_z(- 8.5)
            fan_hole_positions(fan92x25)
            cylinder(d = 4.5, h = 4);
        }
    }
}

module FLEX_fan_gasket_stl() {
    stl("FLEX_fan_gasket");
    fan4square_vent_cap(FAN_TYPE, fan_cuts = false);
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

