#!/usr/bin/env python3

import json
import itertools

with open('TransformUtils_Armors_Dump.json') as f:
    allarmor = json.load(f)

def filter_armors(armor, search, slots, prefix=False):
    if prefix:
        return armor['name'].lower().startswith(search.lower()) and \
            set(slots).intersection(set(armor['slots']))
    else:
        return search.lower() in armor['name'].lower() and \
            set(slots).intersection(set(armor['slots']))

def get_armors(db, search_strings, excludes=None, prefix=False):
    if not excludes:
        excludes = []
    if isinstance(search_strings, str):
        prefixes = [search_strings]

    armors = {}
    for mod in ['Skyrim.esm', 'Dawnguard.esm', 'Dragonborn.esm', 'Update.esm', 'Unofficial Skyrim Special Edition Patch.esp']:
        for string in search_strings:
            for armor in filter(lambda armor: filter_armors(armor, string, [32, 52], prefix), db[mod].values()):
                if armor['name'] not in excludes:
                    armors[mod + '|' + armor['formID']] = armor['name']
    return armors

def get_bikini_gen(db, prefixes, slot):
    if isinstance(prefixes, str):
        prefixes = [prefixes]

    armors = {}
    mod = 'The Amazing World of Bikini Armors REMASTERED.esp'
    for prefix in prefixes:
        for armor in filter(lambda armor: filter_armors(armor, prefix, [slot]), db[mod].values()):
            armors[mod + '|' + armor['formID']] = armor['name']
    return armors

def get_bikini_top(db, prefix):
    return get_bikini_gen(db, prefix, 32)

def get_bikini_bottom(db, prefix):
    return get_bikini_gen(db, prefix, 52)


tops, armors, bottoms = {}, {}, {}

armors['hide'] = get_armors(allarmor, ['Hide', 'Fur Armor'])
tops['hide'] = get_bikini_top(allarmor, 'Hide')
bottoms['hide'] = get_bikini_bottom(allarmor, 'Hide')


armors['leather'] = get_armors(allarmor, ['Leather',
                                          'Imperial Light',
                                          "Riften Guard's Armor",
                                          "Markarth Guard's Armor",
                                          "Whiterun Guard's Armor",
                                          "Falkreath Guard's Armor",
                                          "Hjaalmarch Guard's Armor",
                                          "Winterhold Guard's Armor",
                                          "Stormcloak Cuirass",
                                          "Studded Armor",
                                          "Studded Imperial Armor",
                                          "Scaled"])
tops['leather'] = get_bikini_top(allarmor, ['Leather'])
bottoms['leather'] = get_bikini_bottom(allarmor, ['Leather'])

armors['iron'] = get_armors(allarmor, ['Iron', 'Banded Iron'])
tops['iron'] = get_bikini_top(allarmor, ['Iron'])
bottoms['iron'] = get_bikini_bottom(allarmor, ['Iron'])

armors['steel'] = get_armors(allarmor, ['Steel Armor', 'Imperial Armor'], excludes=["Studded Imperial Armor"])
tops['steel'] = get_bikini_top(allarmor, ['Steel Bikini'])
bottoms['steel'] = get_bikini_bottom(allarmor, 'Steel')

armors['dwarven'] = get_armors(allarmor, ['Dwarven'])
tops['dwarven'] = get_bikini_top(allarmor, ['Dwarven Bikini'])
bottoms['dwarven'] = get_bikini_bottom(allarmor, ['Dwarven Bikini'])

armors['ebony'] = get_armors(allarmor, ['Ebony'])
tops['ebony'] = get_bikini_top(allarmor, ['Ebony Bikini'])
bottoms['ebony'] = get_bikini_bottom(allarmor, ['Ebony'])

armors['wolf'] = get_armors(allarmor, ['Wolf'])
tops['wolf'] = get_bikini_top(allarmor, ['Wolf'])
bottoms['wolf'] = get_bikini_bottom(allarmor, ['Wolf'])

armors['orcish'] = get_armors(allarmor, ['Orcish'])
tops['orcish'] = get_bikini_top(allarmor, ['Orcish Bikini'])
bottoms['orcish'] = get_bikini_bottom(allarmor, ['Orcish'])

