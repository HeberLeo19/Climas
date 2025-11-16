# Usamos NGINX para servir la app compilada
FROM nginx:alpine

# Borramos archivos por defecto de nginx
RUN rm -rf /usr/share/nginx/html/*

# Copiamos la app web de Flutter al directorio público de nginx
COPY build/web /usr/share/nginx/html

# Exponemos el puerto 80 (HTTP)
EXPOSE 80

# Comando por defecto de nginx (ya viene configurado en la imagen base)
