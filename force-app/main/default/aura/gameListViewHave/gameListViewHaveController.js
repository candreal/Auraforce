({
	handleClick : function(component, event, helper) {
        
        //fire event of type gameSearchEvent named search
        let viewEvent = $A.get("e.c:gameListViewHaveEvent");
        viewEvent.fire();
        console.log('view I Have event fired!');
        
	}
})