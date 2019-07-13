;;; init26.el for emacs 26
;;; caskをやめてstraight.elに。

;;; straight.el自身のインストールと初期設定
(let ((bootstrap-file (concat user-emacs-directory "straight/repos/straight.el/bootstrap.el"))
      (bootstrap-version 3))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;; use-packageをインストールする
(straight-use-package 'use-package)

;;; オプションなしで自動的にuse-packageをstraight.elにフォールバックする
;;; 本来は (use-package hoge :straight t) のように書く必要がある
(setq straight-use-package-by-default t)

;;; init-loaderをインストール&読み込み
(use-package init-loader)

;;; ~/.emacs.d/init/ 以下のファイルを全部読み込む
;(init-loader-load "~/.emacs.d/init/")  ; うまくいってない


(use-package auto-install)

(use-package monokai-theme)
(custom-theme-set-faces
 'monokai
 ;; メニューバー = header-line
 '(menu ((t (:foreground "#111111" :background "#CCCCCC")))))
;  :init
;  (custom-theme-set-faces
;   'monokai
;   ;; メニューバー = header-line
;   '(menu ((t (:foreground "#111111" :background "#CCCCCC")))))
;  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; mode

;;; php
(use-package php-mode)

;;; php hook
(add-hook 'php-mode-hook
          (lambda ()

            ; ac-php
            (auto-complete-mode t)
            (require 'ac-php)
            (setq ac-sources  '(ac-source-php ) )
            (yas-global-mode 1)
;            (ac-php-core-eldoc-setup ) ;; enable eldoc

            (c-set-style "stroustrup")
            (setq tab-width 4)
            (setq c-basic-offset 4)
;            (setq indent-tabs-mode t)    ; インデント：タブ文字
;            (setq indent-tabs-mode nil)    ; インデント：空白スペース
            (c-set-offset 'case-label' 4)
            (c-set-offset 'arglist-intro' 4)
            (c-set-offset 'arglist-cont-nonempty' 4)
            (c-set-offset 'arglist-close' 0)
            (electric-indent-local-mode -1)
            (c-toggle-electric-state -1)
            ))

;;; php5
(setq auto-mode-alist
      (append '(("\\.\\(php5\\)$" . php-mode))
              auto-mode-alist))

;;; web
(use-package web-mode)

;;; go
(use-package go-mode)
(use-package company-go)
(add-hook 'go-mode-hook 'flycheck-mode)

;;; swift
(use-package swift-mode)

;;; zencoding
(use-package zencoding-mode)

;;; その他
(use-package yaml-mode)
(use-package coffee-mode)
(use-package haskell-mode)
(use-package idle-highlight-mode)
(use-package js2-mode)
(use-package json-mode)
(use-package jsx-mode)
(use-package markdown-mode)
(use-package nyan-mode)
(use-package scala-mode)
(use-package typescript-mode)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; helm

(use-package helm
  :bind (("M-x" . helm-M-x)
         ("C-x b" . helm-mini)
         ("C-x C-f" . helm-find-files)
         ("C-c y"   . helm-show-kill-ring)
         ("C-c m"   . helm-man-woman)
         ("C-c o"   . helm-occur)
         :map helm-map
         ("C-h" . delete-backward-char)
         :map helm-find-files-map
         ("C-h" . delete-backward-char))
  :init
  (custom-set-faces
   '(helm-header           ((t (:background "#3a3a3a" :underline nil))))
   '(helm-source-header    ((t (:background "gray16" :foreground "gray64" :slant italic))))
   '(helm-candidate-number ((t (:foreground "#00afff"))))
   '(helm-selection        ((t (:background "#005f87" :weight normal))))
   '(helm-match            ((t (:foreground "darkolivegreen3")))))
  :config
  (helm-mode 1))

;(use-package helm-core)

;(use-package helm-config) ; できない

;;; GNU GLOBAL for helm
(use-package helm-gtags)
(add-hook 'php-mode-hook (lambda () (helm-gtags-mode)))
(add-hook 'web-mode-hook (lambda () (helm-gtags-mode)))
(add-hook 'swift-mode-hook (lambda () (helm-gtags-mode)))
(add-hook 'go-mode-hook (lambda () (helm-gtags-mode)))
(add-hook 'python-mode-hook (lambda () (helm-gtags-mode)))
(add-hook 'ruby-mode-hook (lambda () (helm-gtags-mode)))
(setq helm-gtags-path-style 'root)
(setq helm-gtags-auto-update t)
(add-hook 'helm-gtags-mode-hook
          '(lambda ()
             (local-set-key (kbd "M-t") 'helm-gtags-find-tag)
             (local-set-key (kbd "M-r") 'helm-gtags-find-rtag)
             (local-set-key (kbd "M-s") 'helm-gtags-find-symbol)
             (local-set-key (kbd "M-e") 'helm-gtags-pop-stack)
;             (local-set-key (kbd "M-g") 'helm-gtags-dwim)
;             (local-set-key (kbd "M-s") 'helm-gtags-show-stack)
;             (local-set-key (kbd "M-p") 'helm-gtags-previous-history)
;             (local-set-key (kbd "M-n") 'helm-gtags-next-history)
             ))

;; (autoload 'gtags-mode "gtags" "" t)
;; (setq gtags-mode-hook
;;       '(lambda ()
;;          (local-set-key "\M-t" 'gtags-find-tag)
;;          (local-set-key "\M-r" 'gtags-find-rtag)
;;          (local-set-key "\M-s" 'gtags-find-symbol)
;;          (local-set-key "\M-e" 'gtags-pop-stack)
;;          ))
;; (global-set-key "\M-e" 'gtags-pop-stack)
;; (add-hook 'c-mode-common-hook
;;           '(lambda()
;;              (helm-gtags-mode 1)
;;              ))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package geben)


;;; auto-complete
(require 'package)
;; MELPAを追加
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; MELPA-stableを追加
;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; Marmaladeを追加
;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
;; Orgを追加
;(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
;; 初期化
(package-initialize)

;(use-package auto-complete)
(use-package ac-php)  ; php補完 auto-complete, company
;(use-package ac-php-core)
;(use-package auto-complete-config) ; できない
;(require 'auto-complete)
;(require 'auto-complete-config)


;;; 補完？
(use-package company
    :init
    (setq company-selection-wrap-around t)
    :bind
    (:map company-active-map
        ("M-n" . nil)
        ("M-p" . nil)
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous)
;        ([tab] . company-complete-select)
        ("C-h" . nil))
    :config
    (global-company-mode))

;;; editorconfig
(use-package editorconfig
  :config
  (editorconfig-mode 1))
