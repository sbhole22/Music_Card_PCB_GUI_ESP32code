import processing.serial.*;

/*
How to use this UI

left click to trigger a button or slider
right click and drag to UI elements
hover over button and press delete to delete the button
*/

Audio music;

PImage img;
ArrayList<Button> myButtons = new ArrayList<Button>();
ArrayList<Slider> mySliders = new ArrayList<Slider>();
String control_mode = "";
float x_clicked = 0;
float y_clicked = 0;
Controls control;

Serial myPort;
boolean released = true;
String val;
int baudrate = 9600;
String portName = "COM10"; // your port
//settings() runs before setup and lets you put a variable in size
void settings(){
  //setting the size of the canvas to the size of the image
  size(861,480);
}

void setup() {
  img = loadImage("card.png");//loads image

  background(0);
  image(img, 0, 0);
  control = new Controls();
  
  /* ********************************************************************/
  // Todo: initialize Serial port
  /* ********************************************************************/
  


  /* ********************************************************************/
  // Todo: Add touch buttons
  /* ********************************************************************/
  
  //(a,b,c,d,type) These are coordinates for an ellipse
  //(a,b) is the upper right corner, (c,d) is the lower right corner of the ellipse
  myButtons.add(new Button(360.0, 180.0, 440, 260, "Ellipse"));//play/pause
  myButtons.add(new Button(70.0, 210.0, 150, 290, "Ellipse"));//back
  myButtons.add(new Button(605.0, 230.0, 685, 310, "Ellipse"));//fwd
  mySliders.add(new Slider(60.0, 450.0, 800.0, 450.0));
  music = new Audio(this);
  
  myPort = new Serial(this, portName, baudrate);
  myPort.clear();
  
}

void draw() {
  
  background(0);
  image(img, 0, 0);
  control_mode = control.getMode();
  if(control_mode!= "Hide"){
    //You can show or hide the interactive elements here!
    for(int i=0;i<myButtons.size(); i++)
     myButtons.get(i).drawButton(); 
     
     mySliders.get(0).drawSlider();
  }
  
  if (myPort.available() > 0) { 
    String val = myPort.readStringUntil(';'); 

    if (val == null) return;
    
    val = val.trim();  // remove leading/trailing spaces/newlines

    // ignore ESP boot messages or non-numeric lines
    if (val.contains("ESP-ROM") || val.length() == 0) return;

    // split the string by commas
    //String[] nums = split(val, ',');
    //nums[0] = nums[0].substring(0,1);
    //nums[1] = nums[1].substring(0,4);
    //int n0 = Integer.parseInt(nums[0]);    
    //println(n0);
    //float n1 = Float.parseFloat(nums[1]);    
    //println(n1);
    
        // Clean unwanted characters
    val = val.replace("(", "").replace(")", "").replace(";", "");
    
    // Split
    String[] nums = split(val, ',');
    
    // Convert safely
    int n0 = Integer.parseInt(nums[0]);        
    //println(n0);
    float n1 = Float.parseFloat(nums[1]);      
    //println(n1);

      if (n0 == 0 && n1 == 1.0) {
        println("First");
        music.back();
                  // break;
        //drawRedEllipse(0);  // highlight the first ellipse
      } 
      
    if (n0 == 1 && n1 == 1.0) {
        println("Second");
        if(!music.isPlaying())
                      music.play();
                    else 
                      music.pause();
        //drawRedEllipse(1);  // highlight the first ellipse
      } 
      
      if (n0 == 2 && n1 == 1.0) {
        println("Third");
        music.forward();
        //drawRedEllipse(2);  // highlight the first ellipse
      } 
      if (n0 == 3) {
        music.changeVolume(n1);
      } 
  }
  
  music.songFinished();
  
  /********************************************************************
  //TODO: Double check: Play/Pause Music, Go to Previous/Next Song Depending on Serial Message
  *********************************************************************/
  
  
  
}

