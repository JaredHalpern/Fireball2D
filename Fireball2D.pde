import SimpleOpenNI.*;
SimpleOpenNI kinect;

int closestValue;
int closestX;
int closestY;
float lastX;
float lastY;

// declare x-y coordinates for the image
float image1X;
float image1Y;
 
int kinectWidth;
int kinectHeight;
 
// declare a boolean to store whether or not the image is moving
boolean imageMoving;

// declare a variable 
// to store the image 
PImage image1; //1
PImage fireballSprite;

ParticleSystem ps;

void setup()
{
  kinectWidth = 640;
  kinectHeight = 480;
  
  size(kinectWidth, kinectHeight, P2D);
//size(displayWidth, displayHeight, P2D);

if (frame != null) {
    frame.setResizable(true);
  }
  
  fireballSprite = loadImage("sprite.png");
  ps = new ParticleSystem(5000);
  
  // Writing to the depth buffer is disabled to avoid rendering
  // artifacts due to the fact that the particles are semi-transparent
  // but not z-sorted.
  hint(DISABLE_DEPTH_MASK);  
  
  kinect = new SimpleOpenNI(this);
  kinect.setMirror(true);
  kinect.enableDepth();
  kinect.enableRGB();
  
  // start the image out moving
  // so mouse press will drop it
  imageMoving = true;
  
  background(0);
}
void draw() {
  
  background(0);  
  closestValue = 8000;
  kinect.update();
  int[] depthValues = kinect.depthMap();
  
  for(int y = 0; y < kinectHeight; y++){
    for(int x = 0; x < kinectWidth; x++){
      
//      int reversedX = kinectWidth-x-1;
//      int i = reversedX + y * kinectWidth;
      int i = x + y * kinectWidth;
      int currentDepthValue = depthValues[i];
      
      if(currentDepthValue > 610
      && currentDepthValue < 1525
      && currentDepthValue < closestValue)// 2
      {
        
      closestValue = currentDepthValue;
      closestX = x;
      closestY = y;     
      }
    }
  }
  
float interpolatedX = lerp(lastX, closestX, 0.2);
float interpolatedY = lerp(lastY, closestY, 0.2);

if(imageMoving){
  image1X = interpolatedX;
  image1Y = interpolatedY;
}

  // draw irImageMap
//  image(kinect.rgbImage(), 0, 0, 1200, 960);
  image(kinect.rgbImage(), 0, 0);
  println("w:" + displayWidth + ", h:" + displayHeight);
  ps.update();
  ps.display();
  ps.setEmitter(image1X, image1Y);
  fill(255);
  textSize(16);
  text("Frame rate: " + int(frameRate), 10, 20);
  

//  image(image1, image1X, image1Y);
  lastX = interpolatedX;
  lastY = interpolatedY;    
}


