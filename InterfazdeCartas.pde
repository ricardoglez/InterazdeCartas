int numObj = 15;
float ra = 400;
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
PFont  fuente;
PFont  titulos;
int iteracion;
boolean[] posicionesOcupadas =new boolean[3];
boolean mostrarRes = false;
PGraphics fondo;
PGraphics capa1;
String futuro = "Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo ";
color oscuro0= #040A15;
color oscuro1= #040A15;
color medio0 = #967CAF;
color medio1 = #703261;
color claro = #CAD3E0;

void setup() {
  size(1200, 1000);
  carta = loadImage("cartaA.jpg");
  fondo = createGraphics(width, height);
  capa1 = createGraphics(width, height);
  fuente = loadFont("Courier10PitchBT-Roman-48.vlw");
  titulos = loadFont("Chivo-Regular-48.vlw");

  textMode(MODEL);
  posicionesOcupadas[0] = false;
  posicionesOcupadas[1] = false;
  posicionesOcupadas[2] = false;
  //posicionesOcupadas[4] = false;
  // Posiciones finales de las 3 cartas
  posM[0] = new Attractor(-250, 150);
  posM[1] = new Attractor(0, 200);
  posM[2] = new Attractor(250, 150);
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
  background(medio1); 
  //Comenzar desde el centro
  translate(width/2, height/2);
  pushMatrix();
  // Calibrar el mouse a la nueva ubicacion
  sensY = mouseY-height/2;
  sensX = mouseX-width/2;
  //Dibujar las cartas
  proc1();
  mRes();
  if (mostrarRes) {
    image(capa1, -width/2, -height/2);
  }

  popMatrix();
}
// revisar si la posicion "i" esta ocupada 
boolean revisarPos(int i) { 
  if ( posicionesOcupadas[i] ) {
    //fill(0);
    //rect(cartaM[i].location.x, cartaM[i].location.y, 80, 150);
  }
  return posicionesOcupadas[i];
}

void proc1() {
  for (int i = 0; i <= numObj-1; i++) {
    cartaM[i].display();
    if ( ( sensX >= cartaM[i].location.x && sensY >= cartaM[i].location.y ) && ( sensX <= cartaM[i].location.x + cartaA && sensY <= cartaM[i].location.y + cartaH ) ) {
      // Colocar transparencia sobre la carta seleccionada
      //tint(0, 0, 0, 200);
      fill(oscuro0, 180);
      rect(cartaM[i].location.x, cartaM[i].location.y, 80, 150);
    }
    if ( cartaM[i].revEdo()   ) {
      println(i, revisarPos(0), revisarPos(1), revisarPos(2));
      // si estan vacias las posicones mover la carta seleccionada a la primera posicion
      if (!revisarPos(0) && !revisarPos(1) && !revisarPos(2) ) { 
        //println("Las tres desocupadas");
        mostrarRes = false;
        PVector force = posM[0].attract(cartaM[i]);
        cartaM[i].applyForce(force);
        cartaM[i].update();
        cartaM[i].location = posM[0].location;
        posicionesOcupadas[0] = true;
        //Si la primera posicion esta ocupada mover la carta seleccionada a la segunda posicion
      } else if ( revisarPos(0) && !revisarPos(1) && !revisarPos(2) ) {
        PVector force = posM[1].attract(cartaM[i]);
        //println("Uno Ocupada"); 
        cartaM[i].applyForce(force);
        cartaM[i].update();
        cartaM[i].location = posM[1].location;
        posicionesOcupadas[1] = true;
        //Si la primera y la segunda posicion estan ocupadas
      } else if ( revisarPos(0) && revisarPos(1) && !revisarPos(2) ) {
        PVector force = posM[2].attract(cartaM[i]);
        cartaM[i].applyForce(force);
        cartaM[i].update();
        cartaM[i].location = posM[2].location;
        posicionesOcupadas[2] = true;
        mostrarRes = true;
        //println("Uno y Dos Ocupada");
        // Si todos los espacios estan ocupados mostrar el resultado
      }
    }
  }
}

void mRes() {
  if ( mostrarRes ) {
    capa1.beginDraw();
    capa1.translate(width/2, height/2);
    capa1.pushMatrix();
    capa1.tint(255,255,255,100);
    capa1.fill(claro, 10);
    capa1.noStroke();
    capa1.rect(100-width/2, 70-height/2, 1000, 521);
    
    capa1.fill(oscuro0);
    capa1.stroke(oscuro0);
    capa1.textFont(titulos, 18);
    capa1.textSize(48);
    capa1.text("EL TAROT DEL INFORTUNIO", 175-width/2, 90-height/2, 659, 70);
    
    capa1.fill(oscuro1);
    capa1.noStroke();
    capa1.textFont(fuente, 18);
    capa1.textSize(24);
    capa1.text(futuro+futuro+futuro+futuro+futuro+futuro+futuro+futuro+futuro+futuro+futuro, 115-width/2, 152-height/2, 961, 411);
    //capa1.tint(255);
    capa1.fill(medio0, 100);
    capa1.rect(posM[0].location.x-50, posM[0].location.y-20, 180, 250);
    capa1.rect(posM[1].location.x-50, posM[1].location.y-20, 180, 250);
    capa1.rect(posM[2].location.x-50, posM[2].location.y-20, 180, 250);
    capa1.popMatrix();
    capa1.endDraw();
  }
}