(setq doom-font (font-spec :family "JetBrains Mono" :size 28)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 28)
      doom-big-font (font-spec :family "JetBrains Mono" :size 30)
      doom-symbol-font (font-spec :family "JetBrainsMono Nerd Font" :size 28))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(map! :leader
      :desc "Open like spacemacs" "SPC" #'execute-extended-command)

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

(global-prettify-symbols-mode +1)

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

;; Remember to check the doc strings of those variables.
(after! denote
  (setq denote-directory (expand-file-name "~/Documents/notes/"))
  (setq denote-save-buffers nil)
  (setq denote-known-keywords '("emacs" "philosophy" "politics" "economics"))
  (setq denote-infer-keywords t)
  (setq denote-sort-keywords t)
  (setq denote-file-type nil) ; Org is the default, set others here
  (setq denote-prompts '(title keywords))
  (setq denote-excluded-directories-regexp nil)
  (setq denote-excluded-keywords-regexp nil)
  (setq denote-rename-confirmations '(rewrite-front-matter modify-file-name)) 
  (setq denote-date-prompt-use-org-read-date t)
  ;; Read this manual for how to specify `denote-templates'.  We do not
  ;; include an example here to avoid potential confusion.
  (setq denote-date-format nil) ; read doc string
  
  ;; By default, we do not show the context of links.  We just display
  ;; file names.  This provides a more informative view.
  (setq denote-backlinks-show-context t)

  ;; Also see `denote-backlinks-display-buffer-action' which is a bit
  ;; advanced.

  ;; If you use Markdown or plain text files (Org renders links as buttons
  ;; right away)
  (add-hook 'text-mode-hook #'denote-fontify-links-mode-maybe)

;; We use different ways to specify a path for demo purposes.
  (setq denote-dired-directories
        (list denote-directory
              (thread-last denote-directory (expand-file-name "attachments"))
              (expand-file-name "~/Documents/books")))
  
  ;; Generic (great if you rename files Denote-style in lots of places):
  ;; (add-hook 'dired-mode-hook #'denote-dired-mode)
  ;;
  ;; OR if only want it in `denote-dired-directories':
  (add-hook 'dired-mode-hook #'denote-dired-mode-in-directories)


  ;; Automatically rename Denote buffers using the `denote-rename-buffer-format'.
  (denote-rename-buffer-mode 1)

;; Denote DOES NOT define any key bindings.  This is for the user to
  ;; decide.  For example:
  (let ((map global-map))
    (define-key map (kbd "C-c n n") #'denote)
    (define-key map (kbd "C-c n c") #'denote-region) ; "contents" mnemonic
    (define-key map (kbd "C-c n N") #'denote-type)
    (define-key map (kbd "C-c n d") #'denote-date)
    (define-key map (kbd "C-c n z") #'denote-signature) ; "zettelkasten" mnemonic
    (define-key map (kbd "C-c n s") #'denote-subdirectory)
    (define-key map (kbd "C-c n t") #'denote-template)
    ;; If you intend to use Denote with a variety of file types, it is
    ;; easier to bind the link-related commands to the `global-map', as
    ;; shown here.  Otherwise follow the same pattern for `org-mode-map',
    ;; `markdown-mode-map', and/or `text-mode-map'.
    (define-key map (kbd "C-c n i") #'denote-link) ; "insert" mnemonic
    (define-key map (kbd "C-c n I") #'denote-add-links)
    (define-key map (kbd "C-c n b") #'denote-backlinks)
    (define-key map (kbd "C-c n f f") #'denote-find-link)
    (define-key map (kbd "C-c n f b") #'denote-find-backlink)
    ;; Note that `denote-rename-file' can work from any context, not just
    ;; Dired bufffers.  That is why we bind it here to the `global-map'.
    (define-key map (kbd "C-c n r") #'denote-rename-file)
    (define-key map (kbd "C-c n R") #'denote-rename-file-using-front-matter))
  
  ;; Key bindings specifically for Dired.
  (let ((map dired-mode-map))
    (define-key map (kbd "C-c C-d C-i") #'denote-link-dired-marked-notes)
    (define-key map (kbd "C-c C-d C-r") #'denote-dired-rename-files)
    (define-key map (kbd "C-c C-d C-k") #'denote-dired-rename-marked-files-with-keywords)
    (define-key map (kbd "C-c C-d C-R") #'denote-dired-rename-marked-files-using-front-matter))
  
  (with-eval-after-load 'org-capture
    (setq denote-org-capture-specifiers "%l\n%i\n%?")
    (add-to-list 'org-capture-templates
                 '("n" "New note (with denote.el)" plain
                   (file denote-last-path)
                   #'denote-org-capture
                   :no-save t
                   :immediate-finish nil
                   :kill-buffer t
                   :jump-to-captured t)))

;; Also check the commands `denote-link-after-creating',
;; `denote-link-or-create'.  You may want to bind them to keys as well

;; If you want to have Denote commands available via a right click
;; context menu, use the following and then enable
;; `context-menu-mode'.
(add-hook 'context-menu-functions #'denote-context-menu))

(use-package! denote-explore
  :custom
  ;; Location of graph files
  (denote-explore-network-directory "~/documents/notes/graphs/")
  (denote-explore-network-filename "denote-network")
  ;; Output format
  (denote-explore-network-format 'graphviz)
  (denote-explore-network-graphviz-filetype "svg")
  ;; Exlude keywords or regex
  (denote-explore-network-keywords-ignore '("bib")))

(defun my/denote-insert-category (category)
  (save-excursion
    (beginning-of-buffer)
    (while (and
            (< (point) (point-max))
            (string= "#+"
                    (buffer-substring-no-properties
                     (point-at-bol)
                     (+ (point-at-bol) 2))))
      (next-line))

    (insert "#+category: " category)
    (save-buffer)))

(defun my/denote-create-topic-note ()
  (interactive)
  (let* ((topic-files (mapcar (lambda (file)
                                (cons (denote-retrieve-front-matter-title-value file 'org)
                                      file))
                              (denote-directory-files-matching-regexp "_kt")))
         (selected-topic (completing-read "Select topic: "
                                          (mapcar #'car topic-files))))

    (denote (denote-title-prompt (format "%s: " selected-topic))
            (denote-keywords-prompt))

    ;(my/denote-insert-category selected-topic)
    ))

(defun my/denote-extract-subtree ()
  (interactive)
  (save-excursion
    (if-let ((text (org-get-entry))
             (heading (denote-link-ol-get-heading)))
        (progn
          (delete-region (org-entry-beginning-position)
                         (save-excursion (org-end-of-subtree t) (point)))
          (denote heading (denote-keywords-prompt) 'org)
          (insert text)))))

(defvar my/denote-keywords
  '(("pra" . "Active Project")
    ("prb" . "Backlogged Project")
    ("prc" . "Closed Project")))

(defun my/denote-custom-affixation (completions)
  (mapcar (lambda (completion)
            (list completion
                  ""
                  (alist-get completion
                             my/denote-keywords
                             nil
                             nil
                             #'string=)))
          completions))

(defun my/denote-keyword-prompt ()
  (let ((completion-extra-properties
         (list :affixation-function
               #'my/denote-custom-affixation)))
    (denote-keywords-prompt)))
