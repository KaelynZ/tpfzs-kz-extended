;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 6
Scriptname blocksteal_perk Extends Perk Hidden

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
RunScript(akTargetRef)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
Debug.Notification("$BLOCKSTEAL_NOT_LOADED")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Function RunScript(ObjectReference akTargetRef)
	blocksteal.IncCurrentMultiTapCount()
	RegisterForSingleUpdate(blocksteal.GetMultiTapTimer())
endFunction

Event OnUpdate()
	blocksteal.ResetCurrentMultiTapCount()
endEvent
