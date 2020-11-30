PImage img;
PImage img2;
  
  
import ddf.minim.*;

Minim minim;
AudioPlayer groove;

import processing.sound.*;
SoundFile file;
import processing.serial.*;
Serial port;
String temp_c = "";
String temp_f = "";
String temp_t = "";
String temp_p = "";


int realc = 0;
int realf = 0;

float x3 =0;
float realt = 0;
float realp = 0;

int button =0;
int button2 =0;
int square = 0;
int beam =0;
String data = "";

int onOff=1;
int onOff2=0;
int inverted = 1;
int index = 0;
int bgcolor=0;
int count =0;


int totalFrames = 120;
int counter =0;

int backColor = color(239,240,231);
int frontColor =  color(237, 99, 58);
//int frontColor =   color(100, 0, 250);
int middleColor =  color(100, 0, 250);

float x2 =0;

int graphicsCounter = 0;

//String[] bgGraphics = {  "c1.png",  "c1.png", "c1.png",  "c1.png", "c2.png","C.png", "A.png", "R.png", "L.png", "G.png","U.png", "S.png", "T.png", "A.png", "F.png", "hello.png", "mit.png","c1.png",  "c1.png", "c2.png","C.png", "A.png", "R.png", "L.png", "G.png","U.png", "S.png", "T.png", "A.png", "F.png", };
String[] bgGraphics = {"C.png", "C.png", "A.png", "R.png", "L.png", "G.png","U.png", "S.png", "T.png", "A.png", "F.png", "C.png", "A.png", "R.png", "L.png", "G.png","U.png", "S.png", "T.png", "A.png", "F.png", };


//set up the board
int size = 6;
int cols = 1600/size;
int rows = 900/size;
int [][] board = new int[cols][rows];
{ 
  for (int y=0; y<rows; y++) {
    for (int x =0; x<cols; x++) {
      board[x][y]=int(random(2));
    }
  }
}

//set up screen

void setup() {
  minim = new Minim(this);
  groove = minim.loadFile("2.mp3", 1024);
  groove.loop();
  
  
  file = new SoundFile(this, "2.mp3");

  port=new Serial(this, Serial.list()[6], 9600);
  port.bufferUntil('_');
  size(1600, 900);
  frameRate(130);
  img = loadImage("testing15.png");
  img.resize(1600, 900);

  img2 = loadImage("frame3.png");
  img2.resize(1600, 900);
}

//drawing the screen

void draw() {

  img = loadImage(bgGraphics[graphicsCounter]);
  img.resize(1600, 900);

  

 //stroke( 255 );
  
  // draw the waveforms
  // the values returned by left.get() and right.get() will be between -1 and 1,
  // so we need to scale them up to see the waveform
  // note that if the file is MONO, left.get() and right.get() will return the same value
  for(int i = 0; i < groove.bufferSize() - 1; i++)
  {
    float x1 = map( i, 0, groove.bufferSize(), 0, width );
    float x2 = map( i+1, 0, groove.bufferSize(), 0, width );
    line( x1, 50 + groove.left.get(i)*50, x2, 50 + groove.left.get(i+1)*50 );
    line( x1, 150 + groove.right.get(i)*50, x2, 150 + groove.right.get(i+1)*50 );
  }
  
  //noStroke();
  fill( 255, 128 );
  
  // the value returned by the level method is the RMS (root-mean-square) 
  // value of the current buffer of audio.
  // see: http://en.wikipedia.org/wiki/Root_mean_square
  rect( 0, 0, groove.left.level()*width, 100 );
  rect( 0, 100, groove.right.level()*width, 100 );
  
  
  
  
  
  

  frameRate(30);
  background(0);




  //compute the next board
  int [][] next = new int[cols][rows];
  for (int y=1; y<rows-1; y++) {
    for (int x =1; x<cols-1; x++) {
      int neighbours = countNeighbours(x, y);
      next[x][y] = ruleOfLife(board[x][y], neighbours);
    }
  }
  board = next;
  drawBoard();
  
        for(int i = 0; i < groove.bufferSize() - 1; i++)
  {
    float x1 = map( i, 0, groove.bufferSize(), 0, width );
    float x2 = map( i+1, 0, groove.bufferSize(), 0, width );
    x3 = map( groove.right.level()*width, 0, 1000, 0  , 255 );
    //frontColor = color(0, x3, 0-x3);
}
  
  
  
}





