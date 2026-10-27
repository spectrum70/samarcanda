samarcanda (all-minors) theme

By Angelo Dureghello (C) kernel-space.org 2026

Prerequisites:
some nerd font
noto-fonts-emoji that is a fall back to better icon graphic

If fall-back does not work, please edit ".config/fontconfig/fonts.conf" :

<fontconfig>
    <alias>
        <family>monospace</family>
        <prefer>
            <family>Terminess Nerd Font Mono</family>
            <family>Noto Color Emoji</family>
        </prefer>
    </alias>
     ....
