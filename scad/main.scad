
include <filter_section.scad>
include <fan_section.scad>
include <valve_section.scad>

module main_assembly() {
    rotate([-90,0,0])
    mesh_filter(square_vent110x55);

    translate([0,50,0])
    rotate([90,0,0])
    valve_section_assembly();

    translate([0,110,0])
    rotate([90,0,0])
    air_filter_heat_breaker_assembly(square_vent110x55);

    translate([0,150,0])
    rotate([90,0,0])
    air_filter_heat_breaker_assembly(square_vent110x55);

    translate([0,200,0]) {
        rotate([90, 0, 0])
            air_filter_holder_assembly(square_vent110x55);

        translate([0, 0, 60])
            rotate([90, 0, 0])
                air_filter_cassette_assembly(square_vent110x55);
    }

//    translate([0,-100,0])
//    rotate([90,0,0])
//    fan_outblower_assembly();

}

if($preview)
    main_assembly();
