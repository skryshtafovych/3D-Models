screw_y_spacing=55;
top_screw_x_spacing=18;
screw_diameter=5;
flange_thickness=6;
flange_width=49;
flange_height=78;
sphere_width=45;
sphere_height=60;
sphere_z_offset=8;
sphere_y_offset=-3;
cylinder_offset=-6.5;	// this is the y offset for a cylinder that cuts off some of the overhangs
wall_thickness=4;
roof_thickness=12;
sphere_angle=25;
coin_angle=35;
cap_angle=70;
coin_rotation=8;
coin_stickout=5;
coin_diam=19;
coin_thickness=1.75;
cap_diam=30;
cap_chamfer=3;
cap_thickness=6;
countersink_depth=3;
fulcrum_diam=6;
fulcrum_y_offset=-4;
fulcrum_z_offset=3;
eye_height=35;;
eye_diam=10;
eye_x_angle=sphere_angle;
eye_y_angle=18;
tongue_thickness=10;
tongue_length=19;
tongue_width=25;
tongue_angle=75;
tongue_z_offset=-4;
tongue_groove=5;
pupil_diam=3;
eye_and_tongue=true;		//give it a tongue and eyes

difference() {
	scale([flange_width,flange_height,flange_thickness]) cylinder(r=1/2, h=1, $fn=80);
	
	for (offset=[1,-1]) if (offset==1) for (xoff=[1,-1]) translate([xoff*top_screw_x_spacing/2,offset*screw_y_spacing/2,-1]) {
		cylinder(r=screw_diameter/2, h=flange_thickness+2, $fn=8);
		translate([0,0,flange_thickness-countersink_depth+1.01]) cylinder(r1=screw_diameter/2, r2=screw_diameter/2+countersink_depth, h=countersink_depth);
	}
	else translate([0,offset*screw_y_spacing/2,-1]) {
		cylinder(r=screw_diameter/2, h=flange_thickness+2, $fn=8);
		translate([0,0,flange_thickness-countersink_depth+1.01]) cylinder(r1=screw_diameter/2, r2=screw_diameter/2+countersink_depth, h=countersink_depth);
	}
	translate([0,sphere_y_offset-2,8]) rotate([-cap_angle,0,0]) cap_cutout();

}


translate([0,sphere_y_offset,flange_thickness+sphere_z_offset]) difference() {
	rotate([-sphere_angle,0,0]) scale([sphere_width,sphere_width,sphere_height]) sphere(r=1/2, $fn=20);
	rotate([-sphere_angle,0,0]) {
		translate([0,0,-(roof_thickness-wall_thickness)]) scale([sphere_width-wall_thickness,sphere_width-wall_thickness,sphere_height-roof_thickness]) sphere(r=(1/2), $fn=8);
		translate([-sphere_width/2,-sphere_width,-sphere_height/2]) cube([sphere_width,sphere_width,sphere_height]);
	}
	translate([0,cylinder_offset,0]) cylinder(r=sphere_width/2-wall_thickness, h=sphere_height);
	translate([-sphere_width/2,-sphere_width/2,-sphere_height-sphere_z_offset]) cube([sphere_width,sphere_width,sphere_height]);
	rotate([-coin_angle,0,0]) translate([0,0,sphere_height/2+coin_diam/2-roof_thickness-coin_stickout]) rotate([coin_rotation,0,0]) coin_cutout();
}

if (eye_and_tongue) {
	for (eye=[-1,1]) rotate([-eye_x_angle,eye*eye_y_angle,0]) translate([0,0,eye_height]) difference() {
		sphere(r=eye_diam/2);
		translate([0,0,eye_diam/2]) sphere(r=pupil_diam/2);
	}
	difference() {
		translate([0,sphere_width/2+sphere_y_offset-wall_thickness*2,flange_thickness+tongue_z_offset]) rotate([tongue_angle,0,0]) difference() {
			scale([tongue_width,tongue_thickness,tongue_length*2]) sphere(r=1/2, $fn=20);
			translate([0,0,-tongue_length/2]) cube([tongue_width+2, tongue_thickness+2, tongue_length], center=true);
			rotate([8,0,0]) translate([0,tongue_thickness/2+tongue_groove/3,0]) cylinder(r=tongue_groove/2, h=tongue_length, $fn=10);
			
		}
		translate([0,0,-flange_thickness/2]) cube([flange_width+2,flange_height+2,flange_thickness*2], center=true);
	}
} else {
	translate([0,fulcrum_y_offset,flange_thickness-fulcrum_diam/2+fulcrum_z_offset]) rotate([0,90,0]) translate([0,0,-sphere_width/2+wall_thickness/2]) cylinder(r=fulcrum_diam/2, h=sphere_width-wall_thickness, $fn=16);
}

//translate([0,sphere_y_offset,flange_thickness+sphere_z_offset]) rotate([-coin_angle,0,0]) translate([0,0,sphere_height/2+coin_diam/2-roof_thickness-coin_stickout])  rotate([coin_rotation,0,0]) coin();

//translate([0,+sphere_y_offset,13]) rotate([-cap_angle+15,0,0]) cap();


module coin()
{
	translate([0,coin_thickness/2,0]) rotate([90,0,0]) cylinder(r=coin_diam/2, h=coin_thickness);

}

module coin_cutout()
{
	translate([0,coin_thickness/2,0]) rotate([90,0,0]) union() {
		cylinder(r=coin_diam/2, h=coin_thickness);
		translate([-coin_diam/2,-coin_diam,0]) cube([coin_diam,coin_diam,coin_thickness]);

	}

}

module cap()
{
	rotate([90,0,0]) cylinder(r=cap_diam/2, h=cap_thickness, center=true);
}

module cap_cutout()
{
	rotate([90,0,0]) 
		cylinder(r1=cap_diam/2, r2=cap_diam/2+cap_chamfer, h=cap_thickness, center=true);

}