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

metalDrillBoxWidth=millimeter(66);
metalDrillBoxDepth=millimeter(42);
metalDrillBoxHeight=millimeter(14);

metalDrillsmallestDrillDiameterInMM = 1.0;
// arg0: print name on the box, usually diameter or measured in millimeter
// arg1: actual (that is, without printer tolerance) diameter in millimeter
// arg2: calculated X position for positioning names, holes or holding pins.
//       calculating here X pos by myself because spreding non-equal objects 
//       over an axis is a hell in OpenSCAD, don't judge me
// arg3: pin Y position
metalDrillHoleDiametersAndPositionsInMM=[
    [ "8", 8.0,                                   8 +  0*millimeter(5 * nozzleDiameterInMM),  0.8 ],
    [ "6", 6.0,                                 6+8 +  1*millimeter(5 * nozzleDiameterInMM), 12.0 ],
    [ "5", 5.0,                               5+6+8 +  2*millimeter(5 * nozzleDiameterInMM), 12.0 ],
    [ "4.5", 4.5,                         4.5+5+6+8 +  3*millimeter(5 * nozzleDiameterInMM), 12.0 ],
    [ "4", 4.0,                         4+4.5+5+6+8 +  4*millimeter(5 * nozzleDiameterInMM),  8.0 ],
    [ "3.5", 3.5,                   3.5+4+4.5+5+6+8 +  5*millimeter(5 * nozzleDiameterInMM),  8.0 ],
    [ "3.2", 3.2,               3.2+3.5+4+4.5+5+6+8 +  6*millimeter(5 * nozzleDiameterInMM),  8.0 ],
    [ "3", 3.0,               3+3.2+3.5+4+4.5+5+6+8 +  7*millimeter(5 * nozzleDiameterInMM),  5.0 ],
    [ "2.5", 2.5,         2.5+3+3.2+3.5+4+4.5+5+6+8 +  8*millimeter(5 * nozzleDiameterInMM),  5.0 ],
    [ "2", 2.0,         2+2.5+3+3.2+3.5+4+4.5+5+6+8 +  9*millimeter(5 * nozzleDiameterInMM),  8.0 ],
    [ "1.5", 1.5,   1.5+2+2.5+3+3.2+3.5+4+4.5+5+6+8 + 10*millimeter(5 * nozzleDiameterInMM), 12.0 ],
    [ "1", 1.0,   1+1.5+2+2.5+3+3.2+3.5+4+4.5+5+6+8 + 11*millimeter(5 * nozzleDiameterInMM), 14.0 ],
];

module metalDrillBox() {
    difference() {
        union() {
            metalDrillMainBox();
            metalDrillHoldingBar();
            metalDrillHoldingPins();
        }
        metalDrillHoldingHoles();
        metalDrillBoxText();
        metalDrillSizeLabel();
    }
}

module metalDrillHoldingBar() {
    borderOffset = millimeter(5 * nozzleDiameterInMM);
    barSize = millimeter(14 * nozzleDiameterInMM);
    paddingBottom = millimeter(30);
    
    rampOffset = borderOffset + metalDrillsmallestDrillDiameterInMM;
    
    lowPoint=[
        0, 
        0 + paddingBottom, 
        0 + rampOffset
    ];
    maxPoint=[
        metalDrillBoxWidth, 
        barSize + paddingBottom,
        metalDrillBoxHeight
    ];

    boxedRamp(lowPoint, maxPoint, 0);
}

module metalDrillBoxText() {
    drillBoxText(metalDrillBoxText, metalDrillBoxWidth);
}

module metalDrillHoldingPins() {
    for (entry = metalDrillHoleDiametersAndPositionsInMM) {        
        xPos = entry[2];
        yPos = entry[3];
        
        translate([xPos-4, yPos, -0 ])
            rotate([90,0,0]) color("yellow") cube([2.4, 6.2, 1.7]);
    }
    
}

module metalDrillHoldingHoles() {
    for (entry = metalDrillHoleDiametersAndPositionsInMM) {
        dia = entry[1] + printerRoughnessInMM;
        xpos = entry[2];
        
        rotate([90, 0, 0]) 
            translate([xpos-2.6, metalDrillBoxHeight/10 + dia/2, -40 ])
                color("yellow") cylinder(d=dia, h=30, center=true);
    }
}

module metalDrillSizeLabel() {
    drillSizeText(metalDrillHoleDiametersAndPositionsInMM, 0, printerRoughnessInMM);
}

module metalDrillMainBox() {
    outerBoxVec=[metalDrillBoxWidth, metalDrillBoxDepth, metalDrillBoxHeight];
    borderAndPlaneThickness=5*nozzleDiameterInMM;
    
    openRoundedBox(outerBoxVec, borderAndPlaneThickness);
}
