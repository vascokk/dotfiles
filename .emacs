;; setup erlang mode
;; ;; add the location of the elisp files to the load-path
(setq load-path (cons  "/usr/local/lib/erlang/lib/tools-2.6.10/emacs/"
         load-path))
;;          ;; set the location of the man page hierarchy
         (setq erlang-root-dir "/usr/local/lib/erlang")
;;          ;; add the home of the erlang binaries to the exec-path
         (setq exec-path (cons "/usr/local/lib/erlang/bin" exec-path))
;;          ;; load and eval the erlang-start package to set up 
;;          ;; everything else 
         (require 'erlang-start)
(add-to-list 'load-path "/Users/vasco/Work/distel/elisp/")
(require 'distel)
(distel-setup)1
(require 'erlang-eunit)
(require 'erlang-flymake)

(defun my-erlang-mode-hook ()
        ;; when starting an Erlang shell in Emacs, default in the node name
        (setq inferior-erlang-machine-options '("-sname" "emacs"))
        ;; add Erlang functions to an imenu menu
        (imenu-add-to-menubar "imenu")
        ;; customize keys
        (local-set-key [return] 'newline-and-indent)
        )
;; Some Erlang customizations
(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)

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
 '(custom-enabled-themes (quote (tango-dark)))
 '(ecb-options-version "2.40")
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq tramp-default-method "ssh")

(setq auto-mode-alist (cons '("\\.dtl$" . Erlang-mode) auto-mode-alist))

(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (setq package-archives '(("ELPA" . "http://tromey.com/elpa/")
			   ("gnu" . "http://elpa.gnu.org/packages/")
			   ("marmalade" . "http://marmalade-repo.org/packages/")
			   ("melpa" . "http://melpa.milkbox.net/packages/")))
)

(defun ebm-find-rebar-top-recr (dirname)
      (let* ((project-dir (locate-dominating-file dirname "rebar.config")))
        (if project-dir
            (let* ((parent-dir (file-name-directory (directory-file-name project-dir)))
                   (top-project-dir (if (and parent-dir (not (string= parent-dir "/")))
                                       (ebm-find-rebar-top-recr parent-dir)
                                      nil)))
              (if top-project-dir
                  top-project-dir
                project-dir))
              project-dir)))

    (defun ebm-find-rebar-top ()
      (interactive)
      (let* ((dirname (file-name-directory (buffer-file-name)))
             (project-dir (ebm-find-rebar-top-recr dirname)))
        (if project-dir
            project-dir
          (erlang-flymake-get-app-dir))))

     (defun ebm-directory-dirs (dir name)
        "Find all directories in DIR."
        (unless (file-directory-p dir)
          (error "Not a directory `%s'" dir))
        (let ((dir (directory-file-name dir))
              (dirs '())
              (files (directory-files dir nil nil t)))
            (dolist (file files)
              (unless (member file '("." ".."))
                (let ((absolute-path (expand-file-name (concat dir "/" file))))
                  (when (file-directory-p absolute-path)
                    (if (string= file name)
                        (setq dirs (append (cons absolute-path
                                                 (ebm-directory-dirs absolute-path name))
                                           dirs))
                        (setq dirs (append
                                    (ebm-directory-dirs absolute-path name)
                                    dirs)))))))
              dirs))

    (defun ebm-get-deps-code-path-dirs ()
        (ebm-directory-dirs (ebm-find-rebar-top) "ebin"))

    (defun ebm-get-deps-include-dirs ()
       (ebm-directory-dirs (ebm-find-rebar-top) "include"))

    (fset 'erlang-flymake-get-code-path-dirs 'ebm-get-deps-code-path-dirs)
    (fset 'erlang-flymake-get-include-dirs-function 'ebm-get-deps-include-dirs)
