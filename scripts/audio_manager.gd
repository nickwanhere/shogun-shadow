extends Node

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var master_volume: float = 0.0
var music_volume: float = -10.0
var sfx_volume: float = 0.0

func _ready() -> void:
    music_player = AudioStreamPlayer.new()
    sfx_player = AudioStreamPlayer.new()
    add_child(music_player)
    add_child(sfx_player)

    music_player.volume_db = music_volume
    sfx_player.volume_db = sfx_volume

func play_music(track_path: String) -> void:
    if ResourceLoader.exists(track_path):
        var stream = load(track_path)
        music_player.stream = stream
        music_player.play()

func play_sfx(sound_path: String) -> void:
    if ResourceLoader.exists(sound_path):
        var stream = load(sound_path)
        sfx_player.stream = stream
        sfx_player.play()

func set_master_volume(volume_db: float) -> void:
    master_volume = volume_db
    AudioServer.set_bus_volume_db(0, volume_db)

func set_music_volume(volume_db: float) -> void:
    music_volume = volume_db
    music_player.volume_db = volume_db

func set_sfx_volume(volume_db: float) -> void:
    sfx_volume = volume_db
    sfx_player.volume_db = volume_db

func stop_music() -> void:
    music_player.stop()