void serialEvent (Serial port) {
  data = port.readStringUntil('_');
  data = data.substring(0, data.length() - 1);


  int firstIndex = data.indexOf("-");
  button = int(data.substring(0, firstIndex-1));

  int secondIndex = data.indexOf(">");
  button2 = int(data.substring(firstIndex+1, secondIndex - 1));


  square = 1;
  beam = 2;


  int oneIndex = data.indexOf("+");
  int thirdIndex = data.indexOf(".");

  index = data.indexOf(",");
  
  if (button ==0){
      int cellX = mouseX / size;
      int cellY = mouseY / size;

  if (board[cellX][cellY]==0) {
    board[cellX][cellY] = 1 - board[cellX][cellY];
  } else {
    for (int y=1; y<rows-1; y++) {
      for (int x =1; x<cols-1; x++) {
        board[x][y] = 0;
      }
    }
  } 
  }
  
    if (button2 ==0){
   // play/pause song
     file.play();

  }
  
  

  temp_t = data.substring(secondIndex+1, oneIndex-1); 
  temp_c = data.substring(oneIndex+1, index-1);
  temp_f = data.substring(index+1, thirdIndex-1); 
  temp_p = data.substring(thirdIndex+1, data.length()-1); 

  realt = map(int(temp_t), 0, 255, 0, 12);
  realc = int(temp_c);
  realf = int(temp_f);
  realp = map(int(temp_p), 0, 255, 0, bgGraphics.length -1);
  graphicsCounter = int(realp);
}



// count the number of neighbpurs

int countNeighbours(int x, int y) {
  int neighbours = 0;
  for (int i =-1; i<=1; i++) {
    for (int j=-1; j<=1; j++) {
      neighbours +=board[x+j][y+i];
    }
  }
  neighbours -= board[x][y];
  return(neighbours);
};




//apply the rules of life

int ruleOfLife(int status, int neighbours) { 
  if (status == 1 && neighbours >realt) return(0);
  else if (status == 1 && neighbours < 2) return (0);
  else if (status == 0 && neighbours ==3) return (1);


  else return(status);
}


//draw the board on the screen


void drawBoard() {
  //hitta varde fran bakgrundsbild och andra status till 1

  float tileSize =  width/cols;
  
  for (int x = 0; x<cols; x++) {
    for (int y = 0; y<rows; y++) {

      color c = img.get(int(x*tileSize), int(y*tileSize));
      float b = map(brightness(c), 0, 255, 0, 1);
     
      if (b<1) {
        board[x][y]=inverted;

        //dubbla rader
        if (realf <cols) {
          if (realc<rows) {
            //board[x][realc]=1;
            //board[realf][y]=1;
          } else realc = rows -1;
        } else realf = cols -1;


        ///bara en stor prick
        if (realf < 4) realf = 7;
        if (realf > cols -6) realf = cols -6;
        if (realf < cols -2 && realf > 5) {
          if (realc < rows -2 && realc > 0) {                                     
            for (int i =-square; i<=square; i++) {
              for (int j=-4; j<=beam; j++) {
                board[realf+j][realc+i]=1;
              }
            }
          } else realc = rows -1;
        } else realf = cols -1;
      }
    }
  }

if (onOff == 1){
  for (int x = 0; x<cols; x++) {
    for (int y = 0; y<rows; y++) {

      color r = img2.get(int(x*tileSize), int(y*tileSize));
      float t = map(brightness(r), 0, 255, 0, 1);
      if (t<1) {
        board[x][y]=1;
      }
    }
  }
}




  { 
    for (int y=0; y<rows; y++) {

      for (int x =0; x<cols; x++) {
        if (board[x][y]==1) {
          fill(frontColor);
        } else if (board[x][y]==2) {
          fill(middleColor);
        } else if (board[x][y]==3) {
          fill(color(255, 0, 0));
        } else {
          fill(backColor);
        }
        rect(x*size, y*size, size, size);
      }
    }
  }

  //String s = "a cell dies if it has less than 2 and more than " +str(realt) +" neighbours" ;
  //textSize(32);
  //fill(50);
  //text(s, realf*size, realc*size+50);  // Text wraps within text box
}
