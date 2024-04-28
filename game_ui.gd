extends Node2D

@onready var slot0 = $Slot0
@onready var slot1 = $Slot1
@onready var slot2 = $Slot2
@onready var slot3 = $Slot3
@onready var slot4 = $Slot4
@onready var slot5 = $Slot5
@onready var slot6 = $Slot6
@onready var slot7 = $Slot7
@onready var slot8 = $Slot8
@onready var slot9 = $Slot9
@onready var slot10 = $Slot10
@onready var slot11 = $Slot11
@onready var slot12 = $Slot12
@onready var slot13 = $Slot13
@onready var slot14 = $Slot14

@onready var purityIcon = $PurityMarker

func setPurity(value: int): 
	var marker = [
		slot0,
		slot1,
		slot2,
		slot3,
		slot4,
		slot5,
		slot6,
		slot7,
		slot8,
		slot9,
		slot10,
		slot11,
		slot12,
		slot13,
		slot14,
	][value]
	print(marker)
	purityIcon.global_position = marker.global_position
