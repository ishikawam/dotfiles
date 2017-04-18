;;; .emacs 改め .emacs.d/init.el
;;; version 25. 24, 23, が共存している環境 = cask出し分け
;;; emacs24はこのままではエラー。。caskのバージョン上げたらうまく動かなくなった。
;;; emacs25に最適化。


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq preferences-directory "~/.emacs.d/")

(defun load-file-in-dir (dir file)
  (load (concat dir file)))

(cond
 ((string-match "^25\." emacs-version)
  (load-file-in-dir preferences-directory "init24.el"))
 ((string-match "^24\." emacs-version)
  (load-file-in-dir preferences-directory "init24.el"))
 ((string-match "^23\." emacs-version)
  (load-file-in-dir preferences-directory "init23.el"))
; ((string-match "^22\." emacs-version)
;  (load-file-in-dir preferences-directory "init22.el"))
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; 各バージョン共通

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

;;; folding.el コードの折りたたみ
(autoload 'folding-mode          "folding" "Folding mode" t)
(autoload 'turn-off-folding-mode "folding" "Folding mode" t)
(autoload 'turn-on-folding-mode  "folding" "Folding mode" t)

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

; タブは4space
(setq tab-width 4)


;====================================
;;; キーバインド bind-key
;====================================

;;; delete word
(global-set-key (kbd "M-d") 'delete-word)
(global-set-key [(meta backspace)] 'backward-delete-word)


;;; C-hでヘルプではなく、バックスペース
(global-set-key "\C-h" 'backward-delete-char)

;;; 段落飛ばし  M-{、M-} 使いにくいので > やめた。なぜかCommand+Vで制御文字混入するようになった。
;(global-set-key "\M-[" 'backward-paragraph)
;(global-set-key "\M-]" 'forward-paragraph)

;;; スクロールを1行ずつ
(setq scroll-step 1)

;;; スクロールのみ
(defun scroll-up-in-place (n)
  (interactive "p")
  (scroll-down n))
(defun scroll-down-in-place (n)
  (interactive "p")
  (scroll-up n))
(global-set-key "\M-p" 'scroll-up-in-place)
(global-set-key [M-up] 'scroll-up-in-place)
(global-set-key "\M-n" 'scroll-down-in-place)
(global-set-key [M-down] 'scroll-down-in-place)

;;; M-c(先頭大文字変換)無効にする
(global-unset-key "\M-c")


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


;;; .tpl, .volt を html-mode で開く
(setq auto-mode-alist
      (append '(("\\.\\(tpl\\|volt\\|twig\\|blade\\.php\\|mustache\\)$" . html-mode))
              auto-mode-alist))

;;; .scss を css-mode で開く
(setq auto-mode-alist
      (append '(("\\.\\(scss\\)$" . css-mode))
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


;; 保存時に勝手に文字コード変えやがる件
(add-hook 'html-helper-mode-hook
          '(lambda ()
             (setq auto-coding-functions nil)))

;;; local variables listの警告を出さない
(custom-set-variables
 '(safe-local-variable-values
   (quote
    ((encoding . utf-8) ; * encoding : utf-8
     ))))
(put 'downcase-region 'disabled nil)
(prefer-coding-system 'utf-8-unix)
(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)

;; exec-pathリストにshellのPATHを追加する for gnu global
;; emacs25でエラーになったので一旦コメントアウト
;(loop for x in (reverse
;;                (split-string (substring (shell-command-to-string "echo $PATH") 0 -1) ":"))
;      do (add-to-list 'exec-path x))
