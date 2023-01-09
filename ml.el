;; Define and initialise package repositories
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; use-package to simplify the config file
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure 't)

;; Open maximized.
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Get rid of annoying toolbars at the top.
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
;; Allow 'y' or 'n' for any confirm messages instead of 'yes' and 'no'.
(defalias 'yes-or-no-p 'y-or-n-p)

;; When reopening a file, go to where I was before.
(save-place-mode 1)

;; Automatically update files when they update on disk (git merge, etc.).
(global-auto-revert-mode 1)

;; Theme
(use-package exotica-theme
  :config (load-theme 'exotica t))

;; Make comments easier to read (higher contrast).
(set-face-foreground 'font-lock-comment-face "gray62")

;; Pretty paired brackets.
(use-package rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; Smart matching for opening files/directories.
(use-package ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(use-package ido-vertical-mode)
(ido-vertical-mode 1)

;; The important stuff for getting code highlighting, autocomplete, etc.
(use-package lsp-mode)

;; Actually use lsp.
(add-hook 'prog-mode-hook #'lsp)

;; Add a ui for language/completion stuff.
(use-package lsp-ui
  :bind ("C-?" . lsp-ui-doc-glance)
  :config (setq lsp-ui-doc-position 'at-point))

;; This gives nice popups for auto-complete on variables.
;; idle-delay nil means it only does it when I ask it to with M-/.
(use-package company
  :bind ("M-/" . company-complete)
  :config (setq company-idle-delay nil))

;; Rust formatting.
(use-package rust-mode)
(add-hook 'rust-mode-hook 'lsp)

;; Needed for php.
(use-package yasnippet)

;; php formatting.
(use-package php-mode)
;; Phpactor not found. I couldn't resolve this error.
;; (use-package phpactor :ensure t)
;; (use-package company-phpactor :ensure t)
(add-hook 'php-mode-hook 'lsp)
;; (phpactor-install-or-update)

;; Dockerfile formatting.
(use-package dockerfile-mode)
(add-hook 'dockerfile-mode-hook 'lsp)
(add-to-list 'auto-mode-alist '("Dockerfile-[a-zA-Z]*" . dockerfile-mode))

;; Typescript mode.
(use-package typescript-mode
  ;; Typescript should only be indented to 2.
  :config (setq typescript-indent-level 2)
  ;; Typescript on .tsx files.
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode)))

;; Json should only use 4? spaces for indenting.
(use-package json-mode)
(add-hook 'json-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 4)))
;; Non-functional attempt to make this prompt for something to jump to definition of.
(global-set-key (kbd "C-.") 'xref-find-apropos)

;; Set M-, to pop global mark, not just definition-jumping marks.
(global-set-key (kbd "M-,") 'pop-global-mark)

;; Nice keys for surrounding selection in pairs.
(global-set-key (kbd "M-[") 'insert-pair)
(global-set-key (kbd "M-{") 'insert-pair)
(global-set-key (kbd "M-\"") 'insert-pair)
(global-set-key (kbd "M-'") 'insert-pair)

;; Better buffer management
(global-set-key (kbd "<f8>") 'ibuffer)

(use-package multiple-cursors
  :config
  ;; When you have an active region that spans multiple lines, the following will add a cursor to each line:
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  ;; When you want to add multiple cursors not based on continuous lines, but based on keywords in the buffer, use:
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
)

;; Jenkinsfiles should look nice.
(use-package jenkinsfile-mode)
(use-package groovy-mode)

;; So should yaml/yml files.
(use-package yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
;; This makes enter auto-indent in yaml mode.
(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
;; Proper indent.
(setq yaml-indent-offset 4)

;; Never use tabs for indentation.
(setq-default indent-tabs-mode nil)
;; Display tabs in red.
(setq whitespace-style '(face trailing tabs))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-tab ((t (:background "red")))))
;; Show extra whitespace that'll get deleted.
(setq-default show-trailing-whitespace t)
(add-hook 'prog-mode-hook 'whitespace-mode)


;; ;; Tree sitter (which should be built into emacs in the next full version) supports syntax highlighting, etc.,
;; ;; for most programming languages.
;; (use-package tree-sitter
;;   :ensure t
;;   :config
;;   ;; activate tree-sitter on any buffer containing code for which it has a parser available
;;   (global-tree-sitter-mode)
;;   ;; you can easily see the difference tree-sitter-hl-mode makes for python, ts or tsx
;;   ;; by switching on and off
;;   (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

;; (use-package tree-sitter-langs
;;   :ensure t
;;   :after tree-sitter)

;; Hideshow. Always when programming.
(add-hook 'prog-mode-hook #'hs-minor-mode)
;; (add-hook 'yaml-mode-hook #'hs-minor-mode) ;; It doesn't work in yaml mode. :(
(add-hook 'hs-minor-mode-hook
          '(lambda ()
             ;; Blocks of code.
             (define-key hs-minor-mode-map (kbd "S-<left>") 'hs-hide-block)
             (define-key hs-minor-mode-map (kbd "S-<right>") 'hs-show-block)
             ;; Collapse up to current level.
             (define-key hs-minor-mode-map (kbd "C-S-<left>") 'hs-hide-level)
             ;; Expand all.
             (define-key hs-minor-mode-map (kbd "C-S-<right>") 'hs-show-all)))

;; Same for highlighting indents.
(use-package highlight-indent-guides)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(add-hook 'yaml-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'character) ;; solid line
(setq highlight-indent-guides-responsive 'top)   ;; highlight current indent level.

;; Moving line or selection up or down with M-p and M-n.
(use-package move-text)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

(global-set-key (kbd "M-<up>") 'backward-paragraph)
(global-set-key (kbd "M-<down>") 'forward-paragraph)

;; Moving between windows/buffers.
(global-set-key (kbd "C-'") 'other-window)
(global-set-key (kbd "C-<tab>") 'ns-next-frame)
(global-set-key (kbd "<f8>") 'list-buffers)

;; Fast access to kill buffer.
(global-set-key (kbd "<f4>") 'kill-buffer)

;; When C-k at beginning of line, kill/yank the newline too.
(setq kill-whole-line t)

;; Fast access to cleaning up whitespace to one space.
(global-set-key (kbd "M-<space>") 'fixup-whitespace)

;; Cycling between snake_case and camelCase.
(use-package string-inflection
  :config
  (defun string-inflection-mark-style-function (str)
    "foo_bar => fooBar => foo_bar"
    (cond ((string-inflection-underscore-p str)
           (string-inflection-camelcase-function str))
          (t
           (string-inflection-underscore-function str))))
  (defun string-inflection-mark-style-cycle ()
    "foo_bar => fooBar => foo_bar"
    (interactive)
    (string-inflection-insert
     (string-inflection-mark-style-function (string-inflection-get-current-word))))
  :bind ("C-b" . string-inflection-mark-style-cycle))

;; Enables C-; binding to jump around to symbols and refactor a file.
(use-package iedit)

;; Tell mac OS to shut up about ls dired not working.
(when (string= system-type "darwin")
  (setq dired-use-ls-dired nil))

;; Uneditable command prompt to prevent accidental deletions.
(setq comint-prompt-read-only t)

;; Use system shell env vars in emacs shell.
(use-package exec-path-from-shell)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(use-package vterm
  :ensure t
  :config
  (defun turn-off-chrome ()
    (setq-local global-hl-line-mode nil)
    (display-line-numbers-mode -1)
    (setq show-trailing-whitespace nil))
  :hook (vterm-mode . turn-off-chrome))

(defun my-comint-init ()
  "Fix shell echoing."
  (setq comint-process-echoes t))
(add-hook 'comint-mode-hook 'my-comint-init)

;; Commands for the named shells. C-f 8-10 to access.
(defun start-named-shell (buffer-name)
  "Create a new shell with the specified BUFFER-NAME."
  (cond ((not (get-buffer buffer-name))
         (vterm)
         ;; (make-local-variable 'comint-completion-addsuffix)
         ;; (setq comint-completion-addsuffix (quote ("\\" . " ")))
         ;; (setq tab-width 4)
         ;; (setq comint-input-ring-size 100)
         ;; (setq comint-input-ignoredups t)
         ;; (setq comint-process-echoes t)
         (rename-buffer buffer-name))
        ;; if the buffer we want is in the current window, move to
        ;; the end
        ((equal (buffer-name) buffer-name)
         (if (not (equal (point) (point-max)))
             (goto-char (point-max))))
        ;; if the buffer is in another window in the current frame,
        ;; switch to it
        ((get-buffer-window buffer-name)
         (select-window (get-buffer-window buffer-name)))
        ;; if the buffer is in a window in another visible frame,
        ;; set the input focus to the proper frame and window
        ((get-buffer-window buffer-name 'visible)
         (select-frame-set-input-focus
          (window-frame (get-buffer-window buffer-name 'visible)))
         (select-window (get-buffer-window buffer-name 'visible)))
        ;; the buffer is not in any currently visible frame, display
        ;; it in the current window
        (t
         (switch-to-buffer buffer-name))))

(defun vterm1 ()
  "Create shell named vterm1."
  (interactive)
  (start-named-shell "vterm1"))

(defun vterm2 ()
  "Create shell named vterm2."
  (interactive)
  (start-named-shell "vterm2"))

(defun vterm3 ()
  "Create shell named vterm3."
  (interactive)
  (start-named-shell "vterm3"))

(global-set-key (kbd "C-8") 'vterm1)
(global-set-key (kbd "C-9") 'vterm2)
(global-set-key (kbd "C-0") 'vterm3)

;; Shift + arrow to scroll up/down.
(global-set-key (kbd "S-<up>") (kbd "C-u 1 C-v"))
(global-set-key (kbd "S-<down>") (kbd "C-u 1 M-v"))

(use-package flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

;; Always show line numbers.
(global-display-line-numbers-mode)

;; Show column numbers in the mode-line.
(column-number-mode t)

;; Always highlight the current line. In a visible color.
(global-hl-line-mode t)
(set-face-background hl-line-face "gray30")

;; Projectile is for finding files in a project/managing projects.
(use-package projectile)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(use-package projectile-ripgrep)

;; Tell emacs where to find projects.
(setq projectile-project-search-path '("~/atg"))
(projectile-discover-projects-in-search-path)
;; This opens project picker automatically, but gets annoying.
;; (projectile-switch-project)

;; This allows generating uuids for new projects.
(use-package uuidgen)

;; Function to run npm lint on save. NOT TESTED/USED YET.
;; Martin recommends just using a pre-commit hook instead.
(defun npm-lint-fix ()
  "Run npm run lint:fix on the current buffer."
  (interactive)
  (shell-command-on-region
   ;; Select whole buffer.
   (point-min)
   (point-max)
   ;; This does not work because it just runs lint on the entire directory.
   ;; I would like to find a way to run eslint on just a single file/buffer.
   "npm run lint:fix"
   ;; Replace the contents.
   t
   ;; Error buffer:
   "*npm lint error buffer*"
   t))

;; When saving, remove useless trailing whitespaces.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; f3 = save all without prompting.
(defun save-all-buffers (&optional arg)
  "Save everything, negating ARG."
  (interactive "P")
  (save-some-buffers (not arg)))
(global-set-key (kbd "<f3>") 'save-all-buffers)

;; Start with 3 windows, split left-right, and balanced.
(split-window-right)
(split-window-right)
(balance-windows)
;; Then double it.
(make-frame)
(split-window-right)
(split-window-right)
(balance-windows)
;; And give those new ones shells.
(vterm1)
(other-window 1)
(vterm2)
(other-window 1)
( vterm3)
(other-window 1)

(defun highlight-old-years ()
  "Highlight years before 2023."
  (highlight-regexp "201[0-9]")
  (highlight-regexp "202[0-2]"))
(add-hook 'find-file-hook #'highlight-old-years)

;; 2010 2011 2020 2021 2022 2023 2024 2030

;; TODO: Git integration.
;; TODO: org-mode my life!

;; Emacs does this. Don't mess with it.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(exec-path-from-shell uuidgen magit projectile-ripgrep projectile flycheck vterm iedit string-inflection move-text highlight-indent-guides yaml-mode jenkinsfile-mode multiple-cursors typescript-mode dockerfile-mode company-phpactor phpactor php-mode yasnippet rust-mode company lsp-ui lsp-mode ido-vertical-mode rainbow-delimiters exotica-theme use-package)))
