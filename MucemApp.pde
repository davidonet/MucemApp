import apwidgets.*;
import android.text.InputType;
import android.view.inputmethod.EditorInfo;
import android.media.MediaRecorder;
import android.media.MediaPlayer;
import android.os.Environment;
import android.content.Context;
import java.io.File;
import java.io.IOException;

Magnetophone aMagnetophone;
PFont tFont;
ImageMap tMap;
File[] pictures;
APWidgetContainer container1, container2, container3, container4;
APEditText textName, textSurname, textEmail;
APButton btnValidate, btnHome, btnValEmail, btnDelEmail, btnStop ;
PImage tBG, tP1, tP2, tP3, tFace, tFace1; 
int tNbP=1;
String tID;
int tFrame = 0;

File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } 
  else {
    // If it's not a directory
    return null;
  }
}

void slideshow() {
  if (90<tFrame) {
    int anAlpha = 512-(64*tFrame)/15;
    tint(255, 255, 255, anAlpha );
  }
  else
    if (tFrame < 30) {
      int anAlpha =(64*tFrame)/15;
      tint(255, 255, 255, anAlpha );
    }
    else
      tint(255, 255, 255, 128);

  image(tFace1, 320-(tFace1.width/2), 400-(tFace1.height/2));
  tFrame = (tFrame+1)%120;
  if (tFrame == 0)
  {
    tFace1 = loadImage(pictures[(int)random(pictures.length)].getAbsolutePath());
  }
  tint(255, 255, 255, 255);
}

void setup() {
  // Restore with : 
  //$ am startservice -n com.android.systemui/.SystemUIService
  try {
    Process  proc = Runtime.getRuntime().exec(new String[] {
      "su", "-c", "service call activity 79 s16 com.android.systemui"
    }
    );

    try
    {
      proc.waitFor();
    }
    catch (java.lang.InterruptedException e)
    {
    }
  }
  catch(java.io.IOException e)
  {
  }

  size(1280, 800, P2D);

  pictures = listFiles("/sdcard/Pictures");
  /*
  for (int i = 0; i < pictures.length; i++) {
   File f = pictures[i];    
   println("Name: " + f.getName());
   PImage img = loadImage(f.getAbsolutePath());
   println("Size: " + img.width + "x"+img.height);
   println("-----------------------");
   }
   */

  aMagnetophone = new Magnetophone();
  String[] fontList = PFont.list();
  tFont = createFont(fontList[1], 150, true);

  tBG=loadImage("bg.png");
  tP1=loadImage("ecran1.png");
  tP2=loadImage("ecran2.png");
  tP3=loadImage("ecran3.png");
  tFace=loadImage("portrait.jpg");
  tFace1 = loadImage(pictures[(int)random(pictures.length)].getAbsolutePath());

  container1 = new APWidgetContainer( this );
  textName = new APEditText( 860, 300, 360, 40 ); 
  container1.addWidget( textName );
  textName.setInputType(InputType.TYPE_TEXT_VARIATION_PERSON_NAME);
  textName.setImeOptions(EditorInfo.IME_ACTION_NEXT);

  textSurname = new APEditText( 860, 340, 360, 40);
  container1.addWidget( textSurname );
  textSurname.setInputType(InputType.TYPE_TEXT_VARIATION_PERSON_NAME);
  textSurname.setImeOptions(EditorInfo.IME_ACTION_NEXT);

  textEmail = new APEditText( 860, 380, 360, 40 );
  container1.addWidget( textEmail );
  textEmail.setInputType(InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);
  textEmail.setImeOptions(EditorInfo.IME_ACTION_DONE);
  textEmail.setCloseImeOnDone(true);

  container2 = new APWidgetContainer( this );
  btnStop = new APButton(730, 600, 210, 50, "Stop");
  btnValidate = new APButton(980, 600, 210, 50, "Confirmer");
  container2.addWidget(btnStop);
  container2.addWidget(btnValidate);
  container2.hide();

  container3 = new APWidgetContainer( this );
  btnHome = new APButton(860, 600, 210, 50, "Page d'accueil");
  container3.addWidget(btnHome);
  container3.hide();

  container4 = new APWidgetContainer( this );
  btnDelEmail = new APButton(720, 460, 210, 50, "Corriger");
  btnValEmail = new APButton(1000, 460, 210, 50, "Confirmer");
  container4.addWidget(btnDelEmail );
  container4.addWidget(btnValEmail);
  container4.hide();

  tMap = new ImageMap();
  tMap.addATouchZone(730, 485, 870, 550, new startRecord(aMagnetophone));
  tMap.addATouchZone(870, 485, 960, 550, new startPlay(aMagnetophone));
  tMap.addATouchZone(1050, 485, 1180, 550, new startDelete(aMagnetophone));

  smooth();
  frameRate(30);
}

void draw() {
  background(0);

  image(tBG, 0, 0);
  image(tFace, 80, 80);
  switch (tNbP) {
  case 1:
    image(tP1, 640, 0);
    break;
  case 4:
    image(tP1, 640, 0);
    textFont(tFont, 20);
    fill(0, 0, 128);
    text(textName.getText(), 860, 324);
    text(textSurname.getText(), 860, 364);
    text(textEmail.getText(), 860, 404);
    break;
  case 2:
    image(tP2, 640, 0);
    drawMagnetophone();
    break;
  case 3:
    image(tP3, 640, 0);
    break;
  }
  slideshow();
}

void drawMagnetophone()
{
  if (aMagnetophone.tMode == "Record")
    fill(100, 0, 0);
  else
    fill(0);
  textFont(tFont, 150);
  text(aMagnetophone.getTimer(), 870, 416);
  noStroke();
  fill(255, 0, 0); 
  ellipse(802, 516, 32, 32);
  if (aMagnetophone.tMode == "Empty")
    fill(64, 64, 80);
  else
    fill(0, 0, 255);  
  triangle(955, 503, 973, 516, 955, 529);
}

void mouseReleased()
{
  tMap.testIn(mouseX, mouseY);
}

void onClickWidget(APWidget widget) {  
  if (widget == textEmail) {
    tID = year()+nf(month(), 2)+nf(day(), 2)+"_"+textEmail.getText()+"_"+textName.getText()+"-"+textSurname.getText();
    aMagnetophone.setFileName(tID);
    container1.hide();
    container4.show();
    tNbP = 4;
  }
  if (widget == btnValEmail) {
    container4.hide();
    tNbP = 2;
    container2.show();
    textName.setText("");
    textSurname.setText("");
    textEmail.setText("");
    btnValidate.getView().setEnabled(false);
  }
  if (widget == btnDelEmail) {
    container4.hide();
    tNbP = 1;
    container1.show();
  }
  if (widget == btnStop) {
    if ( aMagnetophone.tMode == "Record") {
      aMagnetophone.record();
      btnValidate.getView().setEnabled(true);
    }
    if ( aMagnetophone.tMode == "Play")
      aMagnetophone.play();
  }  
  if (widget == btnValidate) {
    aMagnetophone.stop();
    container2.hide();
    tNbP = 3;
    container3.show();
  }
  if (widget == btnHome) {
    container3.hide();
    tNbP = 1;
    container1.show();
  }
}

