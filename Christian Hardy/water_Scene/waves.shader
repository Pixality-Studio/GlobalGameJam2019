shader_type canvas_item;


//render_mode blend_mix;'


 uniform vec2 tiled_factor = vec2(5.0, 5.0);
 uniform float aspect_ratio = 0.5;
 uniform vec2 time_scale = vec2(1.0,1.0);

 uniform vec2 offset = vec2(2.0, 2.0);
 uniform vec2 amplitude = vec2(0.2,0.2);


void fragment(){
	
	
	//setting the colors
	vec2 tiled_uvs = UV * tiled_factor;
	tiled_uvs.y *= aspect_ratio;
	
	vec2 waves_uv_offset;
	waves_uv_offset.x = cos(TIME * time_scale.x + (tiled_uvs.x + tiled_uvs.y) * offset.x);
	waves_uv_offset.y = sin(TIME + time_scale.y + (tiled_uvs.x + tiled_uvs.y) * offset.y);
	
	COLOR = texture(TEXTURE, tiled_uvs + waves_uv_offset * amplitude);
	
	
//	COLOR = vec4(waves_uv_offset , 0.0, 1.0) ;
	
}
