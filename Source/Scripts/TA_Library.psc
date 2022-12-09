Scriptname TA_Library

Form[] Function GetOutfit(Actor Target) Global Native

Function TransformEquipped(Actor Target, Actor Caster, bool voluntary = true) global
    Form pureForm = Target.GetWornForm(4)
    OutfitServer.TransformArmor(Target, pureForm)
EndFunction
