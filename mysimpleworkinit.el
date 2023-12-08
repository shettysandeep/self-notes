(package-initialize)

;; >>>> Set registers
;; C-x r j e - init files
(set-register ?e (cons 'file "~/.emacs.d/init.el"))
;; C-x r j m  - myday file
(set-register ?m (cons 'file "~/OneDrive - AIR/2023-work-tracker.org"))

;; >>>> SET EXEC-PATH
;; added paths to .zshenv and .zprofile

;; >>>> ORG
(require 'org)

;; >>>> USE-PACKAGE
(require 'use-package)

(set-face-bold-p 'bold nil)

;; >>>> PROJECTILE
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)


;; >>> ORG ROAM
(use-package org-roam
  :ensure t)

;; >>> EMBARK_CONSULT
(use-package embark-consult
  :ensure t)

;; >>>> ORG-BULLETS
(use-package org-bullets
    :ensure t
    :init
     (add-hook 'org-mode-hook (lambda ()
				(org-bullets-mode 1))))

(add-hook 'org-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook 'org-indent-mode)


;; hl-todo
(global-hl-todo-mode)


;; >>>> ORG GLOBAL KEY MAPS
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(define-key org-mode-map (kbd "C-c s") 'consult-org-heading)
(define-key org-mode-map (kbd "C-c C-x 1") 'org-refile)

;; >>>> ORG-TODO HIGHLIGHT
;;(use-package hl-todo
;;  :init
;;  (global-hl-todo-mode))
  
;; >>>> ORG-CAPTURE TEMPLATES
(setq org-capture-templates
      '(
	("t" "Todo" entry (file "/Users/sandeep/OneDrive - AIR/2023-work-tracker.org")
         "* TODO %^{Todo} %^g \n:PROPERTIES:\n:Notes:%? %U\n:END:\n\n" :prepend t)
 	;; ("q" "questions" item (file "~/Library/CloudStorage/Box-Box/org-files/knwldge_ngts.org")
         ;; "- %? %U\n  %i\n" :prepend t )
 	("m" "paper_tghts" item (file "/Users/sandeep/Documents/my-org-files/notes_papers.org")
         "* %?\n %U\n %i\n" :prepend t)
	("w" "work-achievements-diary" item (file "/Users/sandeep/Documents/my-org-files/work-achievements-diary.org")
         "* %?\n %U\n %i\n" :prepend t)
	))


;; >>>> ORG-CITE SETTINGS
(require 'oc-csl)
(require 'oc-basic)
(require 'oc-natbib)
(require 'oc-biblatex)
(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))

;; >>>> MAGIT
(use-package magit
  :ensure t
  :init
  (progn
    (bind-key "C-x g" 'magit-status)))

;; >>>>> PYTHON SETTINGS <<<<<

;; ~~~~Python IDE
;; fire up conda-environment first
(setq python-shell-interpreter "python") ;;python 3 vs python

;; (setq python-shell-interpreter "/Users/sandeep/opt/anaconda3/bin/ipython"
      ;; python-shell-interpreter-args "--simple-prompt -i")

(setenv "WORKON_HOME" "/Users/sandeep/opt/miniconda3/envs/")
;; (add-to-list 'python-shell-completion-native-disabled-interpreters
               ;; "python3.8")

;; ~~~ elpy
(use-package elpy
  :ensure t
  :bind
    (:map elpy-mode-map
          ("C-M-n" . elpy-nav-forward-block)
          ("C-M-p" . elpy-nav-backward-block))
    :hook (;;(elpy-mode . flycheck-mode)
           (elpy-mode . (lambda ()
                          (set (make-local-variable 'company-backends)
                               '((elpy-company-backend :with company-yasnippet))))))
    :init
    (elpy-enable)
    :config
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    ; fix for MacOS, see https://github.com/jorgenschaefer/elpy/issues/1550
    (setq elpy-shell-echo-output nil)
    ;; (setq elpy-rpc-python-command "python3")
    (setq elpy-rpc-virtualenv-path 'current)
    (setq elpy-rpc-timeout 2))



(use-package blacken
    :ensure t
    :hook (python-mode . blacken-mode)
    :config
    (setq blacken-line-length '88))

(use-package python-docstring
  :ensure t
    :hook (python-mode . python-docstring-mode))

;;~~~~ PYTHON COMPLETION, ETC. (EVALUATE)
(use-package company
  :ensure t
  :diminish company-mode
  :init
  (global-company-mode)
  :config
  ;; set default `company-backends'
  (setq company-backends
        '((company-files          ; files & directory
           company-keywords       ; keywords
           company-capf
	   company-jedi)  ; completion-at-point-functions
          (company-abbrev company-dabbrev)
          )))

(add-hook 'after-init-hook 'global-company-mode) ;; added Nov 29, 2023 due to path completion is not working well.


(use-package company-jedi
  :ensure t)

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred
  (setq lsp-pyright-use-library-code-for-types t) ;; set this to nil if getting too many false positive type errors
  ;;(setq lsp-pyright-stub-path (concat (getenv "HOME") "/src/python-type-stubs")) ;; example
  (setq lsp-pyright-stub-path (concat (getenv "HOME") "/opt/miniconda3/envs/py38/pandas-stubs")) ;; example

;; ~~~~ Jupyter
(setq exec-path (append exec-path '("/Users/sandeep/opt/miniconda3/etc/")))

;; ~~~ nltk
(setq exec-path (append exec-path '("/Users/sandeep/.local/bin")))

(add-to-list 'load-path "~/opt/miniconda3/lib/python3.9/site-packages")
(add-to-list 'load-path "/Users/sandeep/Library/Python/3.10/bin")

;; fix for your python-shell-interpreter cannot readline, etc.
;;https://emacs.stackexchange.com/questions/30082/your-python-shell-interpreter-doesn-t-seem-to-support-readline


;; (with-eval-after-load 'python
  ;; (defun python-shell-completion-native-try ()
    ;; "Return non-nil if can trigger native completion."
    ;; (let ((python-shell-completion-native-enable t)
          ;; (python-shell-completion-native-output-timeout
           ;; python-shell-completion-native-try-output-timeout))
      ;; (python-shell-completion-native-get-completions
       ;; (get-buffer-process (current-buffer))
       ;; nil "_"))))

;;~~~~~~~~~~~~~PYTHON CONFIG ENDS


;; ~~~ TREESITTER
(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

;; ~~~ smart parens
(smartparens-global-mode)

;;~~~~~~~~~~~~~~~
;; PDF-Tools
;; run commands in terminal to compile
(use-package pdf-tools
      :ensure t
      :pin manual
      :config
      (custom-set-variables
        '(pdf-tools-handle-upgrades nil)) ; Use brew upgrade pdf-tools instead.
      ;;(setq pdf-info-epdfinfo-program "~/.emacs.d/elpa/pdf-tools-0.90/build/server/epdfinfo")
      ;; The above option is package dependent and can get disturbed when new package is intalled
      (setq pdf-info-epdfinfo-program "~/opt/epdfinfo")
       )
;;(pdf-tools-install)

(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
      TeX-source-correlate-start-server t)

(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)


;; >>> YAS
(require 'yasnippet)
(yas-global-mode 1)

;; ls
(setq dired-use-ls-dired t
        insert-directory-program "/usr/local/opt/coreutils/libexec/gnubin/ls"
        dired-listing-switches "-aBhl --group-directories-first")

;; whick key
(use-package which-key
  :ensure t
  :config (which-key-mode))

;; C++ set up
(use-package modern-cpp-font-lock
  :ensure t)

;; Compile C++
(defun code-compile ()
  (interactive)
  (unless (file-exists-p "Makefile")
    (set (make-local-variable 'compile-command)
     (let ((file (file-name-nondirectory buffer-file-name)))
       (format "%s -o %s %s"
           (if  (equal (file-name-extension file) "cpp") "g++" "gcc" )
           (file-name-sans-extension file)
           file)))
    (compile compile-command)))

(global-set-key [f9] 'code-compile)

;; TeX
(setenv "PATH" (concat (getenv "PATH") ":/Library/TeX/texbin/"))  
(setq exec-path (append exec-path '("/Library/TeX/texbin/")))


;; >>> ESS
(setq exec-path (append exec-path '("/Library/Frameworks/R.framework/Resources")))
;; ~~~~~~ Rmarkdown
(require 'poly-R)
(add-to-list 'auto-mode-alist
             '("\\.[rR]md\\'" . poly-gfm+r-mode))
(setq markdown-code-block-braces t)


;; ~~~~~~~~~~~~~~~~
;; Enable Vertico - file search and completion - sub for IVY, ICICLES, etc.
(use-package vertico
  ;; :ensure t
  :init
  (vertico-mode)
  ;; Grow and shrink the Vertico minibuffer
  (setq vertico-resize t)
  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (setq vertico-cycle nil))



;; Marginalia
;; Enable rich annotations using the Marginalia package
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))



;; Orderless

(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
	completion-category-defaults nil
	completion-category-overrides '((file (styles partial-completion)))))



;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  ;; :ensure t
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; Alternatively try `consult-completing-read-multiple'.
  (defun crm-indicator (args)
    (cons (concat "[CRM] " (car args)) (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))


;; >>> Consult 

(use-package consult
  :ensure t
  :bind
  (("C->" . consult-mark)))


;; >>> Embark
(use-package embark
  :ensure t

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings))) ;; alternative for `describe-bindings'

;; >>> SBCL
(setq inferior-lisp-program (executable-find "sbcl"))

;; >>> Display
(setq inhibit-splash-screen t)
(setq display-line-numbers 'relative)
(setq display-line-numbers-type 'visual)
(add-hook 'pdf-view-mode-hook
          (lambda ()
            (display-line-numbers-mode -1)))

;; >>> Windows/Workspace/Frame
(use-package eyebrowse             
  :ensure t
  :config
  ;; (validate-setq eyebrowse-mode-line-separator " "
                 ;; eyebrowse-new-workspace t)
  (eyebrowse-mode t))

;; Smart parens mode
(use-package smartparens
  :ensure t
  :init
  (smartparens-mode))

;; >>> Navigation
;;`````` Local Document Project Folder
(global-set-key (kbd "<f5>")
		(lambda()
		  (interactive)
		  (dired "~/Documents/1-PROJECTS")))
;;`````` AIR OneDrive Project Folder
(global-set-key (kbd "<f6>")
		(lambda()
		  (interactive)
		  (dired "~/OneDrive - AIR/1-PROJECTS")))

;;```````` My Day file
(global-set-key (kbd "<f1>")
		(lambda()
		  (interactive)
		  (find-file "~/OneDrive - AIR/myday.org")))

;;``````` Daily file
(global-set-key (kbd "<f2>")
		(lambda()
		  (interactive)
		  (find-file "~/OneDrive - AIR/work-tracker-2023.org")))


;; >>> one key to open new file in the REST STOP folder
(defun new-file-place ()
  (interactive)
  (let ((new-name
         (format-time-string "%Y-%m-%d-%H%M%p"))
        (new-path  "~/OneDrive - AIR/Rest_Stop/"))
    (find-file (concat new-path new-name ".org"))
    (insert "#+TAGS: journal")))
(global-set-key (kbd "<f7>") 'new-file-place)

;; >>> screen
(add-to-list 'load-path "~/.emacs.d/sublimity/")
(require 'sublimity)
(require 'sublimity-attractive)

;; >>> server start
(server-start)

;; >>> THEMES
;; (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; >>> ENVIRONMENTAL VARIABLE FOR AIR folder
(setenv "AIR_HOME" "/Users/sandeep/OneDrive - AIR/")


;; >>> window stuff past themese
;;:background "gray95" :foreground "gray20"

(setq auto-mode-alist
          (append auto-mode-alist
                  '(("\\.py\\'" . python-mode)
 ("\\.scss\\'" . scss-mode)
 ("\\.awk\\'" . awk-mode)
  ("\\.java\\'" . java-mode)
 ("\\.m\\'" . objc-mode)
 ("\\.ii\\'" . c++-mode)
 ("\\.i\\'" . c-mode)
 ("\\.lex\\'" . c-mode)
 ("\\.y\\(acc\\)?\\'" . c-mode)
 ("\\.[ch]\\'" . c-mode)
 ("\\.\\(CC?\\|HH?\\)\\'" . c++-mode)
 ("\\.[ch]\\(pp\\|xx\\|\\+\\+\\)\\'" . c++-mode)
 ("\\.\\(cc\\|hh\\)\\'" . c++-mode)
 ("\\.\\(bat\\|cmd\\)\\'" . bat-mode)
 ("\\.[sx]?html?\\(\\.[a-zA-Z_]+\\)?\\'" . html-mode)
 ("\\.svgz?\\'" . image-mode)
 ("\\.svgz?\\'" . xml-mode)
 ("\\.x[bp]m\\'" . image-mode)
 ("\\.x[bp]m\\'" . c-mode)
 ("\\.p[bpgn]m\\'" . image-mode)
 ("\\.tiff?\\'" . image-mode)
 ("\\.gif\\'" . image-mode)
 ("\\.png\\'" . image-mode)
 ("\\.jpe?g\\'" . image-mode)
 ("\\.te?xt\\'" . text-mode)
 ("\\.[tT]e[xX]\\'" . tex-mode)
 ("\\.ins\\'" . tex-mode)
 ("\\.ltx\\'" . latex-mode)
 ("\\.dtx\\'" . doctex-mode)
 ("\\.org\\'" . org-mode)
 ("\\.el\\'" . emacs-lisp-mode)
 ("Project\\.ede\\'" . emacs-lisp-mode)
 ("\\.\\(scm\\|stk\\|ss\\|sch\\)\\'" . scheme-mode)
 ("\\.l\\'" . lisp-mode)
 ("\\.li?sp\\'" . lisp-mode)
 ("\\.[fF]\\'" . fortran-mode)
 ("\\.for\\'" . fortran-mode)
 ("\\.p\\'" . pascal-mode)
 ("\\.pas\\'" . pascal-mode)
 ("\\.\\(dpr\\|DPR\\)\\'" . delphi-mode)
 ("\\.ad[abs]\\'" . ada-mode)
 ("\\.ad[bs].dg\\'" . ada-mode)
 ("\\.\\([pP]\\([Llm]\\|erl\\|od\\)\\|al\\)\\'" . perl-mode)
 ("Imakefile\\'" . makefile-imake-mode)
 ("Makeppfile\\(?:\\.mk\\)?\\'" . makefile-makepp-mode)
 ("\\.makepp\\'" . makefile-makepp-mode)
 ("\\.mk\\'" . makefile-gmake-mode)
 ("\\.make\\'" . makefile-gmake-mode)
 ("[Mm]akefile\\'" . makefile-gmake-mode)
 ("\\.am\\'" . makefile-automake-mode)
 ("\\.texinfo\\'" . texinfo-mode)
 ("\\.te?xi\\'" . texinfo-mode)
 ("\\.[sS]\\'" . asm-mode)
 ("\\.asm\\'" . asm-mode)
 ("\\.css\\'" . css-mode)
 ("\\.mixal\\'" . mixal-mode)
 ("\\.gcov\\'" . compilation-mode)
 ("/\\.[a-z0-9-]*gdbinit" . gdb-script-mode)
 ("-gdb\\.gdb" . gdb-script-mode)
 ("[cC]hange\\.?[lL]og?\\'" . change-log-mode)
 ("[cC]hange[lL]og[-.][0-9]+\\'" . change-log-mode)
 ("\\$CHANGE_LOG\\$\\.TXT" . change-log-mode)
 ("\\.scm\\.[0-9]*\\'" . scheme-mode)
 ("\\.[ckz]?sh\\'\\|\\.shar\\'\\|/\\.z?profile\\'" . sh-mode)
 ("\\.bash\\'" . sh-mode)
 ("\\(/\\|\\`\\)\\.\\(bash_\\(profile\\|history\\|log\\(in\\|out\\)\\)\\|z?log\\(in\\|out\\)\\)\\'" . sh-mode)
 ("\\(/\\|\\`\\)\\.\\(shrc\\|[kz]shrc\\|bashrc\\|t?cshrc\\|esrc\\)\\'" . sh-mode)
 ("\\(/\\|\\`\\)\\.\\([kz]shenv\\|xinitrc\\|startxrc\\|xsession\\)\\'" . sh-mode)
 ("\\.m?spec\\'" . sh-mode)
 ("\\.m[mes]\\'" . nroff-mode)
 ("\\.man\\'" . nroff-mode)
 ("\\.sty\\'" . latex-mode)
 ("\\.cl[so]\\'" . latex-mode)
 ("\\.bbl\\'" . latex-mode)
 ("\\.bib\\'" . bibtex-mode)
 ("\\.bst\\'" . bibtex-style-mode)
 ("\\.sql\\'" . sql-mode)
 ("\\.m[4c]\\'" . m4-mode)
 ("\\.mf\\'" . metafont-mode)
 ("\\.mp\\'" . metapost-mode)
 ("\\.vhdl?\\'" . vhdl-mode)
 ("\\.article\\'" . text-mode)
 ("\\.letter\\'" . text-mode)
 ("\\.i?tcl\\'" . tcl-mode)
 ("\\.exp\\'" . tcl-mode)
 ("\\.itk\\'" . tcl-mode)
 ("\\.icn\\'" . icon-mode)
 ("\\.sim\\'" . simula-mode)
 ("\\.mss\\'" . scribe-mode)
 ("\\.f9[05]\\'" . f90-mode)
 ("\\.f0[38]\\'" . f90-mode)
 ("\\.indent\\.pro\\'" . fundamental-mode)
 ("\\.\\(pro\\|PRO\\)\\'" . idlwave-mode)
 ("\\.srt\\'" . srecode-template-mode)
 ("\\.prolog\\'" . prolog-mode)
 ("\\.tar\\'" . tar-mode)
 ("\\.\\(arc\\|zip\\|lzh\\|lha\\|zoo\\|[jew]ar\\|xpi\\|rar\\|7z\\|ARC\\|ZIP\\|LZH\\|LHA\\|ZOO\\|[JEW]AR\\|XPI\\|RAR\\|7Z\\)\\'" . archive-mode)
 ("\\.oxt\\'" . archive-mode)
 ("\\.\\(deb\\|[oi]pk\\)\\'" . archive-mode)
 ("\\`/tmp/Re" . text-mode)
 ("/Message[0-9]*\\'" . text-mode)
 ("\\`/tmp/fol/" . text-mode)
 ("\\.oak\\'" . scheme-mode)
 ("\\.sgml?\\'" . sgml-mode)
 ("\\.x[ms]l\\'" . xml-mode)
 ("\\.dbk\\'" . xml-mode)
 ("\\.dtd\\'" . sgml-mode)
 ("\\.ds\\(ss\\)?l\\'" . dsssl-mode)
 ("\\.jsm?\\'" . javascript-mode)
 ("\\.json\\'" . javascript-mode)
 ("\\.[ds]?vh?\\'" . verilog-mode)
 ("\\.by\\'" . bovine-grammar-mode)
 ("\\.wy\\'" . wisent-grammar-mode)
 ("[:/\\]\\..*\\(emacs\\|gnus\\|viper\\)\\'" . emacs-lisp-mode)
 ("\\`\\..*emacs\\'" . emacs-lisp-mode)
 ("[:/]_emacs\\'" . emacs-lisp-mode)
 ("/crontab\\.X*[0-9]+\\'" . shell-script-mode)
 ("\\.ml\\'" . lisp-mode)
 ("\\.ld[si]?\\'" . ld-script-mode)
 ("ld\\.?script\\'" . ld-script-mode)
 ("\\.xs\\'" . c-mode)
 ("\\.x[abdsru]?[cnw]?\\'" . ld-script-mode)
 ("\\.zone\\'" . dns-mode)
 ("\\.soa\\'" . dns-mode)
 ("\\.asd\\'" . lisp-mode)
 ("\\.\\(asn\\|mib\\|smi\\)\\'" . snmp-mode)
 ("\\.\\(as\\|mi\\|sm\\)2\\'" . snmpv2-mode)
 ("\\.\\(diffs?\\|patch\\|rej\\)\\'" . diff-mode)
 ("\\.\\(dif\\|pat\\)\\'" . diff-mode)
 ("\\.[eE]?[pP][sS]\\'" . ps-mode)
 ("\\.\\(?:PDF\\|DVI\\|OD[FGPST]\\|DOCX?\\|XLSX?\\|PPTX?\\|pdf\\|djvu\\|dvi\\|od[fgpst]\\|docx?\\|xlsx?\\|pptx?\\)\\'" . doc-view-mode-maybe)
 ("configure\\.\\(ac\\|in\\)\\'" . autoconf-mode)
 ("\\.s\\(v\\|iv\\|ieve\\)\\'" . sieve-mode)
 ("BROWSE\\'" . ebrowse-tree-mode)
 ("\\.ebrowse\\'" . ebrowse-tree-mode)
 ("#\\*mail\\*" . mail-mode)
 ("\\.g\\'" . antlr-mode)
 ("\\.mod\\'" . m2-mode)
 ("\\.ses\\'" . ses-mode)
 ("\\.docbook\\'" . sgml-mode)
 ("\\.com\\'" . dcl-mode)
 ("/config\\.\\(?:bat\\|log\\)\\'" . fundamental-mode)
 ("\\.\\(?:[iI][nN][iI]\\|[lL][sS][tT]\\|[rR][eE][gG]\\|[sS][yY][sS]\\)\\'" . conf-mode)
 ("\\.\\(?:desktop\\|la\\)\\'" . conf-unix-mode)
 ("\\.ppd\\'" . conf-ppd-mode)
 ("java.+\\.conf\\'" . conf-javaprop-mode)
 ("\\.properties\\(?:\\.[a-zA-Z0-9._-]+\\)?\\'" . conf-javaprop-mode)
 ("\\`/etc/\\(?:DIR_COLORS\\|ethers\\|.?fstab\\|.*hosts\\|lesskey\\|login\\.?de\\(?:fs\\|vperm\\)\\|magic\\|mtab\\|pam\\.d/.*\\|permissions\\(?:\\.d/.+\\)?\\|protocols\\|rpc\\|services\\)\\'" . conf-space-mode)
 ("\\`/etc/\\(?:acpid?/.+\\|aliases\\(?:\\.d/.+\\)?\\|default/.+\\|group-?\\|hosts\\..+\\|inittab\\|ksysguarddrc\\|opera6rc\\|passwd-?\\|shadow-?\\|sysconfig/.+\\)\\'" . conf-mode)
 ("[cC]hange[lL]og[-.][-0-9a-z]+\\'" . change-log-mode)
 ("/\\.?\\(?:gnokiirc\\|kde.*rc\\|mime\\.types\\|wgetrc\\)\\'" . conf-mode)
 ("/\\.\\(?:enigma\\|gltron\\|gtk\\|hxplayer\\|net\\|neverball\\|qt/.+\\|realplayer\\|scummvm\\|sversion\\|sylpheed/.+\\|xmp\\)rc\\'" . conf-mode)
 ("/\\.\\(?:gdbtkinit\\|grip\\|orbital/.+txt\\|rhosts\\|tuxracer/options\\)\\'" . conf-mode)
 ("/\\.?X\\(?:default\\|resource\\|re\\)s\\>" . conf-xdefaults-mode)
 ("/X11.+app-defaults/\\|\\.ad\\'" . conf-xdefaults-mode)
 ("/X11.+locale/.+/Compose\\'" . conf-colon-mode)
 ("/X11.+locale/compose\\.dir\\'" . conf-javaprop-mode)
 ("\\.~?[0-9]+\\.[0-9][-.0-9]*~?\\'" nil t)
 ("\\.\\(?:orig\\|in\\|[bB][aA][kK]\\)\\'" nil t)
 ("[/.]c\\(?:on\\)?f\\(?:i?g\\)?\\(?:\\.[a-zA-Z0-9._-]+\\)?\\'" . conf-mode-maybe)
 ("\\.[1-9]\\'" . nroff-mode)
 ("\\.tgz\\'" . tar-mode)
 ("\\.tbz2?\\'" . tar-mode)
 ("\\.txz\\'" . tar-mode))))



;;))

;;>>>>>>>>>>>>>>>>>>>>>>>>>>>
;; Custom-Settings Below
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(blacken-line-length 88)
 '(blink-cursor-mode nil)
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(conda-env-home-directory "/Users/sandeep/opt/miniconda3/")
 '(cursor-type '(bar . 6))
 '(display-line-numbers nil)
 '(display-line-numbers-current-absolute t)
 '(display-line-numbers-grow-only t)
 '(display-line-numbers-type 'visual)
 '(display-line-numbers-widen nil)
 '(display-line-numbers-width nil)
 '(display-time-mail-face 'default)
 '(ein:jupyter-default-server-command "jupyter")
 '(ein:jupyter-server-use-subcommand "notebook")
 '(elfeed-feeds
   '("https://news.mit.edu/topic/mitmachine-learning-rss.xml" "https://www.nasdaq.com/feed/rssoutbound?category=Markets" "https://www.nasdaq.com/feed/rssoutbound?symbol=aapl" "https://www.iza.org/publications/dp" "https://www.nber.org/papers/" "http://www.marketwatch.com/rss/topstories" "http://arxiv.org/rss/cs.ml"))
 '(ess-indent-with-fancy-comments nil)
 '(exec-path
   '("/Users/sandeep/opt/miniconda3/envs/nlp_tfms/bin" "/usr/local/bin" "/usr/bin" "/bin" "/usr/sbin" "/sbin" "/Applications/Emacs.app/Contents/MacOS/bin-x86_64-10_10" "/Applications/Emacs.app/Contents/MacOS/libexec-x86_64-10_10" "/Applications/Emacs.app/Contents/MacOS/libexec" "/Applications/Emacs.app/Contents/MacOS/bin" "/Library/TeX/texbin/" "/Library/Frameworks/R.framework/Resources" "/Users/sandeep/opt/miniconda3/etc" "/usr/local/bin/gfortran"))
 '(fci-rule-color "#383838")
 '(global-display-line-numbers-mode nil)
 '(global-hl-todo-mode t)
 '(global-visual-line-mode nil)
 '(icicle-mode nil)
 '(initial-major-mode 'org-mode)
 '(initial-scratch-message nil)
 '(ivy-mode nil)
 '(line-number-display-limit-width 200)
 '(lsp-python-ms-parse-dot-env-enabled t)
 '(make-backup-files nil)
 '(menu-bar-mode t)
 '(nrepl-message-colors
   '("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3"))
 '(org-agenda-files
   '("~/OneDrive - AIR/2023-work-tracker.org" "/Users/sandeep/OneDrive - AIR/work-tracker-2022.org"))
 '(org-babel-load-languages
   '((awk \.w t)
     (emacs-lisp . t)
     (R . t)
     (python . t)
     (latex . t)))
 '(org-cite-global-bibliography nil)
 '(org-format-latex-options
   '(:foreground default :background default :scale 1.5 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
		 ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(org-refile-targets
   '(("~/OneDrive - AIR/Documents/my-org-files/myday.org" :regexp . "ARCHIVED")
     ("~/OneDrive - AIR/Documents/my-org-files/myday.org" :maxlevel . 1)))
 '(org-todo-keyword-faces '(("INPRCS" . "burlywood4") ("PAUSED" . "gray")))
 '(package-archives
   '(("melpa" . "https://melpa.org/packages/")
     ("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa-stable" . "https://stable.melpa.org/packages/")
     ("org" . "https://orgmode.org/elpa/")))
 '(package-selected-packages
   '(magit-stats all-the-icons-completion marginalia embark-consult org-download python-isort rdf-prefix org-roam rustic rust-mode epresent zpresent pylint async py-autopep8 flycheck csv-mode yapfify smartparens lsp-ui lsp-pyright flymake-python-pyflakes lsp-python-ms company-jedi company-quickhelp python-docstring poly-R adaptive-wrap modern-cpp-font-lock which-key yasnippet-snippets jupyter ess pyenv-mode-auto blacken elpy ein pandoc ox-pandoc elfeed markdown-preview-mode hl-todo org-pdfview pdf-tools embark nov orderless vertico consult treemacs eyebrowse bibtex-actions bibtek-actions pyenv-mode conda anaconda-mode auto-complete company-statistics company magit projectile chronometer spell-fu slime auctex cdlatex markdown-mode org-journal org-bullets request websocket))
 '(paradox-automatically-star t)
 '(paradox-github-token "ADD TOKEN HERE")  ; <--- ADD PARADOX TOKEN
 '(pdf-tools-handle-upgrades nil)
 '(pdf-view-midnight-colors '("#DCDCCC" . "#383838"))
 '(python-shell-completion-native-disabled-interpreters '("pypy" "ipython"))
 '(python-shell-completion-native-enable nil)
 '(python-shell-interpreter "ipython")
 '(recentf-mode t)
 '(scroll-bar-mode nil)
 '(sentence-end-double-space nil)
 '(sublimity-mode nil)
 '(tool-bar-mode nil)
 '(treemacs-fringe-indicator-mode t)
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   '((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3")))
 '(vc-annotate-very-old-color "#DC8CC3")
 '(which-function-mode t)
 '(which-key-mode t)
 '(window-divider-default-places 'bottom-only)
 '(window-divider-default-right-width 3)
 '(yas-global-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "White" :foreground "Black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 180 :width normal :foundry "nil" :family "NanumGothicCoding"))))
 '(company-tooltip-scrollbar-track ((t (:background "#5F5F5F"))))
 '(completions-annotations ((t (:inherit (italic shadow) :foreground "PaleTurquoise4" :height 0.9))))
 '(cursor ((t (:background "gray55"))))
 '(fringe ((t (:inherit default))))
 '(highlight ((t (:background "bisque"))))
 '(line-number ((t (:inherit default :background "gray90" :foreground "dark blue" :box nil :weight ultra-light :height 0.8 :width condensed))))
 '(line-number-current-line ((t (:foreground "red3" :weight ultra-light :height 0.8 :width condensed :foundry "Inconsolata"))))
 '(linum ((t (:inherit (shadow default) :weight ultra-light :height 0.8 :width condensed))))
 '(minibuffer-prompt ((t (:foreground "dark magenta" :height 0.9 :width condensed))))
 '(mode-line ((t (:background "SlateGray2" :foreground "black" :box (:line-width -1 :style released-button) :height 0.9))))
 '(mode-line-buffer-id ((t (:foreground "IndianRed3" :weight bold))))
 '(mode-line-inactive ((t (:inherit mode-line :background "gray75" :foreground "grey20" :box (:line-width -1 :color "grey75") :weight light))))
 '(org-agenda-done ((t (:foreground "dark orange"))))
 '(org-block ((t (:inherit (fixed-pitch shadow) :extend t))))
 '(org-default ((t (:inherit :variable-pitch))))
 '(org-done ((t (:foreground "dark orange" :weight normal))))
 '(org-tag ((t (:weight normal))))
 '(org-todo ((t (:foreground "pink2" :weight normal))))
 '(treemacs-directory-face ((t (:height 0.8 :weight normal :inherit font-lock-function-name-face))))
 '(treemacs-file-face ((t (:inherit default :height 0.8 :family "Osaka"))))
 '(treemacs-root-face ((t (:height 0.9 :weight semi-bold :inherit font-lock-constant-face))))
 '(variable-pitch ((t (:family "Osaka"))))
 '(vertical-border ((t (:foreground "gray25"))))
 '(vertico-current ((t (:inherit highlight))))
 '(window-divider ((t (:foreground "gray60"))))
 '(window-divider-first-pixel ((t (:foreground "gray80")))))


