extends TextureProgressBar

var Adding = false
var Consuming = false

var CA = true #can attack
var GC = false #gain Cooldown
var CC = false #consumption Cooldown
var Alpha = 0
var Beta = 0
var Consumption = 2.5
var Consumed = 0
var MaxConsumption = 25

var Gain = 2.5
var Gained = 0
var MaxGain = 25

var Inspiration = 0

func _process(_delta):
	$".".value = Inspiration

	if Inspiration <= 100 and Inspiration >= 0:
		GlobalData.Inspiration = Inspiration
	
	if Adding == true and GC == false:
		GC = true
		CA = false
		$"../Gain".start()
	
	if Gained == MaxGain:
		$"../Gain".stop()
		Gained = 0
		CA = true
		Adding = false
		GC = false
	
	print(Consumed)
	
	if Consuming == true and CC == false:
		$"../Consumption".start()
		CA = false
		CC = true
	
	if Consumed >= MaxConsumption:
		$"../Consumption".stop()
		Consumed = 0
		CC = false
		CA = true
		Consuming = false
	
	if Inspiration <= -1:
		Inspiration = 0
		Consumed = 0
		Consuming = false
		CA = true
		$"../Consumption".stop()

func _on_integrity_integrity_sucess():
	Alpha = Inspiration
	Gained = 0
	Adding = true

func _on_suferer_hit():
	Beta = Inspiration
	Consuming = true

func _on_gain_timeout():
	Gained = (Inspiration - Alpha) + Gain
	GC = false
	Inspiration += Gain

func _on_consumption_timeout():
	var Ceta = Inspiration - Consumption
	CC = false
	Consumed = Beta - Ceta
	Inspiration -= Consumption
