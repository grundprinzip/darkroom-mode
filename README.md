# darkroom-mode.el - Distraction free editing mode

This is a simple Emacs mode that is designed to enforce the user to be
focussed only on what he/she is writing. This mode is optimized for
writing text, but not programming. It will center the current frame on
the screen and select `Lucida Sans Typewriter` as the default font
with a font size of 16pt.

After endless hours of user research we found that this is the best
setting. Howver, all the possibilities to configure your editor remain
intact.


*Shamelessly idea copy of http://www.informationarchitects.jp/en/ia-writer-for-mac/*

*Best run editors run `darkroom-mode` on Emacs*

## Installation

Download

`git clone https://github.com/grundprinzip/darkroom-mode.git "path-to-where-you-put-darkroom-mode"`

Modify your `.emacs` to be able to load darkroom-mode

       (add-to-list 'load-path "path-to-where-you-put-darkroom-mode")
       (require 'darkroom-mode)

To run `darkroom-mode` you only have to execute

       M-x darkroom-mode   

## Screenshot

Attached a screenshot of the darkroommode on a mac

![Before](https://github.com/grundprinzip/darkroom-mode/raw/master/images/before.png)

With activated `darkroom-mode`

![After](https://github.com/grundprinzip/darkroom-mode/raw/master/images/after.png)
       
## Configuration

The mode allows little configuration to adjust the display to the
users needs. The most important options are:

      (defvar darkroom-mode-face-foreground "Lucida Sans Typewriter"
        "The foreground color of the default face")

      (defvar darkroom-mode-face-size 160
        "Default font size" )

      (defvar darkroom-mode-center-margin 100
        Defines the width of the center part in darkroom-mode")


## Information

* Original Author: Martin Svenson
* Usage: M-x darkroom-mode
* License: free for all usages/modifications/distributions/whatever.
* Requirements: w32-fullscreen.el or something similar under *nix
