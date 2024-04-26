extends CharacterBody2D

class_name Player

const my_scene: PackedScene = preload("res://scenes/player.tscn")

const PIVOT_OFFSET = 32

const GRAVITY: int = 50
const BASE_SPEED: int = 500
const BASE_JUMP_FORCE: int = 1000
const BASE_PUNCH_FORCE: int = 600

@onready var animation = $AnimationTree.get("parameters/playback")

var game
var ball
var x: int
var stats: Stats
var hp: float

var inactive: bool = true
var input_x: float = 0

static func new_player(player_stats: Stats, player_x, game_object, game_ball) -> Player:
    var player: Player = my_scene.instantiate()
    player.set_stats(player_stats)
    player.x = player_x
    player.game = game_object
    player.ball = game_ball
    player.hp = player.stats.max_health
    player.get_node("Pivot").position.x = PIVOT_OFFSET * (-1 if player_x == 1 else 1)
    return player

func set_stats(player_stats: Stats):
    stats = player_stats
    $Sprite2D.set_texture(load(stats.sprites_path))

func flip_h(flipped: bool):
    if flipped != $Sprite2D.flip_h:
        $Sprite2D.flip_h = flipped
        $Sprite2D.position.x = -$Sprite2D.position.x

func attack() -> float:
    return stats.base_attack

func hurt(base_damages: float) -> bool:
    """return True if player is dead"""
    hp -= base_damages / stats.damage_reduction
    var isDead = hp <= 0
    animation.travel("death" if isDead else "hurt")
    return isDead

func die():
    set_physics_process(false)
    animation.travel("die")

func _physics_process(_delta):

    input_x = Input.get_action_strength("p"+str(x)+"_right") \
            - Input.get_action_strength("p"+str(x)+"_left") if not inactive else 0.0

    # Horizontal movement
    velocity.x = input_x * BASE_SPEED * stats.speed_coef

    # Vertical movement
    velocity.y += GRAVITY
    if not inactive and Input.is_action_pressed("p"+str(x)+"_jump") and is_on_floor():
        velocity.y = -BASE_JUMP_FORCE * stats.jump_force_coef
        animation.travel("jump")

    if velocity.x != 0:
        flip_h(input_x<0)

    move_and_slide()

func _input(event):
    if event.is_action_pressed("p"+str(x)+"_shoot"):
        if self in ball.get_node("PunchArea").get_overlapping_bodies():
            if game.is_kick_off():
                game.start()
            if game.is_playing():
                ball.linear_velocity = (ball.position - $Pivot.global_position).normalized() * BASE_PUNCH_FORCE * stats.punch_force_coef
