({
	handleClick : function(component, event, helper) {
        
        //fire event of type gameSearchEvent named search
        let viewEvent = $A.get("e.c:gameListViewWantEvent");
        viewEvent.fire();
        console.log('view I Want event fired!');
        
	}
})