// realsense 2 websocket
// sends depth data from realsense to websockets
// written 2021 by Florian Bruggisser

import ch.bildspur.realsense.*;
import ch.bildspur.realsense.type.*;

import websockets.*;
import oscP5.*;

final int PORT = 8025;

WebsocketServer ws;
RealSenseCamera camera = new RealSenseCamera(this);

void setup() {
  size(640, 480);

  // setup websocket
  ws = new WebsocketServer(this, PORT, "/");

  // setup camera
  println("starting up camera...");
  camera.enableDepthStream(640, 480);
  camera.enableColorizer(ColorScheme.WhiteToBlack);
  camera.addDecimationFilter(4);

  camera.start();
  
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

  // todo: add body binary blob

  ws.sendMessage(msg.getBytes());
}
