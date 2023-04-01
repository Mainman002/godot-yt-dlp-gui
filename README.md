# godot-yt-dlp-gui
Gui for managing yt-dlp commands, mainly for MacOS but can be modified to work on most OS. Uses Godot Engine 3.5.2 Lts.

### Needed files to run the app
* [Godot 3.5.2 Lts Standard](https://godotengine.org/download/3.x/)
* youtube-dl
* yt-dlp
* ffmpeg
* ? fprobe ? Honestly not sure if this is needed, but just in case ;)

### If you have [Brew](https://brew.sh/) installed then you can install dependancies with this command
```
brew install youtube-dl yt-dlp ffmpeg fprobe
```

![Screenshot 2023-03-31 at 7 34 50 PM](https://user-images.githubusercontent.com/11281480/229256769-781318ca-9fc0-4836-b0f4-2c205e5ab9cd.png)

After install you should be able to open the project in Godot 3.5.2 Lts Standard, then run it from the top right Play button
### !! Warning !! 
downloads will keep running in the background until finished or the window is closed, cool thing is that you can keep adding new https addresses
to download without cancelling the last batch of downloads
