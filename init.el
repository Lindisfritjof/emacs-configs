;; dette er init filen til customisering af min emacs.
(setq shell-file-name "/usr/bin/bash")
;; =========== MELPA SUPPORT ===================
(require 'package)
;; Any add to list for package-archives (to add marmalade or melpa) goes here
(add-to-list 'package-archives 
    '("MELPA" .
      "http://stable.melpa.org/packages/"))
(package-initialize)

;; hvis der ikke er nogen arkiverede pakker, refresh:
(when (not package-archive-contents)
  (package-refresh-contents))

;; ====== SLUT PÅ INSTALL. AF MELPA SUPPORT ===========

;; =============================================
;; ===== HER BEGYNDER MINE EGNE CONFIGS ========
;; =============================================

;; ====== GENEREL CUSTOMISERING  I EMACS ============
; Lav eget navn i titlen
(setq frame-title-format "Lindisfarne EMACS")

; fjerner velkomst-skærmen
(setq inhibit-startup-screen t)
(setq initial-scratch-message "")

;; fjerner menuerne
(menu-bar-mode -1)
(tool-bar-mode -1)

;; ======= SLUT PÅ GENEREL OPFØRSEL I EMACS ===


;; ===== Programmeringssmukkesering ============
;; først smækker vi elpy på
(use-package elpy
  :ensure t
  :init
  (elpy-enable))

;; og tilføjer flycheck
;; Enable Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; autopep sammen med
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
;;(add-hook 'prog-mode-hook 'writeroom-mode)
(setq elpy-rpc-python-command "python3")
(setq python-shell-interpreter "python3"
      python-shell-interpreter-args "-i")

;; Jedi-mode + lsp (se matrix-chatten)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
(require 'jedi)
(jedi:setup)
(require 'lsp-python-ms)
(require 'lsp-jedi)
(push 'lsp-jedi lsp-language-id-configuration)

;company-mode
 (add-to-list 'company-backends 'company-jedi)
(setq elpy-rpc-virtualenv-path "/home/fritjof/.emacs.d/elpy/rpc-venv")
(add-hook 'elpy-mode-hook (lambda () (elpy-shell-toggle-dedicated-shell 1)))

;; HTML - web-mode
(setq web-mode-enable-auto-pairing t)
(add-hook 'html-mode-hook 'web-mode)

;; ======= SKRIVESMUKKESERING ================
;; og så laver vi olivetti-mode til .txt-filer
(add-hook 'fountain-mode-hook 'olivetti-mode)
(add-hook 'text-mode-hook 'olivetti-mode)
(add-hook 'text-mode-hook 'company-mode)

;; piller ved lisp eval depth
;; her står der ikke noget endnu, for jeg ved ikke hvad det skulle være...


;; org mode konfigurering
(require 'org)
(setq org-default-notes-file (concat org-directory))

;;capture todo items using C-c c t                                              
(define-key global-map (kbd "C-c c") 'org-capture)
 (setq org-capture-templates
   '(("t" "Todo" entry
      (file+olp+datetree "~/org/todo.org")
      "* TODO %?
   %i
   %a")
     ("n" "noter" entry
      (file+headline "~/org/noter.org" "Noter")
      (file "* %T"))
     ("b" "Bog-noter" entry
      (file "~/org/bog-noter.org")
      "* %T")
     ("d" "Dagbog" entry
     (file "~/org/dagbog.org")
      "* %T")))

;; org bullet pænhed
(use-package org-bullets
    :config
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; e-bøger
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;;========= E-POST MED mu4e ================
;; setting mu4e to executable path & require
(add-to-list 'load-path "/usr/share/emacs/site-lisp/elpa-src/mu4e-1.8.14")
(setq mu4e-mu-binary "/usr/bin/mu")
(require 'mu4e)

;; SMTP fra https://doubleloop.net/2019/09/06/emacs-mu4e-mbsync-and-protonmail/
(setq mu4e-maildir "~/mail"
    mu4e-attachment-dir "~/downloads"
    mu4e-sent-folder "/Sent"
    mu4e-drafts-folder "/Drafts"
    mu4e-trash-folder "/Trash"
    mu4e-refile-folder "/Archive")

(setq user-mail-address "fritjofarnfred@protonmail.com"
    user-full-name  "Øjvind Fritjof Arnfred")

;; Get mail
(setq mu4e-get-mail-command "mbsync protonmail"
    mu4e-change-filenames-when-moving t   ; needed for mbsync
    mu4e-update-interval 120)             ; update every 2 minutes

;; Send mail with SMTP
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-auth-credentials "~/.authinfo"  ;; krypter senere
      smtpmail-smtp-server "127.0.0.1"
      smtpmail-smtp-service 1025)

;;============SLUT PÅ EPOST====================

;; =============================================
;; ===== Her slutter min egenkonfig af emacs ===
;; =============================================


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(dracula))
 '(custom-safe-themes
   '("603a831e0f2e466480cdc633ba37a0b1ae3c3e9a4e90183833bc4def3421a961" default))
 '(doc-view-continuous t)
 '(initial-frame-alist '((fullscreen . maximized)))
 '(package-selected-packages
   '(mu4easy notmuch org-download htmlize latex-unicode-math-mode org-bullets imenu-list darkroom rainbow-mode neotree writeroom-mode writegood-mode org-ai company-jedi pyenv-mode pyenv-mode-auto lsp-jedi jedi eww-lnum ement ac-html emmet-mode web-mode lsp-mode magit py-autopep8 flycheck fountain-mode org olivetti elpy dracula-theme))
 '(send-mail-function 'mailclient-send-it))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
