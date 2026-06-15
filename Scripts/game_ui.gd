extends Node

signal language_changed(language_code: String)
signal typography_ready

const SETTINGS_PATH: String = "user://opciones.cfg"
const SUPPORTED_LANGUAGES: Array[String] = ["es", "en"]

const REGULAR_FONT_CANDIDATES: Array[String] = [
	"res://Recursos/Fuentes/RPGPixel.ttf",
	"res://Recursos/Fuentes/RPGPixel.otf",
	"res://Recursos/Fuentes/PixelRPG.ttf",
	"res://Recursos/Fuentes/PixelRPG.otf",
	"res://Recursos/Fuentes/PixelOperator.ttf",
	"res://Recursos/Fuentes/PixelOperator.otf",
	"res://Recursos/Fuentes/PixelifySans-Regular.ttf",
	"res://Recursos/Fuentes/PressStart2P-Regular.ttf",
	"res://Recursos/Fuentes/Silkscreen-Regular.ttf"
]

const BOLD_FONT_CANDIDATES: Array[String] = [
	"res://Recursos/Fuentes/RPGPixel-Bold.ttf",
	"res://Recursos/Fuentes/RPGPixel-Bold.otf",
	"res://Recursos/Fuentes/PixelRPG-Bold.ttf",
	"res://Recursos/Fuentes/PixelOperator-Bold.ttf",
	"res://Recursos/Fuentes/PixelifySans-Bold.ttf",
	"res://Recursos/Fuentes/Silkscreen-Bold.ttf"
]

const SYMBOL_CHARACTERS: String = (
	"✦⚒▦◈⚙×✕☠⚔◆◇▣★☆🔒🔓❖✧✪✹✺✸✷✶✵"
	+ "←→↑↓‹›«»◀▶▲▼＋−✓✗"
	+ "☀☣♥⬟●➶♨∞滴✚✦⚡◉"
)

const TITLE_NAME_HINTS: Array[String] = [
	"title", "titulo", "header", "cabecera", "heading", "nombre",
	"rarity", "rareza", "phase", "fase", "gold", "oro", "status",
	"estado", "category", "categoria", "tab", "footer"
]

var current_language: String = "es"
var pixel_font: Font
var bold_pixel_font: Font
var symbol_font: Font
var initialized: bool = false

var _pending_controls: Array[WeakRef] = []
var _font_flush_scheduled: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load_language()
	_build_pixel_fonts()
	_build_symbol_font()

	if not get_tree().node_added.is_connected(_on_node_added):
		get_tree().node_added.connect(_on_node_added)

	call_deferred("_apply_font_to_existing_tree")
	call_deferred("_late_typography_refresh")
	initialized = true
	typography_ready.emit()

func _late_typography_refresh() -> void:

	await get_tree().process_frame
	await get_tree().process_frame
	_apply_font_to_existing_tree()

func get_language() -> String:
	return current_language

func set_language(language_code: String) -> void:
	var normalized: String = _normalize_language(language_code)
	if normalized == current_language:
		TranslationServer.set_locale(current_language)
		return

	current_language = normalized
	TranslationServer.set_locale(current_language)
	_save_language()
	language_changed.emit(current_language)

func _normalize_language(language_code: String) -> String:
	var normalized: String = language_code.to_lower().strip_edges()
	if not SUPPORTED_LANGUAGES.has(normalized):
		normalized = "es"
	return normalized

func _load_language() -> void:
	var config: ConfigFile = ConfigFile.new()
	if config.load(SETTINGS_PATH) == OK:
		current_language = _normalize_language(
			str(config.get_value("general", "idioma", "es"))
		)
	else:
		current_language = "es"

	TranslationServer.set_locale(current_language)

func _save_language() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.load(SETTINGS_PATH)
	config.set_value("general", "idioma", current_language)

	var save_error: Error = config.save(SETTINGS_PATH)
	if save_error != OK:
		push_warning("GameUI no pudo guardar el idioma.")

func get_pixel_font() -> Font:
	return pixel_font

func get_bold_pixel_font() -> Font:
	return bold_pixel_font if bold_pixel_font != null else pixel_font

func get_symbol_font() -> Font:
	return symbol_font

