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

metalDrillBoxWidth=millimeter(66);
metalDrillBoxDepth=millimeter(42);
metalDrillBoxHeight=millimeter(14);

module metalDrillBox() {
    difference() {
        union() {
            metalDrillMainBox();
            metalDrillHoldingBar();
            metalDrillHoldingPins();
        }
        metalDrillHoldingHoles();
        metalDrillBoxText();
    }
}

module metalDrillHoldingBar() {
    // construct a hexahedron from points and create faces from it
    borderOffset = millimeter(5 * nozzleDiameterInMM);
    barSize = millimeter(14 * nozzleDiameterInMM);
    paddingBottom = millimeter(30);
    smallestMetalDrillDiameterInMM = 1.0;
    rampOffset = borderOffset + smallestMetalDrillDiameterInMM;
    
    x0=0;
    y0=0 + paddingBottom;
    z0=0 + rampOffset;
    xMax=metalDrillBoxWidth;
    yMax=barSize + paddingBottom;
    zMax=metalDrillBoxHeight;
    
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
            cube([metalDrillBoxWidth, barSize, rampOffset]);
    }
}

module metalDrillBoxText() {
    // With these values you have to fit it yourself because it depends on the font.
    // The resulting text object is not really measureable, so just wing it.
    paddingBottom = millimeter(30 + 0.5);
    xMargin=metalDrillBoxWidth/2;
    
    boxText=metalDrillBoxText; // take from global variable
    
    translate([xMargin, paddingBottom, 1.2])    
        rotate([0,180,0])
            linear_extrude(height = 2)
                text(boxText, size = 5, font = str("Liberation Sans"), halign="center");
}

module metalDrillHoldingPins() {
    // x: as from metalDrillHoldingHoles()
    // y: The X positions are basically copied from the original box.
    // They are set this way in order to provide a ascending "organ pipe" look
    borderOffset = millimeter(5 * nozzleDiameterInMM);
    
    pinPositions=[
        [                                 8 + 0*borderOffset, 0.8 ],
        [                               6+8 + 1*borderOffset, 12.0 ],
        [                             5+6+8 + 2*borderOffset, 12.0 ],
        [                         4.5+5+6+8 + 3*borderOffset, 12.0 ],
        [                       4+4.5+5+6+8 + 4*borderOffset, 8.0 ],
        [                   3.5+4+4.5+5+6+8 + 5*borderOffset, 8.0 ],
        [               3.2+3.5+4+4.5+5+6+8 + 6*borderOffset, 8.0 ],
        [             3+3.2+3.5+4+4.5+5+6+8 + 7*borderOffset, 5.0 ],
        [         2.5+3+3.2+3.5+4+4.5+5+6+8 + 8*borderOffset, 5.0 ],
        [       2+2.5+3+3.2+3.5+4+4.5+5+6+8 + 9*borderOffset, 8.0 ],
        [   1.5+2+2.5+3+3.2+3.5+4+4.5+5+6+8 + 10*borderOffset, 12.0 ],
        [ 1+1.5+2+2.5+3+3.2+3.5+4+4.5+5+6+8 + 11*borderOffset, 14.0 ],
    ];
    
    for (entry = pinPositions) {
//        echo("entry:", entry);
        
        translate([entry.x-4, entry.y, -0 ])
            rotate([90,0,0]) color("yellow") cube([2.4, 6.2, 1.7]);
    }
    
}

module metalDrillHoldingHoles() {
    borderOffset = millimeter(5 * nozzleDiameterInMM);
    
    // x: ideal diameters without printer roughness, y: calculated X position
    // calculating here X pos by myself because spreding non-equal objects over an axis is a hell in OpenSCAD, don't judge me
    drillHoleDiametersAndXPositionInMM=[
        [ 8.0,                                 8 + 0*borderOffset ],
        [ 6.0,                               6+8 + 1*borderOffset ],
        [ 5.0,                             5+6+8 + 2*borderOffset ],
        [ 4.5,                         4.5+5+6+8 + 3*borderOffset ],
        [ 4.0,                       4+4.5+5+6+8 + 4*borderOffset ],
        [ 3.5,                   3.5+4+4.5+5+6+8 + 5*borderOffset ],
        [ 3.2,               3.2+3.5+4+4.5+5+6+8 + 6*borderOffset ],
        [ 3.0,             3+3.2+3.5+4+4.5+5+6+8 + 7*borderOffset ],
        [ 2.5,         2.5+3+3.2+3.5+4+4.5+5+6+8 + 8*borderOffset ],
        [ 2.0,       2+2.5+3+3.2+3.5+4+4.5+5+6+8 + 9*borderOffset ],
        [ 1.5,   1.5+2+2.5+3+3.2+3.5+4+4.5+5+6+8 + 10*borderOffset ],
        [ 1.0, 1+1.5+2+2.5+3+3.2+3.5+4+4.5+5+6+8 + 11*borderOffset ],
    ];
    
    for (entry = drillHoleDiametersAndXPositionInMM) {
//        echo("entry:", entry);
        dia = entry.x + printerRoughnessInMM;
        xpos = entry.y;
        
        rotate([90, 0, 0]) 
            translate([xpos-2.6, metalDrillBoxHeight/10 + dia/2, -40 ])
            color("yellow") cylinder(d=dia, h=30, center=true);
    }
}

module metalDrillMainBox() {
    difference() {
        metalHalfRoundedMainBox();
        metalHalfRoundedMainBoxDiff();
    }
}

module metalHalfRoundedMainBox() {
    union() {
        color("Blue") cube([metalDrillBoxWidth, metalDrillBoxDepth, metalDrillBoxHeight]);
        
        translate([metalDrillBoxWidth, 0, 0]) color("Green")
            rotate([0,90,0])
                translate([-metalDrillBoxHeight/2, 0, -metalDrillBoxWidth/2])
                    cylinder(r=metalDrillBoxHeight/2, h=metalDrillBoxWidth, center = true);
        }
}

module metalHalfRoundedMainBoxDiff() {
    borderOffset = 5*nozzleDiameterInMM;
    w = metalDrillBoxWidth - borderOffset;
    d = metalDrillBoxDepth - borderOffset;
    h = metalDrillBoxHeight - borderOffset;
    
    color("red") union() {
        translate([borderOffset/2, 0-1,  borderOffset/2]) color("yellow")
            cube([w, d+1+borderOffset/2, h+10]);

        translate([w+borderOffset/2, 0,  0]) color("yellow")
            scale([1, 1, 1.1]) // make oval to cut more from upper side to avoid overhang
                rotate([0, 90, 0]) translate([(-h ) / 2 -0.92 , 0, (-w)/2]) // align with long side
                        cylinder(d=h, h=w, center = true);
    }
}