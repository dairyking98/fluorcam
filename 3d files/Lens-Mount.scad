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

//tower thickness
tower_thickness=15;
//height of cmos holder lip from extruder mounting point
cmos_lip_zheight=129;

//cmos holder mounting dimensions
cmos_xyz=[hotend_xyz[0], 50, 15.5];
//cmos holder lip thickness
cmos_lipthickness=2.5;
//cmos holder profile
cmos_profile_xyz=[52.5, 50, 8];
//cmos holder rail cross section
cmos_rail_xz=[3.75, 1.5];
//cmos holder rail separation
cmos_rail_minseparation=20.5;
//cmos holder cable pocket
cmos_cable_yz=[8, 2];
//cmos holder lens opening
cmos_opening=43;

cmos_cable_xyz=concat(cmos_rail_minseparation, cmos_cable_yz);

//y offset height
yoffset_zheight=22;
//gusset thickness
gusset_thickness=3.5;
yoffset_yz=[gusset_thickness, yoffset_zheight];

//tower dimensions
tower_xyz=[hotend_xyz[0], tower_thickness, cmos_lip_zheight+cmos_xyz[2]-cmos_lipthickness];
//height to cmos lip
cmos_zheight=tower_xyz[2]-cmos_xyz[2];

//gusset path 1
p1a=[tower_xyz[1], hotend_xyz[2]];
p1b=[tower_xyz[1], yoffset_yz[1]];
p2=[tower_xyz[1], tower_xyz[2]];
p3a=[hotend_xyz[1], hotend_xyz[2]];
p3b=[hotend_xyz[1], yoffset_yz[1]];
Lgussetpath=[p1a, p2, p3a];
Rgussetpath=[p1b, p2, p3b];

module Additive(){
    cube(hotend_xyz, anchor=FRONT+BOT)
        position(BOT+RIGHT+BACK)
        cube([yoffset_yz[0], hotend_xyz[0], yoffset_yz[1]], anchor=BACK+RIGHT+BOT);
    cube(tower_xyz, anchor=FRONT+BOT);
    translate([0, 0, cmos_zheight])
    cube(cmos_xyz, anchor=BACK+BOT);
    ss=[1, -1];
    paths=[Rgussetpath, Lgussetpath];
    for (n=[0, 1]){
        s=ss[n];
        path=paths[n];
        translate([s*(hotend_xyz[0]-gusset_thickness)/2, 0, 0])
        Gusset(path);
    }
        
        
}

module CMOS(){
//    cube(1, anchor=TOP+FRONT);
    cube(cmos_profile_xyz, anchor=BACK+BOT)
        position(FRONT+TOP){
            cube(cmos_cable_xyz, anchor=BOT+FRONT);
            for (s=[1,-1]){
                translate([s*cmos_rail_minseparation/2, 0, 0])
                cube([cmos_rail_xz[0], cmos_profile_xyz[1], cmos_rail_xz[1]], anchor=s*LEFT+FRONT);
            }
            translate([0, 0, -cmos_profile_xyz[2]])
            cube([cmos_opening, cmos_xyz[1], cmos_lipthickness], anchor=TOP+FRONT);
        }
            
}

module Subtractive(){
    translate([0, 0, cmos_lip_zheight])
    CMOS();
    translate([0, hotend_mount_y, 0])
    for (s=[1, -1]){
        translate([hotend_mountseparation/2*s, 0, 0])
        threaded_rod(d=3, l=10, pitch=.5, internal=true, blunt_start=false, anchor=BOT);
    }
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