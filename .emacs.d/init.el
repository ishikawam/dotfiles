;;; cask + pallet - package manager -
(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t) ;; pallet-modeを有効にする場合

;;; helm
(require 'helm-config)

;;; 高速化
(setq linum-delay t)
(defadvice linum-schedule (around my-linum-schedule () activate)
  (run-with-idle-timer 0.2 nil #'linum-update-current))

;;; *.~ とかのバックアップファイルを作らない
(setq make-backup-files nil)
;;; .#* とかのバックアップファイルを作らない
(setq auto-save-default nil)

;;; 矩形編集
;;; cuaモードに入るには、C-x SPC. http://qiita.com/yyamamot/items/7efcbfdcccdb5fa45ebe
(cua-mode t)
(setq cua-enable-cua-keys nil)
(define-key global-map (kbd "C-x SPC") 'cua-set-rectangle-mark)

;;; elファイルを読み込む
(setq load-path
      (append
       (list
        (expand-file-name "~/.emacs.d/elisp/")
        )
       load-path))

;;; Auto Install
; 重いしつながらないのでコメントアウト。
(require 'auto-install)
;(setq auto-install-directory "~/.emacs.d/auto-install/")
;(auto-install-update-emacswiki-package-name t)
;(auto-install-compatibility-setup)             ; 互換性確保

;;; カラースキーマ color
;(require 'molokai-theme)
(require 'monokai-theme)

;;; folding.el コードの折りたたみ
(autoload 'folding-mode          "folding" "Folding mode" t)
(autoload 'turn-off-folding-mode "folding" "Folding mode" t)
(autoload 'turn-on-folding-mode  "folding" "Folding mode" t)

;;; PHP Xdebug デバッガ geben
;(autoload 'geben "geben" "DBGp protocol front-end" t)

;;; vc-mode は使わない
(setq vc-handled-backends ())

;;; 背景色 やめた。コピペすると無駄にスペースが混入してしまうので。
;(add-to-list 'default-frame-alist '(background-color . "black"))

;;; 選択範囲に色
(setq transient-mark-mode t)

;;; M-D、M-backspaceでコピーしない。＃M-backspaceはうまくいっていない。。。
(defun delete-word (arg)
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))
(defun backward-delete-word (arg)
  (interactive "p")
  (delete-word (- arg)))
(defun delete-backword (arg)
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))
(global-set-key (kbd "M-d") 'delete-word)
(global-set-key [(meta backspace)] 'backward-delete-word)
;(global-set-key [C-backspace] 'backward-delete-word)


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
            (c-set-offset 'arglist-close' 0)))


;;; tab文字を普通に入力
;(add-hook 'text-mode-hook
;          (lambda ()
;            (local-set-key "\t" 'self-insert-command)))
(setq tab-width 4)
;(setq indent-tabs-mode t)    ; インデント：タブ文字
;(setq indent-tabs-mode nil)    ; インデント：空白スペース

;;; C-hでヘルプではなく、バックスペース
(global-set-key "\C-h" 'backward-delete-char)

;;; 段落飛ばし ＞ M-{、M-}でもできるので別のを割り当てる↓
;(global-set-key "\M-p" 'backward-paragraph)
;(global-set-key "\M-n" 'forward-paragraph)

;;; スクロールを1行ずつ
(setq scroll-step 1)

;;; スクロールのみ
(defun scroll-up-in-place (n)
  (interactive "p")
;  (previous-line n)
  (scroll-down n))
(defun scroll-down-in-place (n)
  (interactive "p")
;  (next-line n)
  (scroll-up n))
(global-set-key "\M-p" 'scroll-up-in-place)
(global-set-key [M-up] 'scroll-up-in-place)
(global-set-key "\M-n" 'scroll-down-in-place)
(global-set-key [M-down] 'scroll-down-in-place)




;====================================
;;全角スペースとかに色を付ける
;====================================
(defface my-face-b-1 '((t (:background "#006666"))) nil)
(defface my-face-b-2 '((t (:background "gray16"))) nil)
(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
;(defface my-face-r-1 '((t (:background "gray15"))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)
;(defvar my-face-r-1 'my-face-r-1)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(
     ("　" 0 my-face-b-1 append)
     ("\t" 0 my-face-b-2 append)
     ("[ ]+$" 0 my-face-u-1 append)
;     ("[\r]*\n" 0 my-face-r-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)
(add-hook 'find-file-hooks '(lambda ()
                              (if font-lock-mode
                                  nil
                                (font-lock-mode t))))


;;; .tpl を html-mode で開く
(setq auto-mode-alist
      (append '(("\\.tpl$" . html-mode))
              auto-mode-alist))

;;; html-hook
(add-hook 'html-mode-hook
          (lambda ()
            (setq tab-width 4) ; mon
;            (setq tab-width 2)
;            (setq indent-tabs-mode t)    ; インデント：タブ文字
            (setq indent-tabs-mode nil)    ; インデント：空白スペース
            (setq sgml-basic-offset 4)
            (setq html-basic-offset 4)
            (setq auto-coding-functions nil) ; 勝手に文字コード変えて保存させない
            ))

;;; php5
(setq auto-mode-alist
      (append '(("\\.php5$" . php-mode))
              auto-mode-alist))


;;; 起動画面を出さない
(setq inhibit-startup-message t)

;;; Carbon Emacs 日本語フォント
;;(if (eq window-system 'mac) (progn
;(if window-system (progn
;                    (set-face-attribute 'default nil :family "Monaco" :height 120)
;                    (set-face-attribute 'default nil :family "osaka" :height 120)
;                    (set-fontset-font "fontset-default" 'japanese-jisx0208 '("osaka" . "iso10646-*"))
;))


;(set-fontset-font "fontset-default" 'japanese-jisx0208 '("Monaco" . "iso10646-*"))


;;; モードラインにファイルのフルパス表示
(set-default 'mode-line-buffer-identification
             '(buffer-file-name ("%f") ("%b")))

;;; Auto Complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

;;; GNU GLOBAL for helm
;(load "~/.emacs.d/emacs-helm-gtags/helm-gtags.el")
(require 'helm-gtags)
(add-hook 'go-mode-hook (lambda () (helm-gtags-mode)))
(add-hook 'python-mode-hook (lambda () (helm-gtags-mode)))
(add-hook 'ruby-mode-hook (lambda () (helm-gtags-mode)))
(setq helm-gtags-path-style 'root)
(setq helm-gtags-auto-update t)
(add-hook 'helm-gtags-mode-hook
          '(lambda ()
             (local-set-key (kbd "M-g") 'helm-gtags-dwim)
             (local-set-key (kbd "M-s") 'helm-gtags-show-stack)
             (local-set-key (kbd "M-p") 'helm-gtags-previous-history)
             (local-set-key (kbd "M-n") 'helm-gtags-next-history)))

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
             (gtags-mode 1)
             (gtags-make-complete-list)
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


;;; 大きな画面で開く
(if window-system (progn
                    (setq initial-frame-alist '((width . 202)(height . 58)(top . 0)(left . 48)))
                    ))




(message "Minibuffer depth is %d."
         (minibuffer-depth))


;;; 最後に、強制タブ
;;;(setq-default tab-width 4)
; Switch
;(setq-default indent-tabs-mode t)
(setq-default indent-tabs-mode nil)

;(setq js-indent-level 4)
(add-to-list 'auto-mode-alist '("\\.json$"     . js-mode))
;;;


;; 保存時に勝手に文字コード変えやがる件
(add-hook 'html-helper-mode-hook
          '(lambda ()
             (setq auto-coding-functions nil)))

