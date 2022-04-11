// Written by PxlPhile <github.com/ppxl>
//
// This software is licensed under the CC BY-NC-SA 4.0 license
// (Attribution-NonCommercial-ShareAlike 4.0 International). 
// 
//
// You are free to:
//
//    Share — copy and redistribute the material in any medium or format
//    Adapt — remix, transform, and build upon the material
//
//    The licensor cannot revoke these freedoms as long as you follow the 
//    license terms.
//
// Under the following terms:
//
//    Attribution — You must give appropriate credit, provide a link to the
//    license, and indicate if changes were made. You may do so in any reasonable
//    manner, but not in any way that suggests the licensor endorses you or your
//    use.
//
//    NonCommercial — You may not use the material for commercial purposes.
//
//    ShareAlike — If you remix, transform, or build upon the material, you must
//    distribute your contributions under the same license as the original.
//
//    No additional restrictions — You may not apply legal terms or technological
//    measures that legally restrict others from doing anything the license
//    permits.

// This software works with OpenSCAD 2019.05 or same-ish.

use <openscad-utils.scad>;

// Global resolution
$fs = 0.05;  // Don't generate smaller facets than 0.1 mm
$fa = 5;    // Don't generate larger angles than 5 degrees

// --- 3D printer related settings --

// nozzleDiameter contains the diameter in millimeters of the 3D printer nozzle which is supposed to be used for 
// printing. It will be used to optimize borders during the print.
nozzleDiameterInMM = millimeter(0.4);
// printerRoughness contains a value in millimeters that will be added to negative space so that holes are not
// 3d-printed in a too small way. Adjust this value if you know your 3D printer has a tendency to print a bit sloppy.
printerRoughnessInMM = millimeter(0.5);

metalDrillBoxText = "METALL";
woodDrillBoxText = "HOLZ";
stoneDrillBoxText = "STEIN";

// global variables must come before the file include happens.
include <Bosch_Drill_Holder_Wallet_Set_by_PxlPhile-metalDrillBox.scad>;
include <Bosch_Drill_Holder_Wallet_Set_by_PxlPhile-woodDrillBox.scad>;
include <Bosch_Drill_Holder_Wallet_Set_by_PxlPhile-stoneDrillBox.scad>;

// Main geometry
intersection() {
    // comment out the boxen you don't want to render
    union() {
        translate([0,0,0]) metalDrillBox();
        translate([70,0,0]) woodDrillBox();
        translate([130,0,0]) stoneDrillBox();
    }
}
