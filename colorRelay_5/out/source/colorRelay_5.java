import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import spout.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class colorRelay_5 extends PApplet {




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

public void setup() 
{
  


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

public void draw() 
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
class NeoPixel
{

int number;
int x;
int y;
int currentCol = color(0,0,0);
float cr;
float cg;
float cb;
JSONArray outData;

NeoPixel(int _x, int _y, int _num)
{
number = _num;
x = _x;
y = _y;
outData = new JSONArray();

}

public void readColor(PImage inVid)
{
int loc = x + y*inVid.width;
      // What is current color
currentCol = inVid.pixels[loc];

//currentCol = inVid.get(x,y);
cr =  currentCol >> 16 & 0xFF;
cg = currentCol >> 8 & 0xFF;
cb = currentCol & 0xFF;

//println(number+" : "+cr+"  |  "+cg+"  |  "+cb);



//outData.setFloat(0,cr);
//outData.setFloat(1,cg);
//outData.setFloat(2,cb);

}

public void show()
{
  

//text(""+number+" r:"+cr+" g:"+cg+" b:"+cb,x,y);    
fill(color(cr,cg,cb));
stroke(255);
strokeWeight(1);
ellipse(x,y,20,20);

fill(255);
textAlign(CENTER,CENTER);
textSize(12);
text(""+number,x,y);  

myPort.write(number);
myPort.write(round(cr));
myPort.write(round(cg));
myPort.write(round(cb));

}






}
  public void settings() {  size(640, 480, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "colorRelay_5" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
