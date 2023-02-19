#!/bin/bash
#
# ChatGPT: Open Source
# License: General Public License
# System: GNU/linux
# Date: 17-02-2023
#
# YouTube: https://youtube.com/channel/UCfMjNcFvJae_9g7wQI2W7EA
# Facebook: https://www.facebook.com/whitehacks00
# TikTok: https://tiktok.com/@whitehacks00
# Telegram: https://t.me/whitehacks00
# GitHub: https://github.com/Darkmux
#
# ==============================================
#                   VARIABLES
# ==============================================
operatingSystem=$(uname -o)
deviceArchitecture=$(uname -m)
showPath=$(pwd)
argument=$1
error=$2
urlGPT="https://api.openai.com/v1/completions"
# ==============================================
#                  LIGHT COLORS
# ==============================================
black="\e[1;30m"
blue="\e[1;34m"
green="\e[1;32m"
cyan="\e[1;36m"
red="\e[1;31m"
purple="\e[1;35m"
yellow="\e[1;33m"
white="\e[1;37m"
# ==============================================
#                  DARK COLORS
# ==============================================
blackDark="\e[0;30m"
blueDark="\e[0;34m"
greenDark="\e[0;32m"
cyanDark="\e[0;36m"
redDark="\e[0;31m"
purpleDark="\e[0;35m"
yellowDark="\e[0;33m"
whiteDark="\e[0;37m"
# ==============================================
#               BACKGROUND COLORS
# ==============================================
blackBack=$(setterm -background black)
blueBack=$(setterm -background blue)
greenBack=$(setterm -background green)
cyanBack=$(setterm -background cyan)
redBack=$(setterm -background red)
yellowBack=$(setterm -background yellow)
whiteBack=$(setterm -background white)
# ==============================================
#                   CHECK OS
# ==============================================
if [[ "${operatingSystem}" == "Android" ]]; then
    APT="pkg"
else
    APT="apt"
fi
# ==============================================
#            INSTALLING DEPENDENCIES
# ==============================================
checkcurl=$(command -v curl)
if [[ "${checkcurl}" == "" ]]; then
    ${APT} install curl -y
fi
checkbat=$(command -v bat)
if [[ "${checkbat}" == "" ]]; then
    ${APT} install bat -y
fi
# ==============================================
#                   API_KEY
# ==============================================
if [[ ! -f ".chatGPT.API_KEY" ]]; then
    touch .chatGPT.API_KEY
fi
key=$(cat .chatGPT.API_KEY)
if [[ "${key}" == "" ]]; then
    echo -e -n ${blue}"API_KEY
[-] >> "${black}
    read -r key
    echo "${key}" > .chatGPT.API_KEY
    clear
fi
# ==============================================
#                BANNER CHATGPT
# ==============================================
function chatgpt() {
    echo -e "
  ${black}____ _           _    ${red}____ ____ _____
 ${black}/ ___| |__   __ _| |_ ${red}/ ___|  _ \_   _|
${black}| |   | '_ \ / _' | __${red}| |  _| |_) || |
${black}| |___| | | | (_| | |_${red}| |_| |  __/ | |
${black} \____|_| |_|\__,_|\__|${red}\____|_|    |_|

           ${white}WHITE HACKS © 2023
           ${black}Coded by: ${red}@Darkmux
"
}
# ==============================================
#                   QUESTION
# ==============================================
function arguments() {
    chatgpt
    echo -e -n ${black}"┼────────────────────────┼
│ ${red}PROCESSING QUESTION... ${black}│
┼────────────────────────┼
"${white}
    
    res=$(curl -s ${urlGPT} -H "Content-Type: application/json" -H "Authorization: Bearer ${key}" -d "{\"model\": \"text-davinci-003\", \"prompt\": \"${argument}\", \"temperature\": 0, \"max_tokens\": 1000}")

    response=$(echo ${res} |awk -F 'text":"' '{print $2}'|awk -F '","index"' '{print $1}'| awk -F '\n\n' '{print $1}')

    echo -e "${response}

    " | bat

}
function interactive() {
    chatgpt
    while [ true ]; do
    echo -e -n ${black}"┼────────────────────────┼
│ ${red}WHAT IS YOUR QUESTION? ${black}│
┼────────────────────────┼
│
┼->> "${white}
    read -r question

    if [[ "${question}" == "exit" ]]; then
        exit
    elif [[ "${question}" == "clear" ]]; then
        clear
        interactive
    fi

    echo -e -n ${black}"│
┼────────────────────────┼
│ ${red}PROCESSING QUESTION... ${black}│
┼────────────────────────┼
"${white}

    res=$(curl -s ${urlGPT} -H "Content-Type: application/json" -H "Authorization: Bearer ${key}" -d "{\"model\": \"text-davinci-003\", \"prompt\": \"${question}\", \"temperature\": 0, \"max_tokens\": 1000}")

    response=$(echo ${res} |awk -F 'text":"' '{print $2}'|awk -F '","index"' '{print $1}'| awk -F '\n\n' '{print $1}')

    echo -e "${response}

    " | bat
    done
}
# ==============================================
#              DECLARING FUNCTIONS
# ==============================================
if [[ ! "${error}" == "" ]]; then
    echo -e ${red}"[${white}!${red}] ${black}Please enter your question in quotes."${white}
    exit
fi
if [[ "${argument}" == "" ]]; then
    interactive
else
    arguments
fi
