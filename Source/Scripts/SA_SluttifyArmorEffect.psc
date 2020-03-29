Scriptname SA_SluttifyArmorEffect extends ActiveMagicEffect
{Converts armor to sluttified version}

Event OnEffectStart(Actor Target, Actor Caster)
	Form pureClothes = Target.GetWornForm(4)
	Int pureIndex = JsonUtil.FormListFind("Sluttify Armor/ArmorMap.json", "pure", pureClothes)
	Form slutClothes = JsonUtil.FormListGet("Sluttify Armor/ArmorMap.json", "Slutty", pureIndex)
	
	; Name will be empty on invalid forms
	If slutClothes.GetName() == ""
		Debug.MessageBox("Unable to find slut variant of " + pureClothes.GetName() + ".")
		return
	EndIf
	
	Int slotMask = 4
  	If (pureIndex >= 0)
       	Debug.MessageBox("Sluttifying " + pureClothes.GetName() + ". All that excess material was too constricting anyway.")
		Float health = WornObject.GetItemHealthPercent(Target, 0, slotMask)
		Enchantment sourceEnchant = WornObject.GetEnchantment(Target, 0, slotMask)
		Float sourceMaxCharge = WornObject.GetItemMaxCharge(Target, 0, slotMask)

		If (slutClothes != None)
			Target.RemoveItem(pureClothes)
			Target.EquipItem(slutClothes)
			WornObject.SetItemHealthPercent(Target, 0, slotMask, health)
			WornObject.SetEnchantment(Target, 0, slotMask, sourceEnchant, sourceMaxCharge)
		EndIf
	Else
		Debug.MessageBox("Failed to sluttify " + pureClothes.GetName() + ".")
	EndIf
	
EndEvent
