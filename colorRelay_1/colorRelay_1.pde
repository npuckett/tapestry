import processing.video.*;

Capture cam;

float ringRadius = 150;
int leds = 24;
ArrayList<NeoPixel> pixelList = new ArrayList<NeoPixel>();
JSONObject sendData;
void setup() 
{
  size(640, 480);

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

void draw() 
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
