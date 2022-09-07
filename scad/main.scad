include <filter_section.scad>
include <fan_section.scad>
include <valve_section.scad>
use <recuperation_section.scad>

WINDOW_WIDTH = 1600;
WINDOW_DEPTH = 300;
WINDOW_HEIGTH = 120;
AVAILABLE_DEPTH = 550;

square_vent103x49 = change_type(square_vent110x55, dw = - 4, dh = - 3);
square_vent88x80 = change_type(square_vent80x80, dw = 8, dh = 0);
square_vent48x80 = change_type(square_vent40x80, dw = 8, dh = 0);

module draw_window() {

    module vent_hole() {
        cube([130, AVAILABLE_DEPTH, WINDOW_HEIGTH * 2], center = true);
    }

    translate([0, - WINDOW_DEPTH / 2 + AVAILABLE_DEPTH, 0])
        color("lightblue") difference() {
            cube([WINDOW_WIDTH, WINDOW_DEPTH, WINDOW_HEIGTH], center = true);
            translate([- WINDOW_WIDTH / 2 + 100, 0, 0])
                vent_hole();
            translate([- WINDOW_WIDTH / 2 + 100 + 110 / 2 + 80 + 110 / 2, 0, 0])
                vent_hole();
        }
    translate([0, - AVAILABLE_DEPTH / 2 + AVAILABLE_DEPTH, - WINDOW_HEIGTH])
        color("blue")
            cube([WINDOW_WIDTH, AVAILABLE_DEPTH, WINDOW_HEIGTH], center = true);
}

module place_mesh_filter() {
    translate([- 435, 445, 0])
        rotate([- 90, 0, 180])
            mesh_filter(square_vent110x55);
}

module recuperator_assembly() {
    assembly("recuperator"){
        tjw = square_vent_channel_t_joint_width(square_vent204x60_t_joint);
        chw = square_vent_channel_width(square_vent204x60_t_joint);
        off = (tjw - chw) / 2;

        tj_shift = 500 - tjw / 2 + off;


        color("white")
            translate([- tj_shift - 52, 0, 0])
                rotate([90, 0, 0])
                    square_vent_channel_t_joint_custom(
                    square_vent154x80_t_joint,
                    square_vent48x80,
                    square_vent154x80_t_joint, cut_top = true, extra_walls = [15, 35, 10]);

        rotate([0, 0, 90])
            recuparator_section_assembly(
            change_type(square_vent154x80_t_joint, dw = - 2, dh = - 2)
            );

        color("green")
            translate([tj_shift + 45, 0, 0])
                rotate([- 90, 0, 0])
                    square_vent_channel_t_joint_custom(
                    square_vent154x80_t_joint,
                    square_vent103x49,
                    square_vent154x80_t_joint);
    }
}

module ventilation_assembly() {
    place_mesh_filter();

    //    translate([0,50,0])
    //    rotate([90,0,0])
    //    valve_section_assembly();
    //
    //    translate([0,110,0])
    //    rotate([90,0,0])
    //    air_filter_heat_breaker_assembly(square_vent110x55);
    //
    //    translate([0,150,0])
    //    rotate([90,0,0])
    //    air_filter_heat_breaker_assembly(square_vent110x55);
    //
    //    translate([0,200,0]) {
    //        rotate([90, 0, 0])
    //            air_filter_holder_assembly(square_vent110x55);
    //
    //        translate([0, 0, 60])
    //            rotate([90, 0, 0])
    //                air_filter_cassette_assembly(square_vent110x55);
    //    }

    //        translate([-550,-30,0])
    //        rotate([90,0,90])
    //        fan_outblower_assembly(square_vent154x80_t_joint);

    translate([-434,145,0])
    rotate([90,0,0])
    square_vent_channel_adaptor(
    change_type(square_vent48x80, dw = 4, dh = 3), square_vent103x49, h = 50);

    translate([14,0,0])
    recuperator_assembly();
}

module main_assembly() {
    draw_window();
//
    translate([- 76, 100, - 5])
        ventilation_assembly();

}

if ($preview)
main_assembly();

/**
* STL
*/
module ABS_square_vent_channel_t_joint_bottom_half_w15x40x10_154x80_88x80_154x80_stl() {
    square_vent_channel_t_joint_custom_bottom(
    square_vent154x80_t_joint,
    square_vent88x80,
    square_vent154x80_t_joint, extra_walls = [15, 40, 10]);
}

module ABS_square_vent_channel_t_joint_top_half_cut_w15x40x10_154x80_88x80_154x80_stl() {
    square_vent_channel_t_joint_custom_top(
    square_vent154x80_t_joint,
    square_vent88x80,
    square_vent154x80_t_joint, cut = true, extra_walls = [15, 40, 10]);
}

module ABS_square_vent_channel_t_joint_bottom_half_w20x20x20_154x80_103x49_154x80_stl() {
    square_vent_channel_t_joint_custom_bottom(
    square_vent154x80_t_joint,
    square_vent103x49,
    square_vent154x80_t_joint, extra_walls = [20, 20, 20]);
}

module ABS_square_vent_channel_t_joint_top_half_w20x20x20_154x80_103x49_154x80_stl() {
    square_vent_channel_t_joint_custom_top(
    square_vent154x80_t_joint,
    square_vent103x49,
    square_vent154x80_t_joint, extra_walls = [20, 20, 20]);
}

module ABS_recuperator_tubes_cartridge_156x82_stl() {
    tubes_cartridge(square_vent154x80_t_joint);
}
