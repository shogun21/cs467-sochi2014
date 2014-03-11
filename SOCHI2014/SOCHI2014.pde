/* CS 467 - Project 2 - #SOCHI2014
* Shugo Tanaka
* Emily Hammel
* Gul Mariam
* Anna Guo
* Peter Caruso
*
*/

// Authentication Details tied to my twitter (@shugoingplaces)
// This is where you enter your Oauth info
static String OAuthConsumerKey = "v2Z1zPBUladR4zoh2nJHTA";
static String OAuthConsumerSecret = "dNilEhK2ewOgN5vS8Z0nUgKcyhjtDR98rCsTpG6ztw";

// This is where you enter your Access Token info
static String AccessToken = "18922763-bgzaKasXm83aPYCKD3WBwLHB6qqkl3TRVF6cwNhFQ";
static String AccessTokenSecret = "1vd8audg4jGtaF14VCBXygjPTqrBamxOjBc1hcHTWKkCS";

// Just some random variables kicking around
String myTimeline;
java.util.List statuses = null;
User[] friends;
TwitterFactory twitterFactory;
Twitter twitter;
RequestToken requestToken;
String[] theSearchTweets = new String[11];
QueryResult r;

// Visualization Analytics
int numKeyWords = 10;
int numTweetsPer = 5;
int totalTweets = 100000;

// Sports Tweets
String[][] tweetsS = new String[numKeyWords][numTweetsPer];
int[] freqS = new int[numKeyWords];
int[] sizeS = new int[numKeyWords];
int[] countS = new int[numKeyWords];

// Countries
String[][] tweetsC = new String[numKeyWords][numTweetsPer];
int[] freqC = new int[numKeyWords];
int[] sizeC = new int[numKeyWords];
int[] countC = new int[numKeyWords];


// Our keywords to search
// Sports
String[] wordSearchS = { 
  "biathelon", "bobsled", "curl", "figure skat", "hockey", "luge", "skeleton", "skiing", "snowboard", "speed skat"
};
// Countries
String[] wordSearchC = { 
  "japan", "usa", "sweden", "russia", "norway", "ukraine", "canad", "germany", "korea", "netherland"
};

// Our keywords to display
// Sports
String[] wordDisplayS = { 
  "Biathlon", "Bob Sledding", "Curling", "Figure Skating", "Hockey", "Luge", "Skeleton", "Skiing", "Snowboarding", "Speed Skating"
};
// Countries
String[] wordDisplayC = { 
  "Japan", "USA", "Sweden", "Russia", "Norway", "Ukraine", "Canada", "Germany", "Korea", "Netherlands"
};


PImage bg_c, bg_s;

void setup() {
  // Window size
  size(640, 480);
  rectMode(CORNERS);
  noStroke();
  textAlign(CENTER, CENTER);
  smooth();
  
  bg_c = loadImage("bg_c.png");
  
  for (i = 0; i< numKeyWords; i++) {
    freqC[i] = 0;
    countC[i] = 0;
    freqS[i] = 0;
    countS[i] = 0;
  }  

  // Sets authentication information and builds Twitter Factory
  connectTwitter();
  //getTimeline();  // Prints out all my tweets
  //getSearchTweets("#happy", 10);  // Prints out
  r = getSearchTweets("#SOCHI", totalTweets);
  for (Status status : r.getTweets()) {
    //println("@" + status.getUser().getScreenName() + ": " + status.getText());
    for (i=0;i<numKeyWords; i++) {
      if (status.getText().toLowerCase().contains(wordSearchC[i])) {
        freqC[i]++;
        if (countC[i] < numTweetsPer) {
          tweetsC[i][countC[i]] = "@" + status.getUser().getScreenName() + ": " + status.getText();
          countC[i]++;
        }
      }
      if (status.getText().toLowerCase().contains(wordSearchS[i])) {
        freqS[i]++;
        if (countS[i] < numTweetsPer) {
          tweetsS[i][countS[i]] = "@" + status.getUser().getScreenName() + ": " + status.getText();
          countS[i]++;
        }
      }
    }
  }

  // Debugging and resizing text
  for (i = 0; i< numKeyWords; i++) {
    //println("Frequency " + i + ") " + freq[i]);
    //println("Tweets filled " + i + ") " + count[i]);
    if (freqC[i] <= 1) { //minimum
      sizeC[i] = 10;
    }
    else if (freqC[i] >= 10) { //maximum
      sizeC[i] = 40;
    }
    else {
      sizeC[i] = (3*freqC[i])+10;
    }
    
    if (freqS[i] <= 1) { //minimum
      sizeS[i] = 10;
    }
    else if (freqS[i] >= 10) { //maximum
      sizeS[i] = 40;
    }
    else {
      sizeS[i] = (3*freqS[i])+10;
    }
  }
}

