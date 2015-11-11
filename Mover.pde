// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class Mover {
  PImage imagen;
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  boolean estado;

  Mover(float x_, float  y_) {
    location = new PVector(x_, y_);
    velocity = new PVector(.2, 0);
    acceleration = new PVector(0, 0);
    mass = .2;
    estado = false;
    imagen = loadImage("cartaA.jpg");
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }

  void display() {
      tint(255); 
      image(imagen, location.x, location.y, 80, 150);
  }

  boolean revEdo() {
    // Si no se encuentra en el area de la carta
    if ( !( sensX >= location.x && sensY >= location.y ) || !( sensX <= location.x + cartaA && sensY <= location.y + cartaH ) ) {
      estado = false;
    } else if( ( sensX >= location.x && sensY >= location.y ) && ( sensX <= location.x + cartaA && sensY <= location.y + cartaH ) && mousePressed) {
      // si esta en el area de la carta y ademas hay un clickeo
      estado = true;
    }
    return estado;
  }
}