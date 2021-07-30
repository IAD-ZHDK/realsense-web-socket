# Intel RealSense to WebSocket
Send RealSense data over web socket to p5js.

### Installation

Make sure to install the following Processing packages from the contribution manager:

* oscP5
* Intel RealSense for Processing

Attach the RealSense to the computer and start the sketch.

### P5js

To receive the data in a the P5js demo, open the [demo-receiver/index.html](demo-receiver/index.html) on a local webserver:

```
python3 -m http.server
```

The window shoudl show the image sent from the realsense camera.

### Image Size
To adjust the image size which is sent over the network, use the `DECIMATION` parameter which specifies, by which factor the image will be decimated.

### Filter
To add more filter to smooth the image or set a distance threshold, use the following filter examples:

```java
// filters
camera.addTemporalFilter();
camera.addHoleFillingFilter();

// set distance filter (in meters)
camera.addThresholdFilter(2.0, 3.0);
```

### About

*Implemented by Florian Bruggisser 2021*
