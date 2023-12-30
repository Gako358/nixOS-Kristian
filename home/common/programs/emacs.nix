{ pkgs, ... }:
let
  # Emacs Copilot Installation Definition
  emacsCopilotSrc = builtins.fetchGit {
    url = "https://github.com/zerolfx/copilot.el.git";
    rev = "421703f5dd5218ec2a3aa23ddf09d5f13e5014c2";
  };
  scalaTsModeSrc = builtins.fetchGit {
    url = "https://github.com/KaranAhlawat/scala-ts-mode.git";
    rev = "cbfab189842ce564d9514f1b65a72b0af0d51438";
  };

  kanagawaThemeSrc = builtins.fetchGit {
    url = "https://github.com/meritamen/emacs-kanagawa-theme.git";
    rev = "cd4869986e0a3f688131007f1366f6041ef8d818";
  };
in
{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs:
      with epkgs; [
        # Core packages
        evil # Extensible Vi Layer for Emacs
        evil-collection # A set of keybindings for evil mode
        evil-nerd-commenter # Comment/uncomment lines efficiently
        evil-surround # Emulates vim-surround functionality in Emacs
        evil-leader # A minor mode for Emacs that emulates Vim's "leader" key
        general # Provides a more convenient way to define keybindings
        which-key # Displays available keybindings in popup

        # Optional packages.
        all-the-icons # A package for inserting developer icons
        all-the-icons-dired # Shows icons for each file in dired mode
        all-the-icons-ivy-rich # More friendly display transformer for ivy
        dired-single # Reuse the dired buffer
        direnv # Environment switcher for Emacs
        docker # Docker integration
        dockerfile-mode # Major mode for editing Dockerfiles
        editorconfig # EditorConfig Emacs Plugin
        eldoc # Show function arglist or variable docstring in echo area
        emojify # Display emojis in Emacs
        eshell-prompt-extras # Display extra information and color for your eshell prompt
        flycheck # On-the-fly syntax checking
        hydra # Make bindings that stick around
        ivy # A generic completion mechanism
        ivy-posframe # Display ivy in a posframe
        ivy-prescient # Better sorting and filtering for ivy
        ivy-rich # More friendly display transformer for ivy
        ligature # Ligature support for Emacs
        magit # A Git porcelain inside Emacs
        nerd-icons # Nerd icons for Emacs
        nix-mode # Nix integration
        org # For keeping notes, maintaining TODO lists, and project planning
        org-drill # A spaced repetition system for Emacs
        org-pomodoro # Pomodoro technique implementation
        org-roam # A note-taking tool based on the principles of networked thought
        org-roam-ui # A graphical user interface for org-roam
        pretty-mode # Redisplay parts of the buffer as pretty symbols
        projectile # Project Interaction Library for Emacs
        # protobuf-mode # Major mode for editing protocol buffers
        # simple-httpd # A simple HTTP server
        # websocket # WebSocket client and server
        web-mode # Major mode for editing web templates
        # writegood-mode # A minor mode to aid in finding common writing problems

        # Terminal
        vterm # Fully-featured terminal emulator
        multi-vterm # Manage multiple vterm buffers

        # Theme
        doom-modeline # A fancy and fast mode-line

        # Language Server
        dap-mode # Debug Adapter Protocol mode
        # ccls # C/C++/ObjC language server
        helm-lsp # Helm UI for the Language Server Protocol
        lsp-java # Java
        lsp-metals # Scala language server
        lsp-treemacs # Treemacs integration f
        lsp-tailwindcss # Tailwind CSS support for lsp-mode
        lsp-mode # An implementation of the Language Server Protocol
        lsp-ui # UI integrations for lsp-mode

        # Programming language packages.
        company # Modular text completion framework
        helm-xref # Helm UI for xref
        go-mode # Major mode for the Go programming language
        javap-mode # Major mode for editing Java bytecode
        java-imports # Automatically import Java classes
        java-snippets # Yasnippets for Java
        javadoc-lookup # Lookup Javadoc documentation
        json-mode # Major mode for editing JSON files
        organize-imports-java # Organize imports for Java
        vue-mode # Major mode for editing Vue.js files
        yaml-mode # Major mode for editing YAML files
        yasnippet # Template system for Emacs
        clojure-mode # Major mode for editing clojure files
        cider # Extends clojure-mode with superpowers

        # User interface packages.
        counsel # Various completion functions using Ivy
      ];
    extraConfig = ''
      ;; General Settings
      (defun nix-path (exeFile &rest joins)
        "It returns the path to the /nix/store of EXEFILE and joins JOINS together into a string."
        (let* ((target (string-trim (executable-find exeFile)))
        (path (string-trim (shell-command-to-string (format "nix-store -q %s" target)))))
          (string-join (cons path joins))))

      (setq inhibit-startup-message t) ; Disable startup message
      (menu-bar-mode -1) ; Disable the menu bar
      (tool-bar-mode -1) ; Disable the toolbar
      (scroll-bar-mode -1) ; Disable the scroll bar
      (setq-default indent-tabs-mode nil) ; Use spaces instead of tabs

      ;; Enable relative line numbers
      (setq display-line-numbers-type 'default)
      (global-display-line-numbers-mode t)

      ;; Package Specific Settings

      (yas-global-mode 1) ; Enable YASnippet

      ;; Function to kill all buffers except the current one
      (defun kill-all-buffers-except-current ()
        "Ask for confirmation before killing all buffers except the current one."
        (interactive)
        (if (yes-or-no-p "Really kill all buffers except the current one? ")
            (let ((current-buffer (current-buffer)))
              (mapc 'kill-buffer (delq current-buffer (buffer-list)))
              (delete-other-windows))))

      ;; Evil Mode
      (require 'evil)
      (evil-mode 1)

      ;; Set the leader key to space
      (global-evil-leader-mode)
      (evil-leader/set-leader "<SPC>")
      (evil-leader/set-key
        "b" 'ivy-switch-buffer
        "f" 'counsel-find-file
        "k" 'kill-buffer
        "q" 'kill-all-buffers-except-current
        "w" 'save-buffer
        "x" 'counsel-M-x
        "F" 'counsel-git-grep
        "d" 'dired
        "t" 'vterm
        "p" 'projectile-command-map
        "/" 'magit-status

        ;; Org Keybindings
        "oa" 'org-agenda
        "oc" 'org-capture

        ;; LSP Keybindings
        "lws" 'lsp-ui-sideline-mode
        "lwd" 'lsp-ui-doc-mode
        "lwr" 'lsp-ui-peek-find-references
        "lwf" 'lsp-ui-peek-find-definitions
        "lwa" 'lsp-ui-peek-find-implementation
        "lwh" 'lsp-ui-doc-glance
        "lwe" 'lsp-treemacs-errors-list
        "lxf" 'xml-pretty-print
        "lf" 'lsp-format-buffer
        "lr" 'lsp-rename
        "lR" 'lsp-workspace-restart
        "la" 'lsp-execute-code-action
        "ld" 'lsp-describe-thing-at-point
        "lgt" 'lsp-goto-type-definition
        "lgi" 'lsp-goto-implementation
        "lsh" 'lsp-symbol-highlight
        "lwa" 'lsp-workspace-folders-add
        "lwr" 'lsp-workspace-folders-remove
        "lws" 'lsp-workspace-folders-switch

        ;; Java Keybindings
        "jo" 'lsp-java-organize-imports
        "jbp" 'lsp-java-build-project
        "jupc" 'lsp-java-update-project-configuration
        "jan" 'lsp-java-actionable-notifications
        "juus" 'lsp-java-update-user-settings
        "jus" 'lsp-java-update-server
        "jgt" 'lsp-java-generate-to-string
        "jgeh" 'lsp-java-generate-equals-and-hash-code
        "jgo" 'lsp-java-generate-overrides
        "jggs" 'lsp-java-generate-getters-and-setters
        "jth" 'lsp-java-type-hierarchy
        "jec" 'lsp-java-extract-to-constant
        "jaum" 'lsp-java-add-unimplemented-methods
        "jcp" 'lsp-java-create-parameter
        "jcf" 'lsp-java-create-field
        "jcl" 'lsp-java-create-local
        "jem" 'lsp-java-extract-method
        "jai" 'lsp-java-add-import
        "jtb" 'lsp-jt-browser
        "jro" 'lsp-jt-report-open
        "jlm" 'lsp-jt-lens-mode)

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

      ;; Projectile
      (setq projectile-project-search-path '("~/src/" ))
      (defvar projectile-project-root nil)
      (projectile-mode +1)

      ;; LSP Mode
      (require 'lsp-mode)
      (add-hook 'prog-mode-hook #'lsp-deferred)

      (require 'lsp-java)
      (add-hook 'java-mode-hook #'lsp-deferred)
      (setq lsp-java-server-install-dir "${pkgs.jdt-language-server}/share/java")

      ;; Enable LSP-UI
      (require 'lsp-ui)
      (add-hook 'lsp-mode-hook 'lsp-ui-mode)

      ;; Enable Scala
      ;; scala-ts-mode configuration
      (let ((scala-ts-mode-dir "~/.scalaTsMode")
            (scala-ts-mode-file "~/.scalaTsMode/scala-ts-mode.el"))
        ;; Check if the scala-ts-mode.el file exists
        (when (file-exists-p scala-ts-mode-file)
          ;; Add the directory to the load-path
          (add-to-list 'load-path scala-ts-mode-dir)
          ;; Try to load the scala-ts-mode module and catch any errors
          (condition-case err
              (progn
                (require 'scala-ts-mode))
            ;; If there's an error, print a message (you can also log or take other actions)
            (error (message "Failed to load scala-ts-mode: %s" err)))))


      (require 'lsp-metals)
      (add-hook 'scala-ts-hook #'lsp-metals-bootstrapped)

      ;; Enable LSP-TailwindCSS
      (require 'lsp-tailwindcss)
      (add-hook 'css-mode-hook #'lsp-deferred)

      ;; (require 'python-mode)
      ;; (require 'lsp-pyright)
      ;; (require 'blacken)
      ;; (add-hook 'python-mode-hook #'lsp-deferred)

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
      (add-hook 'vue-mode-hook #'lsp-deferred)
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

      ;; Copilot Configuration
      (let ((copilot-dir "~/.emacsCopilot")
            (copilot-file "~/.emacsCopilot/copilot.el"))
        ;; Check if the copilot.el file exists
        (when (file-exists-p copilot-file)
          ;; Add the directory to the load-path
          (add-to-list 'load-path copilot-dir)
          ;; Try to load the copilot module and catch any errors
          (condition-case err
              (progn
                (require 'copilot)
                (add-hook 'prog-mode-hook 'copilot-mode)
                (define-key copilot-completion-map (kbd "C-p") 'copilot-accept-completion)
                (define-key copilot-mode-map (kbd "C-j") #'copilot-next-completion)
                (define-key copilot-mode-map (kbd "C-k") #'copilot-previous-completion))
            ;; If there's an error, print a message (you can also log or take other actions)
            (error (message "Failed to load copilot: %s" err)))))

      ;; Xml Pretty Print
      (defun xml-pretty-print (beg end &optional arg)
        "Reformat the region between BEG and END.
        With optional ARG, also auto-fill."
        (interactive "*r\nP")
        (shell-command-on-region beg end "xmllint --format -" t t))

      ;; Enable Tree-sitter langs
      (setq treesit-language-source-alist
      '((bash "https://github.com/tree-sitter/tree-sitter-bash")
       (scala "https://github.com/tree-sitter/tree-sitter-scala")
      ))


      (add-hook 'java-mode-hook #'tree-sitter-mode)
      (add-hook 'java-mode-hook #'tree-sitter-hl-mode)

      (require 'company)
      (setq company-backends '(company-capf))

      ;; Direnv Configuration
      (direnv-mode)

      ;; EditorConfig
      (require 'editorconfig)
      (editorconfig-mode 1)

      ;; Vterm Configuration
      (require 'vterm)

      ;; Kanagawa theme
      (let ((kanagawa-theme-dir "~/.emacsKanagawaTheme")
            (kanagawa-theme-file "~/.emacsKanagawaTheme/kanagawa-theme.el"))
        ;; Check if the kanagawa-theme.el file exists
        (when (file-exists-p kanagawa-theme-file)
          ;; Add the directory to the load-path
          (add-to-list 'load-path kanagawa-theme-dir)
          ;; Try to load the kanagawa-theme module and catch any errors
          (condition-case err
              (progn
                (require 'kanagawa-theme))
            ;; If there's an error, print a message (you can also log or take other actions)
            (error (message "Failed to load kanagawa-theme: %s" err)))))

      (load-theme 'kanagawa t)

    '';
  };

  home.packages = with pkgs; [
    rnix-lsp
    metals
    clojure-lsp
    jdt-language-server
  ];

  home.file.".emacsCopilot".source = emacsCopilotSrc;
  home.file.".scalaTsMode".source = scalaTsModeSrc;
  home.file.".emacsKanagawaTheme".source = kanagawaThemeSrc;
}
