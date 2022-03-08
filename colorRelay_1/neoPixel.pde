class NeoPixel
{

int number;
float x;
float y;
color currentCol = color(0,0,0);
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

void readColor(Capture inVid)
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

void show()
{
fill(255);
textAlign(CENTER,CENTER);
text(""+number+" r:"+cr+" g:"+cg+" b:"+cb,x,y);    
noFill();
stroke(255);
ellipse(x,y,20,20);



}






}