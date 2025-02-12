# **************************************************************************** #
#                                Makefile                                       #
# **************************************************************************** #

# ---------------------------
# Main Project Commands
# ---------------------------

# Build the project: create required directories, set permissions, and build containers
build:
	@sudo mkdir -p /home/smoreron/data/db /home/smoreron/data/wordpress /home/smoreron/data/mariadb
	sudo chown -R smoreron:smoreron /home/smoreron/data/mariadb
	sudo chmod -R 755 /home/smoreron/data/mariadb
	sudo chown -R smoreron:smoreron /home/smoreron/data/wordpress
	sudo chmod -R 755 /home/smoreron/data/wordpress
	sudo chown -R smoreron:smoreron /home/smoreron/data/db
	sudo chmod -R 755 /home/smoreron/data/db
	docker compose -f ./srcs/docker-compose.yml build

# Start the project in detached mode
up: build
	sudo docker compose -f ./srcs/docker-compose.yml up -d

# Stop and remove all containers and volumes
down:
	docker compose -f ./srcs/docker-compose.yml down --volumes

# Check the current state of containers
ps:
	docker compose -f ./srcs/docker-compose.yml ps

# ---------------------------
# Logging and Debugging
# ---------------------------

# View logs for all containers
logs:
	docker compose -f ./srcs/docker-compose.yml logs

# View logs for specific containers
logs_wordpress:
	docker logs wordpress
logs_nginx:
	docker logs nginx
logs_mariadb:
	docker logs mariadb

# Follow logs in real-time
follow:
	docker compose -f ./srcs/docker-compose.yml logs --follow

# ---------------------------
# System Management
# ---------------------------

# Clean up unused data and user directories
clean:
	docker volume prune -f
	docker system prune -f
	sudo rm -rf /home/smoreron/data

# Remove unused containers, images, and volumes
prune:
	docker system prune -f

fclean: down clean prune


# ---------------------------
# Docker Compose Utilities
# ---------------------------

# Validate the docker-compose.yml configuration
config:
	docker compose -f ./srcs/docker-compose.yml config

# Restart all containers
restart:
	docker compose -f ./srcs/docker-compose.yml restart

# Run a command inside a running container
# ---------------------------
# Miscellaneous
# ---------------------------

# Show the version of Docker Compose
version:
	docker compose -f ./srcs/docker-compose.yml version

# Display resource usage statistics for containers
stats:
	docker compose -f ./srcs/docker-compose.yml stats

# List networks used by the project
networks:
	docker compose -f ./srcs/docker-compose.yml ls

# ---------------------------
# Check DB
# ---------------------------

exec:
	docker exec -it mariadb /bin/bash
#mysql -u wordpress_user -p 
# USE wordpressdb; SHOW TABLES; SHOW DATABASES;



# ---------------------------
# Aliases and Rules
# ---------------------------

# Build and start the project from scratch
all: build up
re: fclean all



# Define all targets as phony to avoid conflicts with files of the same name
.PHONY: all build up down ps logs logs_wordpress logs_nginx logs_mariadb follow clean prune config restart exec version stats networks