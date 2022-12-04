Scriptname TA_TransformArmorEffect extends ActiveMagicEffect
{Converts armor to sluttified version}

Event OnEffectStart(Actor Target, Actor Caster)
    TA_Library.TransformEquipped(Target, Caster, true)

    ; string[] par = new string[2]
    ; https://www.reddit.com/r/skyrimmods/comments/4cgv9h/no_documentation_for_uie/
    ; https://pastebin.com/GsMcgGTA
    ; par[0] = "foo"
    ; par[1] = "bar"
    ; UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
    ; int fooind = listMenu.AddEntryItem(par[0])
    ; listMenu.AddEntryItem(par[1])
    ; listMenu.SetPropertyIndexBool("hasChildren", fooind, true)
    ; listMenu.AddEntryItem("moo", fooind, 0)
    
    ; int ret = UIExtensions.OpenMenu("UIListMenu")
    ; Debug.Trace("Option " + ret + " selectioned")
EndEvent
