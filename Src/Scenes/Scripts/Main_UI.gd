extends Control

const yt_dlp_dir:String = '"/opt/homebrew/bin/yt-dlp"'
const ffmpeg_dir:String = '"/opt/homebrew/bin/ffmpeg"'
const shell_type:String = '/bin/zsh'
const debug:bool = true

var links:Array = []
var types:Array = [ "mp4", "mp3" ]
var playlist:Array = [ "--no-playlist", "--yes-playlist" ]
var directory:String = ""
var line_list:Array = []

func _ready() -> void:
	# warning-ignore:return_value_discarded
	get_node( "%Download" ).connect("pressed", self, "download")
	# warning-ignore:return_value_discarded
	get_node( "%ClearText" ).connect("pressed", self, "clear_text")
	# warning-ignore:return_value_discarded
	get_node( "%Browse" ).connect("pressed", self, "show_browse")

	if get_node( "%LinkText" ).text.empty() and get_node( "%LinkText" ).text.empty(): get_node( "%Output" ).text = str( "\n", "Select an output directory and enter an Https Youtube link before downloading", "\n" )

	for type in types:
		get_node( "%TypeList" ).add_item( type )

	for type in playlist:
		get_node( "%Playlist" ).add_item( type )

	get_node( "%Output" ).get_parent().visible = debug

func show_browse() -> void:
	get_node( "%FileDialog" ).visible = true

func _on_FileDialog_dir_selected( dir:String ) -> String:
	directory = dir
	get_node( "%FilePath" ).text = directory
	return dir

func download():
	get_node( "%Output" ).text = ""
	line_list.clear()
	for idx in range( 0, _get_line_count( "%LinkText" ) ):
		line_list.append( idx )
		if debug: print( idx )

	if not get_node( "%LinkText" ).text.empty() and not get_node( "%LinkText" ).text.empty():
		for idx in line_list:
			if _get_line_text( "%LinkText", idx ): download_as(
				types[ get_node( "%TypeList" ).selected ],        # Type
				playlist[ get_node( "%Playlist" ).selected ],     # Playlist
				_get_line_text( "%LinkText", idx ),               # Link
				get_node( "%FilePath" ).text )                    # Output Directory

	else: get_node( "%Output" ).text = str( "\n", "Select an output directory and enter an Https Youtube link before downloading", "\n" )

func download_as( _type:String, _playlist:String, _link:String, _out:String ) -> void:
	var cmd:String = ""
	if debug: print( _type )
	match _type:
		"mp4":
			match _playlist:
				"--yes-playlist": cmd = str( yt_dlp_dir, " -i -f ", _type, " --yes-playlist ", "'", _link, "'", " --ffmpeg-location ", ffmpeg_dir, " --no-abort-on-error --no-check-certificate ", " -P ", _out)
				"--no-playlist": cmd = str( yt_dlp_dir, " -f ", _type, " ", "'", _link, "'", " --ffmpeg-location ", ffmpeg_dir, " --no-abort-on-error --no-check-certificate ", " -P ", _out)
		"mp3":
			match _playlist:
				"--yes-playlist": cmd = str( yt_dlp_dir, " -i -f 'ba' -x --audio-format ", _type, " --yes-playlist ", "'", _link, "'", " --ffmpeg-location ", ffmpeg_dir, " --no-abort-on-error --no-check-certificate ", " -P ", _out)
				"--no-playlist": cmd = str( yt_dlp_dir, " -f 'ba' -x --audio-format ", _type, " ", "'", _link, "'", " --ffmpeg-location ", ffmpeg_dir, " --no-abort-on-error --no-check-certificate ", " -P ", _out)
	if debug: print( cmd )

	var output:Array = []
	output.append( OS.execute(shell_type, [ "-c", cmd], debug, output) )

	if debug:
		get_node( "%Output" ).text += str( "\n Command: ", cmd, "\n" )
		get_node( "%Output" ).text += str( "\n", output, "\n" )
	get_node( "%Output" ).get_parent().visible = debug

func clear_text() -> void:
	get_node( "%LinkText" ).text = ""

## Helper Functions
func _get_line_count( _textedit:NodePath ) -> int:
	return get_node( _textedit ).get_line_count()

func _get_line_text( _textedit:NodePath, _idx:int ) -> String:
	return get_node( _textedit ).text.split("\n")[ _idx ]
