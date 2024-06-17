extends Node

const UPGRADES_PATH = ""
const WEAPON_PATH = "res://assets/sprites/Attacks/"
const UPGRADES = {
	"ice_spear1": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Ice Spear",
		"description": "A spear of ice is thrown at a random enemy",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"ice_spear2": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Ice Spear",
		"description": "An addition Ice Spear is thrown",
		"level": "Level: 2",
		"prerequisite": ["ice_spear1"],
		"type": "weapon"
	},
	"ice_spear3": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Ice Spear",
		"description": "Ice Spears now pass through another enemy and do + 3 damage",
		"level": "Level: 3",
		"prerequisite": ["ice_spear2"],
		"type": "weapon"
	},
	"ice_spear4": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Ice Spear",
		"description": "An additional 2 Ice Spears are thrown",
		"level": "Level: 4",
		"prerequisite": ["ice_spear3"],
		"type": "weapon"
	},
	"javelin1": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Javelin",
		"description": "A magical javelin will follow you attacking enemies in a straight line",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"javelin2": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Javelin",
		"description": "The javelin will now attack an additional enemy per attack",
		"level": "Level: 2",
		"prerequisite": ["javelin1"],
		"type": "weapon"
	},
	"javelin3": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Javelin",
		"description": "The javelin will attack another additional enemy per attack",
		"level": "Level: 3",
		"prerequisite": ["javelin2"],
		"type": "weapon"
	},
	"javelin4": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Javelin",
		"description": "The javelin now does + 5 damage per attack and causes 20% additional knockback",
		"level": "Level: 4",
		"prerequisite": ["javelin3"],
		"type": "weapon"
	},
	"tornado1": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Tornado",
		"description": "A tornado is created and random heads somewhere in the players direction",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"tornado2": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Tornado",
		"description": "An additional Tornado is created",
		"level": "Level: 2",
		"prerequisite": ["tornado1"],
		"type": "weapon"
	},
	"tornado3": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Tornado",
		"description": "The Tornado cooldown is reduced by 0.5 seconds",
		"level": "Level: 3",
		"prerequisite": ["tornado2"],
		"type": "weapon"
	},
	"tornado4": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Tornado",
		"description": "An additional tornado is created and the knockback is increased by 25%",
		"level": "Level: 4",
		"prerequisite": ["tornado3"],
		"type": "weapon"
	},
	"armor1": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Armor",
		"description": "Reduces Damage By 1 point",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Armor",
		"description": "Reduces Damage By an additional 1 point",
		"level": "Level: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Armor",
		"description": "Reduces Damage By an additional 1 point",
		"level": "Level: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Armor",
		"description": "Reduces Damage By an additional 1 point",
		"level": "Level: 4",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"speed1": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Speed",
		"description": "Movement Speed Increased by 10% of base speed",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"speed2": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Speed",
		"description": "Movement Speed Increased by an additional 10% of base speed",
		"level": "Level: 2",
		"prerequisite": ["speed1"],
		"type": "upgrade"
	},
	"speed3": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Speed",
		"description": "Movement Speed Increased by an additional 10% of base speed",
		"level": "Level: 3",
		"prerequisite": ["speed2"],
		"type": "upgrade"
	},
	"speed4": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Speed",
		"description": "Movement Speed Increased an additional 10% of base speed",
		"level": "Level: 4",
		"prerequisite": ["speed3"],
		"type": "upgrade"
	},
	"tome1": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Tome",
		"description": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"tome2": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Tome",
		"description": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 2",
		"prerequisite": ["tome1"],
		"type": "upgrade"
	},
	"tome3": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Tome",
		"description": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 3",
		"prerequisite": ["tome2"],
		"type": "upgrade"
	},
	"tome4": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Tome",
		"description": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 4",
		"prerequisite": ["tome3"],
		"type": "upgrade"
	},
	"scroll1": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Scroll",
		"description": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"scroll2": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Scroll",
		"description": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 2",
		"prerequisite": ["scroll1"],
		"type": "upgrade"
	},
	"scroll3": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Scroll",
		"description": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 3",
		"prerequisite": ["scroll2"],
		"type": "upgrade"
	},
	"scroll4": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Scroll",
		"description": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 4",
		"prerequisite": ["scroll3"],
		"type": "upgrade"
	},
	"ring1": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Ring",
		"description": "Your spells now spawn 1 more additional attack",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"ring2": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Ring",
		"description": "Your spells now spawn an additional attack",
		"level": "Level: 2",
		"prerequisite": ["ring1"],
		"type": "upgrade"
	},
	"food": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"display_name": "Food",
		"description": "Heals you for 20 health",
		"level": "",
		"prerequisite": [],
		"type": "item"
	}
}
