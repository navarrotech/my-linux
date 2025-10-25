# Earthfile: https://docs.earthly.dev/docs/earthfile

VERSION --try 0.8

ARG FIRST_NAME=Alex
ARG LAST_NAME=Navarro
ARG EMAIL=alex@navarrocity.com
ARG USERNAME=alex-navarro
ARG USER_ID=1000
ARG GROUP_ID=1000

# Use any of these to test the build:
FROM fedora:42
# FROM rbi:9
# FROM ubuntu:24

# Enable use LOCALLY instead of FROM to actually perform a REAL install:
# LOCALLY

# create group/user and home
RUN groupadd -g "${GROUP_ID}" "${USERNAME}"
RUN useradd -m -u "${USER_ID}" -g "${USERNAME}" -s /bin/bash "${USERNAME}"
RUN mkdir -p /home/$USERNAME && chown $USERNAME:$USERNAME /home/$USERNAME
RUN usermod -aG wheel "${USERNAME}"

# Setup:
IF [ -f /etc/redhat-release ]
  RUN dnf update -y
  RUN dnf group install -y "development-tools" 

  # Core:
  RUN dnf install -y dnf-plugins-core \
    # Core:
    curl wget tar git make findutils which ca-certificates \
    # My favorites:
    fish zoxide fzf ripgrep fd-find bat tree kitty xclip \
    dnf-plugins-core

  # Languages:
  RUN dnf install -y \
    gcc gcc-c++ \
    python3 python3-pip \
    golang \
    rust cargo \
    java-21-openjdk-devel

  # Yazi
  RUN sudo dnf5 copr enable -y lihaohong/yazi && sudo dnf5 install -y yazi

  # KDE Plasma Desktop Environment:
  TRY
    RUN dnf install -y @kde-desktop-environment \
      && systemctl disable gdm \
      && systemctl enable sddm
  END

  # GitHub CLI - https://github.com/cli/cli/blob/trunk/docs/install_linux.md
  RUN dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
  RUN dnf install gh --repo gh-cli

  # Fedora-specific:
  IF [ -f /etc/fedora-release ]
    # Docker
    # https://docs.docker.com/engine/install/fedora/
    RUN dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

    # ProtonVPN:
    RUN wget "https://repo.protonvpn.com/fedora-42-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.3-1.noarch.rpm" \
      && dnf install -y ./protonvpn-stable-release-1.0.3-1.noarch.rpm \
      && dnf install -y proton-vpn-gnome-desktop

  ELSE
    # Docker
    # https://docs.docker.com/engine/install/rhel/
    RUN dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
  
    # ProtonVPN is not supported for RHEL!
  END

  # Docker
  RUN dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # Teams for Linux
  # https://github.com/IsmaelMartinez/teams-for-linux
  RUN curl -1sLf -o /tmp/teams-for-linux.asc https://repo.teamsforlinux.de/teams-for-linux.asc \
    && rpm --import /tmp/teams-for-linux.asc \
    && curl -1sLf -o /etc/yum.repos.d/teams-for-linux.repo https://repo.teamsforlinux.de/rpm/teams-for-linux.repo \
    && dnf -y install teams-for-linux

  # Google Chrome
  COPY ./repos/yum.repos.d/google-chrome.repo /etc/yum.repos.d/google-chrome.repo
  RUN dnf install -y google-chrome-stable

  # VS Code
  COPY ./repos/yum.repos.d/vscode.repo /etc/yum.repos.d/vscode.repo
  RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
  RUN dnf install -y code

  RUN dnf check-update --refresh && dnf makecache && dnf clean all

