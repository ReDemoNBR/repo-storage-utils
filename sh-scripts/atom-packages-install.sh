echo "Installing util packages..."
apm install busy-signal expose intentions platformio-ide-terminal script tool-bar tool-bar-atom
apm install atom-beautify atom-html-preview color-picker file-icons fonts merge-conflicts open-in-browser pigments
echo "Util packages installed"
echo "Installling coding utils (linters, language syntax, indent, autocomplete etc)"
apm install atom-typescript ide-typescript language-gitignore language-nunjucks language-systemd
apm install linter linter-eslint linter-flake8 linter-shellcheck
apm install auto-indent autoclose-html autocomplete-modules highlight-selected 
echo "Coding utils installed"
echo "Installing themes..."
apm install one-dark-shade-ui seti-syntax seti-ui
echo "Themes installed"
echo "Installing done"
