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
int totalTweets = 1000;
String[][] tweets = new String[numKeyWords][numTweetsPer];
int[] freq = new int[numKeyWords];
int[] sizes = new int[numKeyWords];
int[] count = new int[numKeyWords];

// Our keywords to search
String w01 = "biathlon";
String w02 = "bobsled";
String w03 = "curl";
String w04 = "figure skat";
String w05 = "hockey";
String w06 = "luge";
String w07 = "skeleton";
String w08 = "ski";
String w09 = "snowboard";
String w10 = "speed skat";

// Our keywords to display
String kw01 = "Biathlon";
String kw02 = "Bob Sledding";
String kw03 = "Curling";
String kw04 = "Figure Skating";
String kw05 = "Hockey";
String kw06 = "Luge";
String kw07 = "Skeleton";
String kw08 = "Skiing";
String kw09 = "Snowboarding";
String kw10 = "Speed Skating";


void setup() {
  size(640, 480);
  background(15);
  
  for(int i = 0; i< numKeyWords; i++){
    freq[i] = 0;
    count[i] = 0;
    sizes[i] = 32; // Default font size
  }  

  // Sets authentication information and builds Twitter Factory
  connectTwitter();
  //getTimeline();  // Prints out all my tweets
  //getSearchTweets("#happy", 10);  // Prints out
  r = getSearchTweets("#SOCHI", totalTweets);
  for (Status status : r.getTweets()) {
    println("@" + status.getUser().getScreenName() + ": " + status.getText());
    if(status.getText().toLowerCase().contains(w01)){
      freq[0]++;
      if(count[0] < numTweetsPer)
        tweets[0][count[0]] = "@" + status.getUser().getScreenName() + ": " + status.getText();
    }
  }
  rectMode(CORNERS);
  noStroke();
  
  textAlign(CENTER, CENTER);
}

int page = 0;
color bgcolor1 = color(15,15,15);
color bgcolor2 = color(45,45,45);
color row01 = #C6CAF2; // Light blue
color row02 = #F5F6FF; // Off-white
color textColor01 = #000000; // Black
color homeText = #000000;

void draw() {
  
  if(page == 0){
    cursor(HAND);
    // Display home screen, display this
    fill(row01);
    rect(0,0, width, height/10);
    fill(row02);
    rect(0,1*(height/10), width, 2*(height/10));
    fill(row01);
    rect(0,2*(height/10), width, 3*(height/10));
    fill(row02);
    rect(0,3*(height/10), width, 4*(height/10));
    fill(row01);
    rect(0,4*(height/10), width, 5*(height/10));
    fill(row02);
    rect(0,5*(height/10), width, 6*(height/10));
    fill(row01);
    rect(0,6*(height/10), width, 7*(height/10));
    fill(row02);
    rect(0,7*(height/10), width, 8*(height/10));
    fill(row01);
    rect(0,8*(height/10), width, 9*(height/10));
    fill(row02);
    rect(0,9*(height/10), width, 10*(height/10));
    
    // Display text
    fill(homeText);
    textSize(sizes[0]);
    text(kw01, width/2, height/20);
    
    textSize(sizes[1]);
    text(kw02, width/2, 3*(height/20));
    
    textSize(sizes[2]);
    text(kw03, width/2, 5*(height/20));
    
    textSize(sizes[3]);
    text(kw04, width/2, 7*(height/20));
    
    textSize(sizes[4]);
    text(kw05, width/2, 9*(height/20));
    
    textSize(sizes[5]);
    text(kw06, width/2, 11*(height/20));
    
    textSize(sizes[6]);
    text(kw07, width/2, 13*(height/20));
    
    textSize(sizes[7]);
    text(kw08, width/2, 15*(height/20));
    
    textSize(sizes[8]);
    text(kw09, width/2, 17*(height/20));
    
    textSize(sizes[9]);
    text(kw10, width/2, 19*(height/20));
    
  } else if(page == 1){
    // User clicked a word, display this
    cursor(ARROW);
    background(bgcolor2);
    textSize(32);
    fill(textColor01);
    text("1", width/2, height/2); 
  } else if(page == 2){
    // User clicked a word, display this
    cursor(ARROW);
    background(bgcolor2);
    textSize(32);
    fill(textColor01);
    text("2", width/2, height/2); 
  }else if(page == 3){
    // User clicked a word, display this
    cursor(ARROW);
    background(bgcolor2);
    textSize(32);
    fill(textColor01);
    text("3", width/2, height/2); 
  }else if(page == 4){
    // User clicked a word, display this
    cursor(ARROW);
    background(bgcolor2);
    textSize(32);
    fill(textColor01);
    text("4", width/2, height/2); 
  }else if(page == 5){
    // User clicked a word, display this
    cursor(ARROW);
    background(bgcolor2);
    textSize(32);
    fill(textColor01);
    text("5", width/2, height/2); 
  } else if(page == 6){
    // User clicked a word, display this
    cursor(ARROW);
    background(bgcolor2);
    textSize(32);
    fill(textColor01);
    text("6", width/2, height/2); 
  }else if(page == 7){
    // User clicked a word, display this
    cursor(ARROW);
    background(bgcolor2);
    textSize(32);
    fill(textColor01);
    text("7", width/2, height/2); 
  }else if(page == 8){
    // User clicked a word, display this
    cursor(ARROW);
    background(bgcolor2);
    textSize(32);
    fill(textColor01);
    text("8", width/2, height/2); 
  }else if(page == 9){
    // User clicked a word, display this
    cursor(ARROW);
    background(bgcolor2);
    textSize(32);
    fill(textColor01);
    text("9", width/2, height/2); 
  }else if(page == 10){
    // User clicked a word, display this
    cursor(ARROW);
    background(bgcolor2);
    textSize(32);
    fill(textColor01);
    text("10", width/2, height/2); 
  }
  
}

void mouseClicked(){
  if(page == 0){
    if(mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < (height/10)){
     page = 1;
    } else if(mouseX > 0 && mouseX < width && mouseY > 1*(height/10) && mouseY < 2*(height/10)){
     page = 2;
    } else if(mouseX > 0 && mouseX < width && mouseY > 2*(height/10) && mouseY < 3*(height/10)){
     page = 3;
    } else if(mouseX > 0 && mouseX < width && mouseY > 3*(height/10) && mouseY < 4*(height/10)){
     page = 4;
    } else if(mouseX > 0 && mouseX < width && mouseY > 4*(height/10) && mouseY < 5*(height/10)){
     page = 5;
    } else if(mouseX > 0 && mouseX < width && mouseY > 5*(height/10) && mouseY < 6*(height/10)){
     page = 6;
    } else if(mouseX > 0 && mouseX < width && mouseY > 6*(height/10) && mouseY < 7*(height/10)){
     page = 7;
    } else if(mouseX > 0 && mouseX < width && mouseY > 7*(height/10) && mouseY < 8*(height/10)){
     page = 8;
    } else if(mouseX > 0 && mouseX < width && mouseY > 8*(height/10) && mouseY < 9*(height/10)){
     page = 9;
    } else if(mouseX > 0 && mouseX < width && mouseY > 9*(height/10) && mouseY < 10*(height/10)){
     page = 10;
    }
  }
}

void keyPressed(){
  if(keyCode == BACKSPACE || keyCode == ESC){
    page = 0; 
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

