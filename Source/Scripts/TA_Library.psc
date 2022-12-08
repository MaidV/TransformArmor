Scriptname TA_Library

Form[] Function GetOutfit(Actor Target) Global Native

Function TransformEquipped(Actor Target, Actor Caster, bool voluntary = true) global
    Form pureForm = Target.GetWornForm(4)
    If pureForm == None
        Form[] newOutfit = GetOutfit(Target)
        Debug.Notification("New outfit is" + newOutfit.Length)
        int i = 0
        while i < newOutfit.Length
            Target.EquipItem(newOutfit[i], false, true)
            Debug.trace("[TA] Equipped armor: " + newOutfit[i].GetName())
            i += 1
        endwhile
        Target.QueueNiNodeUpdate()
        If voluntary
            Debug.Notification("Can't transform armor if you're naked!")
        EndIf
        return
    EndIf

    int armorMap = JDB.solveObj(".SA.ArmorMap")
    int outfitGroup = JFormMap.getObj(armorMap, pureForm)

    Int slotMask = 4
    Float health = WornObject.GetItemHealthPercent(Target, 0, slotMask)
    Enchantment sourceEnchant = WornObject.GetEnchantment(Target, 0, slotMask)
    Float sourceMaxCharge = WornObject.GetItemMaxCharge(Target, 0, slotMask)

    Debug.Trace("[TA] Reading in outfit for " + pureForm.GetName())
    Form[] newOutfit = TA_Outfit.constructRandomOutfit(outfitGroup)
    if newOutfit.length == 0
        if voluntary
            Debug.Notification("Unable to find transformed variant of " + pureForm.GetName() + ".")
        endif
        return
    endif
    Debug.trace("[TA] Found armor target")
    Target.RemoveItem(pureForm, 1, true)
    Debug.trace("[TA] Removed item: " + pureForm.GetName())

    int i = 0
    while i < newOutfit.Length
        Target.EquipItem(newOutfit[i], false, true)
        Debug.trace("[TA] Equipped armor: " + newOutfit[i].GetName())
        i += 1
    endwhile

    Target.QueueNiNodeUpdate()

    Debug.Notification(pureForm.GetName() + " has been Transformed!")
EndFunction
