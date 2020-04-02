Scriptname SA_Library

Function SluttifyEquipped(Actor Target, Actor Caster, bool voluntary = true) global
    Form pureClothes = Target.GetWornForm(4)
    If pureClothes == None
        If voluntary
            Debug.Notification("Can't sluttify armor if you're naked!")
        EndIf
        return
    EndIf

    Form slutClothes = JFormDB.getForm(pureClothes, ".SA_ArmorMap.slutForm")

    If slutClothes == None
        If voluntary
            Debug.Notification("Unable to find slut variant of " + pureClothes.GetName() + ".")
        EndIf
        return
    EndIf

    Int slotMask = 4
    Float health = WornObject.GetItemHealthPercent(Target, 0, slotMask)
    Enchantment sourceEnchant = WornObject.GetEnchantment(Target, 0, slotMask)
    Float sourceMaxCharge = WornObject.GetItemMaxCharge(Target, 0, slotMask)

    Debug.trace("[SA] Found slut armor: " + slutClothes.GetName())
    Target.RemoveItem(pureClothes, 1, true)
    Debug.trace("[SA] Removed item: " + pureClothes.GetName())
    Target.EquipItem(slutClothes, false, true)
    Debug.trace("[SA] Equipped armor: " + slutClothes.GetName())

    ; Crashes randomly if you don't wait a bit to temper the armor. Probably conflicting with mods that
    ; modify incoming armor (MWA, specifically)
    Utility.Wait(0.5)
    If health != 1.0
        WornObject.SetItemHealthPercent(Target, 0, slotMask, health)
        Debug.trace("[SA] Tempered armor: " + slutClothes.GetName() + " to " + (health as string))
    EndIf
    If sourceEnchant != None
        WornObject.SetEnchantment(Target, 0, slotMask, sourceEnchant, sourceMaxCharge)
        Debug.trace("[SA] Enchanted armor: " + slutClothes.GetName())
    EndIf

    Debug.MessageBox("Sluttified " + pureClothes.GetName() + ". All that excess material was too constricting anyway.")
EndFunction