void mousePressed(MouseEvent evt){

  if(mouseButton == LEFT){
    
     for (int i = 0; i< myButtons.size(); i++){
      if( myButtons.get(i).inButton()){//is the mouse on one of the buttons?
          
          /* ********************************************************************/
          // TODO: assign the function of the buttons here
          // Note that the order of declaring the buttons
          // affects the case numbers here (first object is 0 and so on)
          /* ********************************************************************/
          
          switch(i) {
           // case 0 adds the play/pause function to the button that was
           // declared first
           case 0 : if(!music.isPlaying())
                      music.play();
                    else 
                      music.pause();
                    break;
                    
           case 1: music.back();
                   break;
           
           case 2: music.forward();
                   break;
          }
        } 
        
      }
         
      for (int i = 0; i< mySliders.size(); i++){
        mySliders.get(i).inSlider();
      if( mySliders.get(i).getInSlider()){
          mySliders.get(i).interract(true);
        } 
      }
  }

  if (mouseButton == RIGHT){
    x_clicked = mouseX;
    y_clicked = mouseY;
    
    for (int i = 0; i< myButtons.size(); i++){
      if( myButtons.get(i).inButton()){
          myButtons.get(i).setButtonSelected(true);
        } 
      }
    for (int i = 0; i< mySliders.size(); i++){
      mySliders.get(i).inSlider();
      if( mySliders.get(i).getInSlider()){
          mySliders.get(i).movementStart();
        } 
      } 
  }
  
  
  
}

void mouseDragged(){
  
  if(mouseButton == RIGHT){
    if(0<mouseX && mouseX<width && 0<mouseY && mouseY<height){
      moveButton();//lets user move buttons
    }
  }
  
  if(mouseButton ==LEFT){
    
      for (int i = 0; i< mySliders.size(); i++){
        mySliders.get(i).inSlider();
      if( mySliders.get(i).getInSlider()){
          mySliders.get(i).interract(true);
          mySliders.get(i).setIntensity();
        }
        double intensity = mySliders.get(i).getIntensity();
        music.changeVolume(intensity);
        //print(intensity);
      }
  }
  
}//mouseDragged() responsible for resizing and moving buttons

void keyPressed(){
  
   if(key == DELETE){
     deleteButton();
   }
   if(key == 'h' || key=='H'){
     control.setMode("Hide");
   }
   if(key =='s' || key=='S'){
     control.setMode("Show");
   }
}

void mouseReleased(){
  //print("("+mouseX+", "+ mouseY+")");
  if(mouseButton == RIGHT){
     for (int i = 0; i< myButtons.size(); i++){
      if( myButtons.get(i).getIsMoving()){
        myButtons.get(i).stopMoving();
        myButtons.get(i).setButtonSelected(false);
      }//if a button is being moved and the mouse is released setIsMoving to false
     }
     for (int i = 0; i< mySliders.size(); i++){
       if(mySliders.get(i).getInSlider()){
         mySliders.get(i).stopMoving();
       }
     }
  }
}


void deleteButton(){
  
  for (int i =0 ; i< myButtons.size(); i++){
    if( myButtons.get(i).inButton()){
      myButtons.remove(i);
      i--;
    } 
  }
  
  for (int i = 0; i<mySliders.size();i++){
    mySliders.get(i).inSlider();
    if( mySliders.get(i).getInSlider()){
      mySliders.remove(i);
      i--;
    } 
  }
  
}//use the deleteButton to delete the button by hovering over the button and pressing delete

void moveButton(){
  //if you can move the button
  for (int i = 0; i< myButtons.size(); i++){
    if( myButtons.get(i).getButtonSelected()&&(myButtons.get(i).inButton() || myButtons.get(i).getIsMoving())){//basically if you have just clicked the button or if the button is already moving you can continue moving the button
        myButtons.get(i).moveButton(x_clicked, y_clicked);
        break;
      
    }
  }
    for (int i = 0; i< mySliders.size(); i++){
      
    if( mySliders.get(i).getInSlider()){//basically if you have just clicked the button or if the button is already moving you can continue moving the button
        mySliders.get(i).move();
        break;
      
    }
  } 
}//moveButton()

void buttonTouched(int button_touched){
      
  switch(button_touched){
     case 0: music.back();
             break;
     case 1: music.forward();
             break;
     case 2: if(!music.isPlaying())music.play();
             else music.pause();
             break;
   }
   
}//buttonTouched() if a real button is touched
