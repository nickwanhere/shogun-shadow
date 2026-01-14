extends Control

class_name ScoutDeploymentUI

var scout_button: Button
var active_scouts: Array = []
var max_scouts: int = 3
var scout_cost: int = 50
var player_gold: int = 1000

signal scout_deployed(scout: Scout)
signal scout_recalled(scout: Scout)

@onready var scout_list = $VBoxContainer/ScoutList
@onready var gold_label = $Header/GoldLabel
@onready var deploy_button = $Header/DeployButton

func _ready() -> void:
    setup_ui()
    update_gold_display()

func setup_ui() -> void:
    deploy_button = Button.new()
    deploy_button.text = "Deploy Scout (50 Gold)"
    deploy_button.pressed.connect(_on_deploy_clicked)
    deploy_button.disabled = true
    $Header.add_child(deploy_button)

func _process(_delta: float) -> void:
    update_deploy_button()
    update_scout_list()

func update_deploy_button() -> void:
    if deploy_button:
        deploy_button.text = "Deploy Scout (%d Gold)" % scout_cost
        deploy_button.disabled = player_gold < scout_cost or active_scouts.size() >= max_scouts

func update_gold_display() -> void:
    if gold_label:
        gold_label.text = "Gold: %d | Scouts: %d/%d" % [player_gold, active_scouts.size(), max_scouts]

func update_scout_list() -> void:
    if not scout_list:
        return
    
    for child in scout_list.get_children():
        child.queue_free()
    
    for scout in active_scouts:
        if not scout or scout.is_queued_for_deletion():
            continue
        
        var scout_info = create_scout_info(scout)
        scout_list.add_child(scout_info)

func create_scout_info(scout: Scout) -> Panel:
    var panel = Panel.new()
    panel.custom_minimum_size = Vector2(300, 60)
    
    var vbox = VBoxContainer.new()
    panel.add_child(vbox)
    
    var status_text = Label.new()
    var status = "Inactive"
    var color = Color.WHITE
    
    if scout.is_active:
        if scout.is_retrieving:
            status = "Retrieving Information"
            color = Color.YELLOW
        else:
            status = "Stationed"
            color = Color.GREEN
    else:
        status = "Recalled"
        color = Color.GRAY
    
    status_text.text = "Status: %s" % status
    status_text.modulate = color
    vbox.add_child(status_text)
    
    var progress_bar = ProgressBar.new()
    progress_bar.max_value = 10.0
    progress_bar.value = 0.0
    progress_bar.show_percentage = false
    
    if scout.is_retrieving:
        var progress = (scout.current_retrieval_time / scout.retrieval_time) * 100.0
        progress_bar.value = progress
    else:
        progress_bar.value = 100.0
    
    vbox.add_child(progress_bar)
    
    var recall_button = Button.new()
    recall_button.text = "Recall"
    recall_button.pressed.connect(func(): _on_recall_clicked(scout))
    recall_button.disabled = not scout.is_active
    vbox.add_child(recall_button)
    
    return panel

func _on_deploy_clicked() -> void:
    if player_gold >= scout_cost and active_scouts.size() < max_scouts:
        var scout = Scout.new()
        scout.scout_id = active_scouts.size()
        scout.is_active = false
        active_scouts.append(scout)
        scout_deployed.emit(scout)
        
        player_gold -= scout_cost
        update_gold_display()
        
        GameManager.log_event("scout_deploy", {
            "scout_id": scout.scout_id,
            "cost": scout_cost,
            "remaining_gold": player_gold
        })

func _on_recall_clicked(scout: Scout) -> void:
    if scout in active_scouts:
        scout.recall()
        active_scouts.erase(scout)
        scout_recalled.emit(scout)
        
        update_gold_display()
        update_scout_list()
        
        GameManager.log_event("scout_recall", {
            "scout_id": scout.scout_id
        })

func deploy_scout_at(scout: Scout, position: Vector2i) -> void:
    scout.deploy(Vector2(position.x, position.y))
    update_scout_list()

func update_gold(amount: int) -> void:
    player_gold += amount
    update_gold_display()
