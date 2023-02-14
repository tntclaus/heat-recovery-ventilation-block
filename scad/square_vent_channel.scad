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
module square_vent_channel_t_joint_custom(type1, type2, type3, cut_top=false, extra_walls=[20,20,20]) {
    square_vent_channel_t_joint_custom_top(type1, type2, type3, extra_walls, cut=cut_top);

    hflip() vflip()
    square_vent_channel_t_joint_custom_bottom(type1, type2, type3, extra_walls);
}
module square_vent_channel_t_joint_custom_top(type1, type2, type3, extra_walls, cut) {
//    name = str(
//    "ABS_square_vent_channel_t_joint_top_half", cut == true ? "_cut" : "","_w", extra_walls[0],"x",extra_walls[1],"x",extra_walls[2], "_",
//    square_vent_channel_width_inner(type1), "x", square_vent_channel_heigth_inner(type1), "_",
//    square_vent_channel_width_inner(type2), "x", square_vent_channel_heigth_inner(type2), "_",
//    square_vent_channel_width_inner(type3), "x", square_vent_channel_heigth_inner(type3)
//    );
//    stl(name)
    mirror([1,0,0])
    if(cut) {
        w1 = square_vent_channel_width(type1);
        w2 = square_vent_channel_width(type2);
        w3 = square_vent_channel_width(type3);

        depth = (w1 >= w3 ? w1 : w3) + extra_walls[1];

        d2 = square_vent_channel_heigth(type2);

        difference() {
            square_vent_channel_t_joint_custom_half(type1, type2, type3, extra_walls);
            translate([0, d2 / 2, - depth / 2 - 2])
                cube([w2, 4, extra_walls[1]], center = true);
        }
    } else {
        square_vent_channel_t_joint_custom_half(type1, type2, type3, extra_walls);
    }
}

//module square_vent_channel_t_joint_custom_bottom(type1, type2, type3, extra_walls) {
//    name = str(
//    "ABS_square_vent_channel_t_joint_bottom_half_w", extra_walls[0],"x",extra_walls[1],"x",extra_walls[2], "_",
//    square_vent_channel_width_inner(type1), "x", square_vent_channel_heigth_inner(type1), "_",
//    square_vent_channel_width_inner(type2), "x", square_vent_channel_heigth_inner(type2), "_",
//    square_vent_channel_width_inner(type3), "x", square_vent_channel_heigth_inner(type3)
//    );
//    stl(name);
//    square_vent_channel_t_joint_custom_half(type1, type2, type3, extra_walls);
//}

module square_vent_channel_t_joint_custom_half(type1, type2, type3, extra_walls = 20) {

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
    depth = (w1 >= w3 ? w1 : w3) + extra_walls[1];

    h_max = 1000;


