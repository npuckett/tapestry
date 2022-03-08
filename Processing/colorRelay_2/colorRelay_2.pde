import processing.video.*;

Capture cam;

Movie mov;

float ringRadius = 120;
int leds = 24;
ArrayList<NeoPixel> pixelList = new ArrayList<NeoPixel>();
JSONObject sendData;
void setup() 
{
  size(640, 480);

  mov = new Movie(this, "colorTest.mp4");  
  mov.loop();
    

for(int i = 0;i<leds;i++)
{

float in_angle = (360f/leds)*i;

float localX = width/2 + ringRadius * sin(radians(in_angle));
float localY = height/2 - ringRadius * cos(radians(in_angle)); 

pixelList.add(new NeoPixel(localX,localY,i));

}


sendData = new JSONObject();

}

void draw() 
{

  println(mov.width+" "+mov.height);

  image(mov, 0, 0);
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
      for(NeoPixel np : pixelList)
  {
    //np.readColor(mov);
    np.show();
    sendData.setJSONArray(str(np.number),np.outData);
  }


//saveJSONObject(sendData, "data/new.json");


}


void movieEvent(Movie m) {
  m.read();
  m.loadPixels();

        for(NeoPixel np : pixelList)
  {
    np.readColor(mov);
    //np.show();
    //sendData.setJSONArray(str(np.number),np.outData);
  }
}
