# Music Card — PCB + GUI

A small project that connects a printed capacitive touch music card to an ESP32 (or similar) and a Processing-based GUI. Touch inputs from the card are sent over Serial to Processing to control a digital music player (previous / play/pause / next) and a touch slider controls volume.

This repository contains the Arduino sketches that read touch sensors and the Processing sketches that render the GUI and play audio.

## Repository contents
- `lab1-4.ino` — Arduino sketch: reads 3 touch buttons and 5 slider segments; computes a continuous slider value and prints serial messages (IDs `0`,`1`,`2` for buttons and `3` for slider volume).
- `lab3.pde` — Minimal Processing sketch: draws three buttons and highlights them from serial messages (good as a starter/test sketch).
- `music_card_nosolution.pde` — Full Processing UI: loads card artwork, movable buttons, slider, and an `Audio` helper class; integrates serial control for buttons and volume.
- `touch1_millis.ino` — Debug sketch: prints raw touchRead values for three touch pins (useful for calibration / Serial Plotter).
- `touch2.ino` — Example sketch: sends periodic baseline messages plus `0,1;`, `1,1;`, `2,1;` when touches are detected.
- Images/PDFs/videos — PCB artwork, photos, and demo videos (e.g. `front.jpg`, `back.jpg`, `ckt_design.pdf`, `lab1-4.mp4`).

## Serial protocol
Messages are ASCII, semicolon-terminated, and comma-separated: `id,value;`

- id 0: previous / back (example `0,1;`)
- id 1: play / pause (example `1,1;`)
- id 2: next / forward (example `2,1;`)
- id 3: slider / volume (value is a float between 0.0 and 1.0; example `3,0.68;`)

Processing sketches expect messages terminated with `;` and will trim and sanitize incoming strings (ignore boot messages from the ESP).

## Quick start (Windows)
1. Connect the ESP32/board to your PC via USB.
2. In Arduino IDE:
   - Select the correct board and COM port.
   - Open and upload `lab1-4.ino` (or `touch1_millis.ino` for calibration, `touch2.ino` for a simple demo).