func _build_pixel_fonts() -> void:
	pixel_font = _load_first_font(REGULAR_FONT_CANDIDATES)

	if pixel_font == null:
		pixel_font = _create_system_pixel_font(false)

	_enable_msdf_when_possible(pixel_font)

	bold_pixel_font = _load_first_font(BOLD_FONT_CANDIDATES)
	if bold_pixel_font == null:
		var bold_variation: FontVariation = FontVariation.new()
		bold_variation.base_font = pixel_font
		bold_variation.variation_embolden = 0.65
		bold_pixel_font = bold_variation

	_enable_msdf_when_possible(bold_pixel_font)

func _load_first_font(candidate_paths: Array[String]) -> Font:
	for font_path: String in candidate_paths:
		if not ResourceLoader.exists(font_path):
			continue

		var loaded_font: Resource = load(font_path)
		if loaded_font is Font:
			return loaded_font as Font

	return null

func _create_system_pixel_font(prefer_bold: bool) -> SystemFont:
	var fallback_font: SystemFont = SystemFont.new()
	fallback_font.font_names = PackedStringArray([
		"Pixel Operator Bold" if prefer_bold else "Pixel Operator",
		"Pixelify Sans",
		"Silkscreen",
		"Tiny5",
		"Press Start 2P",
		"Fixedsys Excelsior 3.01",
		"Fixedsys",
		"Terminal",
		"Lucida Console",
		"Consolas",
		"Segoe UI"
	])
	fallback_font.font_weight = 700 if prefer_bold else 400
	fallback_font.allow_system_fallback = true
	fallback_font.multichannel_signed_distance_field = true
	fallback_font.msdf_pixel_range = 24
	fallback_font.msdf_size = 96
	fallback_font.generate_mipmaps = true
	fallback_font.subpixel_positioning = TextServer.SUBPIXEL_POSITIONING_DISABLED
	return fallback_font

func _enable_msdf_when_possible(font_resource: Font) -> void:
	if font_resource is FontFile:
		var font_file: FontFile = font_resource as FontFile
		font_file.multichannel_signed_distance_field = true
		font_file.msdf_pixel_range = 24
		font_file.msdf_size = 96
		font_file.generate_mipmaps = true
		font_file.subpixel_positioning = TextServer.SUBPIXEL_POSITIONING_DISABLED

func _build_symbol_font() -> void:
	var symbols: SystemFont = SystemFont.new()
	symbols.font_names = PackedStringArray([
		"Segoe UI Symbol",
		"Segoe UI Emoji",
		"Noto Sans Symbols 2",
		"Noto Sans Symbols",
		"Arial Unicode MS",
		"Segoe UI"
	])
	symbols.allow_system_fallback = true
	symbols.multichannel_signed_distance_field = true
	symbols.msdf_pixel_range = 24
	symbols.msdf_size = 96
	symbols.generate_mipmaps = true
	symbols.subpixel_positioning = TextServer.SUBPIXEL_POSITIONING_DISABLED
	symbol_font = symbols

func _on_node_added(node: Node) -> void:
	if not (node is Control):
		return

	_pending_controls.append(weakref(node))
	if _font_flush_scheduled:
		return

	_font_flush_scheduled = true
	call_deferred("_flush_pending_controls")

func _flush_pending_controls() -> void:
	_font_flush_scheduled = false
	var queued: Array[WeakRef] = _pending_controls
	_pending_controls = []

	for weak_control: WeakRef in queued:
		var referenced: Variant = weak_control.get_ref()
		if referenced is Control:
			_apply_font_to_control(referenced as Control)

func _apply_font_to_existing_tree() -> void:
	apply_font_to_tree(get_tree().root)

func apply_font_to_tree(root_node: Node) -> void:
	if not is_instance_valid(root_node):
		return

	var pending_nodes: Array[Node] = [root_node]
	while not pending_nodes.is_empty():
		var current: Node = pending_nodes.pop_back()
		if current is Control:
			_apply_font_to_control(current as Control)

		for child: Node in current.get_children():
			pending_nodes.append(child)

func refresh_control(control: Control) -> void:
	_apply_font_to_control(control)

func mark_as_title(control: Control) -> void:
	if not is_instance_valid(control):
		return
	control.set_meta("ui_font_role", "title")
	_apply_font_to_control(control)

func mark_as_body(control: Control) -> void:
	if not is_instance_valid(control):
		return
	control.set_meta("ui_font_role", "body")
	_apply_font_to_control(control)

