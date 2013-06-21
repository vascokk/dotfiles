;; setup erlang mode
;; ;; add the location of the elisp files to the load-path
(setq load-path (cons  "/Users/vasco/erlang/r15b03/lib/tools-2.6.8/emacs/"
         load-path))
;;          ;; set the location of the man page hierarchy
         (setq erlang-root-dir "/Users/vasco/erlang/r15b03")
;;          ;; add the home of the erlang binaries to the exec-path
         (setq exec-path (cons "/Users/vasco/erlang/r15b03/bin" exec-path))
;;          ;; load and eval the erlang-start package to set up 
;;          ;; everything else 
         (require 'erlang-start)
(add-to-list 'load-path "/Users/vasco/Work/distel/elisp/")
(require 'distel)
(distel-setup)
(require 'erlang-eunit)
(require 'erlang-flymake)

;; key bindings
(when (eq system-type 'darwin) ;; mac specific settings
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'meta)
  (global-set-key [kp-delete] 'delete-char) ;; sets fn-delete to be right-delete
  )

;;(setq split-height-threshold nil)
;;(setq split-width-threshold 0)
(setq split-width-threshold most-positive-fixnum)

;;(add-to-list 'load-path "/Users/vasco/Work/magit")
;;(require 'magit)
;;(add-to-list 'load-path "/Users/vasco/Work/magit/contrib")
;;(require 'magit-inotify)
;;(require 'cl-lib)

(add-to-list 'load-path "/Users/vasco/.emacs.d/ecb")
(require 'ecb)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
