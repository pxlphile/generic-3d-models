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
//
// This is a module file being included from a main file. 
// Please open that main file to configure general settings

use <openscad-utils.scad>;

woodDrillBoxWidth=millimeter(55);
woodDrillBoxDepth=millimeter(42);
woodDrillBoxHeight=millimeter(14);
woodDrillSeparatorInMM=millimeter(3);
woodDrillBoxPlaneThickness=millimeter(5*nozzleDiameterInMM);
// sets the distance of x related entities (positioning names, holes or holding pins) to the border.
woodDrillPaddingLeft = millimeter(1.4);

woodDrillSmallestDrillDiameter=millimeter(4);
// arg0: print name on the box, usually diameter or measured in millimeter
// arg1: actual (that is, without printer tolerance) diameter in millimeter
// arg2: calculated position for x related entities (positioning names, holes or holding pins).
//       calculating here X pos by myself because spreding non-equal objects 
//       over an axis is a hell in OpenSCAD, don't judge me
// arg3: pin Y position
woodDrillHoleDiametersAndPositionsInMM=[
        [ "10", 10.0,        10 + 0*woodDrillSeparatorInMM, 0.0 ],
        [ "8",  8.0,       8+10 + 1*woodDrillSeparatorInMM, 0.0 ],
        [ "6",  6.0,     6+8+10 + 2*woodDrillSeparatorInMM, 10.0 ],
        [ "5",  5.0,   5+6+8+10 + 3*woodDrillSeparatorInMM, 11.0 ],
        [ "4",  4.0, 4+5+6+8+10 + 4*woodDrillSeparatorInMM, 17.0 ],
    ];

module woodDrillBox() {
    difference() {
        union() {
            woodDrillMainBox();
            woodDrillHoldingBar();
            woodDrillHoldingPins();
        }
        woodDrillHoldingHoles();
        woodDrillBoxText();
        woodDrillSizeLabel();
    }
}

module woodDrillHoldingBar() {
    borderOffset = millimeter(5 * nozzleDiameterInMM);
    barSize = millimeter(14 * nozzleDiameterInMM);
    paddingBottom = millimeter(30);
    rampOffset = borderOffset + woodDrillSmallestDrillDiameter;
    
    lowPoint=[
        0, 
        0 + paddingBottom, 
        0 + rampOffset
    ];
    maxPoint=[
        woodDrillBoxWidth, 
        barSize + paddingBottom,
        woodDrillBoxHeight
    ];

    boxedRamp(lowPoint, maxPoint, 0);
}

module woodDrillBoxText() {
    drillBoxText(woodDrillBoxText, woodDrillBoxWidth);
}

module woodDrillHoldingPins() {
    drillHoldingPins(woodDrillHoleDiametersAndPositionsInMM, woodDrillPaddingLeft);
}

module woodDrillHoldingHoles() {
    drillHoldingHoles(woodDrillHoleDiametersAndPositionsInMM, woodDrillBoxHeight, woodDrillPaddingLeft, printerRoughnessInMM);
}

module woodDrillSizeLabel() {
    drillSizeText(woodDrillHoleDiametersAndPositionsInMM, woodDrillPaddingLeft, printerRoughnessInMM);
}

module woodDrillMainBox() {
    outerBoxVec=[woodDrillBoxWidth, woodDrillBoxDepth, woodDrillBoxHeight];

    openRoundedBox(outerBoxVec, woodDrillBoxPlaneThickness);
}