func _apply_font_to_control(control: Control) -> void:
	if not is_instance_valid(control) or pixel_font == null:
		return

	control.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	if control is RichTextLabel:
		_apply_rich_text_fonts(control as RichTextLabel)
		return

	if not _supports_standard_font(control):
		return

	var selected_font: Font = _select_font_for_control(control)
	control.begin_bulk_theme_override()
	control.add_theme_font_override("font", selected_font)

	var role: String = _resolve_font_role(control)
	var current_size: int = control.get_theme_font_size("font_size")
	var minimum_size: int = 15
	if role == "title" or role == "heading":
		minimum_size = 20
	elif control is Button:
		minimum_size = 17
	elif control is LineEdit or control is TextEdit or control is SpinBox:
		minimum_size = 16
	if current_size < minimum_size:
		control.add_theme_font_size_override("font_size", minimum_size)
	if role == "title" or role == "heading":
		control.add_theme_constant_override("outline_size", 2)
		control.add_theme_color_override(
			"font_outline_color",
			Color(0.0, 0.0, 0.0, 0.94)
		)
	elif control is Button:
		control.add_theme_constant_override("outline_size", 2)
		control.add_theme_color_override(
			"font_outline_color",
			Color(0.0, 0.0, 0.0, 0.90)
		)
	else:
		control.add_theme_constant_override("outline_size", 1)
		control.add_theme_color_override(
			"font_outline_color",
			Color(0.0, 0.0, 0.0, 0.78)
		)

	control.end_bulk_theme_override()

func _apply_rich_text_fonts(rich_text: RichTextLabel) -> void:
	rich_text.begin_bulk_theme_override()
	rich_text.add_theme_font_override("normal_font", pixel_font)
	rich_text.add_theme_font_override("bold_font", get_bold_pixel_font())
	rich_text.add_theme_font_override("italics_font", pixel_font)
	rich_text.add_theme_font_override("bold_italics_font", get_bold_pixel_font())
	rich_text.add_theme_font_override("mono_font", pixel_font)
	if rich_text.get_theme_font_size("normal_font_size") < 15:
		rich_text.add_theme_font_size_override("normal_font_size", 15)
	if rich_text.get_theme_font_size("bold_font_size") < 17:
		rich_text.add_theme_font_size_override("bold_font_size", 17)
	rich_text.add_theme_constant_override("outline_size", 1)
	rich_text.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.85))
	rich_text.end_bulk_theme_override()

func _supports_standard_font(control: Control) -> bool:
	return (
		control is Label
		or control is Button
		or control is LineEdit
		or control is TextEdit
		or control is ItemList
		or control is Tree
		or control is MenuBar
		or control is TabBar
		or control is SpinBox
	)

func _select_font_for_control(control: Control) -> Font:
	if _is_symbol_control(control) and symbol_font != null:
		return symbol_font

	var role: String = _resolve_font_role(control)
	if role == "title" or role == "heading" or role == "button":
		return get_bold_pixel_font()

	return pixel_font

func _resolve_font_role(control: Control) -> String:
	if control.has_meta("ui_font_role"):
		return str(control.get_meta("ui_font_role", "body"))

	if _is_symbol_control(control):
		return "symbol"

	if control is Button:
		return "button"

	var lower_name: String = str(control.name).to_lower()
	for hint: String in TITLE_NAME_HINTS:
		if lower_name.contains(hint):
			return "title"

	var visible_text: String = _get_visible_text(control)
	if _looks_like_heading(visible_text):
		return "heading"

	return "body"

func _get_visible_text(control: Control) -> String:
	if control is Label:
		return (control as Label).text.strip_edges()
	if control is Button:
		return (control as Button).text.strip_edges()
	if control is LineEdit:
		return (control as LineEdit).text.strip_edges()
	return ""

func _looks_like_heading(text: String) -> bool:
	if text.is_empty() or text.length() > 52 or text.contains("\n"):
		return false

	var has_letter: bool = false
	for index: int in range(text.length()):
		var character: String = text.substr(index, 1)
		if character.to_lower() != character.to_upper():
			has_letter = true
			break

	return has_letter and text == text.to_upper()


func _is_symbol_control(control: Control) -> bool:
	var visible_text: String = _get_visible_text(control)
	if visible_text.is_empty() or visible_text.length() > 6:
		return false

	for index: int in range(visible_text.length()):
		var character: String = visible_text.substr(index, 1)
		if character == " ":
			continue
		if not SYMBOL_CHARACTERS.contains(character):
			return false


	return true