armors['dragon'] = get_armors(allarmor, ['Dragonplate'])
tops['dragon'] = get_bikini_top(allarmor, ['Dragon Bone Bikini Top'])
bottoms['dragon'] = get_bikini_bottom(allarmor, ['Dragon Bone'])

armors['nord'] = get_armors(allarmor, ['Nordic'])
tops['nord'] = get_bikini_top(allarmor, ['Nord Plate Bikini'])
bottoms['nord'] = get_bikini_bottom(allarmor, ['Nord Plate'])

transforms = {}
for key in armors.keys():
    src_armors = armors[key]
    trg_tops = tops[key]
    trg_bottoms = bottoms[key]

    for form,name in src_armors.items():
         transforms[form] = list(itertools.product(trg_tops.keys(), trg_bottoms.keys()))

with open('Vanilla-Bikini.json', 'w', encoding ='utf8') as json_file:
    json.dump(transforms, json_file, indent=2)

G3Barmors = {}
mod = 'Ghaan Revealing Outfit Craftable.esp'
for armor in filter(lambda armor: filter_armors(armor, "G3B", [32, 52]), allarmor[mod].values()):
    G3Barmors[mod + '|' + armor['formID']] = {"name": armor['name'], "slots": armor['slots']}

g3btransforms = {}
for key, val in G3Barmors.items():
    basename = val['name'].split(maxsplit=1)[1]
    for src_armor in get_armors(allarmor, [basename], prefix=True):
        g3btransforms[src_armor] = [[key,]]

with open('Vanilla-G3B.json', 'w', encoding ='utf8') as json_file:
    json.dump(g3btransforms, json_file, indent=2)

BDarmors = {}
mod = 'BD Standalone.esp'
for armor in filter(lambda armor: filter_armors(armor, "", [32]), allarmor[mod].values()):
    BDarmors[mod + '|' + armor['formID']] = {"name": armor['name'], "slots": armor['slots']}

BDtransforms = {}
for key, val in BDarmors.items():
    basename = val['name'].split(' - ')[0]
    for src_armor in get_armors(allarmor, [basename], prefix=True):
        BDtransforms[src_armor] = [[key,]]

with open('Vanilla-BD.json', 'w', encoding ='utf8') as json_file:
    json.dump(BDtransforms, json_file, indent=2)


CT77armors = {}
mod = 'Remodeled Armor.esp'
for armor in filter(lambda armor: filter_armors(armor, "", [32]), allarmor[mod].values()):
    CT77armors[mod + '|' + armor['formID']] = {"name": armor['name'], "slots": armor['slots']}

CT77transforms = {}
for key, val in CT77armors.items():
    basename = val['name'].split(' - ')[0]
    for src_armor in get_armors(allarmor, [basename], prefix=True):
        CT77transforms[src_armor] = [[key,]]

with open('Vanilla-CT77.json', 'w', encoding ='utf8') as json_file:
    json.dump(CT77transforms, json_file, indent=2)


merged = {}
for baseform,bikinis in transforms.items():
    if baseform in BDtransforms.keys():
        bd_form = BDtransforms[baseform][0][0]
        merged[baseform] = BDtransforms[baseform]
        merged[bd_form] = bikinis
    if baseform in g3btransforms.keys():
        g3b_form = g3btransforms[baseform][0][0]
        if baseform in merged:
            merged[baseform].append([g3b_form])
        else:
            merged[baseform] = g3btransforms[baseform]
        merged[g3b_form] = bikinis

    if baseform in CT77transforms.keys():
        CT77_form = CT77transforms[baseform][0][0]
        if baseform in merged:
            merged[baseform].append([CT77_form])
        else:
            merged[baseform] = CT77transforms[baseform]
        merged[CT77_form] = bikinis


    if baseform not in merged:
        merged[baseform] = bikinis


with open('Vanilla-G3B_BD_CT77-Bikini.json', 'w', encoding ='utf8') as json_file:
    json.dump(merged, json_file, indent=2)
