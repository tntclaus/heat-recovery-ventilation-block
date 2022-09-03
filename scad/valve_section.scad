include <NopSCADlib/utils/core/core.scad>

include <square_vent_channels.scad>
include <config.scad>
use <sections.scad>

/**
* Заслонка
*/
module valve_section_assembly() {
    type = square_vent110x55;
    length = 54;
    translate_z(length/2+5)
    valve_section_side(type);
    valve_section_middle(type, length);
    translate_z(-length/2-5)
    vflip()
    valve_section_side(type);
}

module valve_section_side(type) {
    stl(str("ABS_valve_section_", square_vent_channel_fun_name(type)));

    length = 10;
    wall_thickness = PRINTED_WALL_THICKNESS;
    channel_cap_model(type, wall_thickness, length);
}

module valve_section_middle(type, length) {
    wall_thickness = PRINTED_WALL_THICKNESS;

    w_o = square_vent_channel_width(type) + wall_thickness * 2;
    h_o = square_vent_channel_heigth(type) + wall_thickness * 2;
    w = square_vent_channel_width(type);
    h = square_vent_channel_heigth(type);


    new_type = inside_type(type=type, wth=-4);

    stl(str(
    "ABS_valve_section_middle_", square_vent_channel_fun_name(type), "_",
    "l", length));


    square_vent_channel_model(new_type, length);
}
