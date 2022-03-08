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

public class colorRelay_4 extends PApplet {




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


for(int i = 0;i<leds;i++)
{

float in_angle = (360f/leds)*i;

int localX = round(width/2 + ringRadius * sin(radians(in_angle)));
int localY = round(height/2 - ringRadius * cos(radians(in_angle))); 

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

public String readColor(PImage inVid)
{
int loc = round(this.x + this.y*inVid.width);

currentCol = inVid.get(this.x,this.y);
cr =  red(currentCol);
cg = green(currentCol);
cb = blue(currentCol);

//println(number+" : "+cr+"  |  "+cg+"  |  "+cb);

String colorSend = (number+","+round(cr)+","+round(cg)+","+round(cb));

//outData.setFloat(0,cr);
//outData.setFloat(1,cg);
//outData.setFloat(2,cb);
return colorSend;
}

public void show()
{
fill(255);
textAlign(CENTER,CENTER);
text(""+number+" r:"+cr+" g:"+cg+" b:"+cb,x,y);    
noFill();
stroke(255);
strokeWeight(1);
ellipse(x,y,20,20);



}






}
  public void settings() {  size(640, 480, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "colorRelay_4" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
