//Leonard Chau 2025
//Script Inception 30 April 2025

//San Francisco State University
//Dr. Esquerra Research Lab
//Project Fluorcam

//Mount for coaxial lens to 3D printer head
//Mates with 3D printed CMOS PCB holder

//Notes:

//import some dependencies
//https://github.com/BelfrySCAD/BOSL2
include <BOSL2/std.scad>
include <BOSL2/threading.scad>

$fn=60;
$slop=0.05;

//hotend mounting block
hotend_xyz=[58, 59.5, 7];
//hotend fastener hole diameter
hotend_mountdiameter=3;
//hotend fastener hole separation center-center
hotend_mountseparation=40;
//hotend y offset for hole center
hotend_mount_y=44.5;
hotend_mount_xoffset=5.5;

//tower thickness
tower_thickness=15;


collar_ID=48.2;
collar_lip_zheight=52;



//y offset height
yoffset_zheight=22;
//gusset thickness
gusset_thickness=3.5;
yoffset_yz=[gusset_thickness, yoffset_zheight];

module Additive(){

    hull(){
    cube(hotend_xyz, anchor=FRONT+BOT);
    
    translate([0, -collar_ID/2, 0])
    coax_cyl();
    
    translate([hotend_xyz[0]/2, hotend_xyz[1], 0])
    cube([yoffset_yz[0], hotend_xyz[1]+4, yoffset_yz[1]], anchor=BACK+RIGHT+BOT);
    
    }
    
    hull(){
    translate([0, 0, hotend_xyz[2]])
    cube([hotend_xyz[0], 4, hotend_xyz[2]+10.04+3], anchor=BACK+TOP);
    

    
    
    translate([0, -collar_ID/2, 0])
//    cube(200, anchor=BACK);
    coax_cyl();
    
    
    
    }
    translate([0, 0, -10.04-3])
    cube([hotend_xyz[0], 4+4, 3], anchor=FRONT+BOT);
    
        
}

module coax_cyl(){
    difference(){
    cylinder(d=hotend_xyz[0], h=collar_lip_zheight+40);
    
    remove_coax();
    
    }
    
}

module coax_shape(){
    cylinder(d=53.7, h=4.3);
    translate([0, 0, -51])
    cylinder(d=collar_ID, h=51.1);
}

module remove_coax(){
deg=150;
rotate([0, 0, -deg/2-90])
rotate_extrude(angle=deg){
square(200);}
}

module Subtractive(){
    translate([hotend_mount_xoffset, hotend_mount_y, 0])
    for (s=[1, -1]){
        translate([hotend_mountseparation/2*s, 0, 0]){
        threaded_rod(d=3, l=10, pitch=.5, internal=true, blunt_start=false, anchor=BOT);
        
        translate([0, 0, 9])
        cylinder(d=5, h=100);
        }
    }
    
    for (n=[0:15]){
    
    translate([0, -collar_ID/2, yoffset_zheight+n*6])
    coax_shape();
    
    }
    translate([0, -collar_ID/2, -20])
    remove_coax();
    
//    translate([0, -collar_ID/2, 0])
//    cube(200, anchor=BACK);

    cube([100, 100, 10.04], anchor=TOP+FRONT);
    
}

module Finished(){
    difference(){
        Additive();
        Subtractive();
    }
}

module Gusset(path){
    rotate([90, 0, 90])
    linear_extrude(gusset_thickness, center=true)
    polygon(path);
}

Finished();

//CMOS();

//Subtractive();

//Gusset(Lgussetpath);