3. Install Processing (https://processing.org/) and the Processing Sound library (Sketch → Import Library → Add Library → search "sound").
4. Open `music_card_nosolution.pde` (or `lab3.pde`) in Processing. Update the serial port variable if needed (search `portName = "COM10"` and change to your COM port or use `Serial.list()` to auto-detect).
5. Run the Processing sketch. Touching the physical card should trigger the on-screen controls and playback behavior.

## Wiring and hardware notes
- The Arduino sketches use `touchRead()` (ESP32 API). If you are using a different microcontroller, adapt the touch-sensing code accordingly.
- Pin mapping in the sketches uses digital-style numbers (e.g., touch pins 5,6,7 and slider pins 9–13 in `lab1-4.ino`); match these to your ESP32 module's TOUCH-capable pins.
- For slider segments, use one sender and multiple receiver TOUCH pins as recommended in the lab instructions.

## Lab instructions (condensed)
These are the core tasks required by the course labs (Lab 1-3 and Lab 1-4):

- Lab 1-3 — Send touch data to Processing and implement the digital music card UI. Deliverables: Processing sketches that display the three touch buttons and the music card application, plus a short demo video.
- Lab 1-4 — Implement the touch slider: read 5 segments, calibrate min/max per segment, compute an interpolated slider value (0–1), send it as `3,<value>;`, and connect it to the music player's volume control. Deliverables: Arduino code, Processing code with slider, photo of wiring, and a short demo video.

Detailed steps are available in the sketches' comments (`lab1-4.ino`, `music_card_nosolution.pde`) and the folder contains calibration/demo files (`touch1_millis.ino`, demo videos) to help complete the labs.

## Troubleshooting
- Serial port busy: close the Arduino Serial Monitor before running Processing — only one application can open the COM port at a time.
- If Processing doesn't detect mouse drag on Windows (Processing 4), use a mousePressed state workaround.
- If `card.png` is missing, copy or rename `front.jpg` or `lab1-4.jpg` to `card.png` in the Processing sketch folder.

## Next actions (optional)
- Copy an existing image to `card.png` so Processing loads artwork automatically.
- Add a small `examples/` folder with simplified sketches that auto-detect serial ports.
- Add a short wiring diagram (can be generated from `ckt_design.pdf`) and embed it in this README.

If you want any of these applied, tell me which one and I'll make the change.
# Music Card PCB GUI Full

This repository contains an Arduino / Processing project for a touch-controlled "music card" interface (touch buttons and sliders) that communicates over Serial (baud 9600). The project includes Arduino sketches that read capacitive touch inputs (using touchRead(), likely on an ESP32) and Processing sketches that provide a graphical UI and audio controls.


## Quick summary
- Hardware: ESP/Arduino-compatible board with capacitive touch pins (touchRead), wired to the touch pads on the PCB. Serial connection to a host computer is used for UI control and debugging.
- Serial: 9600 baud, messages terminated with `;` and use a comma-separated format like `id,value;` or simple `id,1;` for button presses.
- Processing UI: Uses `Serial` from Processing to open `COM10` (changeable in code) and listens for messages from the Arduino; plays/pauses music and controls volume.

## Serial protocol (derived from code)
- Messages end with `;` and are like `n,m;` where:
  - `n` is a control id:
    - `0` = back / previous
    - `1` = play/pause
    - `2` = forward / next
    - `3` = volume (value is a float between 0 and 1 or similar)
  - Examples:
    - `0,1;` — button 0 pressed (previous)
    - `1,1;` — button 1 pressed (play/pause)
    - `3,0.5;` — set volume to 0.5

The Processing sketches also handle some variants (they trim, remove parentheses, etc.) and ignore ESP boot messages.

## Files in this folder
Below are the main files found in the project root with a short description extracted from the code:

- `lab1-4.ino` — Arduino sketch that reads three touch buttons and five touch slider inputs (pins used: 5,6,7 for three buttons; 9-13 for five sliders). It computes a `discreteV` value (0..1) derived from sliders and prints serial messages like `3,<value>;` for the volume and `0,1;` / `1,1;` / `2,1;` for button presses.
- `lab3.pde` — Processing sketch (UI) that listens on `COM10` at 9600 baud and draws three ellipses to represent three buttons; highlights an ellipse when a corresponding serial message arrives.
- `music_card_nosolution.pde` — Larger Processing sketch that provides a more complete UI: loads `card.png` (looks for it in the sketch folder), provides movable buttons and a slider, and controls audio playback via an `Audio` helper class. It reads serial commands (same `n,m;` format) and maps `0,1` to previous, `1,1` to play/pause, `2,1` forward, and `3,<float>` to change volume.
- `touch1_millis.ino` — Simple Arduino sketch that reads the three touch pins and prints raw values `val1,val2,val3` at a 10 ms period. Useful for calibration and debugging.
- `touch2.ino` — Arduino sketch that prints periodic `0,0; 1,0; 2,0;` lines and sends `0,1; 1,1; 2,1;` when touches are detected (sends at 400 ms intervals). Useful for the Processing UI to detect touches. Also prints `3,<discreteV>;` when slider-based volume is active (in `lab1-4.ino` style sketch).

## Assets (images, PDFs, other)
The folder contains several images and PDFs that appear to be PCB files, photos, and reference schematics:

- `arduino_connection_pic.jpg` — image showing Arduino connections (check for wiring guidance)
- `ckt_design.pdf`, `ckt_design_reflected.pdf` — PCB / circuit design PDFs
- `ckt_without_lam.jpg`, `combined.pdf`, `front.jpg`, `back.jpg`, `lab1-4.jpg` — PCB artwork or photos
- `lab1-2.mp4`, `lab1-4.mp4`, `lab3_compressed.mp4` — demonstration videos
- `layer1.pdf` — PCB layer artwork

Include these assets alongside the Processing sketch if you want the GUI to display the card artwork (`music_card_nosolution.pde` expects an image called `card.png` — ensure that image exists or rename one of the provided `front.jpg`/`back.jpg` as needed).

## How to run (Windows)
1. Open and upload the appropriate Arduino sketch to your ESP32/Arduino:
   - If you want raw touch debugging, open `touch1_millis.ino` and upload.
   - For full behavior with sliders and computed volume, open `lab1-4.ino` and upload.
   - For button-only behavior timed at 400 ms, open `touch2.ino`.
   - Make sure you have selected the correct board (likely ESP32) and COM port in the Arduino IDE.

2. On the PC, open Processing and load one of the sketches:
   - `lab3.pde` — simple 3-ellipse UI
   - `music_card_nosolution.pde` — main GUI (expects `card.png` in the sketch folder and an `Audio` helper class / audio library)

3. Update the serial port name in the Processing sketch (search for `portName = "COM10"`) to the COM port used by your board.

4. Run the Processing sketch. When the Arduino sends messages like `1,1;` the GUI will act (play/pause, previous, next, volume).

## Dependencies / Notes
- Arduino: the sketches use `touchRead()` which is available on ESP32 boards. If you are using a different board, `touchRead()` may not exist or have different pin mappings.
- Processing: the sketches use the Processing Serial library. `music_card_nosolution.pde` references an `Audio` class; make sure that class (and supporting libraries) is present in the sketch folder or Processing libraries path.
- Serial port: default in code is `COM10` and baud `9600` — change to match your machine.

## Wiring hints (derived from project assets)
- Touch pins in code use pins 5, 6, and 7 for touch buttons and pins 9-13 for touch sliders. These pin numbers match the `touchRead()` calls in the Arduino code (but the actual board layout may differ depending on your ESP32 module and PCB).
- Check `arduino_connection_pic.jpg` for how the board was wired to USB/serial and any level-shifters or connectors.



## Next steps I can help with
- Add a `card.png` asset or adapt the Processing sketch to use one of the included images.
- Create a wiring diagram or simplified schematic in README using the provided `ckt_design.pdf`.
- Add a short troubleshooting section (common issues: wrong COM port, wrong board, touchRead thresholds, missing Processing Audio class).

---
If you'd like, I can embed selected images from the folder into this README or adjust the Processing port settings automatically. Which would you like me to do next?
## Lab instructions included from your pasted document

Below are the course lab instructions you provided (Lab 1-3 and Lab 1-4). I copied and condensed them here so the repository README serves as the single place for the assignment steps, deliverables, and notes. Where possible I reference the existing files in this folder.

---

## Lab 1-3: Sending Touch Data to Processing (due 09/25)

Goal: Connect the physical printed music card to Processing so that touching a physical pad lights the corresponding digital touch button in Processing and plays the associated song.

Before you start
- Verify last-lab functionality: connect the printed music card to the ESP32, upload your Arduino sketch, and check Serial Monitor for touch output. If you see touch values on Serial, continue.

Steps (condensed and mapped to files in this repo)
1. Install Processing (https://processing.org/) and the Processing Sound library (Sketch -> Import Library -> Add Library -> search "sound").
2. Create a new Processing sketch and add `setup()` and `draw()` functions.
3. Open a Serial connection in Processing:
  - import processing.serial.*;
  - create `Serial myPort;` and open it with `myPort = new Serial(this, portName, baudrate);`.
  - You can inspect available ports with `Serial.list()` and set `String portName = Serial.list()[i];`.
4. Read Serial in `draw()` and use `myPort.readStringUntil(';')` to get messages formatted like `0,1;`.
  - The starter code in `lab3.pde` shows a minimal implementation that reads `;`-terminated messages and maps them to three ellipses.
5. Parse the incoming string using `split(val, ',')` and convert to ints/floats. Use `trim()` and ignore ESP boot messages.
6. Draw a digital touch button (ellipse) sized 100x100 px and color it gray (not touched) or red (touched). Use `background()` each frame to redraw cleanly.
7. Extend to 3 buttons (left, center, right). `lab3.pde` in this folder already implements a simple 3-ellipse UI that highlights based on serial messages.
8. Install the Processing Sound library and run `music_card_nosolution.pde` to see the digital music card UI and audio helper (`Audio` class). This is the skeleton for the full music card.
9. Implement on-screen button behavior using the provided `Button` class and the `myButtons.add(new Button(...))` calls already present in `music_card_nosolution.pde` (the file already creates 3 buttons at appropriate coordinates).
10. Integrate serial input into the music card application: instead of only changing ellipse color, call `music.back()`, `music.play()/pause()`, or `music.forward()` when receiving `0,1;`, `1,1;`, `2,1;`. The `music_card_nosolution.pde` already contains the code for this mapping in its serial read section.

Serial protocol used by the lab code
- Message format: `sensorID,value;` (semicolon-terminated). Example messages:
  - `0,1;` — touch sensor 0 pressed (previous)
  - `1,1;` — touch sensor 1 pressed (play/pause)
  - `2,1;` — touch sensor 2 pressed (next)
  - `3,0.5;` — slider/volume ID 3 set to 0.5 (used in Lab 1-4)

Deliverables (Lab 1-3)
- Processing code (.pde) for serial communication that displays the three touch buttons (e.g., `lab3.pde`).
- Processing code (.pde) of the music card application (e.g., `music_card_nosolution.pde`).
- A short video (MP4/MOV, ≤1 min, ≤20 MB) showing the printed music card used to play/pause and go previous/next.

Notes / hints from the lab text
- If you get a "port busy" error, close the Arduino Serial Monitor—only one program can open a serial port at a time.
- Use `myPort.available()` to check characters available; the lab suggests checking for at least 4 characters (e.g., `0,1;`) before calling `readStringUntil(';')`.
- Processing code should ignore ESP boot messages (they contain "ESP-ROM").

---

## Lab 1-4: Sensing Input from a Touch Slider (due before next lab section)

Goal: Build the slider circuit and code to compute an overall slider value (0.0-1.0) from 5 touch segments and send that value over Serial as `3,<value>;`. Use that value in Processing to control music volume.

Deliverables (Lab 1-4)
- Photo of slider circuit connected to the printed slider and ESP microcontroller.
- Arduino code (.ino) that serializes the slider value.
- Processing code (.pde) of the music card application with the slider integrated (e.g., updated `music_card_nosolution.pde`).
- A short video (MP4/MOV, ≤1 min, ≤20 MB) showing the printed slider adjusting volume.

Steps (condensed and mapped to the repo)
1. Build the slider hardware: the slider is multiple touch pads placed next to each other. Wire them with one sender pin and multiple receiver pins (TOUCHx pins recommended on the ESP32). DO NOT use the pin labelled pin0 (TOUCH1) as a receiver.
2. Extend microcontroller code to read all 5 slider segments and print raw values to Serial for calibration. Example format for plotting: `slider1,slider2,slider3,slider4,slider5` on a line.
  - Use `touchRead(pin)` for each segment (see `lab1-4.ino` in repo for an implementation that reads 5 sliders and uses thresholds).
3. Measure min (noise threshold) and max (fully touched) for each slider segment using the Serial Plotter. Record these values in your Arduino code.
4. Determine which segments are touched by comparing to per-segment min thresholds.
5. Compute slider position:
  - Single segment touched: map segment index to discrete positions (0.0, 0.25, 0.5, 0.75, 1.0).
  - Two segments touched: compute normalized fractions for both segments (value / max), compute relative position ((1-frac_left)+frac_right)/2, scale by 0.25 (distance between discrete steps), and add to the left segment base value. The `lab1-4.ino` implementation uses this approach and prints `3,<value>;`.
6. Write overall slider value to Serial with sensor ID 3 (e.g., `3,0.68;`) continuously while the slider is being touched.
7. Add a digital slider to the Processing UI (`mySliders.add(new Slider(...))` in `music_card_nosolution.pde`) and map `Slider.getIntensity()` to `music.changeVolume(double intensity);` so dragging the digital slider controls volume.
8. Extend the serial read code in `music_card_nosolution.pde` to parse `3,<float>;` messages and call `music.changeVolume(n1);` (the code already has a clause for `n0 == 3`).

Notes and mapping to files in this repository
- `lab1-4.ino` — contains an implementation of reading 3 touch buttons and 5 slider segments, uses per-slider min/max threshold values, and computes `discreteV`. It prints `3,<value>;` for volume and `0,1;`/`1,1;`/`2,1;` for the three buttons.
- `touch1_millis.ino` — prints raw touch readings for 3 buttons continuously (useful for calibration in Serial Plotter).
- `touch2.ino` — example that prints periodic baseline lines and `0,1;` / `1,1;` / `2,1;` when touches are detected.
- `music_card_nosolution.pde` — main Processing UI; it already contains serial parsing for `n0` and `n1` values and maps `n0==3` to `music.changeVolume(n1);`.


