import processing.serial.*;
import spout.*;

Serial myPort;

int ledStrip1_length = 10;
int ledStrip1_x = 10;
int ledStrip1_y = 10;
int ledStrip1_spacing = 10;


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


for(int i = 0;i<ledStrip1_length;i++)
{

int localX = round(map(i,0,ledStrip1_length-1,20,width-20));
int localY = height/2;
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
      //image(img, 0, 0, width, height);
      
      
      

      //read and send vals
      for(NeoPixel np : pixelList)
      {
        np.readColor(img);
        np.show();
      }      
      
    }






/*
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
*/

}
