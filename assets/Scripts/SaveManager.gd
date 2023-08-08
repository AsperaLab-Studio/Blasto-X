extends Node

# Definiamo una struttura dati per rappresentare le informazioni del gioco da salvare
class_name save_data
var current_level: String

# Funzione per salvare i dati su disco
func save_game(file_path: String, data: save_data) -> void:
	var file = File.new()
	if file.open(file_path, File.WRITE) == OK:
		file.store_var(data)
		file.close()
	else:
		print("Impossibile salvare il file.")

# Funzione per caricare i dati dal disco
func load_game(file_path: String) -> save_data:
	var file = File.new()
	if file.open(file_path, File.READ) == OK:
		var data = file.get_var()
		file.close()
		return data
	else:
		print("File di salvataggio non trovato.")
		return null
