int numObj = 15;
float ra = 300;
float degrees, x, y;
int finGrados = 360;
int inicioGrados = 190;
int totalGrados = finGrados - inicioGrados;
float gradosObj = totalGrados / numObj;
int cartaA = 50;
int cartaH = 150;
float sensX ;
float sensY ;
Mover[] cartaM = new Mover[numObj+1];
Attractor[] posM = new Attractor[3];
PImage carta;
int iteracion;
boolean[] posicionesOcupadas =new boolean[3];
PGraphics fondo;
PGraphics capa1;

void setup() {
  size(1200, 800);
  carta = loadImage("cartaA.jpg");
  fondo = createGraphics(width, height);
  capa1 = createGraphics(width, height);
  posicionesOcupadas[0] = false;
  posicionesOcupadas[1] = false;
  posicionesOcupadas[2] = false;
  //posicionesOcupadas[4] = false;
  // Posiciones finales de las 3 cartas
  posM[0] = new Attractor(-200, 100);
  posM[1] = new Attractor(0, 0);
  posM[2] = new Attractor(200, 100);
  iteracion = 0;
  // Obtener las posiciones de las cartas
  for (int gd = inicioGrados; gd <= finGrados; gd += gradosObj) { // 360 / numObj = 12 grados por 30 objetos   
    degrees = radians(gd);
    x = ra  * cos(degrees); 
    y = ra  * sin(degrees);  
    cartaM[iteracion] = new Mover( x, y );
    iteracion ++;
  }
}

void draw() {
  background(255); 
  tint(255);
  //Comenzar desde el centro
  translate(width/2, height/2);
  pushMatrix();
  // Calibrar el mouse a la nueva ubicacion
  sensY = mouseY-height/2;
  sensX = mouseX-width/2;
  //Dibujar las cartas
  for (int i = 0; i <= numObj-1; i++) {
    cartaM[i].display();
    //posM[1].display(); // ubicacion 0,0
    if( ( sensX >= cartaM[i].location.x && sensY >= cartaM[i].location.y ) && ( sensX <= cartaM[i].location.x + cartaA && sensY <= cartaM[i].location.y + cartaH ) ) {
     // println("zona");
      tint(0, 0, 0, 200);
      fill(0);
      rect(cartaM[i].location.x, cartaM[i].location.y, 80, 150);
    }
    
    if ( cartaM[i].revEdo()   ) {
      println(i, revisarPos(0), revisarPos(1), revisarPos(2));
      // si ka primera posicion esta vacia
      if (!revisarPos(0) && !revisarPos(1) && !revisarPos(2) ) { 
        PVector force = posM[0].attract(cartaM[i]);
        cartaM[i].applyForce(force);
        cartaM[i].update();
        cartaM[i].location = posM[0].location;
        posicionesOcupadas[0] = true;
        println("Las tres desocupadas");
        //Si la primera posicion esta ocupada
      } else if ( revisarPos(0) && !revisarPos(1) && !revisarPos(2) ) {
        PVector force = posM[1].attract(cartaM[i]);
        cartaM[i].applyForce(force);
        cartaM[i].update();
        cartaM[i].location = posM[1].location;
        fill(0);
        rect(cartaM[i].location.x, cartaM[i].location.y, 80, 150);
        posicionesOcupadas[1] = true;
        println("Uno Ocupada"); 
        //Si la primera y la segunda posicion estan ocupadas
      } else if ( revisarPos(0) && revisarPos(1) && !revisarPos(2) ) {
        PVector force = posM[2].attract(cartaM[i]);
        cartaM[i].applyForce(force);
        cartaM[i].update();
        cartaM[i].location = posM[2].location;
        fill(0);
        rect(cartaM[i].location.x, cartaM[i].location.y, 80, 150);
        posicionesOcupadas[2] = true;
        println("Uno y Dos Ocupada");
      } else if ( revisarPos(0) && revisarPos(1) && revisarPos(2) ) {
        //Escapar 
        println("Todas Ocupadas... Aguanta");
      }
      // si  ya hay alguna carta ubicada cambia la posicion de llegada posicionOcupada[++]
      //println(dist(cartaM[i].location.x, cartaM[i].location.y,  posM[1].location.x, posM[1].location.y));
    }
  }
  popMatrix();
}

boolean revisarPos(int i) {

  if ( posicionesOcupadas[i] ) {
    fill(0);
    rect(cartaM[i].location.x, cartaM[i].location.y, 80, 150);
  }
  return posicionesOcupadas[i];
}