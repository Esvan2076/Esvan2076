// === Processing: Typing + Chromatic 3D effect ===
// Texto con efecto 3D (rojo/cian) y animación tipo "máquina de escribir".

String[][] lines = {
  { "Hey there!", "I'm Fernando Esteban." },
  { "I'm studying a B.S. in Computer Engineering",
    "at Tec de Monterrey, Guadalajara, Jalisco, MX" },
  { "I've been coding for 3 years!",
    "I'm proficient in Java, C++, Spring Boot, Web Development, and AWS." },
  { "I've worked on personal, academic, and team projects.",
    "Find my projects on my profile!" },
  { "Feel free to reach out!",
    "Email: fesnandez76@gmail.com" }
};

PFont font;

int cursor = 0;            // cuántos caracteres se muestran (typing)
boolean deleting = false;  // fase de borrado
int section = 0;           // índice de la sección actual
int offset = 35;           // separación vertical entre las dos líneas

int mainFontSize = 60;
int secondaryFontSize = 36;

int pauseMs = 900;         // pausa al terminar de escribir antes de borrar
int phaseStartMs = -1;     // marca de tiempo para la pausa

float splitPx = 3;         // separación del efecto 3D (prueba 2–4 px)

void setup() {
  size(1600, 550);
  smooth();
  background(0);
  // Usa una fuente del sistema; evita .vlw para no depender de archivos
  font = createFont("Helvetica Neue", 48, true);
  textFont(font);
  textAlign(CENTER, BASELINE);
  frameRate(30);
}

void draw() {
  background(0);

  // loop infinito: cuando termine todo, vuelve al inicio
  if (section >= lines.length) {
    section = 0;
    cursor = 0;
    deleting = false;
  }

  String top = lines[section][0];
  String bottom = lines[section][1];

  int topLen = top.length();
  int bottomLen = bottom.length();
  int maxLen = max(topLen, bottomLen);

  if (!deleting) {
    // escribir
    drawTextChromatic3D(top.substring(0, min(cursor, topLen)),
                        width/2, height/2 - offset, mainFontSize, splitPx);
    drawTextChromatic3D(bottom.substring(0, min(cursor, bottomLen)),
                        width/2, height/2 + offset, secondaryFontSize, splitPx);

    cursor++;

    // al terminar de escribir, espera un poco y cambia a borrar
    if (cursor > maxLen) {
      if (phaseStartMs < 0) phaseStartMs = millis();
      if (millis() - phaseStartMs >= pauseMs) {
        deleting = true;
        phaseStartMs = -1;
      }
    }
  } else {
    // borrar
    cursor = max(cursor - 1, 0);

    drawTextChromatic3D(top.substring(0, min(cursor, topLen)),
                        width/2, height/2 - offset, mainFontSize, splitPx);
    drawTextChromatic3D(bottom.substring(0, min(cursor, bottomLen)),
                        width/2, height/2 + offset, secondaryFontSize, splitPx);

    if (cursor == 0) {
      deleting = false;
      section++;
    }
  }

  // --- opcional: exporta frames para GIF ---
  // saveFrame("frames/frame-####.png");
}

// Dibuja texto con efecto 3D anaglifo (rojo/cian + blanco centrado)
void drawTextChromatic3D(String t, float x, float y, int fontSize, float split) {
  textSize(fontSize);
  noStroke();

  // rojo a la izquierda
  fill(255, 0, 0);
  text(t, x - split, y);

  // cian a la derecha
  fill(0, 255, 255);
  text(t, x + split, y);

  // blanco centrado
  fill(255);
  text(t, x, y);
}
