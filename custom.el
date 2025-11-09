;; -*- lexical-binding: t; -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("920a9ae46eff9e641e6af864a09201767f4aca9cf169b2287d9a701ef5ecaa87"
     "cc3cb3b291a7e31f1d40ea8587fb2907aca168d820ab4683764f7c478761f84f"
     "f60670b53f340f48be6071dd39e70e50e634261e6178e95f28f329bea36919ec" default))
 '(logview-additional-level-mappings
   '(("PCoIP-Levels" (error "LVL:0") (warning "LVL:1") (information "LVL:2")
      (debug "LVL:3") (trace "LVL:4") (aliases "pcoip"))))
 '(logview-additional-submodes
   '(("PCoIP" (format . "TIMESTAMP LEVEL THREAD IGNORED NAME")
      (levels . "PCoIP-Levels") (timestamp) (aliases))))
 '(logview-additional-timestamp-formats
   '(("PCoIP-Timestamp"
      (regexp
       . "[0-9]+-[0-9][0-9]-[0-9][0-9]T[0-9][0-9]:[0-9][0-9]:[0-9][0-9]\\.[0-9][0-9][0-9]Z"))))
 '(lsp-clangd-version "16.02")
 '(package-selected-packages nil)
 '(safe-local-variable-values
   '((eval when (fboundp 'rainbow-mode) (rainbow-mode 1))
     (qml-integration-qt-install-bin-folder . "~/Qt/6.9.1/gcc_64/bin")
     (squish-suites-folder . "squish_tests")
     (squish-suite-folder . "squish_tests")
     (qml-integration-import-directories "." "imports"
                                         "~/git_files/soft-clients/desktop_app/ui_session_common_qt/janus/Resources"
                                         "~/git_files/soft-clients/desktop_app/ui_session_common_qt/neos"
                                         "~/git_files/soft-clients/desktop_app/ui_session_common_qt/janus/in_session/resources/")
     (py-master-file
      . "/home/dmoreira/git_files/squish_tool/pcoip_client_control/tests/test_pages.py")
     (qml-integration-ignored-paths "*/.*" "./Documentation" "./package" "./sdk"
                                    "./Tools" "./trust_agent_ipc" "./Dockerfile"
                                    "./cmake" "./licenses" "./build*"
                                    "./modules/_submodules"
                                    "./modules/safe-c-library"
                                    "./modules/logger" "./modules/legacy"
                                    "./modules/broker*" "./modules/test*"
                                    "./modules/edid_retriever"
                                    "./modules/customization_example"
                                    "./modules/vchan_plugins"
                                    "./modules/tera_crypto"
                                    "./modules/ndk_build" "./modules/utils"
                                    "./modules/customization"
                                    "./modules/layer_4" "./modules/android"
                                    "./modules/high_performance_client"
                                    "*/localization" "*/translations")
     (qml-integration-qt-quick-controls-style . "imports/Janus")
     (qml-integration-import-directories "." "imports"
                                         "~/git_files/soft-clients/desktop_app/ui_session_common_qt/janus/resources")
     (qml-integration-user-styles "imports/Janus")
     (cmake-integration-include-subproject-targets-during-completion)
     (cmake-integration-hide-utility-targets-during-completion . t)
     (cmake-integration-include-subproject-targets-during-completion . t)
     (cmake-integration-hide-library-targets-during-completion)
     (cmake-integration-run-working-directory . root)
     (org-download-method . attach) (org-download-method quote attach)
     (ff-search-directories "." "../inc" "../src" "../api" "../src/view/impls/*"
                            "../../inc" "../src/controller" "../../../../inc"
                            "/usr/include")
     (ff-search-directories "." "../inc" "../src" "../api" "../src/view/impls/*"
                            "../../inc" "../../../../inc" "/usr/include")
     (ff-search-directories "." "../inc" "../src" "../api" "../src/view/impls/*"
                            "../../../../inc" "/usr/include")
     (ff-search-directories "." "../inc" "../src" "../src/view/impls/*"
                            "../../../../inc" "/usr/include")
     (ff-search-directories "." "../inc" "../src" "../../../../inc"
                            "../src/view/impls/*" "/usr/include")
     (ff-search-directories "." "../inc" "../src" "../../../../inc"
                            "../src/*/*/*" "/usr/include")
     (ff-search-directories "." "../inc" "../src" "../view/impls/qml"
                            "/usr/include")
     (ff-search-directories "." "../inc" "../src" "/usr/include")
     (ff-search-directories "." "../inc" "../src" "/usr/include"
                            "/home/dmoreira/git_files/soft-clients/modules/*/src/*/*/*"
                            "/home/dmoreira/git_files/soft-clients/modules/*/src/*/*/*/*"
                            "/home/dmoreira/git_files/soft-clients/modules/*/inc/*/*/*")
     (my/qml-root-folder
      . ~/git_files/soft-clients/modules/ui_pre_session_qt/src/view/impls/qml/qml)
     (ff-search-directories "." "/usr/include"
                            "/home/dmoreira/git_files/soft-clients/modules/ui_pre_session_qt/src/*/*/*"
                            "/home/dmoreira/git_files/soft-clients/modules/ui_pre_session_qt/src/*/*/*/*"
                            "/home/dmoreira/git_files/soft-clients/modules/ui_pre_session_qt/inc/*/*/*")
     (my/qmlscene-extra-args . "-I ../janus/imports -I ../janus")
     (cmake-integration-build-dir . "build/Debug")
     (cmake-integration-hide-library-targets-during-completion . t)
     (cmake-integration-conan-arguments . "--build missing -r conancenter")
     (cmake-integration-hide-utility-targets-during-completion)
     (cmake-integration-include-conan-toolchain-file)
     (cmake-integration-include-conan-toolchain-file . t)
     (cmake-integration-conan-profile . "debug") (darlan-cmake-use-ninja . t)
     (darlan-build-dir . "build")
     (cmake-integration-run-working-directory . bin)))
 '(warning-suppress-log-types '((comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
