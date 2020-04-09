Scriptname SA_Library

Function SluttifyEquipped(Actor Target, Actor Caster, bool voluntary = true) global
    Form pureForm = Target.GetWornForm(4)
    If pureForm == None
        If voluntary
            Debug.Notification("Can't sluttify armor if you're naked!")
        EndIf
        return
    EndIf

    int slutFormList = JFormDB.solveObj(pureForm, ".SA_ArmorMap.slutForm")

    If slutFormList == 0
        If voluntary
            Debug.Notification("Unable to find slut variant of " + pureForm.GetName() + ".")
        EndIf
        return
    EndIf

    Int slotMask = 4
    Float health = WornObject.GetItemHealthPercent(Target, 0, slotMask)
    Enchantment sourceEnchant = WornObject.GetEnchantment(Target, 0, slotMask)
    Float sourceMaxCharge = WornObject.GetItemMaxCharge(Target, 0, slotMask)

    Debug.trace("[SA] Found slut armor")
    Target.RemoveItem(pureForm, 1, true)
    Debug.trace("[SA] Removed item: " + pureForm.GetName())

    Int count = JArray.count(slutFormList)
    Form slutForm
    While count > 0
        count -= 1
        slutForm = JArray.getForm(slutFormList, count)
        Target.EquipItem(slutForm, false, true)
        Debug.trace("[SA] Equipped armor: " + slutForm.GetName())
    EndWhile

    ; Crashes randomly if you don't wait a bit to temper the armor. Probably conflicting with mods that
    ; modify incoming armor (MWA, specifically)
    Utility.Wait(0.5)
    If health != 1.0
        WornObject.SetItemHealthPercent(Target, 0, slotMask, health)
        Debug.trace("[SA] Tempered armor: " + slutForm.GetName() + " to " + (health as string))
    EndIf
    If sourceEnchant != None
        WornObject.SetEnchantment(Target, 0, slotMask, sourceEnchant, sourceMaxCharge)
        Debug.trace("[SA] Enchanted armor: " + slutForm.GetName())
    EndIf
    Target.QueueNiNodeUpdate()

    Debug.MessageBox("Sluttified " + pureForm.GetName() + ". All that excess material was too constricting anyway.")
EndFunction
