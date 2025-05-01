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
thread_pitch=1*25.4/36;
//thread major diameter
thread_majordiameter=19;
//thread length
thread_length=3.3;

//counterbore outer diameter
counterbore1_diameter=20.3;
//counterbore length
counterbore1_length=30;

//laser diameter
laser_diameter=11.5;//.1
//laser beam opening diameter
laser_beamdiameter=9;

//cross section?
xsection=false;

//create the solid body
module Additive(){
    //threaded tip
    threaded_rod(d=thread_majordiameter, l=thread_length, pitch=thread_pitch, end_len2=0, anchor=TOP);
    
    //lower portion
    translate([0, 0, -thread_length+z])
    cyl(d=counterbore1_diameter, h=counterbore1_length, anchor=TOP, chamfer2=1, chamfer1=.5);
}

//reductively create additional features
module Subtractive(){
    //removing the top laser hole
    translate([0, 0, -thread_length-z])
    cyl(d=laser_beamdiameter, h=thread_length+2*z, chamfer1=-.5, chamfer2=-.5, anchor=BOTTOM);
    
    //removing chamfer for laser insertion
    translate([0, 0, -thread_length-counterbore1_length-z])
    cyl(d1=laser_diameter+1+2, d2=laser_diameter+2, h=.5+2*z, anchor=BOTTOM);
    
    //removing space for laser
    //keeping cone shaped dimples for fitment
    translate([0, 0, -thread_length-counterbore1_length+.5-z])
    cyl(d=laser_diameter, h=counterbore1_length-.5+2*z, anchor=BOTTOM, texture="cones", tex_depth=-1, tex_size=[2,2]);
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
