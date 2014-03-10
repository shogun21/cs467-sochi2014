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

void setup() {
  size(640, 480);
  background(15);

  // Sets authentication information and builds Twitter Factory
  connectTwitter();
  //getTimeline();  // Prints out all my tweets
<<<<<<< HEAD
  //getSearchTweets("#happy", 10);  // Prints out
  r = getSearchTweets("#happy", 10);
  for (Status status : r.getTweets()) {
    println("@" + status.getUser().getScreenName() + ": " + status.getText());
  }
=======
  getSearchTweets("#Sochi2014", 10);  // Prints out 
>>>>>>> 3b5ff128e6bfb0084b0db4b611079f8b383117cc
}


void draw() {
  background(15);
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

