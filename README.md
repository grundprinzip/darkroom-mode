# darkroom-mode.el - Distraction free editing mode

This is a simple Emacs mode that is designed to enforce the user to be
focussed only on what he/she is writing. This mode is optimized for
writing text, but not programming.

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


* * *
## Information

* Original Author: Martin Svenson
* Usage: M-x darkroom-mode
* License: free for all usages/modifications/distributions/whatever.
* Requirements: w32-fullscreen.el or something similar under *nix
