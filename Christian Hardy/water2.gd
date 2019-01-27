tool
extends Sprite


func _ready():
	pass





func _on_water_item_rect_changed(): #changes the shader apect so it keeps it's scale
	Material.set_shader_param("aspect_ratio", scale.y / scale.x)

