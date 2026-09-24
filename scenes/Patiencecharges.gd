extends Marker2D

var Grow = false
var Max = 4

var One = false
var Two = false
var Three = false
var Four = false

func _process(_delta):
	if Grow == false and GlobalData.PatienceCharges < Max and GlobalData.CurrentWeapon == 1:
		$Grow.start()
		GlobalData.PatienceCharges += 1
		Grow = true
	
	if not GlobalData.CurrentWeapon == 1:
		$Grow.stop()
		GlobalData.PatienceCharges = 0
		Grow = false
		$PatienceCharge1/Animation.play("Reset")
		$PatienceCharge2/Animation.play("Reset")
		$PatienceCharge3/Animation.play("Reset")
		$PatienceCharge4/Animation.play("Reset")
		

	if GlobalData.PatienceCharges == 1 and One == false:
		$PatienceCharge1/Animation.play("Appear")
		One = true
	if GlobalData.PatienceCharges == 2 and Two == false:
		$PatienceCharge2/Animation.play("Appear")
		Two = true
	if GlobalData.PatienceCharges == 3 and Three == false:
		$PatienceCharge3/Animation.play("Appear")
		Three = true
	if GlobalData.PatienceCharges == 4 and Four == false:
		$PatienceCharge4/Animation.play("Appear")
		Four = true

func _on_grow_timeout():
	Grow = false

func _on_suferer_hit():
	if GlobalData.PatienceCharges == 0 and One == true:
		$PatienceCharge1/Animation.play("Dissapear")
		$Grow.start()
		One = false
	if GlobalData.PatienceCharges == 1 and Two == true:
		$PatienceCharge2/Animation.play("Dissapear")
		$Grow.start()
		Two = false
	if GlobalData.PatienceCharges == 2 and Three == true:
		$PatienceCharge3/Animation.play("Dissapear")
		$Grow.start()
		Three = false
	if GlobalData.PatienceCharges == 3 and Four == true:
		$PatienceCharge4/Animation.play("Dissapear")
		$Grow.start()
		Four = false
