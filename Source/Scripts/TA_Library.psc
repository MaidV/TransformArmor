Scriptname TA_Library

Function TransformEquipped(Actor Target, Actor Caster, bool voluntary = true) global
    Form pureForm = Target.GetWornForm(4)
    if (TransformUtils.TransformArmor(Target, pureForm))
        if !voluntary
            Debug.notification(pureForm.GetName() + " was transformed!")
        endif
        Target.RemoveItem(pureForm, 1, True)
    endif
EndFunction
