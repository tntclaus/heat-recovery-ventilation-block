include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>



HEIGTH = 60-3;
WIDTH = 204-3;

TUBE_LENGTH = 1000;

TUBE_DIA = 10;
TUBE_H_SPACING = 1.5;
TUBE_V_SPACING = 0.2;
TUBE_WALL = 1;


SQUARE_TUBE_OUT_H = 55.5;
SQUARE_TUBE_OUT_W = 110.5;


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

function HC() = floor(WIDTH / (TUBE_DIA + TUBE_H_SPACING));
function HS() = (WIDTH - (HC() * TUBE_DIA)) / HC() + TUBE_DIA;

function VC() = floor(HEIGTH / (TUBE_DIA + TUBE_V_SPACING));
function VS() = (HEIGTH - (VC() * TUBE_DIA)) / VC() + TUBE_DIA;

module place_tubes() {
    hs = HS();
    vs = VS();
    vc = VC();

    z_arr = [for (z = [vs / 2 : vs : HEIGTH - vs / 2]) z];

//    echo("hs", z_arr);
    translate([- WIDTH / 2, - HEIGTH / 2, 0])
        for (z = [0 : vc - 1]) {
            translate([0, z_arr[z], 0])
                if (z % 2 == 0) {
                    for (x = [hs / 2 : hs: WIDTH - hs / 2])
                    translate([x, 0, 0])
                        children();
                } else {
                    for (x = [hs / 2 : hs: WIDTH - hs / 2 - HS()])
                    translate([x + HS() / 2, 0, 0])
                        children();
                }
        }
}

module tubes_assemby(length) {
    rotate([90, 0, 0])
        place_tubes()
        tube(length = length, dia = TUBE_DIA, wall_th = TUBE_WALL);
}

module tubes_cartridge() {
    stl("ABS_tubes_cartridge");

    h = 6;
    rotate([90, 0, 0])
        //    render()
        difference() {
            translate_z(h / 2)
            rounded_cube_xy([WIDTH, HEIGTH, h - .1], r=2, xy_center = true);
            place_tubes(){
//                hull() {
                    translate_z(h)
                    cylinder(d = TUBE_DIA * 1.8, h = .1);
//                    translate_z(5)
//                    cylinder(d = TUBE_DIA-TUBE_WALL*2, h = .1);
//                }
//                translate_z(5)
//                cylinder(d = TUBE_DIA-TUBE_WALL*2, h = h);
                cylinder(d = TUBE_DIA, h = h*2);
            }
        }
}

//use <under_window.scad>

module tube_cross_section() {
    difference() {
        union() {
            cube([3, WIDTH*1.2,HEIGTH+2], center = true);
            translate([-10,0,0])
            cube([20,WIDTH,HEIGTH], center = true);
        }
        translate([0,0,0])
        cube([140,WIDTH-4,HEIGTH-4], center = true);
    }
}


module recuparator_section_assembly() {
    hc = HC();
    vc = VC();

    total = hc * vc - vc / 2;

    echo(str("tubes count: ", total));

    space_out = 3.14 * pow((TUBE_DIA / 2), 2) * total;
    space_in = 3.14 * pow(((TUBE_DIA - 2) / 2), 2) * total;

//    tubes_assemby(TUBE_LENGTH);

//    translate([-WIDTH/2, TUBE_LENGTH/2-WIDTH/2-20])
//    tube_cross_section();

    //    translate([0, - TUBE_LENGTH / 2, 0])
    //        tubes_cartridge();
        translate([0, TUBE_LENGTH / 2-2, 0])
            mirror([0,1,0])
            tubes_cartridge();

    echo("count", total, "in/outlet", 51 * 111, "out of tubes", WIDTH * HEIGTH - space_out, "in", space_in);



    //    tube(1000,);
}

recuparator_section_assembly();


