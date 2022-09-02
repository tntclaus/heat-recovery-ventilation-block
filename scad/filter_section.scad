include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/core/rounded_rectangle.scad>

include <square_vent_channels.scad>

include <config.scad>


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

        air_filter_holder_middle(type, wall_thickness = PRINTED_WALL_THICKNESS, length = 32);
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
}

module air_filter_holder_side(type) {
    stl(str("ABS_air_filter_holder_side_", square_vent_channel_fun_name(type)));

    length = 10;
    wall_thickness = PRINTED_WALL_THICKNESS;
    channel_cap_model(type, wall_thickness, length);
}

module air_filter_holder_middle(type, wall_thickness, length) {
    w_o = square_vent_channel_width(type) + wall_thickness * 2;
    h_o = square_vent_channel_heigth(type) + wall_thickness * 2;
    w = square_vent_channel_width(type);
    h = square_vent_channel_heigth(type);

    stl(str("ABS_air_filter_holder_middle_", square_vent_channel_fun_name(type)));

    difference() {
        rounded_cube_xy([w_o, h_o, length], r = 2, xy_center = true, z_center = true);
        rounded_cube_xy([w, h, length*2], r = 2, xy_center = true, z_center = true);

        translate([0,h,0])
        cube([w, h*2, length], center = true);
    }
}
