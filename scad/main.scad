
include <filter_section.scad>
include <fan_section.scad>

module main_assembly() {
//    rotate([-90,0,0])
//    mesh_filter(square_vent110x55);
//
//    translate([0,150,0])
//    rotate([90,0,0])
//    air_filter_holder_assembly(square_vent110x55);

    translate([0,150,0])
    rotate([90,0,0])
    air_filter_cassette_assembly(square_vent110x55);

//    translate([0,-100,0])
//    rotate([90,0,0])
//    fan_outblower_assembly();

}

if($preview)
    main_assembly();
