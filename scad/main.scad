include <filter_section.scad>
include <fan_section.scad>
include <valve_section.scad>
use <recuperation_section.scad>

WINDOW_WIDTH = 1600;
WINDOW_DEPTH = 300;
WINDOW_HEIGTH = 120;
AVAILABLE_DEPTH = 550;

fan92x25 = [92,  25, 88, 41, M4_dome_screw, 41,   4.3, 90, 7, 0,   95];


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

heatexchanger_face_type = square_vent140x100_t_joint;
inlet_width = floor(SPACE_IN(heatexchanger_face_type) / (VC(heatexchanger_face_type) * TUBE_V_SPACING()));

inlet_tube_type = [
    "inlet_tube_type",
    "inlet tube type",
        inlet_width,
        square_vent_channel_heigth(heatexchanger_face_type),
        inlet_width-4,
        square_vent_channel_heigth(heatexchanger_face_type)-4,
        1
    ];

module recuperator_assembly() {
    assembly("recuperator"){

        // расчёт ширины окна вдува по площади выдува
        vc = VC(heatexchanger_face_type);


        //
//        echo(inlet_width);

        tjw = square_vent_channel_t_joint_width(square_vent204x60_t_joint);
        chw = square_vent_channel_width(square_vent204x60_t_joint);
        off = (tjw - chw) / 2;

        tj_shift = 500 - tjw / 2 + off;


        // на улицу
        translate([- tj_shift - 75, 0, 0]) {
            color("white")
                rotate([90, 0, 0])
                    square_vent_channel_t_joint_custom(
                    heatexchanger_face_type,
                    inlet_tube_type,
                    heatexchanger_face_type,
                    extra_walls = [10, 10, 10]);

            // переходник выдува
            translate([- 102, 0, 0])
                rotate([- 90, - 0, - 90]) {
                    t_joint_140x100_to_D100_adaptor();
                }

            //            translate([0,145,0])
            //            rotate([90,0,0])
            //                square_vent_channel_adaptor(square_vent_54x91, square_vent110x55, h = 50);

        }

        // теплообменник
        rotate([0, 0, 90])
            recuparator_section_assembly(
            change_type(heatexchanger_face_type, dw = - 2, dh = - 2),
            hide = false
            );

        // в помещение
        translate([tj_shift + 45, 0, 0]) {
            rotate([- 90, 0, 0])
                color("green")
                    square_vent_channel_t_joint_custom(
                    heatexchanger_face_type,
                    inlet_tube_type,
                    heatexchanger_face_type,
                    extra_walls = [10, 10, 10]);

            translate([0, - 95, 0])
                rotate([- 90, 0, 0])
                    fan_inblower_assembly(inlet_tube_type, fan_type = fan92x25);
//                    square_vent_channel_adaptor(change_type(inlet_tube_type, 8, 8), square_vent114x59, 40, expand = 10);
//                    square_vent_channel_adaptor(square_vent114x59, square_vent170x80, 40, expand = 15);

            //            color("red")
            //                translate([0, - 165, 0])
            //                    rotate([- 90, 0, 0])
            //                        air_filter_cassette_top(square_vent170x80);

            // переходник выдува
            translate([100, 0, 0])
            rotate([ 90, - 0, - 90]) {
                t_joint_140x100_to_D100_adaptor();
            }
        }
    }
}

module ventilation_assembly() {
//    place_mesh_filter();

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

    translate([- 555, 0, 0])
        rotate([90, 0, 90]) {
//                    air_filter_heat_breaker_assembly(square_vent110x55, l = 40);
//                    translate([0,10,10])
//                    fan_outblower_assembly(square_vent_91x54);
        }


    translate([- 434, 145, 0])
        rotate([90, 0, 0]) {
                    translate([0, 0, 50]) {
                        fan_inblower_assembly(inlet_tube_type, fan_type = fan92x25);

                    }

        }

    translate([37, 0, 0])
        recuperator_assembly();

//    translate([434, - 245, - 50])
//        rotate([0, 180, 0]) {
//            difference() {
//                D100_to_D100_flex_adaptor();
//                translate([-50,0,0])
//                cube([100,200,100], center = true);
//            }
//        }

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
module ABS_square_vent_channel_t_joint_bottom_half_w10x10x10_140x100_134x100_140x100_stl() {
    square_vent134x100 = ["","", 138,104,134,100,8];
    square_vent_channel_t_joint_custom_bottom(
    square_vent140x100_t_joint,
    square_vent134x100,
    square_vent140x100_t_joint, extra_walls = [10, 10, 10]);
}

module ABS_square_vent_channel_t_joint_top_half_w10x10x10_140x100_134x100_140x100_stl() {
    square_vent134x100 = ["","", 138,104,134,100,8];
    square_vent_channel_t_joint_custom_top(
    square_vent140x100_t_joint,
    square_vent134x100,
    square_vent140x100_t_joint, extra_walls = [10, 10, 10]);
}

module ABS_recuperator_tubes_cartridge_143x102_stl() {
    tubes_cartridge(change_type(heatexchanger_face_type, dw = - 2, dh = - 2));
}

module ABS_square_vent_channel_adaptor_square_vent_114x59_2_square_vent_170x80_h40_a0_e15_stl() {
    square_vent_channel_adaptor(square_vent114x59, square_vent170x80, h = 40, expand = 15);
}

module ABS_square_vent_channel_adaptor_square_vent_54x91_2_square_vent_110x55_h50_a0_e5_stl() {
    square_vent_channel_adaptor(square_vent_54x91, square_vent110x55, h = 50, expand = 5);
}

module ABS_air_filter_cassette_top_square_vent_170x80_stl() {
    air_filter_cassette_top(square_vent170x80);
}

//// переходник с теплообменника на канал 110х55
//module ABS_square_vent_channel_adaptor_square_vent_166x92_2_square_vent_114x59_h50_a0_e10_stl() {
//    square_vent_channel_adaptor(square_vent166x92, square_vent114x59, 50, expand = 10);
//}

// переходник с теплообменника на трубу D100
module ABS_square_to_circular_vent_channel_adaptorsquare_vent_152x112_2_circular_vent100_h40_a0_e10_stl() {
    t_joint_140x100_to_D100_adaptor();
}

// переходник с трубы 125 на трубу 100
module ABS_circular_to_circular_eccentric_vent_channel_adaptorcircular_vent100_2_circular_vent100_h50_a0_e10_stl() {
    circular_to_circular_eccentric_vent_channel_adaptor(circular_vent125, circular_vent100, 50, expand = 10);
}

module ABS_air_filter_holder_middle_square_vent_110x55_l40_stl() {
    air_filter_holder_middle(square_vent110x55, length = 40);
}


// переходник с теплообменника на вентилятор 92мм
module ABS_fan_holder_square_vent_square_vent_147x113_2_fan92x92_stl() {
    fan_holder_square_vent(fan92x25,change_type(inlet_tube_type, 9, 9));
}


//
module FLEX_fan4inlet_tube_type_cap_fan92x25_stl() {
    fan4square_vent_cap(fan92x25, inlet_tube_type);
}
