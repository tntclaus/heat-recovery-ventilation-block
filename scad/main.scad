include <filter_section.scad>
include <fan_section.scad>
include <valve_section.scad>
use <recuperation_section.scad>

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
            translate([0, 93, 0]) {
                rotate([90, 0, 0])
                    fan_inblower_assembly(RECUPERATOR_IN_CHANNEL, fan_type = fan92x25);
            }


            color("white")
                rotate([90, 0, 0])
                    recuperator_cross();

            // переходник выдува
            translate([- 97, 0, 0])
                rotate([- 90, - 0, - 90]) {
                    fan_outblower_assembly();
                }
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
                    recuperator_cross();

            translate([0, - 95, 0])
                rotate([- 90, 0, 0])
                    fan_inblower_assembly(RECUPERATOR_IN_CHANNEL, fan_type = fan92x25);

            // переходник выдува
            translate([100, 0, 0])
            rotate([ 90, - 0, - 90]) {
                fan_outblower_assembly();
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
//        translate([0,110,0])
//        rotate([90,0,0])
//        air_filter_heat_breaker_assembly(square_vent110x55);
    //
    //    translate([0,150,0])
    //    rotate([90,0,0])
    //    air_filter_heat_breaker_assembly(square_vent110x55);
    //
        translate([- 435,177,0]) {
            rotate([90, 0, 0])
                FLEX_inlet_fan_2_tube_adaptor_stl();
//                air_filter_holder_assembly(square_vent110x55);
//                square_to_square_flex_adaptor(RECUPERATOR_IN_CHANNEL, square_vent110x55, 60);
//            translate([0, 0, 60])
//                rotate([90, 0, 0])
//                    air_filter_cassette_assembly(square_vent110x55);
        }

    translate([37, 0, 0])
        recuperator_assembly();

}

module main_assembly() {
    draw_window();
    //
    translate([- 76, 100, - 5])
        ventilation_assembly();

}

//if ($preview)
//    main_assembly();


//color("red")
//FLEX_inlet_fan_2_tube_adaptor_stl();

ABS_fan_sleeve_stl();

//fan_outblower_assembly();

//ABS_airduct_outlet_fan_adaptor_stl();

//d_out2 = calculate_ellipse_d2_by_circle_d_and_d1(160, 200);
//$fn = 180;
//circle_to_ellipse_adaptor(d_in = 103.5, d_out1 = 200-4.5, d_out2 = d_out2-4.5, length = 42);

/**
* STL
*/

module ABS_recuperator_tubes_cartridge_143x102_stl() {
    tubes_cartridge(change_type(heatexchanger_face_type, dw = - 2, dh = - 2));
}

//module ABS_square_vent_channel_adaptor_square_vent_114x59_2_square_vent_170x80_h40_a0_e15_stl() {
//    square_vent_channel_adaptor(square_vent114x59, square_vent170x80, h = 40, expand = 15);
//}
//
//module ABS_square_vent_channel_adaptor_square_vent_54x91_2_square_vent_110x55_h50_a0_e5_stl() {
//    square_vent_channel_adaptor(square_vent_54x91, square_vent110x55, h = 50, expand = 5);
//}
//
//module ABS_air_filter_cassette_top_square_vent_170x80_stl() {
//    air_filter_cassette_top(square_vent170x80);
//}

//// переходник с теплообменника на канал 110х55
//module ABS_square_vent_channel_adaptor_square_vent_166x92_2_square_vent_114x59_h50_a0_e10_stl() {
//    square_vent_channel_adaptor(square_vent166x92, square_vent114x59, 50, expand = 10);
//}

//// переходник с теплообменника на трубу D100
//module ABS_square_to_circular_vent_channel_adaptorsquare_vent_152x112_2_circular_vent100_h40_a0_e10_stl() {
//    t_joint_140x100_to_D100_adaptor();
//}
//
//// переходник с трубы 125 на трубу 100
//module ABS_circular_to_circular_eccentric_vent_channel_adaptorcircular_vent100_2_circular_vent100_h50_a0_e10_stl() {
//    circular_to_circular_eccentric_vent_channel_adaptor(circular_vent125, circular_vent100, 50, expand = 10);
//}
//
//module ABS_air_filter_holder_middle_square_vent_110x55_l40_stl() {
//    air_filter_holder_middle(square_vent110x55, length = 40);
//}
//
//
//// переходник с теплообменника на вентилятор 92мм
//module ABS_fan_holder_square_vent_square_vent_147x113_2_fan92x92_stl() {
//    fan_holder_square_vent(fan92x25,change_type(RECUPERATOR_IN_CHANNEL, 9, 9));
//}


//
//module FLEX_fan4RECUPERATOR_IN_CHANNEL_cap_fan92x25_stl() {
//    fan4square_vent_cap(fan92x25, RECUPERATOR_IN_CHANNEL);
//}
