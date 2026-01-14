extends Node

class_name SkillManager

var skills: Dictionary = {}

const SKILL_DATA = {
    "tactical_insight": {
        "skill_id": 1,
        "name": "Tactical Insight",
        "description": "+10% information accuracy per level",
        "skill_type": "passive",
        "magnitude": 0.1,
        "range": 0.0,
        "level": 1,
        "max_level": 5,
        "carry_over_percentage": 0.5
    },
    "charisma": {
        "skill_id": 2,
        "name": "Charisma",
        "description": "+5% ally combat effectiveness per level",
        "skill_type": "passive",
        "magnitude": 0.05,
        "range": 5.0,
        "level": 1,
        "max_level": 5,
        "carry_over_percentage": 0.6
    }
}

func _ready() -> void:
    initialize_skills()

func initialize_skills() -> void:
    for skill_name in SKILL_DATA:
        skills[skill_name] = SKILL_DATA[skill_name].duplicate()
    
    GameManager.game_state["skills"] = skills

func get_skill(skill_name: String) -> Dictionary:
    if skill_name in skills:
        return skills[skill_name].duplicate()
    return {}

func get_skill_level(skill_name: String) -> int:
    if skill_name in skills:
        return skills[skill_name]["level"]
    return 0

func upgrade_skill(skill_name: String) -> bool:
    if not (skill_name in skills):
        return false
    
    var skill = skills[skill_name]
    if skill["level"] >= skill["max_level"]:
        return false
    
    skill["level"] += 1
    GameManager.game_state["skills"] = skills
    GameManager.log_event("skill_upgrade", {
        "skill": skill_name,
        "new_level": skill["level"]
    })
    
    return true

func get_skill_effect(skill_name: String) -> float:
    if not (skill_name in skills):
        return 0.0
    
    var skill = skills[skill_name]
    return skill["magnitude"] * skill["level"]

func apply_skill_effects() -> void:
    for skill_name in skills:
        apply_skill_effect(skill_name)

func apply_skill_effect(skill_name: String) -> void:
    var skill = skills[skill_name]
    
    match skill_name:
        "tactical_insight":
            apply_tactical_insight()
        "charisma":
            apply_charisma()

func apply_tactical_insight() -> void:
    var accuracy_bonus = get_skill_effect("tactical_insight")
    GameManager.game_state["information_accuracy_bonus"] = accuracy_bonus

func apply_charisma() -> void:
    var combat_bonus = get_skill_effect("charisma")
    GameManager.game_state["combat_bonus"] = combat_bonus

func get_all_skills() -> Array:
    var skill_list = []
    for skill_name in skills:
        skill_list.append(skills[skill_name].duplicate())
    return skill_list

func get_skill_description(skill_name: String) -> String:
    if not (skill_name in skills):
        return "Unknown skill"
    
    var skill = skills[skill_name]
    return "%s (Level %d/%d): %s" % [skill["name"], skill["level"], skill["max_level"], skill["description"]]
