# Music Player
This is my own project building an almost complete iOS application of photography in Swift.

## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

## Prerequisites
Xcode 8 or above has been installed in your computer

## Installing
Clone the code to your computer and open with Xcode 8 or above

## Language
Swift 3.0

## Functionalities
1. Play .mp3 files
2. Pause, move forward to the next song or backward to the previous song
3. Fast forward or backward through adjusting the slider

## Performed skills:
1. Use Storyboard. Navigation controller was used instead of segue.
2. Manage UITableView
3. Use AVAudioPlayer to play .mp3 files
4. Use Timer to track playing time of audio player and visualize it to user.
5. Use slider to visualize playing time and allow user to adjust playing time through slider.

## Versioning:
#### Sep 10, 2017 - 1.0 

## Bugs:
A song without metadata is used to test the reliability of the application.
If the user has not selected the song, when being selected, the title of the song display normally.
However, if the move forward or backward a cycle, the title would not appear (only for the song without metadata).
After testing, the author realises that the text of the title label is still assigned correctly and only the label itself does not appear for the song.
Other songs with metadata work just fine. Therefore, the author believe this is a bug of the simulator.

If you discover the solution for this bug, please contact the author through GitHub to help him. Any support is appreciated.

## Authors
* **Nguyen Nguyen** - *Initial work* - [Staham Nguyen](https://github.com/stahamnguyen)
