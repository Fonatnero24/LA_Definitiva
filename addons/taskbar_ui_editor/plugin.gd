@tool
extends EditorPlugin

var dock: Control


func _enter_tree() -> void:
	var dock_script: Script = preload("res://addons/taskbar_ui_editor/taskbar_ui_editor_dock.gd")
	dock = dock_script.new()
	dock.name = "Taskbar UI Editor"
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, dock)


func _exit_tree() -> void:
	if is_instance_valid(dock):
		remove_control_from_docks(dock)
		dock.queue_free()
