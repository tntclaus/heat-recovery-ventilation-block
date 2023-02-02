include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>

use <square_vent_channel.scad>


rho_air = 1.204; // kg/m3
mu_air = 1.825 * pow(10, - 5); // kg/(m*s)




/**
 * V = volume, m3;
 * S = surface, m2;
 */
function characteristic_Ld(V, S) = V / S;

function Dg(A, P) = 4 * A / P;

/**
 * Re	=	reynolds number
 * rho	=	density of the fluid (kg/m3)
 * v	=	flow speed (m/s)
 * L	=	characteristic linear dimension (m) — the volume of a system divided by its surface
 * mu	=	dynamic viscosity of the fluid kg/(m*s)
 */
//function Re(v, L) = rho_air * v * L / mu_air;

function Re(v, A, P) = rho_air * v * Dg(A, P) / mu_air;


/**
* Сопротивление трения
*/
function C(Re) = 1 / pow(1.8 * ln(Re) - 5, 2);

/**
 * Коэффициент сопротивление трения по формуле Альтшуля
 *
 * Re = число рейнольдса
 * k  = коэффициент шероховатости
 */
function C_alt(Re, d, k) = 0.11 * pow((k/d + 68/Re), 0.25);


/*
ΔРтр = λтр * (L/de) * pow(ω,2)*ρ/2

где
С   – коэффициент сопротивления трения;
L   – суммарная длина трубок, м;
de  – эквивалентный диаметр, равный внутреннему диаметру трубок, м;
v   – средняя скорость на данном участке, м/с;
rho_air = плотность воздуха, кг/м3 .
*/
function channel_resistance(Re, L, de, v) = C_alt(Re, de, 0.1) * (L / de) * pow(v, 2) * rho_air / 2;

TUBE_LENGTH = 1000;

TUBE_DIA = 10;
TUBE_H_SPACING = 1;
TUBE_V_SPACING = 4.55;
function TUBE_V_SPACING() = TUBE_V_SPACING;
TUBE_WALL = 1;


SQUARE_TUBE_OUT_H = 55.5;
SQUARE_TUBE_OUT_W = 110.5;

CARTRIDGE_H = 6;


module tube_profile(dia, wall_th) {
    difference() {
        circle(d = dia);
        circle(d = dia - wall_th * 2);
    }
}

module tube(length, dia, wall_th) {
    vitamin(str("aluminium_tube(", length, ", ", dia, ",", wall_th, "): Aluminium tube ", length, "x", dia, "x", wall_th
    ));

    color("silver")
        render()
            difference() {
                cylinder(d = dia, h = length, center = true);
                cylinder(d = dia - wall_th * 2, h = length * 2, center = true);
            }
}

function HC(type) = floor(square_vent_channel_width(type) / (TUBE_DIA + TUBE_H_SPACING));
function HS(type) = (square_vent_channel_width(type) - (HC(type) * TUBE_DIA)) / HC(type) + TUBE_DIA;

function VC(type) = floor(square_vent_channel_heigth(type) / (TUBE_DIA + TUBE_V_SPACING));
function VS(type) = (square_vent_channel_heigth(type) - (VC(type) * TUBE_DIA)) / VC(type) + TUBE_DIA;

module place_tubes(type) {
    hs = HS(type);
    vs = VS(type);
    vc = VC(type);

    z_arr = [for (z = [vs / 2 : vs : square_vent_channel_heigth(type) - vs / 2]) z];

    //    echo("hs", z_arr);
    translate([- square_vent_channel_width(type) / 2, - square_vent_channel_heigth(type) / 2, 0])
        for (z = [0 : vc - 1]) {
            translate([0, z_arr[z], 0])
                if (z % 2 == 0) {
                    for (x = [hs / 2 : hs: square_vent_channel_width(type) - hs / 2])
                    translate([x, 0, 0])
                        children();
                } else {
                    for (x = [hs / 2 : hs: square_vent_channel_width(type) - hs / 2 - HS(type)])
                    translate([x + HS(type) / 2, 0, 0])
                        children();
                }
        }
}

module tubes_assemby(type, length) {
    rotate([90, 0, 0])
        place_tubes(type)
        //        cylinder(d = 10, h = 10);
        tube(length = length, dia = TUBE_DIA, wall_th = TUBE_WALL);
}

module tubes_cartridge(type) {
    stl(str("ABS_recuperator_tubes_cartridge_", square_vent_channel_width(type), "x", square_vent_channel_heigth(type)))
    ;

    h = CARTRIDGE_H;
    rotate([90, 0, 0])
        //    render()
        difference() {
            translate_z(h / 2)
            rounded_cube_xy([square_vent_channel_width(type), square_vent_channel_heigth(type), h - .1], r = 2,
            xy_center = true);
            place_tubes(type){
                cylinder(d = TUBE_DIA, h = h * 2);
            }
        }
}

//use <under_window.scad>

module tube_cross_section(type) {
    difference() {
        union() {
            cube([3, square_vent_channel_width(type) * 1.2, square_vent_channel_heigth(type) + 2], center = true);
            translate([- 10, 0, 0])
                cube([20, square_vent_channel_width(type), square_vent_channel_heigth(type)], center = true);
        }
        translate([0, 0, 0])
            cube([140, square_vent_channel_width(type) - 4, square_vent_channel_heigth(type) - 4], center = true);
    }
}

function TOTAL_TUBES(type) = HC(type) * VC(type) - VC(type)/2;
function SPACE_IN(type) = 3.14 * pow(((TUBE_DIA - 2) / 2), 2) * TOTAL_TUBES(type);

module recuparator_section_assembly(type, hide = true) {
//    hc = HC(type);
//    vc = VC(type);

    total = TOTAL_TUBES(type);

    echo(str("tubes count: ", total));

    space_out_total = square_vent_channel_width(type) * square_vent_channel_heigth(type) - 3.14 * pow((TUBE_DIA / 2), 2) * total;
    space_out = 3.14 * pow((TUBE_DIA / 2), 2) * total;
    space_in = 3.14 * pow(((TUBE_DIA - 2) / 2), 2) * total;

    tubes_assemby(type, TUBE_LENGTH);

    //    translate([-square_vent_channel_width(type)/2, TUBE_LENGTH/2-square_vent_channel_width(type)/2-20])
    //    tube_cross_section();

    if (hide) {} else {
        translate([0, - TUBE_LENGTH / 2 + CARTRIDGE_H * 1.5, 0])
            tubes_cartridge(type);
        translate([0, TUBE_LENGTH / 2 - CARTRIDGE_H * 1.5, 0])
            mirror([0, 1, 0])
                tubes_cartridge(type);
    }

    echo("count", total, "in/outlet", 51 * 111, "out of tubes",
        space_out_total, "in", space_in);




    //    tube(1000,);
}


tube_count = 100;

v = 3;
L = 1;
d = 0.008;
d_in = 0.001;

PI = 3.14;

// Выдув
A = PI * pow(d / 2, 2);
P = PI * d;

// Вдув
//a = 0.14;
//b = 0.08;
//A = a * b - (PI * pow(d_in / 2, 2) * tube_count);
//P = (PI * d_in * tube_count) + 2 * (a + b);

Re = Re(v, A, P);

R = channel_resistance(Re, L, d, v);

function R_parallel(R, count) = count == 0 ? 1/R : 1/R + R_parallel(R, count - 1);



echo("Re: ", Re);
echo("C:  ", C(Re));
echo("R:  ", R, "Па");
echo("R:  ", 1/R_parallel(R, 100), "Па");

