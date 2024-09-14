IS_DOMAIN_SETUP := $(shell grep -c "vtryason.42.fr" /etc/hosts)
LOCAL_IP_ADDRESS := $(shell hostname -i)
DOCKER_NETWORK := $(shell docker network ls | grep -c docker-network)

all: mount_wordpress mount_mariadb up
	@if [ "$(IS_DOMAIN_SETUP)" = 0 ]; then \
	sudo cp /etc/hosts /tmp/hosts.tmp; \
	echo $(LOCAL_IP_ADDRESS) "     vtryason.42.fr" | sudo tee -a /etc/hosts >/dev/null; \
	sudo rm /tmp/hosts.tmp; \
	fi

up:
	@docker compose -f srcs/docker-compose.yml up --build --detach
	@echo "\n\e[0;32mServers are up!\033[0m\n"

shutdown:
	@docker compose -f srcs/docker-compose.yml down
	@echo "\n\e[0;31mServers are down!\033[0m\n"

mount_wordpress: 
	@sudo mkdir -p /home/vboxuser/data/wordpress

mount_mariadb:
	@sudo mkdir -p /home/vboxuser/data/mariadb

fclean:
	@if [ "$(IS_DOMAIN_SETUP)" -gt 0 ]; then \
	head -n -1 /etc/hosts > /tmp/hosts.tmp \
    && sudo cp /tmp/hosts.tmp /etc/hosts \
    && sudo rm /tmp/hosts.tmp; \
	fi
	@docker ps -q | xargs -r docker stop >/dev/null 2>&1
	@docker ps -qa | xargs -r docker rm >/dev/null 2>&1
	@docker images -qa | xargs -r docker rmi >/dev/null 2>&1
	@if [ "$(DOCKER_NETWORK)" -gt 0 ]; then \
	docker network rm docker-network >/dev/null 2>&1; \
	fi
	@docker volume ls -q | xargs -r docker volume rm >/dev/null 2>&1
	@sudo rm -rf /home/vboxuser/data
	@echo "\n\\e[0;31mFull clean completed!\033[0m\n"

re: fclean all 

.PHONY: fclean all up shutdown mount_mariadb mount_wordpress re 

