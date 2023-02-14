include <NopSCADlib/vitamins/screws.scad>

use <recuperation_section.scad>

fan40x28 = [40,  28, 37, 16,    M3_dome_screw, 25,   7.5,100, 9, 0,   undef];
//fan40x28 = [40,  28, 38, 16,    M2_5_dome_screw, 25,   7.5,100, 9, 0,   undef];
fan60x20 = [60,  20, 57, 25,    M4_dome_screw, 31.5, 3.6, 64, 7, 0,   63];

fan92x25 = [92,  25, 88, 41,    M4_dome_screw, 41,   4.3, 90, 7, 0,   100];



WINDOW_WIDTH = 1600;
WINDOW_DEPTH = 300;
WINDOW_HEIGTH = 120;
AVAILABLE_DEPTH = 550;

WIDTH_O = 110;
//WIDTH_O = 204;
HEIGTH_O = 60;

WIDTH_I = WIDTH_O - 4;
HEIGTH_I = HEIGTH_O - 3;


PRINTED_WALL_THICKNESS = 2;
FAN_TYPE = fan92x25;

heatexchanger_face_type = square_vent140x100_t_joint;

inlet_width = floor(SPACE_IN(heatexchanger_face_type) / (VC(heatexchanger_face_type) * TUBE_V_SPACING()));

RECUPERATOR_IN_CHANNEL = [
    "inlet_tube_type",
    "inlet tube type",
        inlet_width,
        square_vent_channel_heigth(heatexchanger_face_type),
        inlet_width-4,
        square_vent_channel_heigth(heatexchanger_face_type)-4,
        1
    ];
