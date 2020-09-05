Button[] buttons;

void setupButtons() {
  buttons = new Button[] {
    new Button(
      new PVector(100, height-200), new PVector(100, 100), color(255), color(200), color(100),
      new ButtonEvent() {
        public void mousePressed() { left(); }
        public void mouseHover() {}
      }
    ),
    
    new Button(
      new PVector(width-200, height-200), new PVector(100, 100), color(255), color(200), color(100),
      new ButtonEvent() {
        public void mousePressed() { right(); }
        public void mouseHover() {}
      }
    ),
    
    new Button(
      new PVector(width/2, height-400), new PVector(100, 100), color(255), color(200), color(100),
      new ButtonEvent() {
        public void mousePressed() { forward(); }
        public void mouseHover() {}
      }
    ),
    
    new Button(
      new PVector(width/2, height-200), new PVector(100, 100), color(255), color(200), color(100),
      new ButtonEvent() {
        public void mousePressed() { backward(); }
        public void mouseHover() {}
      }
    )
  };
}

void drawButtons() {
  for (Button button: buttons) {
    button.update();
  }
  
  for (Button button: buttons) {
    button.draw();
  }
}

class Button {
  PVector position;
  PVector size;

  ButtonState buttonState;

  color col;
  color normal, hover, pressed;

  ButtonEvent[] buttonEvents;
  
  Button(PVector position, PVector size, color normal, color hover, color pressed, ButtonEvent... buttonEvents) {
    this.position = position;
    this.size = size;
    this.normal = normal;
    this.hover = hover;
    this.pressed = pressed;
    
    this.buttonEvents = buttonEvents;
  }

  void update() {
    boolean hasPressed = false;
    
    //for (TouchEvent.Pointer touch: touches) {
    //  if (
    //    touch.x >= position.x && touch.x <= position.x + size.x &&
    //    touch.y >= position.y && touch.y <= position.y + size.y
    //  ) {
    //    hasPressed = true;
    //  }
    //}
    
    if (hasPressed)
      buttonState = ButtonState.PRESSED;
    else
      buttonState = ButtonState.NORMAL;

    switch(buttonState) {
      case NORMAL:
        col = normal;
        break;
      case HOVER:
      //  col = hover;
        
      //  for (ButtonEvent buttonEvent: buttonEvents) {
      //    buttonEvent.mouseHover();
      //  }
        break;
      case PRESSED:
        col = pressed;
        
        for (ButtonEvent buttonEvent: buttonEvents) {
          buttonEvent.mousePressed();
        }
        break;
    }
  }

  void draw() {
    fill(col);
    stroke(0);
    rectMode(CORNER);
    rect(position.x, position.y, size.x, size.y, 5);
  }
}

interface ButtonEvent {
  void mousePressed();
  void mouseHover();
}

enum ButtonState {
  NORMAL, 
  HOVER, 
  PRESSED
}
