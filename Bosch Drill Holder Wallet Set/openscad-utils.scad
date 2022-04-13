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

// millimeter returns the same value for semantical purposes (that is to avoid magic numbers).
function millimeter(valueInMM) = valueInMM;

// degree returns the same value for semantical purposes (that is to avoid magic numbers).
function degree(valueInDegree) = valueInDegree;

module drillHoldingBar(borderOffsetInMM, outerBoxSizeVecInMM, rampBarSizeInMM, rampBarPaddingBottomInMM, smallestDrillDiameterInMM) {
    paddingBottom = rampBarPaddingBottomInMM;
    rampOffset = borderOffsetInMM + smallestDrillDiameterInMM;
    
    drillBoxWidth = outerBoxSizeVecInMM.x;
    drillBoxHeight = outerBoxSizeVecInMM.z;
    
    lowPoint=[
        0, 
        0 + paddingBottom, 
        0 + rampOffset
    ];
    maxPoint=[
        drillBoxWidth, 
        rampBarSizeInMM + paddingBottom,
        drillBoxHeight
    ];

    boxedRamp(lowPoint, maxPoint, 0);
}

// boxedRamp creates a regular hexahedron ramp.
// param: minPoint - 3D coordinate with the lowest values of the prism
// param: minPoint - 3D coordinate with the highest values of the prism
// param: barWidthInMM - width of the ramp in millimeters
module boxedRamp(prismMinPoint, prismMaxPoint, zBottom) {
    // construct a triangular prism from points and create faces from it
    // then fill a cube below the prism
    
    x0=prismMinPoint.x;
    y0=prismMinPoint.y;
    z0=prismMinPoint.z;
    xMax=prismMaxPoint.x;
    yMax=prismMaxPoint.y;
    zMax=prismMaxPoint.z;
    
    ps=[
        [x0,   y0,   z0],   // point 0
        [x0,   yMax, z0],   // ...
        [x0,   yMax, zMax],
        [x0,   y0,   zMax],
        [xMax, y0,   z0],
        [xMax, yMax, z0],   // point 5
   ];
      
   fs=[
        // faces reference above points
        [0,1,2,3], // face 0
        [5,4,3,2], // ...
        [0,4,5,1],
        [0,3,4],
        [5,2,1]    // face 4
    ];
    
    union() {
        // draw ramp
        color("lightgray") polyhedron(points=ps,faces=fs);
        // fill the space between the ramp and the box area
        translate([x0, y0, zBottom])
            cube([xMax-x0, yMax-y0,z0-zBottom]);
    }
}

module openRoundedBox(outerBoxSizeVecInMM, boxAndBorderThicknessInMM) {
    difference() {
        openRoundedBoxBlock(outerBoxSizeVecInMM);
        openRoundedBoxDiff(outerBoxSizeVecInMM, boxAndBorderThicknessInMM);
    }
}

module openRoundedBoxBlock(outerBoxSizeVecInMM) {
    w = outerBoxSizeVecInMM.x;
    d = outerBoxSizeVecInMM.y;
    h = outerBoxSizeVecInMM.z;
    
    union() {
        color("Blue") cube([w, d, h]);
        
        translate([w, 0, 0]) color("Green")
            rotate([0,90,0])
                translate([-h/2, 0, -w/2])
                    cylinder(r=h/2, h=w, center = true);
        }
}

module openRoundedBoxDiff(outerBoxSizeVecInMM, boxAndBorderThicknessInMM) {
    borderOffset = boxAndBorderThicknessInMM;
    w = outerBoxSizeVecInMM.x - borderOffset;
    d = outerBoxSizeVecInMM.y - borderOffset;
    h = outerBoxSizeVecInMM.z - borderOffset;
    wayHigherToCutAwayTop=millimeter(10);
    
    color("red") union() {
        translate([borderOffset/2, 0-1,  borderOffset/2]) color("yellow")
            cube([w, d+1+borderOffset/2, h+wayHigherToCutAwayTop]);

        translate([w+borderOffset/2, 0,  0]) color("yellow")
            scale([1, 1, 1.1]) // make oval to cut more from upper side to avoid overhang
                rotate([0, 90, 0]) translate([-h/2 -0.92 , 0, -w/2]) // align with long side
                    cylinder(d=h, h=w, center = true);
    }
}

module drillBoxText(txt, boxWidthInMM) {
    // With these values you have to fit it yourself because it depends on the font.
    // The resulting text object is not really measureable, so just wing it.
    paddingBottom = millimeter(30 + 0.5);
    xMargin=boxWidthInMM/2;
    
    translate([xMargin, paddingBottom, 1.2])    
        rotate([0,180,0])
            linear_extrude(height = 2)
                text(txt, size = 5, font = str("Liberation Sans"), halign="center");
}

module drillSizeText(drillHoleDiasAndPositionsInMM, paddingLeftInMM, printerToleranceInMM) {
    for (entry = drillHoleDiasAndPositionsInMM) {
        txt = entry[0];
        dia = entry[1] + printerToleranceInMM;
        xPos = entry[2];
        
        translate([xPos+paddingLeftInMM, 37, -1.2 ])
            linear_extrude(height = 2)
                rotate([180, 0, 180]) 
                    text(txt, size = 3, font = str("Liberation Sans"), halign="center");
    }
}

module drillHoldingHoles(drillHoleDiametersAndPositionsInMM, boxHeightInMM, paddingLeftInMM, printerToleranceInMM) {
    
    for (entry = drillHoleDiametersAndPositionsInMM) {
        dia = entry[1] + printerToleranceInMM;
        xPos = entry[2];
        
        rotate([90, 0, 0]) 
            translate([xPos+paddingLeftInMM, boxHeightInMM/10 + dia/2, -40 ])
                color("yellow") cylinder(d=dia, h=30, center=true);
    }
}

module drillHoldingPins(drillHoleDiametersAndPositionsInMM, paddingLeftInMM) {
    for (entry = drillHoleDiametersAndPositionsInMM) {
        xPos=entry[2] + paddingLeftInMM;
        yPos=entry[3];
        
        translate([xPos, yPos, 3.8 ])
            rotate([90,0,0]) color("yellow") cube([2.4, 6.2, 1.7], center=true);
    }
}