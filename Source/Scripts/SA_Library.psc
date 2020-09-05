Scriptname SA_Library

Function SluttifyEquipped(Actor Target, Actor Caster, bool voluntary = true) global
    Form pureForm = Target.GetWornForm(4)
    If pureForm == None
        If voluntary
            Debug.Notification("Can't sluttify armor if you're naked!")
        EndIf
        return
    EndIf

    int armorMap = JDB.solveObj(".SA.ArmorMap")
    int outfitGroup = JFormMap.getObj(armorMap, pureForm)
    int outfitSlot = JIntMap.nextKey(outfitGroup)

    If outfitSlot == 0
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

    Debug.Trace("[SA] Reading in outfit for " + pureForm.GetName())
    while outfitSlot != 0
        int slotList = JIntMap.getObj(outfitGroup, outfitSlot)
        Debug.Trace("[SA] Found item(s) in slot " + (outfitSlot as string) + ".")

        int j = JArray.count(slotList)
        while j > 0
            j -= 1
            Armor slutArmor = JArray.getForm(slotList, j) as Armor
            Target.EquipItem(slutArmor, false, true)
            Debug.trace("[SA] Equipped armor: " + slutArmor.GetName())
        endwhile

        outfitSlot = JIntMap.nextKey(outfitGroup, outfitSlot)
    endwhile

    ; ; Crashes randomly if you don't wait a bit to temper the armor. Probably conflicting with mods that
    ; ; modify incoming armor (MWA, specifically)
    ; Utility.Wait(0.5)
    ; If health != 1.0
    ;     WornObject.SetItemHealthPercent(Target, 0, slotMask, health)
    ;     Debug.trace("[SA] Tempered armor: " + slutForm.GetName() + " to " + (health as string))
    ; EndIf
    ; If sourceEnchant != None
    ;     WornObject.SetEnchantment(Target, 0, slotMask, sourceEnchant, sourceMaxCharge)
    ;     Debug.trace("[SA] Enchanted armor: " + slutForm.GetName())
    ; EndIf
    Target.QueueNiNodeUpdate()

    Debug.Notification(pureForm.GetName() + " has been Sluttified!")
EndFunction
