#include <ArduinoOSCWiFi.h>
#include <Adafruit_NeoPixel.h>

// WiFi stuff
const char* ssid = "RUR_WEARABLES";
const char* pwd = "torrential_light";
const IPAddress gateway(192,168, 0, 1);
const IPAddress subnet(255, 255, 255, 0);



//IP of the board
const IPAddress ip(192, 168, 0, 203);
//IP of the control laptop
const char* host = "192.168.0.101";
//listening port
const int recv_port = 8000;
//input message address
const String inAddress = "/neodata";

//Neopixel setup
#define MATRIXPIN 32
#define STRIPPIN  21

const int totalLeds = 62;
const int matrixLeds = 32;
const int stripLeds = 30;




Adafruit_NeoPixel matrix(matrixLeds, MATRIXPIN, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel strip(stripLeds, STRIPPIN, NEO_GRB + NEO_KHZ800);



void setup() 
{
  pinMode(LED_BUILTIN,OUTPUT);
  digitalWrite(LED_BUILTIN,LOW);
    Serial.begin(115200);
    delay(2000);

    // WiFi stuff (no timeout setting for WiFi)
#ifdef ESP_PLATFORM
    WiFi.disconnect(true, true);  // disable wifi, erase ap info
    delay(1000);
    WiFi.mode(WIFI_STA);
#endif
    WiFi.begin(ssid, pwd);
    WiFi.config(ip, gateway, subnet);
    while (WiFi.status() != WL_CONNECTED) {
        Serial.print(".");
        delay(500);
    }
    Serial.print("WiFi connected, IP = ");
    Serial.println(WiFi.localIP());
//turn on led to show wifi connection
digitalWrite(LED_BUILTIN,HIGH);

//turn all pixels off
  matrix.begin();
  matrix.setBrightness(100);
  matrix.show();
  
  strip.begin();
  strip.setBrightness(100);
  strip.show();
    

///this subscribes to messages on a particular port/address 
//and defines the function that is called each time
        OscWiFi.subscribe(recv_port, inAddress,
        [](const OscMessage& m) {

            //the data is packaged as , separated strings per pixel
            ///"R,G,B"  this reads through the message and breaks up the data
            for(int i=0;i<totalLeds;i++)
            {
             String recvString = m.arg<String>(i);
             int i1 = recvString.indexOf(',');
             int i2 = recvString.indexOf(',', i1+1);

            String firstValue = recvString.substring(0, i1);
            String secondValue = recvString.substring(i1 + 1, i2);
            String thirdValue = recvString.substring(i2 + 1); 

                //the matrix leds are first in the message 0 - 31
                if(i<matrixLeds)
                {
                  matrix.setPixelColor(i,firstValue.toInt(),secondValue.toInt(),thirdValue.toInt()); 
                }
                //everything 31 and above go to the strip
                else
                {
                  strip.setPixelColor(i-matrixLeds,firstValue.toInt(),secondValue.toInt(),thirdValue.toInt()); 
                }

            } 
            //show the data for both
            strip.show();
            matrix.show();
             
        });
}
void loop() 
{
  //this is needed to make the library work
  OscWiFi.update();

}
