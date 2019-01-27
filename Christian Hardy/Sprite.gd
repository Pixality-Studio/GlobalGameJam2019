tool
extends Sprite


func _ready():
	pass


func _on_water_item_rect_changed():
	print("x")
	Material.set_shader_parem("aspect_ratio", scale.y / scale.x)