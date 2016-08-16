;;; for emacs 24

;;; cask + pallet - package manager -
(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t) ;; pallet-modeを有効にする場合

;;; helm
(require 'helm-config)

;;; Auto Install
(require 'auto-install)
;(setq auto-install-directory "~/.emacs.d/auto-install/")
;(auto-install-update-emacswiki-package-name t)
;(auto-install-compatibility-setup)             ; 互換性確保

;;; カラースキーマ color
;(require 'molokai-theme)
(require 'monokai-theme)
(custom-theme-set-faces
 'monokai
 ;; メニューバー = header-line
 '(menu ((t (:foreground "#111111" :background "#CCCCCC")))))


;;; PHP Xdebug デバッガ geben
(require 'geben)

;;; php-mode
(require 'php-mode)

;;; php hook
(add-hook 'php-mode-hook
          (lambda ()
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
      (append '(("\\.php5$" . php-mode))
              auto-mode-alist))


;;; モードラインにファイルのフルパス表示
(set-default 'mode-line-buffer-identification
             '(buffer-file-name ("%f") ("%b")))

;;; Auto Complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

;;; GNU GLOBAL for helm
(require 'helm-gtags)
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

(autoload 'gtags-mode "gtags" "" t)
(setq gtags-mode-hook
      '(lambda ()
         (local-set-key "\M-t" 'gtags-find-tag)
         (local-set-key "\M-r" 'gtags-find-rtag)
         (local-set-key "\M-s" 'gtags-find-symbol)
         (local-set-key "\M-e" 'gtags-pop-stack)
         ))
(global-set-key "\M-e" 'gtags-pop-stack)
(add-hook 'c-mode-common-hook
          '(lambda()
             (helm-gtags-mode 1)
             ))

;;; zencoding
(require 'zencoding-mode)
(add-hook 'sgml-mode-hook 'zencoding-mode ;; html-modeとかで自動的にzencodingできるようにする うーん、インデント文字数替えたいけど効かない
          (lambda()
            (setq indent-tabs-mode nil)
            (setq tab-width 4) ; mon
;            (setq tab-width 2)
            (setq sgml-basic-offset 4)
            (setq auto-coding-functions nil) ; 勝手に文字コード変えて保存させない
            ))

;; js2-mode
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

; todo まだ使えていない↓
;;; web-mode
(require 'web-mode)
;;; emacs 23以下の互換
(when (< emacs-major-version 24)
  (defalias 'prog-mode 'fundamental-mode))
;;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))
;;; インデント数
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-html-offset   4)
  (setq web-mode-css-offset    4)
  (setq web-mode-script-offset 4)
  (setq web-mode-php-offset    4)
  (setq web-mode-java-offset   4)
  (setq web-mode-asp-offset    4))
(add-hook 'web-mode-hook 'web-mode-hook
          (lambda()
            (setq indent-tabs-mode nil)
            (setq tab-width 4)
            (setq sgml-basic-offset 4)
            (setq auto-coding-functions nil) ; 勝手に文字コード変えて保存させない
            ))


;(setq js-indent-level 4)
(add-to-list 'auto-mode-alist '("\\.json$"     . js-mode))
;;;

;;; jsx-mode
(require 'jsx-mode)
; You can edit user-customizable variables by typing the following command.
;;     M-x customize-group [RET] jsx-mode
(custom-set-variables
 '(jsx-indent-level 4)
 '(jsx-syntax-check-mode "compile"))

(defun jsx-mode-init ()
  (define-key jsx-mode-map (kbd "C-c d") 'jsx-display-popup-err-for-current-line)
  (when (require 'auto-complete nil t)
    (auto-complete-mode t)))

(add-hook 'jsx-mode-hook 'jsx-mode-init)

;;; editorconfig
(when (locate-library "editorconfig")
  (editorconfig-mode 1)
  )
