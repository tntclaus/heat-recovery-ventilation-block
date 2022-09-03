include <NopSCADlib/utils/core/core.scad>

include <square_vent_channels.scad>
include <config.scad>
use <sections.scad>


/**
* Фильтр из металлической сетки:
* Mesh 60 или 30 — https://aliexpress.ru/item/1005003473125481.html
*/
module mesh_filter(type) {
    stl(str("ABS_mesh_filter_cap_", square_vent_channel_fun_name(type)));

    length = 10;
    wall_thickness = PRINTED_WALL_THICKNESS;
    channel_cap_model(type, wall_thickness, length);
}

/**
* Деталь для установки фильтров, склеивается из 3 частей.
* Подключается между двух плоских воздуховодов.
*/
module air_filter_holder_assembly(type) {
    assembly("air_filter_holder") {
        d = 42;
        translate_z(d / 2)
        air_filter_holder_side(type);

        translate_z(- d / 2)
        rotate([180, 0, 0])
            air_filter_holder_side(type);

        air_filter_holder_middle(type, length = 32);
    }
}


module air_filter_heat_breaker_assembly(type) {
    assembly("air_filter_holder") {
        d = 18;
        translate_z(d / 2)
        air_filter_holder_side(type);

        translate_z(- d / 2)
        rotate([180, 0, 0])
            air_filter_holder_side(type);

        air_filter_holder_middle(type, length = 8);
    }
}

/**
* Многослойный фильтр:
* Слой 1 ( 5мм) — грубая очистка https://aliexpress.ru/item/32760571194.html
* Слой 2 (10мм) — HEPA https://aliexpress.ru/item/1005001619559275.html
* Слой 3 ( 5мм) — угольный фильтр https://aliexpress.ru/item/32789944517.html
* Толщина 20 мм
*/
module air_filter_cassette_assembly(type) {
    inside_type = inside_type(square_vent110x55);

    air_filter_cassette_top(inside_type);
    vflip()
    air_filter_cassette_bottom(inside_type);
}

module air_filter_cassette_top(type) {
    stl(str("ABS_air_filter_cassette_top_", square_vent_channel_fun_name(type)));
    channel_cap_model(type, PRINTED_WALL_THICKNESS, 31.8);
}

module air_filter_cassette_bottom(type) {
    stl(str("ABS_air_filter_cassette_bottom_", square_vent_channel_fun_name(type)));

    translate_z(-31.8/2+7.5/2)
    square_vent_channel_model(type, 5);
}


module air_filter_holder_side(type) {
    stl(str("ABS_air_filter_holder_side_", square_vent_channel_fun_name(type)));

    length = 10;
    wall_thickness = PRINTED_WALL_THICKNESS;
    channel_cap_model(type, wall_thickness, length);
}

module air_filter_holder_middle(type, length) {
    wall_thickness = PRINTED_WALL_THICKNESS;

    w_o = square_vent_channel_width(type) + wall_thickness * 2;
    h_o = square_vent_channel_heigth(type) + wall_thickness * 2;
    w = square_vent_channel_width(type);
    h = square_vent_channel_heigth(type);

    stl(str(
    "ABS_air_filter_holder_middle_", square_vent_channel_fun_name(type), "_",
    "l", length));

    difference() {
        rounded_cube_xy([w_o, h_o, length], r = 2, xy_center = true, z_center = true);
        rounded_cube_xy([w, h, length*2], r = 2, xy_center = true, z_center = true);

        translate([0,h,0])
        cube([w, h*2, length], center = true);
    }
}


/***
 ***
 *** Генераторы STL
 ***
 ***/
module ABS_air_filter_holder_middle_square_vent_110x55_l32_stl() {
    air_filter_holder_middle(square_vent110x55, length = 32);
}

module ABS_air_filter_holder_side_square_vent_110x55_stl() {
    air_filter_holder_side(square_vent110x55);
}


module ABS_mesh_filter_cap_square_vent_110x55_stl() {
    mesh_filter(square_vent110x55);
}

module ABS_air_filter_cassette_top_square_vent_105x50_stl() {
    type = square_vent110x55;
    inside_type = inside_type(square_vent110x55);
    air_filter_cassette_top(inside_type);
}


module ABS_air_filter_cassette_bottom_square_vent_105x50_stl(){
    type = square_vent110x55;
    inside_type = inside_type(square_vent110x55);
    air_filter_cassette_bottom(inside_type);
}
