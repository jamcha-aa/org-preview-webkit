;;; org-preview-webkit.el --- preview an org-mode file as html with xwidget-webkit

;; Copyright (C) 2016 jamcha

;; Author: jamcha <jamcha.aa@gmail.com>
;; Created: 2016-09-25
;; Version: 0.1

;; Keywords: org, html, xwidget-webkit
;; Package-Requires: ((org "8.0") (emacs "25.1"))
;; URL: https://github.com/jamcha-aa/org-preview-webkit

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; org-preview-webkit-mode is a simple program that gives an preview
;; extension to org-mode. Anytime on saving, the built-in
;; xwidget-webkit-browser shows an output image as html.

;;; Code:
(require 'org)
(require 'xwidget)

(defvar-local org-preview-webkit-file nil)

;;;###autoload

(defun org-preview-frame-lock ()
  "Disable/Enable to override current frame"
  (interactive)
  (let (window (get-buffer-window (current-buffer)))
    (set-window-dedicated-p window (not (window-dedicated-p window))))
  (current-buffer))

(defun org-preview-webkit-xwidget ()
  (when (derived-mode-p 'org-mode)
  (interactive)
  (org-export-to-file 'html org-preview-webkit-file nil nil nil nil nil))
  (xwidget-webkit-browse-url (concat "file://" org-preview-webkit-file)))

(defun org-preview-webkit-on ()
  "Turn on org-preview-webkit."
  (unless org-preview-webkit-file
    (setq org-preview-webkit-file (concat buffer-file-name (make-temp-name "-") ".html")))
  (add-hook 'after-save-hook #'org-preview-webkit-xwidget nil 'make-it-local)
  (message "org-preview-webkit-mode is on."))

(defun org-preview-webkit-off ()
  "Turn off org-preview-webkit."
  (if (and (boundp 'org-preview-webkit-file)
           org-preview-webkit-file) (delete-file org-preview-webkit-file))
  (remove-hook 'after-save-hook #'org-preview-webkit-xwidget t)
  (message "org-preview-webkit-mode is off."))


;;;###autoload
(define-minor-mode org-preview-webkit-mode
  "cycle org-preview-webkit-mode between on/off"
  :lighter "org-webkit"
  (if (get 'org-preview-webkit-mode 'state)
    (progn
      (org-preview-frame-lock)
      (org-preview-webkit-off)
      (put 'org-preview-webkit-mode 'state nil))
    (progn
      (org-preview-frame-lock)
      (org-preview-webkit-on)
      (put 'org-preview-webkit-mode 'state t))))

(provide 'org-preview-webkit)

;;; org-preview-webkit.el ends here
