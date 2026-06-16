# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: edi-maio <edi-maio@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/06/16 14:17:15 by edi-maio          #+#    #+#              #
#    Updated: 2026/06/16 14:17:56 by edi-maio         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME=inception

all:
	mkdir -p /home/edi-maio/data/wordpress \
	         /home/edi-maio/data/mariadb \
	         /home/edi-maio/data/portainer
	docker compose -f srcs/docker-compose.yml up -d --build

down:
	docker compose -f srcs/docker-compose.yml down

clean: down
	rm -rf /home/edi-maio/data

fclean: clean
	docker system prune -af

re: fclean all