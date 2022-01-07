pre-commit:
  parallel: true
  commands:
     sh-fmt:
       run: git-format-staged --formatter  'shfmt -' '*.sh' '*.bash'
       glob: "*.{sh,bash}"
     shellcheck:
       run: shellcheck {all_files}
       glob: "*.{sh,bash}"
