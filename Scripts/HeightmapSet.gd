@tool
extends StaticBody3D

@export var update := false
@onready var heightmapCollider := $HeightmapCol


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		#editor code
		if(update):
			update = false
			_updateCollisionMesh()

func _updateCollisionMesh():
	var heightmapShape : HeightMapShape3D = heightmapCollider.get_shape()
	var heightScale : float = RenderingServer.global_shader_parameter_get("HeightScale")
	var heightOff : float = RenderingServer.global_shader_parameter_get("HeightOffset")
	
	var heightMin := heightOff - (0.5 * heightScale)
	var heightMax := heightOff + (0.5 * heightScale)
	var heightmap : Texture2D = RenderingServer.global_shader_parameter_get("Heightmap")
	var img := Image.new()
	img.copy_from(heightmap.get_image())
	img.resize(25,25)
	img.convert(Image.FORMAT_RF)
	heightmapShape.update_map_data_from_image(img,heightMin,heightMax)
	
	
