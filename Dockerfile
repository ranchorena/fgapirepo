# Partir de la imagen de Alpine de Python 3.10.5
FROM python:3.10.5-alpine

# Copiar la aplicación fgapi a la carpeta de trabajo
COPY ./fgapi /usr/src/app/fibergis.v3

COPY ./requirements.txt /usr/src/app/fibergis.v3/requirements.txt

# Establecer la carpeta de trabajo
WORKDIR /usr/src/app/fibergis.v3

# Instalar dependencias de compilación necesarias para GeoAlchemy2
RUN apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev

# Instalar las dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Desinstalar dependencias de compilación
RUN apk del .build-deps

# Exponer el puerto 6062
EXPOSE 6062

# Instalo curl pra luego usarla y hacer checkeos
RUN apk add --no-cache curl

# Ejecutar el archivo server.py
ENTRYPOINT [ "python", "server.py", "--host", "0.0.0.0", "--port", "6062" ]