int numObj = 15;
float ra = 400;
float degrees, x, y;
int finGrados = 360;
int inicioGrados = 190;
int totalGrados = finGrados - inicioGrados;
float gradosObj = totalGrados / numObj;
int cartaA = 50;
int cartaH = 150;
float sensX;
float sensY;
Mover[] cartaM = new Mover[numObj + 1];
Attractor[] posM = new Attractor[3];
PFont fuente;
PFont titulos;
int iteracion;
boolean[] posicionesOcupadas = new boolean[3];
boolean mostrarRes = false;
boolean rest = false;
PGraphics cartasMostradas;
PGraphics capa1;
String futuro = "Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo Futurismo ";
color oscuro0 = #040A15;
color oscuro1= #040A15;
color medio0 = #967CAF;
color medio1 = #703261;
color claro = #CAD3E0;
PImage[] cartas = new PImage[15];
PImage flecha;

//-----------------------------------------------------**
//-----------------------------------------------------**
//-----------------------------------------------------**
void setup() {
  size(1200, 1000);
  //fullScreen();//cartas[0] = new PImage();
  cartasMostradas = createGraphics(width, height);
  capa1 = createGraphics(width, height);
  fuente = loadFont("Courier10PitchBT-Roman-48.vlw");
  titulos = loadFont("Chivo-Regular-48.vlw");
  cartas[0] = loadImage("t00.png");
  cartas[1] = loadImage("t01.png");
  cartas[2] = loadImage("t02.png");
  flecha = loadImage("flecha.png");
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
    x = ra * cos(degrees);
    y = ra * sin(degrees);
    //println(x, y);
    cartaM[iteracion] = new Mover(x, y);
    iteracion++;
  }
}
//-----------------------------------------------------**
//-----------------------------------------------------**
//LOOP inicial
void draw() {
  posM[0] = new Attractor(-250, 150);
  posM[1] = new Attractor(0, 200);
  posM[2] = new Attractor(250, 150);
  background(medio1);
  //Comenzar desde el centro
  pushMatrix();
  translate(1200 / 2, 1000 / 2);
  // Calibrar el mouse a la nueva ubicacion
  sensY = mouseY - 1000 / 2;
  sensX = mouseX - 1200 / 2;
  //Dibujar las cartas y mostrar cual esta seleccionada
  proc1();
  popMatrix();
  // Si esta ocupada alguna posicion
  // dibujar la capa de las cartas Mostradas
  if (posicionesOcupadas[0] || posicionesOcupadas[1] || posicionesOcupadas[2]) {
    image(cartasMostradas, 0, 0);
  } 
  // Mostrar el resultado 
  if (mostrarRes) {
    //Dibujar el REsultado 
    //despues la capa donde se ha dibujar el mismo
    dibujarResultado();
    image(capa1, 0, 0);
    //pushMatrix();
    //translate(width, height - 55);
    //popMatrix();
  }
  // Revisar el estad del boton de Reinicio
  if (estadoRein()) {
    // Obtener las posiciones de las cartas
    iteracion = 0;
    for (int gd = inicioGrados; gd <= finGrados; gd += gradosObj) { 
      degrees = radians(gd);
      x = ra * cos(degrees);
      y = ra * sin(degrees);
      //println(x, y);
      cartaM[iteracion].location.x = x;
      cartaM[iteracion].location.y = y;
      iteracion++;
    }
    cartasMostradas.beginDraw();
      cartasMostradas.pushMatrix();
        cartasMostradas.translate(1200, 1000);
        cartasMostradas.background(0, 0);
      cartasMostradas.popMatrix();
    cartasMostradas.endDraw();
    //background(medio1); 
    proc1();
   // cartasMostradas.popMatrix();
    fill(claro, 126);
  } else {
  }
}
//---------------------------------------------------------------//
///****
///***Prceso de Dibujar las cartas y sus animaciones respectivas
///****
//---------------------------------------------------------------//
void proc1() {
  for (int i = 0; i <= numObj - 1; i++) {
    cartaM[i].display();
    if ((sensX >= cartaM[i].location.x && sensY >= cartaM[i].location.y) && (sensX <= cartaM[i].location.x + cartaA && sensY <= cartaM[i].location.y + cartaH)) {
      // Colocar transparencia sobre la carta seleccionada
      noStroke();
      fill(oscuro0, 100);
      rect(cartaM[i].location.x, cartaM[i].location.y, 80, 150);
    }
    revisarCartas(i);
  }
}
//****
//**Revisar el estado de las cartas
//**Acomodar la posicion de la carta seleccionada y mostrar la imagen 
//****
void revisarCartas(int cart) {
  if (cartaM[cart].revEdo()) {
    //println(i, revisarPos(0), revisarPos(1), revisarPos(2));
    //// Si estan vacias las posiciones 
    //// mover la carta seleccionada a la primera posicion
    if (!revisarPos(0) && !revisarPos(1) && !revisarPos(2)) {
      println("Las tres desocupadas");
      int rand = int(random(0, 2));
      mostrarRes = false;
      PVector force = posM[0].attract(cartaM[cart]);
      cartaM[cart].applyForce(force);
      cartaM[cart].update();
      cartaM[cart].location = posM[0].location;
      cartasMostradas.beginDraw();
         cartasMostradas.pushMatrix();
          cartasMostradas.translate(600, 500);
          cartasMostradas.tint(255, 255, 255);
          cartasMostradas.fill(0);
          cartasMostradas.image(cartas[rand], posM[0].location.x - 100, posM[0].location.y - 50, 220, 320);
         cartasMostradas.popMatrix();
      cartasMostradas.endDraw();
      posicionesOcupadas[0] = true;
      /////Si la primera posicion esta ocupada 
      /////mover la carta seleccionada a la segunda posicion
    } else if (revisarPos(0) && !revisarPos(1) && !revisarPos(2)) {
      int rand = int(random(0, 2));
      PVector force = posM[1].attract(cartaM[cart]);
      println("Uno Ocupada"); 
      cartaM[cart].applyForce(force);
      cartaM[cart].update();
      cartaM[cart].location = posM[1].location;
      cartasMostradas.beginDraw();
        cartasMostradas.pushMatrix();
          cartasMostradas.translate(600, 500 );
          cartasMostradas.tint(255, 255, 255);
          cartasMostradas.fill(0);
          cartasMostradas.image(cartas[rand], posM[1].location.x - 100, posM[1].location.y - 50, 220, 320);
        cartasMostradas.popMatrix();
      cartasMostradas.endDraw();
      posicionesOcupadas[1] = true;
      //Si la primera y la segunda posicion estan ocupadas
      // Dibujar la carta en la ultima posicion;
    } else if (revisarPos(0) && revisarPos(1) && !revisarPos(2)) {
      int rand = int(random(0, 2));
      PVector force = posM[2].attract(cartaM[cart]);
      cartaM[cart].applyForce(force);
      cartaM[cart].update();
      cartaM[cart].location = posM[2].location;
      cartasMostradas.beginDraw();
       cartasMostradas.pushMatrix();
          cartasMostradas.translate(600, 500);
          cartasMostradas.tint(255, 255, 255);
          cartasMostradas.fill(0);
          cartasMostradas.image(cartas[rand], posM[2].location.x - 100, posM[2].location.y - 50, 220, 320);
       cartasMostradas.popMatrix();
      cartasMostradas.endDraw();
      posicionesOcupadas[2] = true;
      mostrarRes = true;
      println("Uno y Dos Ocupada");
      // Si todos los espacios estan ocupados mostrar el resultado
    }
  }
}
//***
//** Revisar  la posicion  
//** donde se muestan las cartas y regresar el estado 
//***
boolean revisarPos(int i) {
  if (posicionesOcupadas[i]) {
    //fill(0);
    //rect(cartaM[i].location.x, cartaM[i].location.y, 80, 150);
  }
  return posicionesOcupadas[i];
}
//---------------------------------------------------------------//
//****
//**Esta funcion revisa el estado de reinicio  
//****
//---------------------------------------------------------------//
boolean estadoRein() {
  boolean estado = false;
  
  //Revisar la posicion del sensor 
  //y dibujar un ellipse de fondo del botn de estadoRein tirada
  //fill(255,0,0);
  //rect(sensX+width/2,sensY+height/2, 200,200);
  if (dist(-110, -80, sensX - 600, 55 + sensY - 500) <= 60) {
    text("Tirar de Nuevo", 1200-110,1000-80);
    //Si se da clic al boton de restart
    if (mousePressed && dist(-110, -80, sensX - 600, 55 + sensY - 500) <= 60) {
      
      println("REINICIAR");
      estado = true;
      //estadoRein el juego
      //Rasignar valores a las posiciones de las cartas
      mostrarRes = false; // ocultar el resultado con texto
      //Desactivar las posicones para mostrar
      posicionesOcupadas[0] = false;
      posicionesOcupadas[1] = false;
      posicionesOcupadas[2] = false;
       cartasMostradas.beginDraw();
       cartasMostradas.background(medio1);
       cartasMostradas.endDraw();
       capa1.beginDraw();
       capa1.background(medio1);
       capa1.endDraw();
      //fill(medio1, 20);
    } else {
      estado =  false; 
      //noFill();
      fill(medio1, 20);
    }
  }
  // Dibujar el boton de reinicio
  return estado;
}


