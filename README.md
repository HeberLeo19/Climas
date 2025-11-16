PARA CARGAR EL ARCHIVO .TAR Y CORRER EL CONTENEDOR

DESCARGAR LA IMAGEN APP_CLIMA.TAR

1. docker load -i app_clima.tar

2. docker run -d -p 8080:80 --name clima app_clima

3. http://localhost:8080


PARA EJECUTAR DESDE TERMINAL DEL CODIGO Y WEB:
1. flutter build web >
2. docker build -t app_clima .
3. docker run -d -p 8080:80 --name app_clima_container app_clima
4. http://localhost:8080
