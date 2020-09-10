#!/bin/bash

CYAN='\033[0;36m'
NC='\033[0m' # No Color

services_names[1]="core с elastic"
services_names[2]="core без elastic"
services_names[3]="sender (rabbitmq)"
services_names[4]="1csync"
services_names[5]="amosync"
services_names[6]="bitrixsync"

services_paths[1]="./core/ci/docker/dev/docker-compose.with-elastic.yml"
services_paths[2]="./core/ci/docker/dev/docker-compose.yml"
services_paths[3]="./sender/docker-compose.dev.yml"
services_paths[4]="./1csync/ci/dev/docker-compose.yml"
services_paths[5]="./amosync/ci/dev/docker-compose.yml"
services_paths[6]="./bitrixsync/ci/dev/docker-compose.yml"

actions[1]="Запустить сервисы"
actions[2]="Остановить сервисы"



printf "${CYAN}Что хочешь сделать?${NC} (напиши цифру)\n"
for action in "${!actions[@]}"
do
	printf "${CYAN}$action.${NC} "
	echo "${actions[$action]}"
done
printf "\n"
read action
printf  "\n"
if [[ ${actions[$action]} == '' ]]
		then printf "${CYAN}Несуществующий номер действия${NC}\n"
		exit
fi



if [[ $action == 1 ]]
	then 
		printf "${CYAN}Что хочешь запустить?${NC} (пиши цифры через запятую)\n"
		for service in "${!services_names[@]}"
		do
			printf "${CYAN}$service. ${NC}"
			echo "${services_names[$service]}"
		done
		printf "\n"
		read chosen_services_numbers
		printf  "\n"

		services_numbers=$(echo $chosen_services_numbers | tr "," "\n")
		services=""

		for service_number in $services_numbers
		do
			if [[ ${services_names[$service_number]} == '' ]]
				then printf "${CYAN}Несуществующий номер сервиса${NC}\n"
				exit
			fi
			
			printf "${CYAN}Запускаю ${NC}" 
			echo ${services_names[$service_number]}...
			
			docker-compose -f ${services_paths[$service_number]} up -d --build
			
			services+="${services_names[$service_number]}${CYAN};${NC} "
		done

		printf "${CYAN}Были запущены сервисы: ${NC}$services\n"
	else
		printf "${CYAN}Что хочешь остановить?${NC} (пиши цифры через запятую)\n"
		for service in "${!services_names[@]}"
		do
			printf "${CYAN}$service. ${NC}"
			echo "${services_names[$service]}"
		done
		printf "\n"
		read chosen_services_numbers
		printf  "\n"

		services_numbers=$(echo $chosen_services_numbers | tr "," "\n")
		services=""

		for service_number in $services_numbers
		do
			if [[ ${services_names[$service_number]} == '' ]]
				then printf "${CYAN}Несуществующий номер сервиса${NC}\n"
				exit
			fi
			
			printf "${CYAN}Останавливаю ${NC}"
			echo ${services_names[$service_number]}...
			
			docker-compose -f ${services_paths[$service_number]} down
			
			services+="${services_names[$service_number]}${CYAN};${NC} "
		done

		printf "${CYAN}Были остановлены сервисы: ${NC}$services\n"
fi
