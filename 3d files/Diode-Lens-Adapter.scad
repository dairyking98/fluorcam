//Leonard Chau 2025
//Script Inception 29 April 2025

//San Francisco State University
//Dr. Esquerra Research Lab
//Project Fluorcam

//Adapter for mounting laser to coaxial lens

//Notes: 
//The thread size seems to be non standard.
//Some variant of Royal Microscopical Society (RMS) spec.
//The major diameter of thread is measured at 18.72mm.
//The thread pitch is assumed to be 36 TPI, roughly 
//confirmed via thread gauge.
//The nominal diameter of laser housing is 12mm.
//A modeled offset of -.5mm was found to have great
//insertion, removal, and retention of laser.
//A modeled major diameter of 19mm was found to have
//a tight but precise thread fitment to the coaxial lens.
//Printed major diameter hits target of 18.7mm.
//Pinted on a BambuLab P1S printer.

//import some dependencies
//https://github.com/BelfrySCAD/BOSL2
include <BOSL2/std.scad>
include <BOSL2/threading.scad>

//set facet number
$fn=60;
//small value for offset for z fighting
z=.001;

//pitch of thread (RMS)
//thread_pitch=1*25.4/36;

pitch_or_tpi=0;//[0:pitch (metric), 1:tpi (imperial)]
thread_value=.5;

thread_pitch=pitch_or_tpi==0?thread_value:25.4/thread_value;
//thread major diameter
thread_majordiameter=17;
//thread length
thread_length=3.3;

//counterbore outer diameter
counterbore1_diameter=19.5;
//counterbore length
counterbore1_length=20;

//laser diameter
laser_diameter=11.5;//.1
//laser beam opening diameter
laser_beamdiameter=9;

//cross section?
xsection=false;

diode_width=25;//20
diode_groove=4.4;
diode_thickness=1.3;
diode_clearance=1.5;
diode_height=5.5;

module diode(){
    difference(){
        union(){
            linear_extrude(diode_thickness)
            rotate([0, 0, 360/24])
            regular_ngon(n=12, ir=diode_width/2);
            
            linear_extrude(diode_clearance+diode_thickness)
            for (n=[0:5]){
                    rotate([0, 0, (n+.5)*360/6])
                    hull(){
                        translate([0, (20/2)+.4, 0])
                        circle(d=8);
                        circle(d=3);
                    }
            }
            cylinder(d=11, h=diode_height);
        }
        linear_extrude(diode_thickness+diode_clearance, scale=.95)
        for (n=[0:5]){
            if (n!=3)
            rotate([0, 0, n*360/6])
            hull(){
                translate([0, (20/2)+.4, 0])
                circle(d=diode_groove);
                translate([0, 30, 0])
                circle(d=diode_groove);
            }
        }
    }
}

//create the solid body
module Additive(){
    //threaded tip
    threaded_rod(d=thread_majordiameter, l=thread_length, pitch=thread_pitch, end_len2=.5, bevel2=.5, anchor=TOP);
    
    //lower portion
    translate([0, 0, -thread_length+z])
    cyl(d=counterbore1_diameter, h=counterbore1_length, anchor=TOP, chamfer2=1, chamfer1=.5);
}

//reductively create additional features
module Subtractive(){
    //removing the top laser hole
    translate([0, 0, -thread_length-z])
    cyl(d=laser_diameter, h=thread_length+2*z, chamfer1=0, chamfer2=-.5, anchor=BOTTOM);
    
    //removing chamfer for laser insertion
    translate([0, 0, -thread_length-counterbore1_length-z])
    cyl(d1=laser_diameter+1+2, d2=laser_diameter+2, h=.5+2*z, anchor=BOTTOM);
    
    //remove space for diode
    translate([0, 0, -thread_length-counterbore1_length-z])
    diode();
    
    //removing space for laser
    //keeping cone shaped dimples for fitment
    translate([0, 0, -thread_length-counterbore1_length+.5-z])
    cyl(d=laser_diameter, h=counterbore1_length-.5+2*z, anchor=BOTTOM/*, texture="cones", tex_depth=-1, tex_size=[2,2]*/);
}

//finished part
module Finished(){
    difference(){
        Additive();
        Subtractive();
    }
}

//cross section of finished part
module XSection(){
    difference(){
        Finished();
        cube(100, anchor=LEFT);
    }
}

//render selection of part
module Render(){
    if (xsection==false)
        Finished();
    else
        XSection();
}

//execute code
Render();

//for demonstration

//Additive();
//Subtractive();
