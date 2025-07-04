///////////////////////
// Native parameters //
///////////////////////
$fa = 0.1;
$fs = 0.1;
$fn=128;

//////////////////////
// Model parameters //
//////////////////////

barDiameter = 23.5;
barDistance=16.9;
barOffset = 0.2;

handlerWidth = 30;
handlerShape = "triangle";

wallSize = 2.5;
insideDiameter = barDiameter + barOffset;
outsideDiameter = insideDiameter + wallSize * 2;

structureTriange=15;
structureLength=36;
structureHeight=4;

///////////
// Tools //
///////////

module rounding2d(r) {
  offset(r = r) offset(delta = -r) children(0);
}

module circleHandler() {
  translate([0, outsideDiameter / 2, 0]) difference() {
    circle(d=outsideDiameter);
    circle(d=insideDiameter);
  }
}

module halfCircle(d) {
  difference() {
    circle(d=d);
    translate([0,-d/2]) square([d/2,d]);
  }
}

linear_extrude(handlerWidth) {
  rounding2d(0.999 * (wallSize / 2)) {
    union() {
      difference() {
        union() {
          circleHandler();
          translate([insideDiameter + barDistance, 0, 0]) circleHandler();
          square([insideDiameter + barDistance, wallSize]);
        }

        // Cut the closest circle
        translate([0, wallSize]) union() {
          translate([0,insideDiameter/2,0]) rotate(45) square([insideDiameter, outsideDiameter]);
          square([(insideDiameter/2)+wallSize, insideDiameter+wallSize]);
        }

        // Cut the second circle
        translate([barDistance,wallSize]) union() {
          translate([0, insideDiameter/2]) polygon([[0,0], [0, insideDiameter], [insideDiameter, 0]]);
          square([insideDiameter, insideDiameter/2]);
        }
      }
    }
  }

  // Handler diagonal
  polygon([[0,0], [structureTriange, -structureTriange], [structureTriange,0]]);
  rotate(45) translate([0, -1*(structureLength)]) square([wallSize, structureLength]);
}

// Handler shapes
if (handlerShape == "circle") {
  translate([structureHeight+structureLength/sqrt(2),-structureLength/sqrt(2)+wallSize,handlerWidth/2]) rotate([90,180,0]) linear_extrude(wallSize) union() {
    halfCircle(handlerWidth);
    translate([0,-handlerWidth/2,0]) square([structureHeight, handlerWidth]);
  }
}
if (handlerShape == "triangle") {
  translate([structureHeight+structureLength/sqrt(2),-structureLength/sqrt(2)+wallSize,handlerWidth/2]) rotate([90,180,0]) linear_extrude(wallSize) union() {
    handlerOffset = handlerWidth/4;
    translate([-handlerOffset,-handlerWidth/2]) polygon([[0,0], [0, handlerWidth],[-handlerWidth/4,3*handlerWidth/4],[-handlerWidth/4,0],[-handlerWidth/4,handlerWidth/4]]);
    translate([-handlerOffset,-handlerWidth/2]) square([structureHeight + handlerOffset, handlerWidth]);
  }
}