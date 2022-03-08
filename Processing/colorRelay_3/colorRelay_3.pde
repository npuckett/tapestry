import toxi.math.*;
import toxi.color.*;
import processing.serial.*;


Serial myPort;

PGraphics grad1;



float ringRadius = 200;
int leds = 12;
ArrayList<NeoPixel> pixelList = new ArrayList<NeoPixel>();
JSONObject sendData;


void setup() 
{
  size(640, 480, P3D);

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

void draw() 
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



