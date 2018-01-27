;;; prog-fill.el --- Smartly format lines to use vertical space. -*- lexical-binding: t; -*-

;; Copyright (C) 2018 Matthew Carter <m@ahungry.com>

;; Author: Matthew Carter <m@ahungry.com>
;; Maintainer: Matthew Carter <m@ahungry.com>
;; URL: https://github.com/ahungry/color-theme-ahungry
;; Version: 0.0.1
;; Keywords: ahungry convenience c formatting
;; Package-Requires: ((emacs "25.1") (cl-lib "0.6.1"))

;; This file is NOT part of GNU Emacs.

;;; License:

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Make

;;; Code:
(require 'cl-lib)

;; Dynamically bind this when modes change
(defvar prog-fill-method-separators '(or "->" "."))
(defvar prog-fill-arg-separators '(or ","))
(defvar prog-fill-break-method-immediately-p nil)
(defvar prog-fill-floating-open-paren-p t)
(defvar prog-fill-floating-close-paren-p t)
(defvar prog-fill-auto-indent-p t)

(defun prog-fill ()
  "Split multi-argument call into one per line.

TODO: Handle string quotations (do not break them apart).
TODO: Handle different arg separators (Lisp style)."
  (interactive)
  (cl-flet ((re-next (reg) (re-search-forward reg nil t)))
    (save-excursion
      (save-restriction
        (goto-char (point-at-bol))
        (narrow-to-region (point) (point-at-eol))

        ;; Split args to methods on opening paren
        (goto-char (point-min))
        (while (re-next (rx "(" (group (not (any ")")))))
          (replace-match (rx "(\n" (backref 1))))

        ;; Split based on arglist
        (goto-char (point-min))
        (while (re-next  (rx-to-string `(group ,prog-fill-arg-separators)))
          (replace-match (rx (backref 1) ?\n)))

        ;; Split on closing paren
        (goto-char (point-min))
        (while (re-next ")")
          (replace-match "\n)"))

        ;; Split on nested parens/methods
        (goto-char (point-min))
        (while (re-next "))")
          (replace-match ")\n)"))

        ;; Split to multi-line chained method calls (keep first level bound)
        (goto-char (point-min))
        (while (re-next (rx-to-string
                         `(:
                           (group ,prog-fill-method-separators)
                           (group (zero-or-more any))
                           (group ,prog-fill-method-separators))))
          (replace-match (rx (backref 1) (backref 2) ?\n (backref 3))))

        ;; Split to multi-line chained method calls (keep first level unbound)
        (if prog-fill-break-method-immediately-p
            (progn                    ; This implies breaking on $this
              (goto-char (point-min))
              (while (re-next (rx
                               (group (eval prog-fill-method-separators))))
                (replace-match (rx ?\n (backref 1)))))

          (progn
            ;; Bring back up ending parens arrows
            (goto-char (point-min)) ; This implies breaking on $this->that
            (while (re-next (rx-to-string
                             `(:
                               ")" ?\n
                               (group ,prog-fill-method-separators))))
              (replace-match (rx ")" (backref 1))))))

        ;; Split multi-line
        (goto-char (point-min))
        (while (re-next (rx-to-string
                         `(:
                           ")"
                           (group ,prog-fill-method-separators))))
          (replace-match (rx ")" ?\n (backref 1))))

        ;; Bring back up closing parens
        (goto-char (point-min))
        (while (re-next (rx
                         "(" ?\n (0+ " ") ")"))
          (replace-match "()"))

        ;; Bring back up ALL closing parens
        (unless prog-fill-floating-close-paren-p
          (goto-char (point-min))
          (while (re-next (rx ?\n (0+ " ") ")"))
            (replace-match ")")))

        ;; Bring back up all the parens next lines
        (unless prog-fill-floating-open-paren-p
          (goto-char (point-min))
          (while (re-next (rx
                           "(" ?\n))
            (replace-match "(")))

        ;; Ensure no pure whitespace lines (what mode would want them?)
        (goto-char (point-min))
        (while (re-next (rx ?\n (0+ whitespace) eol))
          (replace-match ""))

        (when prog-fill-auto-indent-p
          (indent-region (point-min) (point-max)))

        (fill-paragraph)))))

;;;###autoload
(add-hook
 'prog-mode-hook
 (lambda () (local-set-key (kbd "M-q") #'prog-fill)))

(provide 'prog-fill)

;;; prog-fill.el ends here
