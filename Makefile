all:
	mkdir -p /home/jvenkata/data/mariadb
	mkdir -p /home/jvenkata/data/wordpress
	docker-compose -f srcs/docker-compose.yml up --build

down:
	docker-compose -f srcs/docker-compose.yml down

clean:
	docker-compose -f srcs/docker-compose.yml down -v

fclean: clean
	rm -rf /home/jvenkata/data

re: fclean all