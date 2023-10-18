#!/bin/bash
set -e

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

user_can_sudo() {
  command_exists sudo || return 1
  ! LANG= sudo -n -v 2>&1 | grep -q "may not run sudo"
}

install_chrome() {
  RUN=$(user_can_sudo && echo "sudo" || echo "command")
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  $RUN dpkg -i google-chrome-stable_current_amd64.deb
}

install_simple_screen_recorder() {
  RUN=$(user_can_sudo && echo "sudo" || echo "command")
  $RUN apt-add-repository ppa:maarten-baert/simplescreenrecorder
  $RUN apt-get update -y  
  $RUN apt-get install simplescreenrecorder -y
}

install_docker() {
  RUN=$(user_can_sudo && echo "sudo" || echo "command")
  $RUN apt-get remove docker docker-engine docker.io containerd runc
  $RUN apt-get install ca-certificates curl gnupg lsb-release -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
	  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
	  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  $RUN apt-get update
  $RUN apt-get install docker-ce docker-ce-cli containerd.io -y
}

install_vscode() {
  RUN=$(user_can_sudo && echo "sudo" || echo "command")

  $RUN apt install software-properties-common apt-transport-https wget -y
  wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
  $RUN add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
  $RUN apt install code
}

install_beyondcompare() {
  RUN=$(user_can_sudo && echo "sudo" || echo "command")

  wget https://www.scootersoftware.com/bcompare-4.4.6.27483_amd64.deb
  $RUN apt update
  $RUN apt install ./bcompare-4.4.6.27483_amd64.deb
}

main() {
  RUN=$(user_can_sudo && echo "sudo" || echo "command")
  
  $RUN apt-get update
  $RUN apt-get upgrade
  $RUN apt-get install -y git wget vim
  
  # Time sync. for dual booting btw Window and Ubuntu
  timedatectl set-local-rtc 1 --adjust-system-clock
  
  # chrome
  # NOTE: It requires typing `enter` key, so automatic installation may breaks
  # install_chrome
  
  # Set minimal C++ example 
  $RUN apt install cmake libeigen3-dev libboost-all-dev -y

  # For playing mkv file
  $RUN apt install ubuntu-restricted-extras mpv -y
  
  # xpad
  $RUN apt install xpad -y  
  
  # terminator
  $RUN apt install terminator -y  

  # Simple screen recorder
  install_simple_screen_recorder
  
  # Inkscape 
  $RUN apt-get install inkscape
  
  # pip3
  $RUN apt install python3-pip -y
  
  # Docker
  install_docker

  # latex
  # NOTE: If you want to install full version, use `texlive-full` instead
  $RUN apt install texlive-latex-extra -y

  # VSCode
  install_vscode

  # Beyond Compare
  install_beyondcompare

  # Zotero
  $RUN apt install zotero
}

main 