int page = 0;
int mode = 0;
color bgcolor1 = color(15, 15, 15);
color bgcolor2 = #F5F6FF;
color row01 = #C6CAF2; // Light blue
color row02 = #F5F6FF; // Off-white
color textColor01 = #000000; // Black
color homeText = #000000;
color pageText = #000000;
int pageTextSize = 14;

int i;

void draw() {

  // Display home screen
  if (page == 0) {
    cursor(HAND);

    for (i = 0; i<numKeyWords; i++) {
      // Alternate colors
    if(mode == 0){
      background(bg_c);
    }
      if(mode == 1){
        if (i%2 == 0)
          fill(row02);
        else
          fill(row01);
      }

      // Draw background rectangle
      rect(0, i*(height/10), width, (i+1)*(height/10));
      // Display keyword
      fill(homeText);
      if(mode == 0){
        textSize(sizeC[i]);
        text(wordDisplayC[i], width/2, (i*2+1)*(height/20));
      } else if(mode == 1) {
        textSize(sizeS[i]);
        text(wordDisplayS[i], width/2, (i*2+1)*(height/20));
      }
    }
  } 
  else if (page == 1) {
    // User clicked a word, display this
    background(bgcolor2);
    cursor(ARROW);
    fill(pageText);
    if(mode == 0){
      textSize(sizeC[0]);
      text(wordDisplayC[0], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countC[0]; i++) {
        text(tweetsC[0][i], 0, (i+1)*(height/(countC[0]+1)), width, (i+2)*(height/(countC[0]+1)));
      }
    } else if(mode == 1){
      textSize(sizeS[0]);
      text(wordDisplayS[0], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countS[0]; i++) {
        text(tweetsS[0][i], 0, (i+1)*(height/(countS[0]+1)), width, (i+2)*(height/(countS[0]+1)));
      }
    }
  } 
  else if (page == 2) {
    // User clicked a word, display this
    background(bgcolor2);
    cursor(ARROW);
    fill(pageText);
    if(mode == 0){
      textSize(sizeC[1]);
      text(wordDisplayC[1], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countC[1]; i++) {
        text(tweetsC[1][i], 0, (i+1)*(height/(countC[1]+1)), width, (i+2)*(height/(countC[1]+1)));
      }
    } else if(mode == 1){
      textSize(sizeS[1]);
      text(wordDisplayS[1], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countS[1]; i++) {
        text(tweetsS[1][i], 0, (i+1)*(height/(countS[1]+1)), width, (i+2)*(height/(countS[1]+1)));
      }
    }
  }
  else if (page == 3) {
    // User clicked a word, display this
    background(bgcolor2);
    cursor(ARROW);
    fill(pageText);
    if(mode == 0){
      textSize(sizeC[2]);
      text(wordDisplayC[2], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countC[2]; i++) {
        text(tweetsC[2][i], 0, (i+1)*(height/(countC[2]+1)), width, (i+2)*(height/(countC[2]+1)));
      }
    } else if(mode == 1){
      textSize(sizeS[2]);
      text(wordDisplayS[2], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countS[2]; i++) {
        text(tweetsS[2][i], 0, (i+1)*(height/(countS[2]+1)), width, (i+2)*(height/(countS[2]+1)));
      }
    }
  }
  else if (page == 4) {
    // User clicked a word, display this
    background(bgcolor2);
    cursor(ARROW);
    fill(pageText);
    if (mode == 0){
      textSize(sizeC[3]);
      text(wordDisplayC[3], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countC[3]; i++) {
        text(tweetsC[3][i], 0, (i+1)*(height/(countC[3]+1)), width, (i+2)*(height/(countC[3]+1)));
      }
    } else if(mode == 1){
      textSize(sizeS[3]);
      text(wordDisplayS[3], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countS[3]; i++) {
        text(tweetsS[3][i], 0, (i+1)*(height/(countS[3]+1)), width, (i+2)*(height/(countS[3]+1)));
      }
    }
  }
  else if (page == 5) {
    // User clicked a word, display this
    background(bgcolor2);
    cursor(ARROW);
    fill(pageText);
    if(mode == 0){
      textSize(sizeC[4]);
      text(wordDisplayC[4], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countC[4]; i++) {
        text(tweetsC[4][i], 0, (i+1)*(height/(countC[4]+1)), width, (i+2)*(height/(countC[4]+1)));
      }
    } else if(mode == 1){
      textSize(sizeS[4]);
      text(wordDisplayS[4], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countS[4]; i++) {
        text(tweetsS[4][i], 0, (i+1)*(height/(countS[4]+1)), width, (i+2)*(height/(countS[4]+1)));
      }
    }
  } 
  else if (page == 6) {
    // User clicked a word, display this
    background(bgcolor2);
    cursor(ARROW);
    fill(pageText);
    if(mode == 0){
      textSize(sizeC[5]);
      text(wordDisplayC[5], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countC[5]; i++) {
        text(tweetsC[5][i], 0, (i+1)*(height/(countC[5]+1)), width, (i+2)*(height/(countC[5]+1)));
      }
    } else if(mode == 1){
      textSize(sizeS[5]);
      text(wordDisplayS[5], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countS[5]; i++) {
        text(tweetsS[5][i], 0, (i+1)*(height/(countS[5]+1)), width, (i+2)*(height/(countS[5]+1)));
      }
    }
  }
  else if (page == 7) {
    // User clicked a word, display this
    background(bgcolor2);
    cursor(ARROW);
    fill(pageText);
    if (mode == 0){
      textSize(sizeC[6]);
      text(wordDisplayC[6], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countC[6]; i++) {
        text(tweetsC[6][i], 0, (i+1)*(height/(countC[6]+1)), width, (i+2)*(height/(countC[6]+1)));
      }
    } else if(mode == 1){
      textSize(sizeS[6]);
      text(wordDisplayS[6], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countS[6]; i++) {
        text(tweetsS[6][i], 0, (i+1)*(height/(countS[6]+1)), width, (i+2)*(height/(countS[6]+1)));
      }
    }
  }
  else if (page == 8) {
    // User clicked a word, display this
    background(bgcolor2);
    cursor(ARROW);
    fill(pageText);
    if(mode == 0){
      textSize(sizeC[7]);
      text(wordDisplayC[7], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countC[7]; i++) {
        text(tweetsC[7][i], 0, (i+1)*(height/(countC[7]+1)), width, (i+2)*(height/(countC[7]+1)));
      }
    } else if(mode == 1){
      textSize(sizeS[7]);
      text(wordDisplayS[7], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countS[7]; i++) {
        text(tweetsS[7][i], 0, (i+1)*(height/(countS[7]+1)), width, (i+2)*(height/(countS[7]+1)));
      }
    }
  }
  else if (page == 9) {
    // User clicked a word, display this
    background(bgcolor2);
    cursor(ARROW);
    fill(pageText);
    if(mode == 0){
      textSize(sizeC[8]);
      text(wordDisplayC[8], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countC[8]; i++) {
        text(tweetsC[8][i], 0, (i+1)*(height/(countC[8]+1)), width, (i+2)*(height/(countC[8]+1)));
      }
    } else if(mode == 1){
      textSize(sizeS[8]);
      text(wordDisplayS[8], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countS[8]; i++) {
        text(tweetsS[8][i], 0, (i+1)*(height/(countS[8]+1)), width, (i+2)*(height/(countS[8]+1)));
      }
    }
  }
  else if (page == 10) {
    // User clicked a word, display this
    background(bgcolor2);
    cursor(ARROW);
    fill(pageText);
    if(mode == 0){
      textSize(sizeC[9]);
      text(wordDisplayC[9], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countC[9]; i++) {
        text(tweetsC[9][i], 0, (i+1)*(height/(countC[9]+1)), width, (i+2)*(height/(countC[9]+1)));
      }
    } else if(mode == 1){
      textSize(sizeS[9]);
      text(wordDisplayS[9], width/2, height/10);
      textSize(pageTextSize);
      for (i = 0; i < countS[9]; i++) {
        text(tweetsS[9][i], 0, (i+1)*(height/(countS[9]+1)), width, (i+2)*(height/(countS[9]+1)));
      }
    }
  }
}

