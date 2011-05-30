;;; darkroom-mode.el - Distraction free editing mode

;; Author: Martin Svenson
;; Usage: M-x darkroom-mode
;; License: free for all usages/modifications/distributions/whatever.
;; Requirements: w32-fullscreen.el or something similar under *nix

(require 'cl)

(cond ((eq window-system 'w32) 
       (require 'w32-fullscreen)))
        
(require 'frame-local-vars)

;; ------ configuration -----
(defvar darkroom-mode-face-foreground "Lucida Sans Typewriter"
  "The foreground color of the default face")

(defvar darkroom-mode-face-size 160
  "Default font size" )

(defvar darkroom-mode-center-margin 100 "")

(defvar darkroom-mode-enable-multi-monitor-support nil
  "Whether to enable multi-frame (i.e multiple monitor) support. An option since this feature is experimental")

(defvar darkroom-mode-enable-longline-wrap t
  "If longlines-mode is enabled, should longlines-wrap-follows-window-size also be enabled when going into darkroom mode?")

;; -------- code start -------
(setq *darkroom-mode-memtable* (make-hash-table))

(defun* darkroom-recall (var &optional (frame (selected-frame)))
  (cdr (assoc var (gethash frame *darkroom-mode-memtable*))))

(defun* darkroom-remember (var val &optional (frame (selected-frame)))
  (let* ((varlist (gethash frame *darkroom-mode-memtable*))
	 (target (assoc var varlist)))
    (cond (target
	   (setf (cdr target) val))
	  (t
	   (puthash frame (cons (cons var val)
				varlist) *darkroom-mode-memtable*)))))

(defun darkroom-mode-set-enabled(var)
  (darkroom-remember 'darkroom-mode-enabled var))

(defun darkroom-mode-enabledp()
  (darkroom-recall 'darkroom-mode-enabled))

(defun darkroom-mode-update-window()
  (message "Updating Window")
  (set-window-margins (selected-window)
		      left-margin-width
		      right-margin-width))

(defun darkroom-mode ()
  (interactive)
  (cond ((darkroom-mode-enabledp)
	 (darkroom-mode-disable))
	(t
	 (darkroom-mode-enable))))

(defun darkroom-mode-enable()
  (interactive)

  (darkroom-remember 'default-font (face-attribute 'default :font))
  (darkroom-remember 'default-font-size (face-attribute 'default :height))
  (set-face-attribute 'default (selected-frame) :font darkroom-mode-face-foreground)
  (set-face-attribute 'default (selected-frame) :height darkroom-mode-face-size)
  
  ; ----- margins
  ; note: margins are buffer local, so if multi-monitor support is
  ;       enabled, frame-locals are used. Otherwise, it's set
  ;       globally.
  ; - remember margins (only needed if multi-monitor support is disabled)
  (unless darkroom-mode-enable-multi-monitor-support
    (darkroom-remember 'left-margin-width
		       (default-value 'left-margin-width))
    (darkroom-remember 'right-margin-width
		       (default-value 'right-margin-width)))
  
  ; ----- other settings
  ; - remember
  (darkroom-remember 'line-spacing (frame-parameter nil 'line-spacing))
  (when (and  (boundp 'longlines-mode)
	      longlines-mode
	      darkroom-mode-enable-longline-wrap)
    (darkroom-remember 'longlines-wrap-follow
	  longlines-wrap-follows-window-size))
  ; - set
  (modify-frame-parameters (selected-frame)
			   '((line-spacing . 1)))
  (when (and 
	 (boundp 'longlines-mode)
	 longlines-mode
	 darkroom-mode-enable-longline-wrap)
    (longlines-mode 0)
    (setq longlines-wrap-follows-window-size t)
    (longlines-mode 1))
  
  ; ---- frame size
  ; - remember
  (darkroom-remember 'frame-width (frame-parameter nil 'width))
  (darkroom-remember 'frame-height (frame-parameter nil 'height))
  (darkroom-remember 'frame-left (frame-parameter nil 'left))
  (darkroom-remember 'frame-top (frame-parameter nil 'top))

  ;;  - set fullscreen
  (cond ((eq window-system 'w32)
           (w32-fullscreen-on))
         ((eq window-system 'ns)
           (set-frame-parameter nil 'fullscreen 'fullboth)))

  ; - set margins
  (cond (darkroom-mode-enable-multi-monitor-support
	 (setq-frame-default 'left-margin-width (/ (- (frame-width) darkroom-mode-center-margin) 2))
	 (setq-frame-default 'right-margin-width (/ (- (frame-width) darkroom-mode-center-margin) 2))
	 (frame-local-variables-check t))
	(t
	 (setq-default left-margin-width (/ (- (frame-width) darkroom-mode-center-margin) 2))
	 (setq-default right-margin-width (/ (- (frame-width) darkroom-mode-center-margin) 2))))
  (darkroom-mode-update-window)

  
  (darkroom-mode-set-enabled t)
  (message (format "darkroom mode enabled on %s" (selected-frame))))

(defun darkroom-mode-disable()
  (interactive)

  (set-face-attribute 'default (selected-frame) :font (darkroom-recall 'default-font))
  (set-face-attribute 'default (selected-frame) :height (darkroom-recall 'default-font-size))
  
  ; - restore other settings
  (modify-frame-parameters
   (selected-frame)
   `((line-spacing . ,(darkroom-recall 'line-spacing))))
  (when (and
	 (boundp 'longlines-mode)
	 longlines-mode
	 (darkroom-recall 'longlines-wrap-follow)
	 darkroom-mode-enable-longline-wrap)
    (longlines-mode 0)
    (setq longlines-wrap-follows-window-size
	  (darkroom-recall 'longlines-wrap-follow))
    (longlines-mode 1))
  ; - restore margins
  (cond (darkroom-mode-enable-multi-monitor-support
	 (unset-frame-default 'left-margin-width)
	 (unset-frame-default 'right-margin-width)
	 (frame-local-variables-check t))
	(t
	 (setq-default left-margin-width
		       (darkroom-recall 'left-margin-width))
	 (setq-default right-margin-width
		       (darkroom-recall 'right-margin-width))))
  (darkroom-mode-update-window)
  ; - restore frame size	 
  (cond ((eq window-system 'w32) 
           (w32-fullscreen-off))
         ((eq window-system 'ns)
         (set-frame-parameter nil 'fullscreen nil)))
  (darkroom-mode-recall-frame-size)
  (darkroom-mode-set-enabled nil)
  (message (format "darkroom-mode disabled on %s" (selected-frame)))
  ; for some reason frame size needs to be recalled again ...
  (sleep-for 0.05)
  (darkroom-mode-recall-frame-size))

(defun darkroom-mode-recall-frame-size()
  (modify-frame-parameters (selected-frame)
			   `((left . ,(darkroom-recall 'frame-left))
			     (top . ,(darkroom-recall 'frame-top))
			     (width . ,(darkroom-recall 'frame-width))
			     (height . ,(darkroom-recall 'frame-height)))))

;;;;;;;;;;;; small margins darkroom ;;;
(defun darkroom-mode-small()
  (interactive)
  (let ((darkroom-mode-left-margin 1)
	(darkroom-mode-right-margin 1))
    (darkroom-mode)))

(defun darkroom-mode-ecb()
  (interactive)
  (let ((darkroom-mode-left-margin 10)
	(darkroom-mode-right-margin 1))
    (darkroom-mode)))

;;;;;;;;;;;;;;;;; end ;;;;;;;;;;;;;;;;;
(provide 'darkroom-mode)
