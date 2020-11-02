({
	doInit : function(component, event, helper) {
		//set row actions
        let actions = [
            { label: 'I Want', name: 'wantList' },
            { label: 'I Have', name: 'haveList' }];
        //set columns of lightning:datatable
        component.set('v.columns', [
            {label: 'Title', fieldName: 'Name', type: 'text'},
            {label: 'Release Date', fieldName: 'Release_Date__c', type: 'date'},
            {label: 'Metacritic Rating', fieldName: 'Metacritic_Rating__c', type: 'number'},
            {type: 'action', typeAttributes: {rowActions: actions}}
            //{type:  'button',typeAttributes:{iconName: 'utility:save', label: 'I Want', name: 'wantList', disabled: false}},
            //{type:  'button',typeAttributes:{iconName: 'utility:save', label: 'I Have', name: 'haveList', disabled: false}}
        ]);
        
        //initalize v.wantList and v.haveList with 2 calls to the Apex controller
        let w = component.get('c.getWantList');
        let h = component.get('c.getHaveList');
        
        w.setCallback(this, function(response){
            //check for success
            if (response.getState() === 'SUCCESS') {
                //set v.wantList equal to the response
                component.set('v.wantList', response.getReturnValue());
            }
        });
        
        h.setCallback(this, function(response){
            //check for success
            if (response.getState() === 'SUCCESS') {
                //set v.haveList equal to the response
                component.set('v.haveList', response.getReturnValue());
            }
        });
        
        //enqueue actions
        $A.enqueueAction(w);
        $A.enqueueAction(h);
	},
    
    handleSearch : function(component, event, helper) {
        //set boolean to true: isSearch
        component.set('v.isSearch', true);
        console.log('search event caught!');
        //get the input string from the event (old: let s = component.get('v.searchName');)
        let s = event.getParam("search");
        //URL encode the string: encodeURIComponent() which encodes special characters including: , / ? : @ & = + $ #
        let es = encodeURIComponent(s);
        //pass the string to the search function in the Apex controller
        let action = component.get('c.searchGames');
        action.setParams({'s': es});
        //set callback function
        action.setCallback(this, function(response){
            //check for success
            if (response.getState() === 'SUCCESS'){
                //set the results equal to v.returnedGames
                component.set('v.returnedGames', response.getReturnValue());
                //ensure the variable was set correctly: console.log(JSON.parse(JSON.stringify(component.get("v.returnedGames") )));
                
                //fire event gameSearchDoneEvent
                let searchDoneEvent = $A.get("e.c:gameSearchDoneEvent");
                searchDoneEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    handleViewWant : function(component, event, helper) {
        //set boolean isSearch to false and isListWant to true
        component.set('v.isSearch', false);
        component.set('v.isListWant', true);
        
        //refresh the want list
        let w = component.get('c.getWantList');
        w.setCallback(this, function(response){
            //check for success
            if (response.getState() === 'SUCCESS') {
                //set v.wantList equal to the response
                component.set('v.wantList', response.getReturnValue());
            }
        });
        $A.enqueueAction(w);
    },
    
    handleViewHave : function(component, event, helper) {
        //set boolean isSearch to false and isListHave to false
        component.set('v.isSearch', false);
        component.set('v.isListWant', false);
        
        //refresh the have list
        let h = component.get('c.getHaveList');
        h.setCallback(this, function(response){
            //check for success
            if (response.getState() === 'SUCCESS') {
                //set v.haveList equal to the response
                component.set('v.haveList', response.getReturnValue());
            }
        });
        $A.enqueueAction(h);
    },
    
    handleRowAction : function (component, event, helper) {
        console.log('action clicked!');
        let action = event.getParam('action');
        let row = event.getParam('row');
        //game title, release date, and metacritic rating
        let title = row.Name;
        let rdate = row.Release_Date__c;
        let mrating = row.Metacritic_Rating__c;

        switch (action.name) {
            case 'wantList':
                //add the row to the wantList
                console.log('I want this game: ' + JSON.stringify(row));
                //call apex method to add to want list
                let waction = component.get('c.saveGame');
                waction.setParams({"t" : title, "rd" : rdate, "mr" : mrating, "l": 'want'});
                waction.setCallback(this, function(response) {
                    //check if successful
                    if (response.getState() === 'SUCCESS') {
                        //sucessfully added to want list!
                        console.log('wlist add success!');
                    }
                });
                $A.enqueueAction(waction);
                break;
            case 'haveList':
                //add the row to the haveList
                console.log('I have this game: ' + JSON.stringify(row));
                //call apex method to add to have list
                let haction = component.get('c.saveGame');
                haction.setParams({"t" : title, "rd" : rdate, "mr" : mrating, "l": 'have'});
                haction.setCallback(this, function(response) {
                    //check if successful
                    if (response.getState() === 'SUCCESS') {
                        //sucessfully added to have list!
                        console.log('hlist add success!');
                    }
                });
                $A.enqueueAction(haction);
                break;
        }
    },
    
})