import processing.serial.*;
import spout.*;

Serial myPort;



ArrayList<NeoPixel> pixelList = new ArrayList<NeoPixel>();
///
PGraphics pgr; // Canvas to receive a texture
PImage img; // Image to receive a texture

// For PGraphics to PImage
PGraphicsOpenGL pgl;

// DECLARE A SPOUT OBJECT
Spout spout;

///
OPC opc;

void setup() 
{
  size(640, 480, P3D);


//printArray(Serial.list());
//myPort = new Serial(this, Serial.list()[2], 9600);


  pgr = createGraphics(width, height, PConstants.P2D);
  img = createImage(width, height, ARGB);
  
  // CREATE A NEW SPOUT OBJECT
  spout = new Spout(this);

// For PGraphics to PImage
   pgl = (PGraphicsOpenGL)g;
int ind = round(64*4);
opc = new OPC(this, "127.0.0.1", 7890);
opc.ledStrip(0, 255, width/2, 10,1, 0, false);
//opc.ledStrip(64, 64, width/2, 10,10, 0, false);
//opc.ledStrip(128, 64, width/2, 10,10, 0, false);
//opc.ledStrip(192, 64, width/2, 10,10, 0, false);
opc.ledStrip(256, 30, width/2, height/2,20, 0, false);

}

void draw() 
{
background(0);
pgr = spout.receiveTexture(pgr);
if(pgr.loaded) {
      // image(pgr, 0, 0, width, height);
      
      // PGraphics to PImage
      if(pgr.width != img.width || pgr.height != img.height)
        img = createImage(pgr.width, pgr.height, PConstants.ARGB);
      pgl.getTexture(pgr).get(img.pixels);
      img.updatePixels();
      
      // img now has the graphics pixels
      image(img, 0, 0, width, height);
      
      
    }








}
