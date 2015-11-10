// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// A class for a draggable attractive body in our world

class Attractor {
  //float mass;    // Mass, tied to size
  //float G;       // Gravitational Constant
  PVector location;   // Location
  boolean dragging = false; // Is the object being dragged?
  boolean rollover = false; // Is the mouse over the ellipse?
  PVector dragOffset;  // holds the offset for when object is clicked on

  Attractor(float x_ , float y_) {
    location = new PVector(x_ , y_);
    //mass = 20;
    //G = 1;
    dragOffset = new PVector(0.0,0.0);
  }

  PVector attract(Mover m) {
    PVector force = PVector.sub(location,m.location);   // Calculate direction of force
    float d = force.mag();                              // Distance between objects
    d = constrain(d,5.0,25.0);                          // Limiting the distance to eliminate "extreme" results for very close or very far objects
    force.normalize();                                  // Normalize vector (distance doesn't matter here, we just want this vector for direction)
    //float strength = (G * mass * m.mass) / (d * d);     // Calculate gravitional force magnitude
    force.mult(2);     // Get force vector --> magnitude * direction
    return force;
  }

  // Method to display
  void display() {
    ellipseMode(CENTER);
    strokeWeight(4);
    stroke(0);
    if (dragging) fill (50);
    else if (rollover) fill(100);
    else fill(175,200);
    ellipse(location.x,location.y,20,20);
  }
}