$fn=$preview?60:180;

marblepath=1;
radius=6;
height=7;
tolerance=0.1;
wall = 1;
walldistance = 0.5;
downhole = radius-marblepath-wall-walldistance;
nuboffset=1.5*marblepath;
nubradius=0.25;
nubheight=0.5;
engravingDepth=0.3;
sizecatcher=marblepath*2.2;
sizecatcherinner=marblepath*2;

module mirrorCopy(vec=[1,0,0], vec2=[0,0,0], vec3=[0,0,0]){
    
    children();
    mirror(vec) children();

    if(vec2){    
        mirror(vec2){
            children();
            mirror(vec) children();
        }
    }

    if(vec3){
        mirror(vec3){
            children();
            mirror(vec) children();
            mirror(vec2){
                children();
                mirror(vec) children();
            }
        }
    }
    
} 


// Main cylinder

union(){
    // Nub
    translate([nuboffset,nuboffset,height-2])
    cylinder(h=nubheight-tolerance,r=nubradius-tolerance/2);
    
    //Catcher
    mirrorCopy([1,0,0]){
        
        difference(){
            translate([radius-tolerance,0,0])
            cylinder(h=2, r=sizecatcher);
            
            cylinder(h=height,r=radius);
            
            translate([radius-tolerance,0,1])
            cylinder(h=3, r=sizecatcherinner);
        }
    }
    
    // main part
    difference(){
        union(){
            cylinder(h=height,r=radius);
            
            
        }
        union(){
            translate([0,0,height-2]) {
                cylinder(h=3,r=radius-wall);
            }
            
            // Upper canal
            mirrorCopy([0,1,0]){
                hull(){
                    translate([0,radius-2.5,height-2-marblepath]) {
                        union(){
                            sphere(r=marblepath);
                            cylinder(r=marblepath, h=2);
                        }
                    }
                    translate([0,0,height-2-marblepath-0.5]) {
                        union(){
                            sphere(r=marblepath);
                            cylinder(r=marblepath, h=2);
                        }
                    }
                }
            }
            
            // Lower canals
            mirrorCopy([1,0,0]){
                // fally down bit
                hull(){
                    translate([radius,0,2]) {
                        sphere(r=marblepath);
                    };
                    translate([downhole,0,height-2-marblepath/2])        {
                        sphere(r=marblepath);
                    }
                    translate([downhole,0,height-2-marblepath-1])        {
                        sphere(r=marblepath);
                    }
                }
                // upper part
                hull(){
                    translate([0,0,height-2-marblepath-0.5]) {
                        union(){
                            sphere(r=marblepath);
                            cylinder(r=marblepath, h=2);
                        }
                    };
                    translate([downhole,0,height-2-marblepath-1])        {
                        union(){
                            sphere(r=marblepath);
                            cylinder(r=marblepath, h=2);
                        }
                    }
                }
            }
            
            //Engravings
            //outside 0
            translate([radius-engravingDepth,0,5.75])
            rotate(a=90,v=[1,0,0])rotate(a=90,v=[0,1,0])
            linear_extrude(engravingDepth)
            text(text="0",size=1.5,halign="center",valign="center");
            //outside 1
            translate([-(radius-engravingDepth),0,5.75])
            rotate(a=90,v=[1,0,0])rotate(a=270,v=[0,1,0])
            linear_extrude(engravingDepth)
            text(text="1",size=1.5,halign="center",valign="center");
            //QuSoft at the bottom
            translate([0,0,engravingDepth])
            rotate(a=180,v=[1,0,0])
            linear_extrude(engravingDepth+tolerance)
            text(text="QuSoft",size=2,halign="center",valign="center");
            
        }
    }
}

// Top part

translate([15,0,0])
difference() {
    union(){
        translate([0,0,(2-tolerance)])
        cylinder(r=radius, h=1);
        cylinder(r=radius-1-tolerance, h=2); 
    }
    
        
        
    mirrorCopy([1,0,0]){
        translate([downhole,0,-1])
        cylinder(h=5,r=marblepath);
    }
    mirrorCopy([0,1,0]){
        translate([0,downhole,-1])
        cylinder(h=5,r=marblepath);
        
    }
    
    //top cutout
    translate([0,0,(2-tolerance)])
    cylinder(r=radius-wall-walldistance,h=2);
    
    
    mirrorCopy([1,0,0]){
        translate([nuboffset,nuboffset,0])
        cylinder(h=nubheight,r=nubradius);
        
    }
    
    rotate(45)
    rotate_extrude(angle=90)
    translate([sqrt(pow(nuboffset,2)*2),nubheight/2,0])
    square([nubradius*2,nubheight],center=true);
    
    // lettering
    translate([0,marblepath*2,2-engravingDepth])
    //rotate(a=180,v=[1,0,0])
    linear_extrude(engravingDepth+tolerance)
    #text(text="S0",size=0.75,halign="center",valign="center");
    
    
    translate([marblepath*2,0,2-engravingDepth])
    rotate(a=270,v=[0,0,1])
    linear_extrude(engravingDepth+tolerance)
    #text(text="H0",size=0.75,halign="center",valign="center");
    
    
    translate([0,-marblepath*2,2-engravingDepth])
    rotate(a=180,v=[0,0,1])
    linear_extrude(engravingDepth+tolerance)
    #text(text="S1",size=0.75,halign="center",valign="center");
    
    
    translate([-marblepath*2,0,2-engravingDepth])
    rotate(a=90,v=[0,0,1])
    linear_extrude(engravingDepth+tolerance)
    #text(text="H1",size=0.75,halign="center",valign="center");
    
}

//Lid

translate([30,0,0])
union(){
    translate([0,0,(2-tolerance)])
    cylinder(r=radius-wall-walldistance-tolerance,h=1);
    
    difference(){
        translate([0,0,3])
        cube([radius*0.5, 1, 1.5],center=true);
        
        
        translate([-radius/2,0,3.7])
        mirrorCopy([0,1,0]){
        translate([0,0.8,0])
            rotate(a=90,v=[0,1,0])
            cylinder(r=0.7, h= radius);
        }
        
    }
}
