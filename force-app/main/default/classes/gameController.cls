public class gameController {
    
    //call the callout method to search games
    @AuraEnabled
    public static List<Game__c> searchGames(String s) {
        return gamesCallout.getGames(s);
    }
    
    //look if the current user is the owner of a wantList item:
    	//if yes, query for the related games
    	//if no, create one
    @AuraEnabled
    public static List<Game__c> getWantList() {
        List<Game__c> games = new List<Game__c>();
        
        //search for a record of type WantList__c owned by the current user
        String uid = UserInfo.getUserId();
        List<WantList__c> wlist = [SELECT Id, OwnerId, (SELECT Id, Game__c FROM Want_List_Items__r) FROM WantList__c WHERE OwnerId = :uid LIMIT 1];
        
        //check if a record is returned
        if (wlist.size() == 1) {
            //get the related games
            String lid = wlist[0].Id;
            system.debug('current user has a want list already. Id: ' + lid);
            for (WantListItem__c wl : wlist[0].Want_List_Items__r) {
                //wl.Game__c returns an Id. need to search for the associated game object
                Id gid = wl.Game__c;
                Game__c g = [SELECT Id, Name, Release_Date__c, Metacritic_Rating__c FROM Game__c WHERE Id = :gid];
                games.add(g);
            }
            //system.debug('please work' + games);
            
        } else {
            //create a wlist record owned by the user
            WantList__c mywlist = new WantList__c();
            mywlist.OwnerId = uid;
            insert mywlist;
        }
        
        
        return games;
    }
    
    //look if the current user is the owner of a haveList item:
    	//if yes, query for the related games
    	//if no, create one
    @AuraEnabled
    public static List<Game__c> getHaveList() {
        List<Game__c> games = new List<Game__c>();
        
        //search for a record of type HaveList__c owned by the current user
        String uid = UserInfo.getUserId();
        List<HaveList__c> hlist = [SELECT Id, OwnerId, (SELECT Id, Game__c FROM HaveListItems__r) FROM HaveList__c WHERE OwnerId = :uid LIMIT 1];
        
        //check if a record is returned
        if (hlist.size() == 1) {
            //get the related games
            String lid = hlist[0].Id;
            system.debug('current user has a have list already. Id: ' + lid);
            for (HaveListItem__c hl : hlist[0].HaveListItems__r) {
                //hl.Game__c returns an Id. need to search for the associated game object
                Id gid = hl.Game__c;
                //system.debug(gid);
                Game__c g = [SELECT Id, Name, Release_Date__c, Metacritic_Rating__c FROM Game__c WHERE Id = :gid];
                games.add(g);
            }
            system.debug('please work' + games);
            
        } else {
            //create a hlist record owned by the user
            HaveList__c myhlist = new HaveList__c();
            myhlist.OwnerId = uid;
            insert myhlist;
        }
        
        
        return games;
    }
    
    //see if the given game is in the database
    	//if not, save to db
    //return the saved game
    @AuraEnabled
    public static Game__c saveGame(String t, Date rd, Integer mr, String l) {
        //search to see if the input game is already in the db (search by title)
        Game__c g = new Game__c();
        g.Name = t;
        g.Metacritic_Rating__c = mr;
        g.Release_Date__c = rd;
        
        List<Game__c> glist = [SELECT Name FROM Game__c WHERE Name = :t LIMIT 1];
        if (glist.size() == 0) {
            //insert game
            insert g;
            system.debug('game does not exist! Adding it');
            glist = [SELECT Name FROM Game__c WHERE Name = :t LIMIT 1];
            g = glist[0];
        } else {
            system.debug('game already exists! Moving on...');
            g = glist[0];
        }
        
        //call wlist or hlist depending on value of String l
        if (l == 'have') {
            system.debug('Adding game to have list!');
            addHaveList(g);
        } else {
            system.debug('Adding game to want list!');
            addWantList(g);
        }
        
        return g;
    }
    
    //find the id of current user's haveList record
    //Create a haveListItem record associated with the previous 2 records
    //return the saved game
    @AuraEnabled
    public static Game__c addHaveList(Game__c g) {
        
        //find the haveList owned by the current user
        String uid = UserInfo.getUserId();
        List<HaveList__c> hlist = [SELECT Id, OwnerId, (SELECT Id, Game__c FROM HaveListItems__r) FROM HaveList__c WHERE OwnerId = :uid LIMIT 1];
        
        Id gid = g.Id;
        Id lid = hlist[0].Id;
        //see if a haveListItem already exists
        List<HaveListItem__c> junctions = [SELECT Game__c, HaveList__c FROM HaveListItem__c WHERE Game__c = :gid AND HaveList__c = :lid LIMIT 1];
        
        if (junctions.size() == 0) {
            system.debug('Adding Game to I Have List!');
            //create a haveListItem related to the two
        	HaveListItem__c haveGame = new HaveListItem__c();
        	haveGame.Game__c = g.Id;
        	haveGame.HaveList__c = hlist[0].Id;
        	//insert haveListItem
        	insert haveGame;
        } else {
            system.debug('Already Added!');
        }
        
        return g;
    }
    
    //find the id of current user's wantList record
    //Create a wantListItem record associated with the previous 2 records
    //return the saved game
    @AuraEnabled
    public static Game__c addWantList(Game__c g) {

        //find the wantList owned by the current user
        String uid = UserInfo.getUserId();
        List<WantList__c> wlist = [SELECT Id, OwnerId, (SELECT Id, Game__c FROM Want_List_Items__r) FROM WantList__c WHERE OwnerId = :uid LIMIT 1];
        
        Id gid = g.Id;
        Id lid = wlist[0].Id;
        
        //see if a wantListItem already exists
        List<WantListItem__c> junctions = [SELECT Game__c, WantList__c FROM WantListItem__c WHERE Game__c = :gid AND WantList__c = :lid LIMIT 1];
        
        if (junctions.size() == 0) {
            system.debug('Adding Game to I Want List!');
            //create a wantListItem related to the two
        	WantListItem__c wantGame = new WantListItem__c();
        	wantGame.Game__c = g.Id;
        	wantGame.WantList__c = wlist[0].Id;
        	//insert wantListItem
        	insert wantGame;
        } else {
            system.debug('Already Added!');
        }
        
        return g;
    }

}