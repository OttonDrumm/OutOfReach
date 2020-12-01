extends Node2D

signal create_piece

# Called when the node enters the scene tree for the first time.
func _ready():
	MStatManager.connect("stats_updated", self, "update_stat_view")
	MPieceManager.connect("switch_engine", self, "show_engine")
	$Fuel.max_value = MStatManager.get_max_stat(MPieceManager.current_engine, 'fuel')
	$MaxFuel.max_value = MStatManager.get_max_stat(MPieceManager.current_engine, 'fuel')
	#$MaxFuel.value = s.fuel
	$Shield.max_value = MStatManager.get_max_stat(MPieceManager.current_engine, 'shield')
	update_stat_view()

func generate_piece (_type, _id):
	var piece = MPieceManager.get_piece(_type, _id)
	emit_signal("create_piece", piece)

func update_stat_view():
	$Fuel.value = MStatManager.stats.fuel[MPieceManager.current_engine]
	$MaxFuel.value = $MaxFuel.max_value - MStatManager.stats.max_fuel[MPieceManager.current_engine]
	$Shield.value = MStatManager.stats.shield[MPieceManager.current_engine]

func show_engine ():
	$Fuel.max_value = MStatManager.get_max_stat(MPieceManager.current_engine, 'fuel')
	$MaxFuel.max_value = MStatManager.get_max_stat(MPieceManager.current_engine, 'fuel')
	$Shield.max_value = MStatManager.get_max_stat(MPieceManager.current_engine, 'shield')
	update_stat_view()
	
	$Buttons_1.hide()
	$Buttons_2.hide()
	$Buttons_3.hide()
	
	$Sticker_1.hide()
	$Sticker_2.hide()
	$Sticker_3.hide()
	
	if MPieceManager.current_engine > 0:
		$Buttons_1.show()
		$Sticker_1.show()
	if MPieceManager.current_engine > 1:
		$Buttons_2.show()
		$Sticker_2.show()
	if MPieceManager.current_engine > 2:
		$Buttons_3.show()
		$Sticker_3.show()

#### CREATION EVENTS ####

func _on_Fuel_3_pressed():
	generate_piece("Fuel", 3)

func _on_Plate_3_pressed():
	generate_piece("Plate", 3)

func _on_Prop_3_pressed():
	generate_piece("Propulsor", 3)

func _on_Wing_3_pressed():
	generate_piece("Wing", 3)

func _on_Fuel_2_pressed():
	generate_piece("Fuel", 2)

func _on_Plate_2_pressed():
	generate_piece("Plate", 2)

func _on_Prop_2_pressed():
	generate_piece("Propulsor", 2)

func _on_Wing_2_pressed():
	generate_piece("Wing", 2)

func _on_Fuel_1_pressed():
	generate_piece("Fuel", 1)
	
func _on_Fuel_0_pressed():
	generate_piece("Fuel", 0)

func _on_Plate_1_pressed():
	generate_piece("Plate", 1)

func _on_Prop_1_pressed():
	generate_piece("Propulsor", 1)

func _on_Wing_1_pressed():
	generate_piece("Wing", 1)
