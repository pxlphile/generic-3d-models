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

stoneDrillBoxWidth=millimeter(55);
stoneDrillBoxDepth=millimeter(42);
stoneDrillBoxHeight=millimeter(14);
stoneDrillSeparatorInMM=millimeter(7);
stoneDrillHoldingBarMaxHeightInMM=millimeter(12);
stoneDrillHoldingBarMinHeightInMM=millimeter(8);
stoneDrillSmallestDrillDiameter=millimeter(3.2);
stoneDrillBoxPlaneThickness=millimeter(5*nozzleDiameterInMM);

module stoneDrillBox() {
    difference() {
        union() {
            stoneDrillMainBox();
            stoneDrillHoldingBar();
            stoneDrillHoldingPins();
        }
        stoneDrillHoldingHoles();
        stoneDrillBoxText();
    }
}

module stoneDrillHoldingBar() {
    // construct a hexahedron from points and create faces from it
    borderOffset = stoneDrillSeparatorInMM;
    barSize = millimeter(14 * nozzleDiameterInMM);
    paddingBottom = millimeter(30);
    rampOffset = stoneDrillHoldingBarMinHeightInMM;
    
    x0=0;
    y0=0 + paddingBottom;
    z0=0 + stoneDrillSmallestDrillDiameter;
    xMax=stoneDrillBoxWidth;
    yMax=barSize + paddingBottom;
    zMax=stoneDrillHoldingBarMaxHeightInMM;
    
    ps=[
        [x0,   y0,   z0],   // point 0
        [x0,   yMax, z0],   // ...
        [x0,   yMax, zMax],
        [x0,   y0,   zMax],
        [xMax, y0,   z0],
        [xMax, yMax, z0],   // point 5
   ];
      
   fs=[
        [0,1,2,3], // faces reference above points
        [5,4,3,2],
        [0,4,5,1],
        [0,3,4],
        [5,2,1]
    ];
    
    // move ramp box near box top as means of drill holding
    union() {
        // draw ramp
        color("lightgray") polyhedron(points=ps,faces=fs);
        // fill the space between the ramp and the box area
        color("darkgray") translate([0, paddingBottom, 0])
            cube([stoneDrillBoxWidth, barSize, stoneDrillSmallestDrillDiameter]);
    }
}

module stoneDrillBoxText() {
    // With these values you have to fit it yourself because it depends on the font.
    // The resulting text object is not really measureable, so just wing it.
    paddingBottom = millimeter(30 + 0.5);
    xMargin=stoneDrillBoxWidth/2;
    
    boxText=stoneDrillBoxText; // take from global variable
    
    translate([xMargin, paddingBottom, 1.2])    
        rotate([0,180,0])
            linear_extrude(height = 2)
                text(boxText, size = 5, font = str("Liberation Sans"), halign="center");
}

module stoneDrillHoldingPins() {
    // x: as from stoneDrillHoldingHoles()
    // y: The X positions are basically copied from the original box.
    // They are set this way in order to provide a ascending "organ pipe" look
    borderOffset = stoneDrillSeparatorInMM;
    
    pinPositions=[
        [                 7.5 + 0*borderOffset, 2.0 ],
        [             6.3+7.5 + 1*borderOffset, 0.0 ],
        [         4.4+6.3+7.5 + 2*borderOffset, 3.0 ],
        [     4.2+4.4+6.3+7.5 + 3*borderOffset, 11.0 ],
        [ 3.2+4.2+4.4+6.3+7.5 + 4*borderOffset, 16.0 ],
    ];
    
    for (entry = pinPositions) {
//        echo("entry:", entry);
        
        translate([entry.x-4, entry.y, -0 ])
            rotate([90,0,0]) color("yellow") cube([2.4, 6.2, 1.7]);
    }
}

module stoneDrillHoldingHoles() {
    borderOffset = stoneDrillSeparatorInMM;
    
    // x: ideal diameters without printer roughness, y: calculated X position
    // calculating here X pos by myself because spreding non-equal objects over an axis is a hell in OpenSCAD, don't judge me
    drillHoleDiametersAndXPositionInMM=[
        [ 7.5,                 7.5 + 0*borderOffset ],
        [ 6.3,             6.3+7.5 + 1*borderOffset ],
        [ 4.4,         4.4+6.3+7.5 + 2*borderOffset ],
        [ 4.2,     4.2+4.4+6.3+7.5 + 3*borderOffset ],
        [ 3.2, 3.2+4.2+4.4+6.3+7.5 + 4*borderOffset ],
    ];
    
    for (entry = drillHoleDiametersAndXPositionInMM) {
//        echo("entry:", entry);
        dia = entry.x + printerRoughnessInMM;
        xpos = entry.y;
        
        rotate([90, 0, 0]) 
            translate([xpos-2.6, stoneDrillBoxHeight/10 + dia/2, -40 ])
            color("yellow") cylinder(d=dia, h=30, center=true);
    }
}

module stoneDrillMainBox() {
    difference() {
        stoneHalfRoundedMainBox();
        stoneHalfRoundedMainBoxDiff();
    }
}

module stoneHalfRoundedMainBox() {
    union() {
        color("Blue") cube([stoneDrillBoxWidth, stoneDrillBoxDepth, stoneDrillBoxHeight]);
        
        translate([stoneDrillBoxWidth, 0, 0]) color("Green")
            rotate([0,90,0])
                translate([-stoneDrillBoxHeight/2, 0, -stoneDrillBoxWidth/2])
                    cylinder(r=stoneDrillBoxHeight/2, h=stoneDrillBoxWidth, center = true);
        }
}

module stoneHalfRoundedMainBoxDiff() {
    borderOffset = stoneDrillBoxPlaneThickness;
    w = stoneDrillBoxWidth - borderOffset;
    d = stoneDrillBoxDepth - borderOffset;
    h = stoneDrillBoxHeight - borderOffset;
    
    color("red") union() {
        translate([borderOffset/2, 0-1,  borderOffset/2]) color("yellow")
            cube([w, d+1+borderOffset/2, h+10]);

        translate([w+borderOffset/2, 0,  0]) color("yellow")
            scale([1, 1, 1.1]) // make oval to cut more from upper side to avoid overhang
                rotate([0, 90, 0]) translate([(-h ) / 2 -0.92 , 0, (-w)/2]) // align with long side
                        cylinder(d=h, h=w, center = true);
    }
}