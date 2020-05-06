import processing.serial.*;
import http.requests.*;

final int baudRate = 9600;

Serial inPort;  // the serial port
String inString; // input string from serial port
String[] splitString; // input string array after splitting

int device_number = 0;
String ifttt_url = "";

void updateArraySerial(int[] array) {
  if (array == null) {
    return;
  }

  for(int i = 0; i < min(array.length, splitString.length - 1); i++){
    try {
      array[i] = Integer.parseInt(trim(splitString[i + 1]));
    } catch (NumberFormatException e) {
      array[i] = 0;
    }
  }
}

void setup(){
  println((Object[])Serial.list());
  
  inPort = new Serial(this, Serial.list()[device_number], baudRate); 
  inPort.bufferUntil('\n');
}

void serialEvent(Serial p) {
  inString = p.readString();
  println(inString);
  
  splitString = splitTokens(inString);
  
  if (splitString[1].equals("11") && splitString[4].equals("touched")) {
     GetRequest get = new GetRequest(ifttt_url);
     get.send();
    println("Message sent");
  }
}

void draw() {
}
