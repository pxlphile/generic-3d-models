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

stoneDrillBoxWidth=millimeter(55);
stoneDrillBoxDepth=millimeter(42);
stoneDrillBoxHeight=millimeter(14);
stoneDrillSeparatorInMM=millimeter(3);
stoneDrillBoxPlaneThickness=millimeter(5*nozzleDiameterInMM);

stoneDrillSmallestDrillDiameter=millimeter(3.2);
// arg0: print name on the box, usually diameter or measured in millimeter
// arg1: actual (that is, without printer tolerance) diameter in millimeter
// arg2: calculated X position for positioning names, holes or holding pins.
//       calculating here X pos by myself because spreding non-equal objects 
//       over an axis is a hell in OpenSCAD, don't judge me
// arg3: pin Y position
stoneDrillHoleDiametersAndPositionsInMM=[
    [ "10", 7.5,                 7.5 + 0*stoneDrillSeparatorInMM, 2.0 ],
    [ "8",  6.3,             6.3+7.5 + 1*stoneDrillSeparatorInMM, 0.0 ],
    [ "6",  4.4,         4.4+6.3+7.5 + 2*stoneDrillSeparatorInMM, 3.0 ],
    [ "5",  4.2,     4.2+4.4+6.3+7.5 + 3*stoneDrillSeparatorInMM, 11.0 ],
    [ "4",  3.2, 3.2+4.2+4.4+6.3+7.5 + 4*stoneDrillSeparatorInMM, 16.0 ],
];

module stoneDrillBox() {
    difference() {
        union() {
            stoneDrillMainBox();
            stoneDrillHoldingBar();
            stoneDrillHoldingPins();
        }
        stoneDrillHoldingHoles();
        stoneDrillBoxText();
        stoneDrillSizeLabel();
    }
}

module stoneDrillHoldingBar() {
    borderOffset = millimeter(5 * nozzleDiameterInMM);
    barSize = millimeter(14 * nozzleDiameterInMM);
    paddingBottom = millimeter(30);
    rampOffset = borderOffset + stoneDrillSmallestDrillDiameter;
    
    lowPoint=[
        0, 
        0 + paddingBottom, 
        0 + rampOffset
    ];
    maxPoint=[
        stoneDrillBoxWidth, 
        barSize + paddingBottom,
        stoneDrillBoxHeight
    ];

    boxedRamp(lowPoint, maxPoint, 0);
}

module stoneDrillBoxText() {
    drillBoxText(stoneDrillBoxText, stoneDrillBoxWidth);
}

module stoneDrillHoldingPins() {
    borderOffset = stoneDrillSeparatorInMM;
    
    paddingLeft = millimeter(8);
    
    for (entry = stoneDrillHoleDiametersAndPositionsInMM) {
        translate([entry[2] - 4+paddingLeft, entry[3], -0 ])
            rotate([90,0,0]) color("yellow") cube([2.4, 6.2, 1.7]);
    }
}

module stoneDrillHoldingHoles() {
    borderOffset = stoneDrillSeparatorInMM;
    
    paddingLeft = millimeter(8);
    
    for (entry = stoneDrillHoleDiametersAndPositionsInMM) {
        dia = entry[1] + printerRoughnessInMM;
        xpos = entry[2];
        
        rotate([90, 0, 0]) 
            translate([xpos-2.3+paddingLeft, stoneDrillBoxHeight/10 + dia/2, -40 ])
                color("yellow") cylinder(d=dia, h=30, center=true);
    }
}

module stoneDrillSizeLabel() {
    paddingLeft = millimeter(8);

    drillSizeText(stoneDrillHoleDiametersAndPositionsInMM, paddingLeft, printerRoughnessInMM);
}

module stoneDrillMainBox() {
    outerBoxVec=[stoneDrillBoxWidth, stoneDrillBoxDepth, stoneDrillBoxHeight];
    
    openRoundedBox(outerBoxVec, stoneDrillBoxPlaneThickness);
}
