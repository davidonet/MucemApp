class Function {

  Magnetophone mMag;

  Function(Magnetophone aMag) {
    mMag = aMag;
  }

  void call() {
  }
}

class startRecord extends Function {

  startRecord(Magnetophone aMag) {
    super(aMag);
  }

  void call() {
    mMag.record();
  }
}

class startPlay extends Function {

  startPlay(Magnetophone aMag) {
    super(aMag);
  }

  void call() {
    mMag.play();
  }
}

class startDelete extends Function {

  startDelete(Magnetophone aMag) {
    super(aMag);
  }

  void call() {
    mMag.delete();
  }
}

class Magnetophone {

  String tFileName = null;
  int tTimer;
  float tTS;
  String tMode;
  MediaPlayer mPlayer = null;
  MediaRecorder mRecorder = null;

  void Magnetophone() {
    tMode = "Empty";
    tTimer = 0;
  }

  void setFileName(String aFileName)
  {
    tFileName = aFileName+".aac";
  }

  void stop()
  {
    if (null != mRecorder) {
      mRecorder.stop();
      mRecorder.release();
      mRecorder = null;
    }
    if ( null != mPlayer) {
      mPlayer.release();
      mPlayer = null;
    }
    tTimer = 0;
    tFileName = null;
  }

  void record() {
    if (tMode == "Record") {
      tMode = "Pause";
      if (null != mRecorder) {
        mRecorder.stop();
        mRecorder.release();
        mRecorder = null;
      }
    }
    else {
      tMode = "Record";
      if ( tMode == "Play" ) {
        if ( null != mPlayer) {
          mPlayer.release();
          mPlayer = null;
        }
      }

      if (null != tFileName) {
        mRecorder = new MediaRecorder();
        mRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
        mRecorder.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4);
        mRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AAC);
        File f = new File("/sdcard/"+tFileName);
        if (f.exists()) {
          f.delete();
        }
        mRecorder.setOutputFile("/sdcard/"+tFileName);

        try {
          mRecorder.prepare();
        } 
        catch (IOException e) {
          println("prepare() failed");
        }
        mRecorder.start();
        tTS =millis();
      }
    }
  }

  void play() {
    if ( tMode == "Play" ) {
      tMode = "Pause";
      if ( null != mPlayer) {
        mPlayer.release();
        mPlayer = null;
      }
    }
    else {
      if (tMode == "Record") {
        if (null != mRecorder) {
          mRecorder.stop();
          mRecorder.release();
          mRecorder = null;
        }
      }
      println(tFileName);
      tMode = "Play";
      if (null != tFileName) {
        mPlayer = new MediaPlayer();
        try {
          mPlayer.setDataSource("/sdcard/"+tFileName);
          mPlayer.prepare();
          mPlayer.start();
        } 
        catch (IOException e) {
          println("prepare() failed");
        }
      }
    }
  }


  void delete()
  {
    if (null != tFileName) {
      File f = new File("/sdcard/"+tFileName);
      if (f.exists()) {
        f.delete();
      }
      tMode = "Empty";
      tTimer = 0;
      tTS=0;
    }
  }

  String getTimer() {
    if (tMode == "Record") {
      tTimer = 60-int((millis()-tTS)/1000.);
      if (tTimer<1)
        record();
    }
    if (tMode == "Play") {
      if ( null != mPlayer) {
        try {
          tTimer =  int(mPlayer.getCurrentPosition()/1000.);
        }
        catch (Exception e) {
          tTimer = 0;
        }
        if (! mPlayer.isPlaying ()) {
          tMode = "Pause";
          mPlayer.release();
          mPlayer = null;
        }
      }
    }
    return nf(tTimer, 2);
  }
}

