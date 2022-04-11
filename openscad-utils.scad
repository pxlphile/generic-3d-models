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