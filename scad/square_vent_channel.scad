include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>


function square_vent_channel_fun_name(type) = type[0];
function square_vent_channel_name(type) = type[1];
function square_vent_channel_width(type) = type[2];
function square_vent_channel_heigth(type) = type[3];
function square_vent_channel_width_inner(type) = type[4];
function square_vent_channel_heigth_inner(type) = type[5];
function square_vent_channel_radius(type) = type[6];

function square_vent_channel_t_joint_depth(type) = type[7];
function square_vent_channel_t_joint_width(type) = type[8];


function change_type(type, dw, dh, dr = 0) = [str("square_vent_", type[2] + dw, "x", type[3] + dh), "", type[2] + dw,
        type[3] + dh, type[4] + dw, type[5] + dh, type[6] + dr];

module square_vent_channel_vitamin(type) {
    vitamin(str(square_vent_channel_fun_name(type), ": ", square_vent_channel_name(type)));
};

/**
* Печатаемый тройник
* @param type1 — вход 1
* @param type2 — вход 2
* @param type3 — вход 3
* Вид:
* 1 — T — 3
*     2
*/
module square_vent_channel_t_joint_custom(type1, type2, type3) {
    square_vent_channel_t_joint_custom_half(type1, type2, type3);
}
module square_vent_channel_t_joint_custom_half(type1, type2, type3, extra_walls = 20) {
    name = str(
    "ABS_square_vent_channel_t_joint_half_w", extra_walls, "_",
    square_vent_channel_width(type1), "x", square_vent_channel_heigth(type1), "_",
    square_vent_channel_width(type2), "x", square_vent_channel_heigth(type2), "_",
    square_vent_channel_width(type3), "x", square_vent_channel_heigth(type3), "_"
    );
    stl(name);
    out_type1 = change_type(type1, dw = 4, dh = 3);
    out_type2 = change_type(type2, dw = 4, dh = 3);
    out_type3 = change_type(type3, dw = 4, dh = 3);

    w1 = square_vent_channel_width(type1);
    w2 = square_vent_channel_width(type2);
    w3 = square_vent_channel_width(type3);

    w_out_type1 = w1 >= w3 ? out_type1 : out_type3;
    w_type = w1 >= w3 ? type1 : type3;
    w_type_2 = w1 >= w3 ? type3 : type1;
    //    d_type
    width = w2;
    depth = (w1 >= w3 ? w1 : w3) + extra_walls;

    h_max = 1000;


    difference() {
        difference() {
            union() {
                rotate([0, 90, 0])
                    square_vent_channel_cube(w_out_type1, width + extra_walls * 2);

                translate_z(- (depth - square_vent_channel_width(w_type)) / 2 - 1)
                square_vent_channel_cube(out_type2, depth);
            }
            translate([- 2, 0, 0])
                rotate([0, 90, 0])
                    square_vent_channel_cube(w_type, width + extra_walls * 2 + 1);

            translate([2, 0, 0])
                rotate([0, 90, 0])
                    square_vent_channel_cube(w_type_2, width + extra_walls * 2 + 1);


            translate_z(- (depth - square_vent_channel_width(w_type)) / 2 - 3)
            square_vent_channel_cube(type2, depth);
        }
        translate([0,-h_max/2,0])
        cube([1000,h_max,1000], center = true);
    }
}

/**
* Стандартный тройник
*/
module square_vent_channel_t_joint(type) {
    square_vent_channel_vitamin(type);

    d = square_vent_channel_t_joint_depth(type) - 1;
    w = square_vent_channel_t_joint_width(type);

    difference() {
        union() {
            translate_z(- (d - square_vent_channel_width(type)) / 2 - 1)
            square_vent_channel_cube(type, d);
            rotate([0, 90, 0])
                square_vent_channel_model(type, w);
        }
        rotate([0, 90, 0])
            square_vent_channel_cube_inner(type, w);

        translate_z(- (d - square_vent_channel_width(type)) / 2 - 3)
        square_vent_channel_cube_inner(type, d);
    }
}


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
