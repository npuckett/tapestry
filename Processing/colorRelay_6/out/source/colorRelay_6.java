import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import spout.*; 
import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class colorRelay_6 extends PApplet {






OscP5 oscP5;
NetAddress myRemoteLocation;

Serial myPort;

int ledStrip1_length = 62;
int ledStrip1_x = 100;
int ledStrip1_y = 100;
int ledStrip1_spacing = 60;


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
  

frameRate(24);
oscP5 = new OscP5(this,12000);
myRemoteLocation = new NetAddress("192.168.0.203",8000);


//myPort = new Serial(this, Serial.list()[2], 9600);


  pgr = createGraphics(width, height, PConstants.P2D);
  img = createImage(width, height, ARGB);
  
  // CREATE A NEW SPOUT OBJECT
  spout = new Spout(this);

// For PGraphics to PImage
   pgl = (PGraphicsOpenGL)g;

int index = 0;
for(int y =0;y<4;y++)
{
  for (int x = 0;x<8;x++)
  {
    int localX = ledStrip1_x+ledStrip1_spacing*x;
    int localY = ledStrip1_y+ledStrip1_spacing*y;
    pixelList.add(new NeoPixel(localX,localY,index));
    index++;
  }

}


for (int i= 0;i<30;i++)
{
    int localX = round(map(i,0,29,20,width-20));
    int localY = 400;
    pixelList.add(new NeoPixel(localX,localY,index));
    index++;


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
      
      
      
      OscMessage myMessage = new OscMessage("/neodata");
      //read and send vals
      for(NeoPixel np : pixelList)
      {
        np.readColor(img);
        np.show();
        myMessage.add(round(np.cr)+","+round(np.cg)+","+round(np.cb));
      } 
     oscP5.send(myMessage, myRemoteLocation);       
      
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

//myPort.write(number);
//myPort.write(round(cr));
//myPort.write(round(cg));
//myPort.write(round(cb));

}






}
  public void settings() {  size(640, 480, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "colorRelay_6" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
