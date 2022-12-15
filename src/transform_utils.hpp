#pragma once

#include "json.hpp"
#include <string>
#include <vector>

namespace TransformUtils {
struct Article {
    std::string name;
    int32_t formID;
    uint32_t slots;
    bool enchanted;
    RE::TESObjectARMO *form;

    Article(){};
    Article(RE::TESObjectARMO *armor);
};

struct Outfit {
    std::vector<Article> articles;
    void Equip(RE::Actor *actor, bool unequip = true, bool add_to_inventory = true) const;
};

typedef std::unordered_map<std::string, std::unordered_map<std::string, Article>> armor_record_t;
typedef std::vector<std::vector<Article>> transform_target_t;

void LoadArmors();
void LoadTransforms();
void DumpArmors();
armor_record_t &GetLoadedArmors();
bool TransformArmor(RE::Actor *actor, RE::TESObjectARMO *armor);

void to_json(nlohmann::json &j, const Article &a);
void from_json(const nlohmann::json &j, transform_target_t &a);
} // namespace TransformUtils