    difference() {
        difference() {
            union() {
                rotate([0, 90, 0])
                    square_vent_channel_cube(w_out_type1, width + extra_walls[0] + extra_walls[2]);

                translate_z(- (depth - square_vent_channel_width(w_type)) / 2 - 1)
                square_vent_channel_cube(out_type2, depth);
            }
            translate([- 2, 0, 0])
                rotate([0, 90, 0])
                    square_vent_channel_cube(w_type, width + extra_walls[0] + extra_walls[2] + 1);

            translate([2, 0, 0])
                rotate([0, 90, 0])
                    square_vent_channel_cube(w_type_2, width + extra_walls[0] + extra_walls[2] + 1);


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
//    echo([w_i, h_i, r]);
    rounded_cube_xy([w_i, h_i, length], r = r, xy_center = true, z_center = true);
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


module square_vent_channel_adaptor(channel_in, channel_out, h, a = 0, expand = 5, expand_exit = undef, stl = true) {
//    if(stl) {
//        name = str(
//        "ABS_square_vent_channel_adaptor_",
//        square_vent_channel_fun_name(channel_in), "_2_",
//        square_vent_channel_fun_name(channel_out), "_",
//        "h", h, "_",
//        "a", a, "_",
//        "e", expand
//        );
//        stl(name);
//    }
    expand1 = expand;
    expand2 = expand_exit ? expand_exit : expand;

    module outer_shell() {
        hull() {
            translate_z(h / 2)
            square_vent_channel_cube(channel_in, 0.1);

            translate_z(- h / 2)
            rotate([0, 0, a])
                square_vent_channel_cube(channel_out, 0.1);
        }
    }

    module inner_shell() {
        translate_z(h / 2)
            square_vent_channel_cube_inner(channel_in, 0.2);

            translate_z(- h / 2)
            rotate([0, 0, a])
                square_vent_channel_cube_inner(channel_out, 0.2);
        hull() {
            translate_z(h / 2)
            square_vent_channel_cube_inner(channel_in, 0.1);

            translate_z(- h / 2)
            rotate([0, 0, a])
                square_vent_channel_cube_inner(channel_out, 0.1);
        }
    }

    difference() {
        outer_shell();
        inner_shell();
    }


    translate_z((h+expand1) / 2)
    square_vent_channel_model(channel_in, length = expand1);

    translate_z(-(h+expand2) / 2)
    rotate([0, 0, a])
    square_vent_channel_model(channel_out, length = expand2);
}


module square_to_circular_vent_channel_adaptor(channel_square, channel_circular, h, a = 0, expand = 5) {
    channel_in =  channel_square;
    channel_out = channel_circular;
    name = str(
    "ABS_square_to_circular_vent_channel_adaptor",
    square_vent_channel_fun_name(channel_in), "_2_",
    square_vent_channel_fun_name(channel_out), "_",
    "h", h, "_",
    "a", a, "_",
    "e", expand
    );
    stl(name);

    module outer_shell() {
        hull() {
            translate_z(h / 2)
            square_vent_channel_cube(channel_in, 0.1);

            translate_z(- h / 2)
            rotate([0, 0, a])
                cylinder(d = square_vent_channel_width(channel_out), h = 0.1, center = true);
        }
    }

    module inner_shell() {
        translate_z(h / 2)
            square_vent_channel_cube_inner(channel_in, 0.2);

            translate_z(- h / 2)
            rotate([0, 0, a])
                square_vent_channel_cube_inner(channel_out, 0.2);
        hull() {
            translate_z(h / 2)
            square_vent_channel_cube_inner(channel_in, 0.1);

            translate_z(- h / 2)
            rotate([0, 0, a])
                cylinder(d = square_vent_channel_width_inner(channel_out), h = 0.1, center = true);
        }
    }

    difference() {
        outer_shell();
        inner_shell();
    }


    translate_z((h+expand) / 2)
    square_vent_channel_model(channel_in, length = expand);

    translate_z(-(h+expand-.25) / 2)
    rotate([0, 0, a])
    difference() {
        cylinder(d = square_vent_channel_width(channel_out), h = expand, center = true);
        cylinder(d = square_vent_channel_width_inner(channel_out), h = expand*2, center = true);
    }
//    square_vent_channel_model(channel_out, length = expand);
}

module circular_to_circular_eccentric_vent_channel_adaptor(channel_in, channel_out, h, a = 0, expand = 5) {
    name = str(
    "ABS_circular_to_circular_eccentric_vent_channel_adaptor",
    square_vent_channel_fun_name(channel_in), "_2_",
    square_vent_channel_fun_name(channel_out), "_",
    "h", h, "_",
    "a", a, "_",
    "e", expand
    );
    stl(name);

    module outer_shell() {
        hull() {
            translate_z(h / 2)
            cylinder(d = square_vent_channel_width(channel_in), h = 0.1, center = true);

            translate_z(- h / 2)
            rotate([0, 0, a])
                cylinder(d = square_vent_channel_width(channel_out), h = 0.1, center = true);
        }
    }

    module inner_shell() {
        translate_z(h / 2)
            cylinder(d = square_vent_channel_width_inner(channel_in), h = 0.2, center = true);

            translate_z(- h / 2)
            rotate([0, 0, a])
                cylinder(d = square_vent_channel_width_inner(channel_out), h = 0.2, center = true);
        hull() {
            translate_z(h / 2)
            cylinder(d = square_vent_channel_width_inner(channel_in), h = 0.1, center = true);

            translate_z(- h / 2)
            rotate([0, 0, a])
                cylinder(d = square_vent_channel_width_inner(channel_out), h = 0.1, center = true);
        }
    }

    difference() {
        outer_shell();
        inner_shell();
    }

    translate_z((h+expand) / 2)
    difference() {
        cylinder(d = square_vent_channel_width(channel_in), h = expand, center = true);
        cylinder(d = square_vent_channel_width_inner(channel_in), h = expand*2, center = true);
    }

    translate_z(-(h+expand-.25) / 2)
    rotate([0, 0, a])
    difference() {
        cylinder(d = square_vent_channel_width(channel_out), h = expand, center = true);
        cylinder(d = square_vent_channel_width_inner(channel_out), h = expand*2, center = true);
    }
}



module circular_to_circular_flex_adaptor(channel_in, channel_out, h, a = 0, expand = 5, sections = 10) {
    assert(sections % 2 == 0, "sections count must be even");

    name = str(
    "FLEX_circular_to_circular_flex_adaptor_",
    square_vent_channel_fun_name(channel_in), "_2_",
    square_vent_channel_fun_name(channel_out), "_",
    "h", h, "_",
    "a", a, "_",
    "s", sections, "_",
    "e", expand
    );
    stl(name);


    module shell(d1, d2, outer) {
        assert(d1 >= d2, "d1 must be greater or equal to d2");

        if(!outer) {
            translate_z(h / 2)
            cylinder(d = square_vent_channel_width_inner(channel_in), h = 0.2, center = true);

            translate_z(- h / 2)
            rotate([0, 0, a])
                cylinder(d = square_vent_channel_width_inner(channel_out), h = 0.2, center = true);
        }
        step = h / sections;

        function dia(hf) = (hf+h/2)/h * (d1-d2);
        dimensions = [for(hf = [-h/2 : step : h/2 - step]) [hf, dia(hf)]];

        for(i = [0 : len(dimensions)-1]) {
            hf = dimensions[i][0];
            dia1 = i > 0 ? d2+dimensions[i-1][1] : d2;
            dia2 = i == len(dimensions)-1 ? d1 : d2+dimensions[i][1];
//            echo("HF", hf, dia1, dia2);

            hull() {
                if(i % 2 != 0) {
                    translate_z(hf)
                        cylinder(d = dia1+step, h = 0.1, center = true);

                    translate_z(hf+step)
                    rotate([0, 0, a])
                        cylinder(d = dia2, h = 0.1, center = true);
                } else {
                    translate_z(hf)
                        cylinder(d = dia1, h = 0.1, center = true);

                    translate_z(hf+step)
                    rotate([0, 0, a])
                        cylinder(d = dia2+step, h = 0.1, center = true);
                }
            }
        }
    }

    difference() {
        shell(
            d1 = square_vent_channel_width(channel_in),
            d2 = square_vent_channel_width(channel_out),
            outer = true);
        shell(
            d1 = square_vent_channel_width_inner(channel_in),
            d2 = square_vent_channel_width_inner(channel_out),
            outer = false);
    }

    translate_z((h+expand) / 2)
    difference() {
        cylinder(d = square_vent_channel_width(channel_in), h = expand, center = true);
        cylinder(d = square_vent_channel_width_inner(channel_in), h = expand*2, center = true);
    }

    translate_z(-(h+expand-.25) / 2)
    rotate([0, 0, a])
    difference() {
        cylinder(d = square_vent_channel_width(channel_out), h = expand, center = true);
        cylinder(d = square_vent_channel_width_inner(channel_out), h = expand*2, center = true);
    }
}



module square_to_square_flex_adaptor(channel_in, channel_out, h, a = 0, expand = 10, sections = 10, stl = true) {
//    assert(sections % 2 == 0, "sections count must be even");
//    if(stl) {
//        name = str(
//        "FLEX_square_to_square_flex_adaptor_",
//        square_vent_channel_fun_name(channel_in), "_2_",
//        square_vent_channel_fun_name(channel_out), "_",
//        "h", h, "_",
//        "a", a, "_",
//        "s", sections, "_",
//        "e", expand
//        );
//        stl(name);
//    }


    module channel_cube(outer, size) {
        if(outer)
            square_vent_channel_cube(size, 0.1);
        else
            square_vent_channel_cube_inner(size, 0.1);
    }

    function channel_width(outer, size) = outer ? square_vent_channel_width(size) : square_vent_channel_width_inner(size);
    function channel_depth(outer, size) = outer ? square_vent_channel_heigth(size) : square_vent_channel_heigth_inner(size);

    module shell(in, out, outer) {
//        assert(d1 >= d2, "d1 must be greater or equal to d2");

        if(!outer) {
            translate_z(h / 2)
            square_vent_channel_cube_inner(in, 0.2);

            translate_z(- h / 2)
            rotate([0, 0, a])
                square_vent_channel_cube_inner(out, 0.2);
        }
        step = h / sections;

        r_in = square_vent_channel_radius(in);
        r_out = square_vent_channel_radius(out);
        w_in = channel_width(outer, in);
        w_out = channel_width(outer, out);
        d_in = channel_depth(outer, in);
        d_out = channel_depth(outer, out);

        function w(hf) = (hf+h/2)/h * (w_in-w_out);
        function d(hf) = (hf+h/2)/h * (d_in-d_out);
        function r(hf) = (hf+h/2)/h * (r_in-r_out);
        dimensions = [for(hf = [-h/2 : step : h/2 - step]) [hf, w(hf), d(hf), r(hf)]];

        for(i = [0 : len(dimensions)-1]) {
            s1 = i % 2 == 0 ? 0 : step;
            s2 = i % 2 != 0 ? 0 : step;

            hf = dimensions[i][0];
            w1 = i > 0 ? w_out+dimensions[i-1][1] : w_out;
            d1 = i > 0 ? d_out+dimensions[i-1][2] : d_out;
            r1 = i > 0 ? r_out+dimensions[i-1][3] : r_out;

            w2 = i == len(dimensions)-1 ? w_in : w_out+dimensions[i][1];
            d2 = i == len(dimensions)-1 ? d_in : d_out+dimensions[i][2];
            r2 = i == len(dimensions)-1 ? r_in : r_out+dimensions[i][3];

            chan1 = [0,1,w1+s1,d1+s1,w1+s1,d1+s1,r1];
            chan2 = [0,1,w2+s2,d2+s2,w2+s2,d2+s2,r2];

//            echo("HF", dimensions[i]);

            hull() {
                if(i % 2 != 0) {
                    translate_z(hf)
                        channel_cube(outer, chan1);

                    translate_z(hf+step)
                    rotate([0, 0, a])
                        channel_cube(outer, chan2);
                } else {
                    translate_z(hf)
                        channel_cube(outer, chan1);

                    translate_z(hf+step)
                    rotate([0, 0, a])
                        channel_cube(outer, chan2);
                }
            }
        }
    }

    difference() {
        shell(
            in = channel_in,
            out = channel_out,
            outer = true);
        shell(
            in = channel_in,
            out = channel_out,
            outer = false);
    }

    translate_z((h+expand) / 2)
    square_vent_channel_model(channel_in, length = expand);

    translate_z(-(h+expand) / 2)
    rotate([0, 0, a])
    square_vent_channel_model(channel_out, length = expand);
}

module ellipse(d1, d2, h, $fn=undef) {
    resize([d1, d2, h])
        cylinder(d = 1, h = h, center = true, $fn=$fn);
}


function calculate_ellipse_d2_by_circle_d_and_d1(d_in, d_out1) = d_in + ((3.14 * d_in) - (3.14 * d_out1))/3.14;

module circle_to_ellipse_adaptor(d_in, d_out1, d_out2 = undef, length = 30, wall_thickness = 4) {

    d_out2_calced = d_out2 ? d_out2 : calculate_ellipse_d2_by_circle_d_and_d1(d_in, d_out1);

    y_shift = (d_out2_calced - d_in)/2;

    throat_h = 7;

    module shell(d_in, d_out1, d_out2, h) {
        hull() {
            translate_z(h / 2)
            cylinder(d = d_in, h = 0.1, center = true);

            translate([0, y_shift, - h / 2])
            ellipse(d_out1, d_out2, h = 0.1, $fn=90);
        }
    }

    echo(d_in, d_out1, d_out2_calced);


    difference() {
        union() {
            shell(d_in = d_in + wall_thickness, d_out1 = d_out1 + wall_thickness, d_out2 = d_out2_calced +
                wall_thickness, h = length);

            translate_z(length / 2 + throat_h/2)
                cylinder(d = d_in+ wall_thickness, h = throat_h, center = true);

            translate([0, y_shift, - length / 2 - throat_h/2])
                ellipse(d_out1 + wall_thickness, d_out2_calced + wall_thickness, h = throat_h, $fn=90);
        }
        shell(d_in = d_in, d_out1 = d_out1, d_out2 = d_out2_calced, h = length+.01);

        translate_z(length / 2 + throat_h/2)
            cylinder(d = d_in, h = throat_h+.1, center = true);

        translate([0, y_shift, - length / 2 - throat_h/2])
            ellipse(d_out1, d_out2_calced, h = throat_h+.1, $fn=90);

    }

}
