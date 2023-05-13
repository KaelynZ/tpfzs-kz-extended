Scriptname blocksteal_container extends ObjectReference  

Formlist property basket_formlist auto

event OnActivate(ObjectReference akActionRef)
	RegisterForMenu("ContainerMenu")
endEvent

event OnMenuClose(String MenuName)
	if (MenuName != "ContainerMenu")
		return
	endif
	UnregisterForMenu("ContainerMenu")
	basket_formlist.revert()
	self.GetAllForms(basket_formlist)
endEvent
