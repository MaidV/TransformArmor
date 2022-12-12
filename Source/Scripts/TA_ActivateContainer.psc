;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 12
Scriptname TA_ActivateContainer Extends Perk Hidden

;BEGIN FRAGMENT Fragment_4
Function Fragment_4(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
debug.trace("[TA] Activate container")
float r = Utility.RandomFloat(0, 100)
If r < TA_MCM.containerProbability
    TA_Library.TransformEquipped(akActor, None, false)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

TA_MCMConfig Property TA_MCM Auto
