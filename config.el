(setq doom-font (font-spec :family "JetBrains Mono" :size 25)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 25)
      doom-big-font (font-spec :family "JetBrains Mono" :size 27)
      doom-symbol-font (font-spec :family "JetBrainsMono Nerd Font" :size 25))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

;; Global settings (defaults)
(setq doom-themes-enable-bold t
      doom-themes-enable-italic t)
(load-theme 'doom-tokyo-night t)

;; Enable custom neotree theme (all-the-icons must be installed!)
(doom-themes-neotree-config)
;; or for treemacs users
(setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
(doom-themes-treemacs-config)
;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)

;; enable word-wrap (almost) everywhere
(+global-word-wrap-mode +1)

(setq +tree-sitter-hl-enabled-modes t)

(map! :leader
      :desc "Org babel tangle" "m b b" #'org-babel-tangle)

(after! org
  (setq org-directory "~/org"
        org-ellipsis " ▼ "))

(after! org
  (global-org-modern-mode))

(after! org
  (require 'org-tempo)
  (pushnew! org-structure-template-alist
            '("el" . "src emacs-lisp")))

(remove-hook! '(org-mode-hook text-mode-hook conf-mode-hook vterm-mode-hook)
  #'display-line-numbers-mode)

(setq doom-modeline-enable-word-count t)

(after! neotree
  (setq neo-smart-open t
        neo-window-fixed-size nil))
(after! doom-themes
  (setq doom-neotree-enable-variable-pitch t))
(map! :leader
      :desc "Toggle neotree file viewer" "t n" #'neotree-toggle
      :desc "Open directory in neotree"  "d n" #'neotree-dir)

(after! org
  (setq org-roam-directory "~/org/roam/"
        org-roam-graph-viewer "/usr/bin/brave"))

(map! :leader
      (:prefix ("n r" . "org-roam")
       :desc "Completion at point" "c" #'completion-at-point
       :desc "Find node"           "f" #'org-roam-node-find
       :desc "Show graph"          "g" #'org-roam-graph
       :desc "Insert node"         "i" #'org-roam-node-insert
       :desc "Capture to node"     "n" #'org-roam-capture
       :desc "Toggle roam buffer"  "r" #'org-roam-buffer-toggle))
