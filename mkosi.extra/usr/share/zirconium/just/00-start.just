default:
    @zjust --choose

# Simple wrapper over bootc/pompona for updating your system
update:
    #!/usr/bin/env bash
    if [[ -e "/sysroot/ostree" || -e "/sysroot/composefs" ]] ; then
        pkexec bootc upgrade
    else
        pompona-update
    fi

reset-all-configs:
    #!/usr/bin/env bash
    if gum confirm --default=no "Are you sure you want to reset all your configuration?" ; then
        pkill -USR1 -x dms >/dev/null 2>&1 || :
        rm -rf "$HOME/.config/dms" "$HOME/.cache/dms" "$HOME/.local/state/dms"
        mv "$HOME/.config/DankMaterialShell" "$HOME/.config/dms"
        mv "$HOME/.cache/DankMaterialShell" "$HOME/.cache/dms"
        mv "$HOME/.local/state/DankMaterialShell" "$HOME/.local/state/dms"
        ln -sf "$HOME/.config/dms" "$HOME/.config/DankMaterialShell"
        ln -sf "$HOME/.cache/dms" "$HOME/.cache/DankMaterialShell"
        ln -sf "$HOME/.local/state/dms" "$HOME/.local/state/DankMaterialShell"
    fi

# Toggle display of the user-motd in terminal
toggle-user-motd:
    #!/usr/bin/bash
    if [ -e "${HOME}/.config/zirconium/no-show-user-motd" ] ; then
        if gum confirm "Would you like to enable the MOTD?" ; then
            rm -f "${HOME}/.config/zirconium/no-show-user-motd"
            echo "MOTD will now be shown on login."
            exit 0
        fi
    fi
    if gum confirm "Would you like to disable the MOTD?" ; then
        mkdir -p "${HOME}/.config"
        touch "${HOME}/.config/zirconium/no-show-user-motd"
        echo "MOTD will not be shown anymore"
        exit 0
    fi

toggle-fcitx5:
    #!/usr/bin/env bash

    if systemctl is-enabled --quiet --user fcitx5 ; then
        if gum confirm "Would you like to disable fcitx5?" ; then
            systemctl disable --quiet --now --user fcitx5.service
            systemctl mask --quiet --now --user fcitx5.service
            echo "Disabled fcitx5"
            exit 0
        fi
    else
        if gum confirm "Would you like to enable fcitx5?" ; then
            systemctl unmask --quiet --user fcitx5.service
            systemctl enable --quiet --now --user fcitx5.service
            echo "Enabled fcitx5"
            exit 0
        fi
    fi

preinstalled-flatpaks:
    #!/usr/bin/env bash
    if gum confirm "Would you like to (re)install the preinstalled flatpaks?" ; then
        flatpak preinstall --reinstall
    fi

update-greeter:
    DMS_PRIVESC=sudo dms-greeter sync --auth

# Turn automatic updates on or off
toggle-updates ACTION="prompt":
    #!/usr/bin/bash
    CURRENT_STATE="$(systemctl is-enabled uupd.timer)"

    if [ "${CURRENT_STATE}" == "enabled" ] ; then
        if gum confirm --default=no "Would you like to disable automatic updates?" ; then
            sudo systemctl disable uupd.timer
            echo "Updates have been disabled"
        fi
    else
        if gum confirm --default=yes "Would you like to enable automatic updates?" ; then
            sudo systemctl enable uupd.timer
            echo "Updates have been enabled"
        fi
    fi

alias toggle-tpm2 := toggle-luks-tpm2

# TPM2 auto-unlock toggle
toggle-luks-tpm2:
    @/usr/bin/luks-tpm2-autounlock

# Check for local overrides
check-local-overrides:
    #!/usr/bin/bash
    RESET="\x1b[0m"
    if [ "${NO_COLOR}" == 1 ]; then
        BLUE_COLOR=""
        GREEN_COLOR=""
        YELLOW_COLOR=""
    else
        BLUE_COLOR="${BLUE_COLOR:-\x1b[38;5;117m}"
        GREEN_COLOR="${GREEN_COLOR:-\x1b[38;5;85m}"
        YELLOW_COLOR="${YELLOW_COLOR:-\x1b[93m}"
    fi

    sudo diff -qr \
        --suppress-common-lines \
        --color="always" \
        --exclude "passwd*" \
        --exclude "group*" \
        --exclude="subgid*" \
        --exclude="subuid*" \
        --exclude="machine-id" \
        --exclude="adjtime" \
        --exclude="fstab" \
        --exclude="system-connections" \
        --exclude="shadow*" \
        --exclude="gshadow*" \
        --exclude="ssh_host*" \
        --exclude="cmdline" \
        --exclude="crypttab" \
        --exclude="hostname" \
        --exclude="localtime" \
        --exclude="locale*" \
        --exclude="*lock" \
        --exclude=".updated" \
        --exclude="*LOCK" \
        --exclude="vconsole*" \
        --exclude="00-keyboard.conf" \
        --exclude="grub" \
        --exclude="system.control*" \
        --exclude="cdi" \
        --exclude="default.target" \
        /usr/etc /etc 2>/dev/null | sed \
            -e '/Binary\ files\ /d ; /Common subdirectories/d' \
            -e "/Files/ s/^/${BLUE_COLOR}&/g" \
            -e "/Files/ s/\$/&${RESET}/g" \
            -e "/Only in/ s/^/${GREEN_COLOR}&/g" \
            -e "/Only in/ s/\$/&${RESET}/g" \
            -e "s/\:.*/${RESET}${YELLOW_COLOR}&${RESET}/g"

# Gather device info to a pastebin
generate-bug-report:
    #!/usr/bin/bash
    if ! gum confirm "Submit information to the CentOS pastebin?" ; then
        exit 0
    fi

    REPORT_DATA="$(mktemp)"
    trap 'rm ${REPORT_DATA}' EXIT
    cat &> "${REPORT_DATA}" <<EOF
    --#--# sudo bootc status --verbose:
    $(sudo bootc status --verbose)
    --#--# fpaste --sysinfo --printonly:
    $(fpaste --sysinfo --printonly)
    --#--# flatpak list --columns=application,version,options:
    $(flatpak list --columns=application,version,options)
    --#-# BIOS info:
    Manufacturer:
    $(dmidecode -s baseboard-manufacturer 2>/dev/null)
    Product Name:
    $(dmidecode -s baseboard-product-name 2>/dev/null)
    Version:
    $(dmidecode -s bios-version 2>/dev/null)
    Release Date:
    $(dmidecode -s bios-release-date 2>/dev/null)
    EOF

    gzip -9c $REPORT_DATA | base64 | fpaste -t "zirconium report $(date +%Y%m%d%H%M%S)" --private=1