void mouseClicked() {
  if (page == 0) {
    if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < (height/10)) {
      page = 1;
    } 
    else if (mouseX > 0 && mouseX < width && mouseY > 1*(height/10) && mouseY < 2*(height/10)) {
      page = 2;
    } 
    else if (mouseX > 0 && mouseX < width && mouseY > 2*(height/10) && mouseY < 3*(height/10)) {
      page = 3;
    } 
    else if (mouseX > 0 && mouseX < width && mouseY > 3*(height/10) && mouseY < 4*(height/10)) {
      page = 4;
    } 
    else if (mouseX > 0 && mouseX < width && mouseY > 4*(height/10) && mouseY < 5*(height/10)) {
      page = 5;
    } 
    else if (mouseX > 0 && mouseX < width && mouseY > 5*(height/10) && mouseY < 6*(height/10)) {
      page = 6;
    } 
    else if (mouseX > 0 && mouseX < width && mouseY > 6*(height/10) && mouseY < 7*(height/10)) {
      page = 7;
    } 
    else if (mouseX > 0 && mouseX < width && mouseY > 7*(height/10) && mouseY < 8*(height/10)) {
      page = 8;
    } 
    else if (mouseX > 0 && mouseX < width && mouseY > 8*(height/10) && mouseY < 9*(height/10)) {
      page = 9;
    } 
    else if (mouseX > 0 && mouseX < width && mouseY > 9*(height/10) && mouseY < 10*(height/10)) {
      page = 10;
    }
  }
}

