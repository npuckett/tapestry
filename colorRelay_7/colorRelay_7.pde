import processing.serial.*;
import spout.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
//NetAddress myRemoteLocation;
NetAddressList deviceList = new NetAddressList();
int broadcastPort = 8000;
String broadCastAddress = "/neodata";

String[] deviceIPs = {
"192.168.0.200",
"192.168.0.201",
"192.168.0.202",
"192.168.0.203"
};

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

void setup() 
{
  size(640, 480, P3D);

frameRate(24);
oscP5 = new OscP5(this,12000);
//set up devices
for(int i = 0;i<deviceIPs.length;i++)
{
connect(deviceIPs[i]);
}





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
      
      
      
      OscMessage myMessage = new OscMessage(broadCastAddress);
      //read and send vals
      for(NeoPixel np : pixelList)
      {
        np.readColor(img);
        np.show();
        myMessage.add(round(np.cr)+","+round(np.cg)+","+round(np.cb));
      } 
     oscP5.send(myMessage, deviceList);       
      
    }

}


 private void connect(String theIPaddress) 
 {
     if (!deviceList.contains(theIPaddress, broadcastPort)) {
      deviceList.add(new NetAddress(theIPaddress, broadcastPort));
       println("### adding "+theIPaddress+" to the list.");
     } else {
       println("### "+theIPaddress+" is already connected.");
     }
     println("### currently there are "+deviceList.list().size()+" remote locations connected.");
 }