//****
//**Dibujar el cuadro de texto con el Augurio 
//**
//****
void dibujarResultado() {
  pushMatrix();
    translate(1200, 1000);
    //rect(sensX+width/2,sensY+height/2, 200,200);
    noStroke();
    ellipseMode(CENTER);
    //fill(medio1,20);
    ellipse(-110, -80, 120, 120);
    stroke(claro);
    strokeWeight(6);
    line(-80, -80, -130, -130);
    line(-80, -80, -130, -30);
  popMatrix();
  capa1.beginDraw();
    capa1.pushMatrix();
      capa1.translate(600, 500);
      capa1.tint(0, 0, 0, 10);
      capa1.fill(claro, 100);
      capa1.noStroke();
      capa1.rect(1200 / 12 - 600, 1000 / 18 - 500, 1000, 500 + 1000 / 20);
      capa1.fill(oscuro0);
      capa1.stroke(oscuro0);
      capa1.textFont(titulos, 18);
      capa1.textSize(48);
      capa1.text("EL TAROT DEL INFORTUNIO", 175 - 1200 / 2, 90 - 1000 / 2, 659, 70);
      capa1.fill(oscuro1);
      capa1.noStroke();
      capa1.textFont(fuente, 18);
      capa1.textSize(24);
      capa1.text(futuro + futuro + futuro + futuro + futuro + futuro + futuro + futuro + futuro + futuro + futuro, 115 - width / 2, 152 - height / 2, 961, 411);
      //capa1.tint(255);
      capa1.fill(medio0, 100);
    capa1.popMatrix();
  capa1.endDraw();
  }