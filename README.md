## Puzzle Generator

Puzzle Generator is a macOS Command Line Utility written in Swift. It detects images (`.png` or `.jpg`) in the current folder and crops them into puzzle pieces.

### Example Input

<p><img src="images/sample.jpg" align="center" width="300px"></p>

### Output (2x2)

<p><img src="images/output%20composite.png" align="center" width="350px"></p>

## Using Puzzle Generator

Download the latest executable from [Puzzle-Generator/Releases](https://github.com/calda/Puzzle-Generator/releases). Run it  with `./Puzzle\ Generator`. 

#### JPNG

Puzzle Generator supports the [JPNG](https://github.com/nicklockwood/JPNG) library. Puzzle Generator will export files in the JPNG format if it detects [JPNGTool](https://github.com/nicklockwood/JPNG/blob/master/JPNGTool/JPNGTool) in the current folder.

#### Example Configuration

<p><img src="images/folder.png" align="center" width="200px"></p>

```
cal: ~ $ cd Documents/Puzzles
cal: ~/Documents/Puzzles $ ./Puzzle\ Generator 
Detected JPNGTool.
Found 89 images in the current directory.

Number of rows? 4
Number of columns? 3

Generating puzzle-A-ahh
2016-12-19 00:59:47.016 JPNGTool[20892:563605] Converted 'GeneratedPuzzles/puzzle-A-ahh/puzzle-A-ahh-row0-col0.png' to JPNG
...
```