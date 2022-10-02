$fa = 0.2;
$fs = 5;

union() {
    color("green") {
        difference() {
            cube([200, 300, 100], center = true);
            translate([0, -75, 40]) rotate([10, 0, 0]) cube([250, 300, 100], center = true);
            translate([140, 0, 0]) rotate([0, 45, 0]) cube([250, 310, 100], center = true);
            translate([-140, 0, 0]) rotate([0, -45, 0]) cube([250, 310, 100], center = true);
            translate([110, -160, 0]) rotate([0, 0, -40]) cube([150, 150, 150], center = true);
            translate([-110, -160, 0]) rotate([0, 0, 40]) cube([150, 150, 150], center = true);
        }
    }
    color("red") {
        difference() {
            translate([0, -50, -20]) sphere(75);
            translate([0, 0, -100]) cube([200, 300, 100], center = true);
        }
    }
    color("blue") {
        translate([50, 160, -20]) rotate([90, 0, 0]) cylinder(h = 20, r = 15, center = true, $fs = 2);
        translate([-50, 160, -20]) rotate([90, 0, 0]) cylinder(h = 20, r = 15, center = true, $fs = 2);
    }
}
