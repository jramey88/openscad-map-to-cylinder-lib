module circle_slice(r, fn=32){
    a = 360/fn;
    x = r*cos(a/2);
    y = r*sin(a/2);
    overlap_adjustment = 0.01;  //get rid of tiny gaps between slices
    polygon([[0, 0], [x, y+overlap_adjustment], [x, -y-overlap_adjustment]]);
}

module map_to_cylinder(r, h, fn=32){
    a = 360/fn; //angle of each slice
    slice_width = 2*r*sin(a/2);
    //%cylinder(r=r, h=h, $fn=fn);
    
    if($children>0){
        for(i=[0:fn]){
            //intersection of flat object with circle slices
            rotate([0, 0, a*i])
            intersection(){
                rotate([0, 0, -90])
                linear_extrude(h)
                    circle_slice(r, fn);
                
                translate([-slice_width*i, -r, 0])
                rotate([90, 0, 0])
                    children(0);
            }
        }
    }
}

module map_to_cylinder_test(){
    map_to_cylinder(20, 20, fn=128)
    translate([0, 0, -1])
    linear_extrude(1)
        text("Hello World!");
}

map_to_cylinder_test();



tx = "A";
font_size = 20;
thickness = 1;
fn = 24;

module one_over_fn_for_circle(radius, fn) {
    a = 360 / fn;
    x = radius * cos(a / 2);
    y = radius * sin(a / 2);
    polygon(points=[[0, 0], [x, y],[x, -y]]);
}

module square_to_cylinder(length, width, square_thickness, fn) {
    r = length / 6.28318;
    a = 360 / fn;
    y = r * sin(a / 2);
    for(i = [0 : fn - 1]) {
        // line up the triangle
        rotate(a * i) translate([0, -(2 * y * i + y), 0])

         intersection() {
            // line up the triangle
            translate([0, 2 * y * i + y, 0]) 
                linear_extrude(width) 
                    one_over_fn_for_circle(r, fn);
            // make the character stand up
            translate([r - square_thickness, 0, width]) 
                rotate([0, 90, 0]) 
                    children(0);
        }
    }
}

translate([0, 50, 0])
square_to_cylinder(font_size, font_size, thickness, fn)
    linear_extrude(thickness)
        translate([font_size / 2, font_size / 2, 0])
            rotate(90) 
                text(tx, size = font_size, valign = "center", halign = "center");