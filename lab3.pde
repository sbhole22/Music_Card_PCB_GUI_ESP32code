import processing.serial.*;

int baudrate = 9600;
String portName = "COM10"; // your port
Serial myPort;

void setup() {
  size(500, 500); 
  myPort = new Serial(this, portName, baudrate);
  myPort.clear();
  
  // draw initial gray ellipses
  drawGrayEllipses();
}

void draw() {
  if (myPort.available() > 0) { 
    String val = myPort.readStringUntil(';'); 

    if (val == null) return;
    
    val = val.trim();  // remove leading/trailing spaces/newlines

    // ignore ESP boot messages or non-numeric lines
    if (val.contains("ESP-ROM") || val.length() == 0) return;

    // split the string by commas
    String[] nums = split(val, ',');
    nums[0] = nums[0].substring(0,1);
    nums[1] = nums[1].substring(0,1);
    int n0 = Integer.parseInt(nums[0]);    
    //println(n0);
    int n1 = Integer.parseInt(nums[1]);    
    //println(n1);

      if (n0 == 0 && n1 == 1) {
        println("First");
        drawRedEllipse(0);  // highlight the first ellipse
      } 
      
    if (n0 == 1 && n1 == 1) {
        println("Second");
        drawRedEllipse(1);  // highlight the first ellipse
      } 
      
      if (n0 == 2 && n1 == 1) {
        println("Third");
        drawRedEllipse(2);  // highlight the first ellipse
      } 
  }
}

// draw all ellipses gray
void drawGrayEllipses() {
  background(255);
  ellipseMode(CENTER);
  fill(200);
  ellipse(100, 250, 100, 100);
  ellipse(250, 250, 100, 100);
  ellipse(400, 250, 100, 100);
}

// draw one red ellipse based on index 0,1,2
void drawRedEllipse(int index) {
  drawGrayEllipses();  // reset all to gray
  fill(255, 0, 0);     // red
  if (index == 0) ellipse(100, 250, 100, 100);
  if (index == 1) ellipse(250, 250, 100, 100);
  if (index == 2) ellipse(400, 250, 100, 100);
}
