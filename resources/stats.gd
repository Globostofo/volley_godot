extends Resource

class_name Stats

@export_group("Character")
@export var name: String = "name"
@export var description: String = "description"
@export var skills: String = """skills"""

@export_group("Statistics")
@export var max_health: float = 100.0
@export var base_attack: float = 10.0
@export var damage_reduction: float = 1.0
@export var heal: float = 0.0
@export var speed_coef: float = 1.0
@export var jump_force_coef: float = 1.0
@export var punch_force_coef: float = 1.0

@export_group("Custom events")
@export_range(0, 1, 0.01) var critical_chance: float = 0.0
@export_range(0, 1, 0.01) var dodge_chance: float = 0.0

@export_group("Visual")
@export var sprites_path: String
