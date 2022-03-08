import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import toxi.math.*; 
import toxi.color.*; 
import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class colorRelay_3 extends PApplet {






Serial myPort;

PGraphics grad1;



float ringRadius = 200;
int leds = 12;
ArrayList<NeoPixel> pixelList = new ArrayList<NeoPixel>();
JSONObject sendData;


public void setup() 
{
  

 grad1 = createGraphics(640,480);
printArray(Serial.list());
myPort = new Serial(this, Serial.list()[2], 256000);

for(int i = 0;i<leds;i++)
{

float in_angle = (360f/leds)*i;

int localX = round(width/2 + ringRadius * sin(radians(in_angle)));
int localY = round(height/2 - ringRadius * cos(radians(in_angle))); 

pixelList.add(new NeoPixel(localX,localY,i));

}


sendData = new JSONObject();

}

public void draw() 
{
   ColorGradient grad=new ColorGradient();

  grad.addColorAt(0,TColor.BLUE);
  grad.addColorAt(mouseX,TColor.RED);
  grad.addColorAt(width,TColor.YELLOW);
  
  ColorList cols=grad.calcGradient(0,width);
  grad1.beginDraw();
  int x=0;
  for(TColor c : cols) 
  {
    
    grad1.stroke(c.toARGB());
    grad1.line(x,0,x,height);
    x++;
  }
  grad1.endDraw();
  image(grad1,0,0);


  String output = "";
  int i = 0;

      for(NeoPixel np : pixelList)
      {
        if(i>0)
        {
          output += ",";
        }
        output += np.readColor(grad1);
        np.show();
        i++;
        //sendData.setJSONArray(str(np.number),np.outData);
      }

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

public String readColor(PGraphics inVid)
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
    String[] appletArgs = new String[] { "colorRelay_3" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
