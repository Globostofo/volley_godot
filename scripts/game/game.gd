extends Node2D

enum {
    KICK_OFF,
    PLAYING,
    ROUND_OVER,
    GAME_OVER
}

@onready var kick_off_label = $CanvasLayer/GUI/KickOffLabel

var state
var left_player: Player
var right_player: Player
var update_timer_label: bool = false
var life_bars: Dictionary = {}

var game_winner: Player = null

func _ready():
    left_player = Player.new_player(Characters.characters[0], 1, self, $Ball)
    left_player.set_name("LeftPlayer")		# node name
    add_child(left_player)
    life_bars[left_player] = $CanvasLayer/GUI/LifeBars/HBoxContainer/LeftLifeBar
    life_bars[left_player].init(left_player.stats.max_health)

    right_player = Player.new_player(Characters.characters[1], 2, self, $Ball)
    right_player.set_name("RightPlayer")	# node name
    add_child(right_player)
    life_bars[right_player] = $CanvasLayer/GUI/LifeBars/HBoxContainer/RightLifeBar
    life_bars[right_player].init(right_player.stats.max_health)
    life_bars[right_player].flip(true)
    
    init_kick_off()

func _draw():
    draw_rect(
        Rect2($Net.position-$Net/CollisionShape2D.shape.size/2, $Net/CollisionShape2D.shape.size),
        Color.WHITE
    )

func is_kick_off() -> bool:
    return state == KICK_OFF

func is_playing() -> bool:
    return state == PLAYING

func init_kick_off():
    state = KICK_OFF
    left_player.inactive = true
    left_player.position = Vector2(100, 670)
    left_player.flip_h(false)
    right_player.inactive = true
    right_player.position = Vector2(1180, 670)
    right_player.flip_h(true)
    $Ball.freeze = true
    $Ball.position = Vector2(640, 420)
    $Ball.physics_material_override.bounce = 1
    $KickOffTimer.start()
    update_timer_label = true
    kick_off_label.text = str($KickOffTimer.wait_time)
    kick_off_label.show()

func start():
    state = PLAYING
    $Ball.freeze = false

func end_round(winner: Player, loser: Player):
    $Ball.physics_material_override.bounce = 0.6
    $RoundOverTimer.start()
    winner.animation.travel("attack1")
    var loser_is_dead = loser.hurt(winner.attack())
    life_bars[loser].target = loser.hp
    if loser_is_dead:
        state = GAME_OVER
        game_winner = winner
        loser.inactive = true
        loser.animation.travel("death")
    else:
        state = ROUND_OVER
        loser.animation.travel("hurt")

func _process(_delta):
    if update_timer_label:
        kick_off_label.text = str(ceil($KickOffTimer.time_left))

func _on_left_ground_body_entered(_body):
    if state == PLAYING:
        end_round(right_player, left_player)

func _on_right_ground_body_entered(_body):
    if state == PLAYING:
        end_round(left_player, right_player)

func _on_kick_off_timer_timeout():
    left_player.inactive = false
    right_player.inactive = false
    $KickOffGoTimer.start()
    update_timer_label = false
    kick_off_label.text = "Go!"

func _on_kick_off_go_timer_timeout():
    kick_off_label.hide()

func _on_round_over_timer_timeout():
    if state == ROUND_OVER:
        init_kick_off()
    else:
        pass
