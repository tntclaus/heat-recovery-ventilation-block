include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>

include <NopSCADlib/vitamins/nuts.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/fans.scad>

include <square_vent_channels.scad>

include <config.scad>

h = 100;


module place_fans4square_vent(w) {
    translate([w/2, 0, 0])
        children();

    translate([- w/2, 0, 0])
        children();
}

function fan_to_vent(fan_type) = ["", "", fan_width(fan_type)+4, fan_width(fan_type)+4, fan_width(fan_type), fan_width(fan_type), 5];

/**
* Заглушка на канал
*/
module fan_holder_square_vent(fan_type, vent_type) {
    circular_vent92 = fan_to_vent(fan_type);

//    name = str(
//        "ABS_fan_holder_square_vent_",
//        square_vent_channel_fun_name(vent_type), "_2_fan",
//        fan_width(fan_type),"x",fan_width(fan_type)
//        );
//    stl(name);

    translate_z(-5){
        translate_z(- 26)
        fan4square_vent_cap(fan_type);

        square_vent_channel_adaptor(vent_type, circular_vent92, 30, expand = 5, stl = false);
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

module fan4square_vent_cap(fan_type, fan_cuts = true) {
    fw = fan_width(fan_type);
//    if(material != "") {
//        stl(str(
//        material, "_fan_cap_",
//        fan_width(fan_type), "x", fan_depth(fan_type)
//        ));
//    }

    module fan_cut(a) {
        rotate([0, 0, a])
                    rounded_cube_xy(
                        [fan_aperture(fan_type) + fan_thickness(fan_type) * 2, 4, 10],
                    1, xy_center = true, z_center = true);
    }

    module fan_base() {
        difference() {
            rounded_cube_xy([fw,fw,2], 2, xy_center = true);
            fan_holes(fan_type);
            if(fan_cuts) {
                fan_cut(45);
                fan_cut(-45);
            }
        }
    }

    translate_z(6)
    fan_base();
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

module fan_inblower_assembly(vent_type, fan_type) {
    w = fan_width(fan_type)+1;

    assembly("fan_inblower") {
        translate_z(-40)
        fan(fan_type);
        fan_holder_square_vent(fan_type,change_type(vent_type, 9, 9));
        translate_z(-33)
        color("red")
        FLEX_fan_gasket_stl();
    }
}

module fan_outblower_assembly() {
    fan_type = FAN_TYPE;
    w = fan_width(fan_type);

    assembly("fan_outblower") {
        translate_z(-30.5)
        fan(fan_type);
        ABS_airduct_outlet_fan_adaptor_stl();

        translate_z(-24)
        color("red")
        FLEX_fan_gasket_stl();

        translate_z(-62)
        FLEX_outlet_fan_2_tube_adaptor_stl();
        translate_z(-80) {
            ABS_fan_sleeve_stl();
            hflip() vflip() ABS_fan_sleeve_stl();
        }
    }
}



module ABS_fan_sleeve_stl() {
    stl("ABS_fan_sleeve");
    fw = fan_width(FAN_TYPE) + 10;
    fw_inner = fan_width(FAN_TYPE) + 4;

    module place_mount_hole() {
        for(x = [-1, 1])
        translate([x*(fw/2+6),0,0])
            rotate([90,0,0])
                children();
    }

    translate_z(40)
    difference() {
        union() {
            rounded_cube_xy([fw, fw, 10], 2, xy_center = true, z_center = true);
            rounded_cube_xz([fw_inner+30, 7, 10], 2, xy_center = true, z_center = true);


        }
        rounded_cube_xy([fw_inner, fw_inner, 11], 2, xy_center = true, z_center = true);

        translate([0,fw-.25,0])
        cube([fw*2,fw*2,fw*2], center = true);

        place_mount_hole()
            cylinder(d = 3.5, h = 100, center = true);
    }


    //    cube([fw,fw,fw]);
}

//module ABS_fan4square_vent_cap_fan60x20_stl() {
//    fan4square_vent_cap(fan60x20);
//}
//
//module ABS_fan4square_vent204x60_middle_square_vent_204x60_l30_stl() {
//    fan4square_vent204x60_middle(square_vent204x60, 30);
//}
//
//module ABS_fan4square_vent_base_fan60x20_stl() {
//    fan4square_vent_base(fan60x20);
//}
