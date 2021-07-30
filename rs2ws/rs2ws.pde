// realsense 2 websocket
// sends depth data from realsense to websockets
// written 2021 by Florian Bruggisser

import ch.bildspur.realsense.*;
import ch.bildspur.realsense.type.*;

import websockets.*;
import oscP5.*;

final int PORT = 8025;

final int WIDTH = 640;
final int HEIGHT = 480;
final int DECIMATION = 2;

WebsocketServer ws;
RealSenseCamera camera = new RealSenseCamera(this);

byte[] depthBuffer = null;

void setup() {
  size(640, 480);

  try {
    // setup websocket
    ws = new WebsocketServer(this, PORT, "/");

    // setup buffer
    depthBuffer = new byte[WIDTH / DECIMATION * HEIGHT / DECIMATION];

    // setup camera
    println("starting up camera...");
    camera.enableDepthStream(WIDTH, HEIGHT);
    camera.enableColorizer(ColorScheme.WhiteToBlack);
    camera.addDecimationFilter(DECIMATION);
    
    // filters
    // camera.addTemporalFilter();
    // camera.addHoleFillingFilter();
    
    // set distance filter (in meters)
    // camera.addThresholdFilter(2.0, 3.0);

    camera.start();
  } 
  catch (Exception ex) {
    fill(255);
    textSize(20);

    text("Error starting up: " + ex.getMessage(), 30, 30);
  }

  println("Sending data on: ws://localhost:" + PORT + "/");
}

void draw() {
  background(55);

  // read camera image
  camera.readFrames();
  PImage depth = camera.getDepthImage();
  image(depth, 0, 0, width, height);

  // send image over websocket
  sendPImage(depth);

  // display information
  fill(55, 100);
  noStroke();
  rect(0, 0, width, 100);

  fill(255);
  textSize(20);

  text("Image Size: " + depth.width + " x " + depth.height, 30, 30);
  text("Serving: ws://localhost:" + PORT + "/", 30, 60);

  surface.setTitle("Realsense 2 WebSocket - " + round(frameRate) + " FPS");
}

void sendPImage(PImage image) {
  OscMessage msg = new OscMessage("/depth");
  msg.add(image.width);
  msg.add(image.height);

  // fill depth buffer
  int[] pixels = image.pixels;
  for (int i = 0; i < pixels.length; i++) {
    depthBuffer[i] = (byte)(pixels[i] & 0xFF);
  }

  msg.add(depthBuffer);

  try {
    ws.sendMessage(msg.getBytes());
  } 
  catch(Exception ex) {
    println("ERROR: " + ex.getMessage());
  }
}
