/////////////////////////add interface elements here
//   Joystick(float _xPos, float _yPos, float _size, float _xRange, float _yRange, color _background, color _stick, String _xa, String _ya, int _upKey, int _leftKey, int _downKey, int _rightKey, int _xTilt, int _yTilt) {
Joystick movement;
//  Slider(float _xPos, float _yPos, float _size, float _width, float _low, float _high, color _background, color _stick, String _ga, int _pKey, int _mKey, float _inc, int _tilt, boolean _horizontal, boolean _reverse) {
Slider turning;
//  Button(float _xPos, float _yPos, float _size, color _background, color _forground, String _gpButton, int _keyboard, boolean _momentary, boolean _val, String _label) {
Button turbo;
//////////////////////
float batVolt=0.0;
boolean enabled=false;
////////////////////////add variables here
PVector moveVal=new PVector(0, 0);
float turnVal=0.0;

float velx=0;
float vely=0;
float velt=0;

boolean turboMode=false;
float boostScalar=0;

void setup() {
  size(1400, 800);
  rcmdsSetup();
  //setup UI here
  setupGamepad("Controller (XBOX 360 For Windows)");
  movement=new Joystick(1100, 400, 200, -1, 1, color(100), color(200), "X Rotation", "Y Rotation", 'i', 'j', 'k', 'l', 0, 0);
  turning=new Slider(200, 400, 200, 50, -1, 1, color(100), color(200), "X Axis", 'd', 'a', 1, 0, true, true);
  turbo=new Button(1100, 700, 70, color(120), color(195, 195, 0), null, 0, false, false, "boost");
}
void draw() {
  background(0);
  runWifiSettingsChanger();

  if (gamepadButton("Button 7", false)) {
    enabled=true;
  }
  if (gamepadButton("Button 6", false)) {
    enabled=false;
  }
  enabled=enableSwitch.run(enabled);
  /////////////////////////////////////add UI here
  moveVal=movement.run(new PVector(0, 0));
  turnVal=turning.run(0);
  turboMode=gamepadVal("Z Axis", turboMode?-1:0)<-0.5?true:false;
  turbo.val=turboMode;
  turboMode=turbo.run();

  boostScalar=turboMode?1:.4;

  String[] msg={"battery voltage", "ping", "forwards", "left", "clockwise", "v f", "v l", "v t"};
  String[] data={str(batVolt), str(wifiPing), str(moveVal.y*boostScalar), str(moveVal.x*boostScalar), str(turnVal*boostScalar), str(velx), str(vely), str(velt)};
  dispTelem(msg, data, width/2, height*2/3, width/4, height*2/3, 12);

  sendWifiData(true);
  endOfDraw();
}
void WifiDataToRecv() {
  batVolt=recvFl();
  ////////////////////////////////////add data to read here
  velx=recvFl();
  vely=recvFl();
  velt=recvFl();
}
void WifiDataToSend() {
  sendBl(enabled);
  ///////////////////////////////////add data to send here
  sendBy((byte)1);// mode
  sendFl(moveVal.y*boostScalar); // forwards
  sendFl(moveVal.x*boostScalar); // left
  sendFl(turnVal*boostScalar*.6);
}
