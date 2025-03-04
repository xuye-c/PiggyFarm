import processing.sound.*;
SoundFile bgm;
SoundFile oink;

PImage pig1;
PImage pig2;
PImage pigimg;
PImage egg;
PImage bg;
boolean run = false;
int S_h = 800;
int S_w = 500;
int p_x = 250;
int pig_step = 5;
IntList e_x;
int ex = 0;
int e_y = 0;
int es_low = 3;
int es_high = 5;
int e_speed = 0;
boolean moveLeft = false;
boolean moveRight = false;
boolean pig_inlove = false;
int ploving_t = 0;
int score = 0;


void setup(){
  size(500, 800);
  e_x = new IntList();
  score = 0;
  
  bgm = new SoundFile(this, "Alpok.mp3");
  bgm.play(1,0.5);
  bgm.loop();
  oink = new SoundFile(this, "heng.mp3");
  
  pig1 = loadImage("pig1.png");
  pig2 = loadImage("pig2.png");
  egg = loadImage("egg.png");
  bg = loadImage("bg.png");
  
  
  bg.resize(500,800);
  pig1.resize(S_w/5, S_h/10);
  pig2.resize(S_w/5, S_h/10);
  egg.resize(S_w/15, S_h/20);
  
  pigimg = pig1;
  background(bg);
  image(pigimg, p_x, 4*S_h/5);
  textSize(35);
  textAlign(CENTER);
  fill(255);
  stroke(255);
  text("Press Space key to start", 250, 250);
  
}

void draw(){
  if(run){
    //background(220, 190, 160);
    background(bg);
    //moving pig
    if(pig_inlove&&ploving_t<=60){
      pigimg = pig2;
      ploving_t++;
    }
    else{
      pigimg = pig1;
    }
    if (moveLeft && p_x>0){
      p_x -= pig_step;
    }
    if (moveRight && p_x<500-S_w/5) {
      p_x += pig_step;
    }
    image(pigimg, p_x, 4*S_h/5);
    
    //falling egg
    if(e_x.size()==0){
      e_x.append((int)random(0,S_w-S_w/15));
      if(score%10==0&&es_high<=7){
        //es_low++;
        es_high++;
      }
      else if(score%5==0&&es_low<=7){
        es_low++;
        //es_high++;
      }
      e_speed = (int)random(es_low,es_high);
    }
    else{
      int ex = e_x.get(0);
      image(egg, ex, e_y);
      e_y+=e_speed;
    }
    
    //score shown
    textSize(20);
    textAlign(RIGHT);
    fill(255);
    stroke(255);
    text("Eggs collected: "+score, 480, 50);
    
    //piggy collect eggs
    if(e_y>=4*S_h/5&&e_y<=4*S_h/5+S_h/30&&e_x.get(0)>=p_x&&e_x.get(0)<=(p_x+S_w/5-S_w/15)){
      e_x.remove(ex);
      e_y = 0;
      score++;
      pig_inlove = true;
      ploving_t = 0;
      oink.play();
    }
    else if(e_y>4*S_h/5){
      run = false;
      GameOver();
    }
  }
}

void keyPressed(){
  if(run){ 
    if (keyCode == LEFT){
      moveLeft = true;
    }
    else if (keyCode == RIGHT){
      moveRight = true;
    }
  }
  else{
    if(keyCode == 32){
      resetGame();
    }
  }
}

void keyReleased(){
  if (keyCode == LEFT){
      moveLeft = false;
    }
    else if (keyCode == RIGHT){
      moveRight = false;
    }
}

void GameOver(){
  bgm.stop();
  
  background(255);
  background(bg);
  textSize(35);
  textAlign(CENTER);
  fill(255);
  stroke(255);
  text("You've collected " + score + " eggs!", 250, 300);
  text("Press Space key to restart", 250, 400);
}

void resetGame(){
  bgm.stop();
  p_x = 250; 
  e_x.clear(); 
  e_y = 0;
  score = 0;
  es_low = 3;
  es_high = 5;
  e_speed = 0;
  pig_inlove = false;
  ploving_t = 0;
  run = true;
  bgm.play(1,0.5);
  bgm.loop();
}
