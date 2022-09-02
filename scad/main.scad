
include <filter_section.scad>

module main_assembly() {
//    rotate([90,0,0])
//    mesh_filter(square_vent110x55);

//    rotate([90,0,0])
    air_filter_holder_assembly(square_vent110x55);
}

if($preview)
    main_assembly();
