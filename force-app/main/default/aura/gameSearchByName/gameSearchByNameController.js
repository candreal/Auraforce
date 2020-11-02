({
	doInit : function(component, event, helper) {
        
	},
    
    handleClick : function(component, event, helper) {
        //check if enter key is hit
        let isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
            let b = component.get('v.isSearching');
            component.set('v.isSearching', true);
        	//fire event of type gameSearchEvent named search
        	let searchEvent = $A.get("e.c:gameSearchEvent");
        	let s = component.get('v.searchName');
        	searchEvent.setParams({"search": s});
        	searchEvent.fire();
        	console.log('search event fired!');
        }
        
	},
    
    handleSearchDone : function(component, event, helper) {
        component.set('v.isSearching', false);
    }
})