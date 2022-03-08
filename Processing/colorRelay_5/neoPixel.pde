class NeoPixel
{

int number;
int x;
int y;
color currentCol = color(0,0,0);
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

void readColor(PImage inVid)
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

void show()
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
