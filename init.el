;;; init --- my init.el file

;;; Commentary:


;;; Code:

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;;
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)


(require 'auto-complete)

; install and trigger use-package
(mapc
 (lambda (package)
   (if (not (package-installed-p package))
       (progn
         (package-refresh-contents)
         (package-install package))))
 '(use-package diminish bind-key))

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)
(setq use-package-always-ensure t)

; Sets $MANPATH, $PATH and exec-path from your shell, but only on OS X and Linux
; (Also tack on GOPATH)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH"))

;; old load-path additions -- retained just in case
; (expand-file-name "~/emacs/user-shadow")
; (expand-file-name "~/emacs/elib-1.0")
; (expand-file-name "~/emacs/jde-2.2.8/lisp")
; (expand-file-name "~/emacs/jde-2.1.5")
; (expand-file-name "~/emacs/pcl-cvs")

;; load-path manipulations
(setq load-path (append load-path (list
                                   (expand-file-name "~/.emacs.d/custom"))))

;;                      MISCELLANEOUS KEYBOARD MACROS

;; BS and DEL

(global-set-key "\^h" 'backward-delete-char-untabify)
                                        ; Unfortunately, just about
                                        ; every other mode redefines
                                        ; DEL. Aargh! [AG]

;(global-set-key "\177" 'delete-char)   ; also have to redefine help key
(global-set-key "\^xh" 'help-for-help)
(global-set-key "\C-x\C-u" 'undo)       ; quicker than C-x u

(global-set-key "\C-x8" 'kill-buffer-delete-window)

; restore these deprecated bindings because my fingers are old dogs
; NB: It looks like the a possible salve is to use M-w and C-y instead
;(global-set-key "\C-xx" 'copy-to-register)
;(global-set-key "\C-xg" 'insert-register)

;; Make keyboard bindings not suck (copied from https://johnsogg.github.io/emacs-golang)
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)
;(global-set-key "\M-c" 'copy-region-as-kill)
;(global-set-key "\M-v" 'yank)
(global-set-key "\M-g" 'goto-line)

; fix echoed commands in zsh
(defun my-init-shell-mode ()
  (setq comint-process-echoes t))
(with-eval-after-load 'shell
  (add-hook 'shell-mode-hook #'my-init-shell-mode))

; bindings to launch shells
(global-set-key "\^Xs"  'shell)
(global-set-key "\^X4s" 'shell-other-window)

(defun shell-other-window (shell-number)
  "Run shell in other window."
  (interactive "P")
  (if (equal shell-number nil)
      (setq shell-number 1))
  (switch-to-buffer-other-window "*shell*") ;; only default shell
  (shell))

;; from eclipse.ini
;; -Dorg.eclipse.swt.internal.carbon.smallFonts

;; custom font from https://github.com/source-foundry/Hack
(set-frame-font "Hack 16" t)
(add-to-list 'default-frame-alist '(width . 120))
(add-to-list 'default-frame-alist '(height . 80))

(load-theme 'alect-black t) ; for now


;; rust support
(use-package rust-mode)
(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))
(setq rust-format-on-save t)

;(evil-mode 1)

;; Not quite sure if I need this but...
(dirtrack-mode 0)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(compilation-ask-about-save nil)
 '(completion-ignored-extensions
   '(".o" "~" ".bin" ".lbin" ".so" ".a" ".ln" ".blg" ".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".svn/" ".hg/" ".git/" ".bzr/" "CVS/" "_darcs/" "_MTN/" ".fmt" ".tfm" ".class" ".fas" ".lib" ".mem" ".x86f" ".sparcf" ".dfsl" ".pfsl" ".d64fsl" ".p64fsl" ".lx64fsl" ".lx32fsl" ".dx64fsl" ".dx32fsl" ".fx64fsl" ".fx32fsl" ".sx64fsl" ".sx32fsl" ".wx64fsl" ".wx32fsl" ".fasl" ".ufsl" ".fsl" ".dxl" ".lo" ".la" ".gmo" ".mo" ".toc" ".aux" ".cp" ".fn" ".ky" ".pg" ".tp" ".vr" ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs" ".pyc" ".pyo" ".egg-info/"))
 '(custom-enabled-themes '(alect-black))
 '(custom-safe-themes
   '("ab04c00a7e48ad784b52f34aa6bfa1e80d0c3fcacc50e1189af3651013eb0d58" "04dd0236a367865e591927a3810f178e8d33c372ad5bfef48b5ce90d4b476481" "59171e7f5270c0f8c28721bb96ae56d35f38a0d86da35eab4001aebbd99271a8" "7153b82e50b6f7452b4519097f880d968a6eaf6f6ef38cc45a144958e553fbc6" default))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(rust-mode elixir-mode magit evil go-autocomplete zenburn-theme alect-themes atom-one-dark-theme flymake-go flycheck dumb-jump gotest go-direx go-gopath go-eldoc go-add-tags go-stacktracer diminish use-package exec-path-from-shell auto-complete))
 '(ring-bell-function 'ignore)
 '(shell-file-name "/bin/zsh")
 '(shell-popd-regexp "popd\\|po")
 '(shell-pushd-regexp "pushd\\|pu\\|[0-9]")
 '(tool-bar-mode nil)
 '(visible-bell t))


;(hide-cstm-set-faces
  ;; cstm-set-faces was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
; '(default ((t (:background "seashell"))))
; '(bold ((t (:bold t :foreground "firebrick3"))))
; '(code-keywords-serious-face ((t (:foreground "black" :background "magenta"))))
; '(code-keywords-warning-face ((t (:foreground "black" :background "yellow"))))
; '(font-lock-comment-face ((t (:foreground "green4"))))
; '(font-lock-constant-face ((t (:foreground "DodgerBlue"))))
; '(font-lock-function-name-face ((t (:foreground "purple4"))))
; '(font-lock-keyword-face ((t (:foreground "DeepPink2"))))
; '(font-lock-string-face ((t (:foreground "red3"))))
; '(font-lock-type-face ((t (:foreground "IndianRed4"))))
; '(italic ((t (:italic t :foreground "RoyalBlue2"))))
; '(modeline ((t (:background "DarkSlateBlue" :foreground "seashell"))))
; '(region ((t (:background "MistyRose2")))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "DodgerBlue4" :foreground "#b2af95" :box (:line-width 2 :style released-button)))))
 '(region ((t (:extend t :background "MistyRose2")))))

(server-start)

(provide 'init)
;;; init.el ends here
