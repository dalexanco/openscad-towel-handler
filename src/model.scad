///////////////////////
// Native parameters //
///////////////////////
$fa = 0.1;
$fs = 0.1;
$fn=128;

//////////////////////
/* [Radiator Sizes] */
//////////////////////

// The diameter of one radiator bar.
Bar_Diameter = 23.5;

// The distance between radiator bars.
Bar_Distance=16.9;

///////////////////////
/* [Rack parameters] */
///////////////////////

// The width of your piece.
Rack_Width = 30;

// The shape of the tip.
Rack_Shape = "triangle"; // [triangle, circle]

// The thickness of the object. 
Wall_Size = 2.5;

////////////////
/* [Advanced] */
////////////////

// The space between towel rack and bar.
barOffset = 0.2;

/* [Hidden] */

insideDiameter = Bar_Diameter + barOffset;
outsideDiameter = insideDiameter + Wall_Size * 2;

structureTriange=15;
structureLength=36;
structureHeight=4;

///////////
// Tools //
///////////

module rounding2d(r) {
  offset(r = r) offset(delta = -r) children(0);
}

module circleRack() {
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

linear_extrude(Rack_Width) {
  rounding2d(0.999 * (Wall_Size / 2)) {
    union() {
      difference() {
        union() {
          circleRack();
          translate([insideDiameter + Bar_Distance, 0, 0]) circleRack();
          square([insideDiameter + Bar_Distance, Wall_Size]);
        }

        // Cut the closest circle
        translate([0, Wall_Size]) union() {
          translate([0,insideDiameter/2,0]) rotate(45) square([insideDiameter, outsideDiameter]);
          square([(insideDiameter/2)+Wall_Size, insideDiameter+Wall_Size]);
        }

        // Cut the second circle
        translate([Bar_Distance,Wall_Size]) union() {
          translate([0, insideDiameter/2]) polygon([[0,0], [0, insideDiameter], [insideDiameter, 0]]);
          square([insideDiameter, insideDiameter/2]);
        }
      }
    }
  }

  // Rack diagonal
  polygon([[0,0], [structureTriange, -structureTriange], [structureTriange,0]]);
  rotate(45) translate([0, -1*(structureLength)]) square([Wall_Size, structureLength]);
}

// Rack shapes
if (Rack_Shape == "circle") {
  translate([structureHeight+structureLength/sqrt(2),-structureLength/sqrt(2)+Wall_Size,Rack_Width/2]) rotate([90,180,0]) linear_extrude(Wall_Size) union() {
    halfCircle(Rack_Width);
    translate([0,-Rack_Width/2,0]) square([structureHeight, Rack_Width]);
  }
}
if (Rack_Shape == "triangle") {
  translate([structureHeight+structureLength/sqrt(2),-structureLength/sqrt(2)+Wall_Size,Rack_Width/2]) rotate([90,180,0]) linear_extrude(Wall_Size) union() {
    rackOffset = Rack_Width/4;
    translate([-rackOffset,-Rack_Width/2]) polygon([[0,0], [0, Rack_Width],[-Rack_Width/4,3*Rack_Width/4],[-Rack_Width/4,0],[-Rack_Width/4,Rack_Width/4]]);
    translate([-rackOffset,-Rack_Width/2]) square([structureHeight + rackOffset, Rack_Width]);
  }
}