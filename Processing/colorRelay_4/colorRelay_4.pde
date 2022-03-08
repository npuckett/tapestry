import processing.serial.*;
import spout.*;

Serial myPort;

float ringRadius = 130;
int leds = 12;
ArrayList<NeoPixel> pixelList = new ArrayList<NeoPixel>();
///
PGraphics pgr; // Canvas to receive a texture
PImage img; // Image to receive a texture

// For PGraphics to PImage
PGraphicsOpenGL pgl;

// DECLARE A SPOUT OBJECT
Spout spout;

///


void setup() 
{
  size(640, 480, P3D);


printArray(Serial.list());
myPort = new Serial(this, Serial.list()[2], 9600);


  pgr = createGraphics(width, height, PConstants.P2D);
  img = createImage(width, height, ARGB);
  
  // CREATE A NEW SPOUT OBJECT
  spout = new Spout(this);

// For PGraphics to PImage
   pgl = (PGraphicsOpenGL)g;


for(int i = 0;i<leds;i++)
{

float in_angle = (360f/leds)*i;

int localX = round(width/2 + ringRadius * sin(radians(in_angle)));
int localY = round(height/2 - ringRadius * cos(radians(in_angle))); 

pixelList.add(new NeoPixel(localX,localY,i));

}




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







  String output = "";
  int i = 0;

      for(NeoPixel np : pixelList)
      {
        if(i>0)
        {
          output += ",";
        }
        output += np.readColor(img);
        np.show();
        i++;
        //sendData.setJSONArray(str(np.number),np.outData);
      }
      output+="\n";

//String output = sendData.toString();
myPort.write(output);

//println(output);
//saveJSONObject(sendData, "data/new.json");


}
