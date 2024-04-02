# ClassicsRoutes

# Для использования приложения требуется развернуть локальный хост

## Для этого введите следующую команду в терминал:

docker run --name ClassicsRoutes \
-e POSTGRES_DB=route_database \
-e POSTGRES_USER=route_username \
-e POSTGRES_PASSWORD=route_password \
-p 5432:5432 -d postgres
