@tool
extends EditorPlugin

const Utils := preload("utils.gd")


class ExampleEditorDebugger extends EditorDebuggerPlugin:

	const OVERRIDE_CAMERA_2D_BUTTON_INDEX: int = 16
	const OVERRIDE_CAMERA_3D_BUTTON_INDEX: int = 11
	var override_camera_2d_button: Button = null
	var override_camera_3d_button: Button = null

	func _on_session_started():
		var editor_scene_root = EditorInterface.get_edited_scene_root()
		var playing_scene: String = EditorInterface.get_playing_scene()
		var editing_scene: String = editor_scene_root.scene_file_path

		# Ignore if the scene being edited is not the one playing:
		if editing_scene != playing_scene:
			return

		# Ignore if it's the main scene:
		if editing_scene == ProjectSettings.get_setting("application/run/main_scene"):
			return

		# Ignore GUI scenes:
		if editor_scene_root is Control:
			return

		elif editor_scene_root is Node2D:

			# Ignore if the scene has a camera:
			var camera_2d = Utils.find_child_by_type(EditorInterface.get_edited_scene_root(), "Camera2D")
			if camera_2d:
				return

			override_camera_2d_button.button_pressed = true

		elif editor_scene_root is Node3D:

			# Ignore if the scene has a camera:
			var camera_3d = Utils.find_child_by_type(EditorInterface.get_edited_scene_root(), "Camera3D")
			if camera_3d:
				return

			override_camera_3d_button.button_pressed = true

	func _setup_session(session_id):
		var session = get_session(session_id)
		session.started.connect(_on_session_started)

		var main_screen = EditorInterface.get_editor_main_screen()

		var canvas_item_editor = Utils.find_child_by_type(main_screen, "CanvasItemEditor")
		var canvas_item_editor_toolbar = canvas_item_editor.get_child(0).get_child(0).get_child(0)
		var canvas_item_editor_toolbar_buttons := canvas_item_editor_toolbar.find_children(
			"", "Button", false, false,
		)
		override_camera_2d_button = canvas_item_editor_toolbar_buttons[OVERRIDE_CAMERA_2D_BUTTON_INDEX]

		var spatial_editor = Utils.find_child_by_type(main_screen, "Node3DEditor")
		var spatial_editor_toolbar = spatial_editor.get_child(0).get_child(0).get_child(0)
		var spatial_editor_toolbar_buttons := spatial_editor_toolbar.find_children(
			"", "Button", false, false,
		)
		override_camera_3d_button = spatial_editor_toolbar_buttons[OVERRIDE_CAMERA_3D_BUTTON_INDEX]


var debugger = ExampleEditorDebugger.new()


func _enter_tree():
	add_debugger_plugin(debugger)


func _exit_tree():
	remove_debugger_plugin(debugger)
