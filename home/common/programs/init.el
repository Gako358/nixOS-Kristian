;;; init --- Extra configuration for emacs in nix
;;; Commentary:

;;; Code:
(setq inhibit-startup-message t) ; Disable startup message
(menu-bar-mode -1) ; Disable the menu bar
(tool-bar-mode -1) ; Disable the toolbar
(scroll-bar-mode -1) ; Disable the scroll bar
(setq-default indent-tabs-mode nil) ; Use spaces instead of tabs

(setq display-line-numbers-type 'default)
(global-display-line-numbers-mode t)

;; Package Specific Settings

;; Git gutter
;; git-gutter
(require 'git-gutter)
(add-hook 'prog-mode-hook 'git-gutter-mode)
(setq git-gutter:update-interval 0.05)

;; git-gutter-fringe
(require 'git-gutter-fringe)
(define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
(define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
(define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom)

;; Tabspaces
(require 'tabspaces)
(setq tabspaces-use-filtered-buffers-as-default t)
(setq tabspaces-default-tab "Default")
(setq tabspaces-remove-to-default t)
(setq tabspaces-include-buffers '("*scratch*"))
(setq tabspaces-initialize-project-with-todo t)
(setq tabspaces-todo-file-name "project-todo.org")
;;Tabspaces sessions
(setq tabspaces-session t)
(setq tabspaces-session-auto-restore t)

(yas-global-mode 1) ; Enable YASnippet

;; Function to kill all buffers except the current one
(defun kill-all-buffers-except-current ()
"Ask for confirmation before killing all buffers except the current one."
(interactive)
(if (yes-or-no-p "Really kill all buffers except the current one? ")
    (let ((current-buffer (current-buffer)))
        (mapc 'kill-buffer (delq current-buffer (buffer-list)))
        (delete-other-windows))))
;; Rg
(require 'rg)

;; Evil Mode
(setq evil-want-keybinding nil)
(require 'evil)
(evil-mode 1)
(evil-collection-init '(calendar dired magit org org-roam))

;; Set the leader key to space
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
  "b" 'counsel-switch-buffer
  "f" 'counsel-find-file
  "k" 'kill-buffer
  "q" 'kill-all-buffers-except-current
  "w" 'save-buffer
  "x" 'counsel-M-x
  "F" 'counsel-rg
  "d" 'dired
  "t" 'tabspaces-command-map
  "/" 'magit-status
  "<SPC>" 'project-find-file
  "ps" 'project-shell
  "pb" 'project-switch-to-buffer
  
  ;; Org Keybindings
  "oa" 'org-agenda
  "oc" 'org-capture

  ;; Lsp keybinds
  "gd" 'xref-find-definitions
  "gr" 'xref-find-references
  "gf" 'eglot-format
  "ga" 'eglot-code-actions
  "gt" 'eglot-find-typeDefinition
  "gh" 'eglot-inlay-hints-mode

  ;; rg.el
  "sp" 'rg-project
  "sdp" 'rg-dwim-project-dir
  "sd" 'rg-dwim
)

;; Flycheck
(require 'flycheck)
(global-flycheck-mode) ; Enable flycheck

;; Set keybindings for moving between windows
(global-set-key (kbd "C-h") 'windmove-left)
(global-set-key (kbd "C-j") 'windmove-down)
(global-set-key (kbd "C-k") 'windmove-up)
(global-set-key (kbd "C-l") 'windmove-right)

;; Which Key
(require 'which-key)
(which-key-mode)

;; Ivy & Counsel
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)

;; Enable SQL
(require 'sql)

(defun upcase-sql-keywords ()
(interactive)
(save-excursion
    (dolist (keywords sql-mode-postgres-font-lock-keywords)
    (goto-char (point-min))
    (while (re-search-forward (car keywords) nil t)
        (goto-char (+ 1 (match-beginning 0)))
        (when (eql font-lock-keyword-face (face-at-point))
        (backward-char)
        (upcase-word 1)
        (forward-char))))))

;; Javascript Environment
(helm-mode +1)
(require 'web-mode)
(require 'helm-xref)
(require 'vue-mode)
(require 'json-mode)
(require 'dap-chrome)
(add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-mode))
(flycheck-add-mode 'javascript-eslint 'web-mode)

;; Web-mode configurations
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.liquid\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(setq web-mode-enable-auto-closing t)
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-part-padding 2)
(setq web-mode-script-padding 2)
(setq web-mode-style-padding 2)
(setq web-mode-code-indent-offset 2)

;; Copilot
;;(require 'copilot)
;;(add-hook 'prog-mode-hook 'copilot-mode)
;;(define-key copilot-completion-map (kbd "C-p") 'copilot-accept-completion)
;;(define-key copilot-mode-map (kbd "C-j") #'copilot-next-completion)
;;(define-key copilot-mode-map (kbd "C-k") #'copilot-previous-completion)
;;(add-to-list 'copilot-major-mode-alist '("scala-ts" . "scala"))

;; Xml Pretty Print
(defun xml-pretty-print (beg end &optional arg)
"Reformat the region between BEG and END.
With optional ARG, also auto-fill."
(interactive "*r\nP")
(shell-command-on-region beg end "xmllint --format -" t t))

(setq major-mode-remap-alist
'((yaml-mode . yaml-ts-mode)
    (bash-mode . bash-ts-mode)
    (js2-mode . js-ts-mode)
    (typescript-mode . typescript-ts-mode)
    (json-mode . json-ts-mode)
    (css-mode . css-ts-mode)
    (python-mode . python-ts-mode)))

;; Tree-sitter-config
(setq treesit-font-lock-level 4)

;; Eglot
(dolist (mode
    '(
        clojure-mode-hook
        clojurescript-mode-hook
        clojurec-mode-hook
        scala-ts-mode-hook
        ))
(add-hook mode 'eglot-ensure))
(add-hook 'java-mode-hook 'eglot-java-mode)
(add-hook 'after-save-hook 'eglot-format)

(with-eval-after-load 'eglot
(add-to-list 'eglot-server-programs '((scala-mode scala-ts-mode) . ("metals"))))

;; Company
(require 'company)
(setq company-backends '(company-capf))
(add-hook 'after-init-hook 'global-company-mode)

;; Direnv Configuration
(direnv-mode)

;; EditorConfig
(require 'editorconfig)
(editorconfig-mode 1)

;; Font
(require 'kanagawa-theme)
(add-hook 'after-make-frame-functions
            (lambda (frame)
              (with-selected-frame frame
		 (load-theme 'doom-one t)
                 (set-frame-font "Iosevka Nerd Font 12" nil t)
                 (company-quickhelp-mode)
		 )))

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook #'tabspaces-mode)

;; Turn off bell
(setq ring-bell-function 'ignore)

;; Themes
(require 'doom-themes)
(require 'doom-modeline)
(doom-modeline-mode 1)
(setq doom-modeline-icon t)
(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-height 35)
(setq doom-modeline-minor-modes t)
(setq doom-modeline-enable-word-count t)
(setq doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode text-mode))
(setq doom-modeline-buffer-encoding t)
(setq doom-modeline-indent-info t)
(setq doom-modeline-total-line-number t)
(setq doom-modeline-github t)
(setq doom-modeline-github-interval (* 10 60))

(server-start)