ELSE IF [ -f /etc/debian_version ]
  RUN apt update -y
  RUN install -m 0755 -d /etc/apt/keyrings
  RUN chmod a+r /etc/apt/keyrings/*.gpg

  RUN apt install -y build-essential \
    # Core:
    curl wget tar git make findutils which ca-certificates ffmpeg 7zip jq \
    poppler-utils imagemagick \
    # My favorites:
    fish zoxide fzf ripgrep fd-find bat tree kitty \

  # Languages:
  RUN apt install -y \
    gcc g++ \
    python3 python3-pip \
    golang-go \
    rustc cargo \
    openjdk-21-jdk

  # KDE Plasma Desktop Environment:
  TRY
    RUN apt install -y kde-plasma-desktop \
      && systemctl disable gdm3 \
      && systemctl enable sddm
  END

  # Docker - https://docs.docker.com/engine/install/ubuntu/
  # Add Docker's official GPG key:
  RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
  RUN apt update -y && apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # ProtonVPN:
  RUN wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.8_all.deb \
    && dpkg -i ./protonvpn-stable-release_1.0.8_all.deb \
    && apt update -y \
    && apt install proton-vpn-gnome-desktop

  # Github CLI - https://github.com/cli/cli/blob/trunk/docs/install_linux.md
  COPY ./repos/apt/github-cli.list /etc/apt/sources.list.d/github-cli.list
  RUN out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && sudo apt update -y && sudo apt install gh -y

  # Teams for Linux
  RUN wget -qO /etc/apt/keyrings/teams-for-linux.asc https://repo.teamsforlinux.de/teams-for-linux.asc \
  && sh -c 'echo "Types: deb\nURIs: https://repo.teamsforlinux.de/debian/\nSuites: stable\nComponents: main\nSigned-By: /etc/apt/keyrings/teams-for-linux.asc\nArchitectures: amd64" | sudo tee /etc/apt/sources.list.d/teams-for-linux-packages.sources' \
  && apt update -y && sudo apt install -y teams-for-linux

  # Google Chrome
  COPY ./repos/apt/google-chrome.list /etc/apt/sources.list.d/google-chrome.list
  RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/keyrings/google-linux.gpg
  RUN apt update -y && apt install -y google-chrome-stable

  # VS Code
  COPY ./repos/apt/vscode.list /etc/apt/sources.list.d/vscode.list
  RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/keyrings/microsoft.gpg
  RUN apt update -y && apt install -y code

  RUN apt clean  && rm -rf /var/lib/apt/lists/*
END

# Docker
RUN systemctl enable docker

# https://docs.docker.com/engine/install/linux-postinstall/
RUN usermod -aG docker $USERNAME

# The remaining commands should be independent of the base OS:

WORKDIR /home/${USERNAME}

# NVM:
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
RUN mv /root/.nvm /home/${USERNAME}/.nvm

# Starship.rs
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- --yes --bin-dir /usr/local/bin

# Addons:
RUN mkdir -p /home/${USERNAME}/.config/
ENV PATH=$PATH:/usr/local/bin:/home/${USERNAME}/.nvm/versions/node/v23.11.1/bin
# RUN nvm install 23.11.1

# Fish Addons (via fisher)
RUN fish -c 'curl -sL https://git.io/fisher | source; and fisher install jorgebucaran/fisher oh-my-fish/plugin-bang-bang edc/bass jorgebucaran/nvm.fish'

# Configs:
COPY configs/config.fish /home/${USERNAME}/.config/fish/config.fish
COPY configs/starship.toml /home/${USERNAME}/.config/starship.toml
COPY configs/kitty.conf /home/${USERNAME}/.config/kitty/kitty.conf
COPY configs/.bashrc /home/${USERNAME}/.bashrc

ENV USER="${USERNAME}" HOME="/home/${USERNAME}"
USER ${USERNAME}

RUN git config --global user.name "${FIRST_NAME} ${LAST_NAME}"
RUN git config --global user.email "${EMAIL}"
RUN ssh-keygen \
  -t ed25519 \
  -C "${EMAIL}" \
  -f /home/${USERNAME}/.ssh/id_ed25519 \
  -N ""
