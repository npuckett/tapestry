import processing.serial.*;
import spout.*;

Serial myPort;

float ringRadius1 = 130;
float ringRadius2 = 70;
float ringRadius3 = 20;
int leds1 = 24;
int leds2 = 12;
int leds3 = 6;

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
int offset1 = 64;
int offset2 = 129;
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

opc = new OPC(this, "127.0.0.1", 7890);
for(int i = 0;i<leds1;i++)
{

float in_angle = (360f/leds1)*i;

int localX = round(width/2 + ringRadius1 * sin(radians(in_angle)));
int localY = round(height/2 - ringRadius1 * cos(radians(in_angle))); 

//pixelList.add(new NeoPixel(localX,localY,i));
opc.led(i,localX,localY);
}

for(int i = 0;i<leds2;i++)
{

float in_angle = (360f/leds2)*i;

int localX = round(width/2 + ringRadius2 * sin(radians(in_angle)));
int localY = round(height/2 - ringRadius2 * cos(radians(in_angle))); 

//pixelList.add(new NeoPixel(localX,localY,i));
opc.led(i+offset1,localX,localY);
}

for(int i = 0;i<leds3;i++)
{

float in_angle = (360f/leds3)*i;

int localX = round(width/2 + ringRadius3 * sin(radians(in_angle)));
int localY = round(height/2 - ringRadius3 * cos(radians(in_angle))); 

//pixelList.add(new NeoPixel(localX,localY,i));
opc.led(i+offset2,localX,localY);
}

opc.led(128,width/2,height/2);

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
//myPort.write(output);

//println(output);
//saveJSONObject(sendData, "data/new.json");


}
