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

String readColor(PImage inVid)
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

void show()
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
