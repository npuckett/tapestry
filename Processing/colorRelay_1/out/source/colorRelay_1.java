import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.video.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class colorRelay_1 extends PApplet {



Capture cam;

float ringRadius = 150;
int leds = 24;
ArrayList<NeoPixel> pixelList = new ArrayList<NeoPixel>();
JSONObject sendData;
public void setup() 
{
  

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[3]);
    cam.start();     
  }  

for(int i = 0;i<leds;i++)
{

float in_angle = (360f/leds)*i;

float localX = width/2 + ringRadius * sin(radians(in_angle));
float localY = height/2 - ringRadius * cos(radians(in_angle)); 

pixelList.add(new NeoPixel(localX,localY,i));

}


sendData = new JSONObject();

}

public void draw() 
{
  if (cam.available() == true) 
  {
    cam.read();
  println(cam.width+" "+cam.height);
  cam.loadPixels();
  image(cam, 0, 0);
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
  
  for(NeoPixel np : pixelList)
  {
    np.readColor(cam);
    np.show();
    sendData.setJSONArray(str(np.number),np.outData);
  }

//saveJSONObject(sendData, "data/new.json");
}

}
class NeoPixel
{

int number;
float x;
float y;
int currentCol = color(0,0,0);
float cr;
float cg;
float cb;
JSONArray outData;

NeoPixel(float _x, float _y, int _num)
{
number = _num;
x = _x;
y = _y;
outData = new JSONArray();

}

public void readColor(Capture inVid)
{
int loc = round(this.x + this.y*inVid.width);
currentCol = inVid.pixels[loc];
cr =  red(currentCol);
cg = green(currentCol);
cb = blue(currentCol);

//println(number+" : "+cr+"  |  "+cg+"  |  "+cb);

outData.setFloat(0,cr);
outData.setFloat(1,cg);
outData.setFloat(2,cb);

}

public void show()
{
fill(255);
textAlign(CENTER,CENTER);
text(""+number+" r:"+cr+" g:"+cg+" b:"+cb,x,y);    
noFill();
stroke(255);
ellipse(x,y,20,20);



}






}
  public void settings() {  size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "colorRelay_1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
