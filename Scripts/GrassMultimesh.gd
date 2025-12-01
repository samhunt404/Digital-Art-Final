@tool
extends MultiMeshInstance3D

@export var count : Vector2i
@export var size : float
@export var spawn : bool
@export var clear : bool
func _process(_delta : float) -> void:
	if Engine.is_editor_hint():
		#code to run in editor
		if spawn:
			spawn = false
			_spawn_grass()
		if clear:
			clear = false
			_reset()
func _spawn_grass() -> void:
	var heightmap : Texture2D = RenderingServer.global_shader_parameter_get("Heightmap")
	var heightoff : float = RenderingServer.global_shader_parameter_get("HeightOffset")
	var heightscale : float = RenderingServer.global_shader_parameter_get("HeightScale")
	
	multimesh.instance_count = count.x * count.y
	print("Spawning %s grass instance(s)" % [multimesh.instance_count])
	for i in range(0,multimesh.instance_count):
		var x = i % count.x;
		var y = i / count.y;
		#set color, uv for wind shader
		multimesh.set_instance_color(i,Color(x/float(count.x),y/float(count.y),0.0));
		randomize()
		
		var yoff = (heightmap.get_image().get_pixelv(Vector2(x,y)/Vector2(count) * 256.0).v + heightoff) * heightscale
		var offset := Vector3(randf_range(0.0,1.0),yoff,randf_range(0.0,1.0)) * Vector3(1.0/float(count.x),1.0,1.0/float(count.y))
		var pos := Vector3(float(x)/count.x * size,0.0,float(y)/count.y * size)
		pos += offset * Vector3(100.0,1.0,100.0)
		if i % 13 == 0 and i % 7 == 0:
			print(offset)
		var currTransform : Transform3D
		currTransform = currTransform.translated(pos)
		
		multimesh.set_instance_transform(i,currTransform)

func _reset() -> void:
	multimesh.instance_count = 0;
	multimesh.buffer.clear()
	
