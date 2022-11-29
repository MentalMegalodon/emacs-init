;; Define the init file
(setq inhibit-startup-screen t)
(setq custom-file (expand-file-name "ml.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
