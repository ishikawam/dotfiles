(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;(el-get 'sync 'helm)
;(el-get-bundle helm)
;(el-get-bundle helm-config)

(el-get-bundle auto-install)

;;; color theme
(el-get-bundle color-theme)
(color-theme-midnight)
;(color-theme-arjen)
;(color-theme-charcoal-black)


;;; PHP Xdebug デバッガ geben
(el-get-bundle geben)
(require 'geben)

;;; php-mode
(el-get-bundle php-mode)
(require 'php-mode)

;;; Auto Complete
;(el-get-bundle auto-complete-config)

;;; GNU GLOBAL for helm
;(el-get-bundle helm-gtags)

;;; zencoding
(el-get-bundle zencoding-mode)
(require 'zencoding-mode)

;;; web-mode
(el-get-bundle web-mode)
(require 'web-mode)

;(el-get-bundle auto-complete)