void keyPressed() {
  if (keyCode == BACKSPACE || keyCode == ESC) {
    page = 0;
  } else if(key == 's' || key == 'S'){
    mode = 1;
  } else if(key == 'c' || key == 'C'){
    mode = 0;
  }
}


// Initial connection
void connectTwitter() {
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey(OAuthConsumerKey);
  cb.setOAuthConsumerSecret( OAuthConsumerSecret );
  cb.setOAuthAccessToken( AccessToken);
  cb.setOAuthAccessTokenSecret( AccessTokenSecret );
  twitterFactory = new TwitterFactory(cb.build());
  twitter = twitterFactory.getInstance();
  println("connected");
}

// Loading up the access token
private static AccessToken loadAccessToken() {
  return new AccessToken(AccessToken, AccessTokenSecret);
}


// Get your tweets
void getTimeline() {

  try {
    statuses = twitter.getUserTimeline();
  } 
  catch(TwitterException e) {
    println("Get timeline: " + e + " Status code: " + e.getStatusCode());
  }

  for (int i=0; i<statuses.size(); i++) {
    Status status = (Status)statuses.get(i);
    println(status.getUser().getName() + ": " + status.getText());
  }
}


// Search for tweets
QueryResult getSearchTweets(String queryStr, int num) {
  try {
    Query query = new Query(queryStr);
    query.count(num); // Get 10 of the 100 search results
    QueryResult result = twitter.search(query);
    return result;
    //    for (Status status : result.getTweets()) {
    //      println("@" + status.getUser().getScreenName() + ": " + status.getText());
    //    }
  } 
  catch (TwitterException e) {
    println("Search tweets: " + e);
    return null;
  }
}
