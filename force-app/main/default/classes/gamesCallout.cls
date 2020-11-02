public class gamesCallout {
    //optional: get number of search results, store in static variable
    public static Integer numResults = 0;
    
    //method for finding games: returns a list of games List<Game__c>
    public static List<Game__c> getGames(String t){
        //create list that will be returned
        List<Game__c> games = new List<Game__c>();
        
        //if input string is null, return empty list. don't bother with callout
        if (t == '') {
            return games;
        }
            
        //url string starts like this for searching game by name: https://api.rawg.io/api/games?search= + 'searchString'
        String url = 'https://api.rawg.io/api/games?search=' + t;
        
        //create required objects for callout: http and httprequest
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        //set endpoint and method of the request object
        request.setEndpoint(url);
        request.setMethod('GET');
        
        //send the response
        HttpResponse response = http.send(request);
        
        //if successful request, parse JSON response
        if (response.getStatusCode() == 200) {
            
            //deserialize JSON object
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            //save the number of results returned
            numResults = (Integer) results.get('count');
            system.debug('Number of results:' + numResults);
            
            //store the results in a List<Object> of Map<String, Object>
            List<Object> gameList = (List<Object>) results.get('results');
            system.debug(gameList);
            //loop through the resulting list, storing the games in a Game__c variable
            for (Object o : gameList) {
                Map<String,Object> m = (Map<String,Object>) o;
                Game__c g = new Game__c();
                //set name, release date, rating. check for null values
                g.Name = (String) m.get('name');
                if (m.get('released') != null) {
                	g.Release_Date__c = date.valueOf((String) m.get('released'));
                }
                if (m.get('metacritic') != null) {
                	g.Metacritic_Rating__c = (Integer) m.get('metacritic');
                }
                system.debug(g.Name);
                //little trickier to set the platforms
                
                //add this game to the list of games
                games.add(g);
            }
        }
        
        
        //return result!
        return games;
    }
        //RAWG platform ids: PC:4 PS4:18 PS5:187 Xbox1:1 XboxSX:186 Switch:7

}