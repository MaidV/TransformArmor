;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 6
Scriptname TA_activateContainer Extends Perk Hidden

;BEGIN FRAGMENT Fragment_5
Function Fragment_5(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
    debug.trace("[SA] Activate container")
    float r = Utility.RandomFloat(0, 100)
    If r < TA_MCM.containerProbability || true
        TA_Library.TransformEquipped(akActor, None, false)
    EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

TA_MCMConfig Property TA_MCM Auto