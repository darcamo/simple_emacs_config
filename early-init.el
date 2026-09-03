;; -*- lexical-binding: t; -*-
(setq package-enable-at-startup nil)

;; See https://www.jamescherti.com/emacs-security-settings/
(setq gnutls-verify-error t)
(setq tls-checktrust t)
(setq gnutls-min-prime-bits 3072)
