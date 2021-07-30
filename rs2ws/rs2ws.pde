// realsense 2 websocket
// sends depth data from realsense to websockets
// written 2021 by Florian Bruggisser

import ch.bildspur.realsense.*;
import ch.bildspur.realsense.type.*;

RealSenseCamera camera = new RealSenseCamera(this);

void setup() {
  size(640, 480);
  
  // setup camera
  println("starting up camera...");
  camera.enableDepthStream(640, 480);
  camera.enableColorizer(ColorScheme.WhiteToBlack);
  camera.addDecimationFilter(4);
  
  camera.start();
}

void draw() {
  background(55);
  
  // read camera image
  camera.readFrames();
  PImage depth = camera.getDepthImage();
  image(depth, 0, 0, width, height);
  
  // send image over websocket
  
  // display information
  fill(55, 100);
  noStroke();
  rect(0, 0, width, 100);
  
  fill(255);
  textSize(20);
  
  text("Image Size: " + depth.width + " x " + depth.height, 30, 30);
  
  surface.setTitle("Realsense 2 WebSocket - " + round(frameRate) + " FPS");
}
