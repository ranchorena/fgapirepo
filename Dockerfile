# Partir de la imagen de Python 3.10.5
FROM python:3.10.5

# Copiar la aplicación fgapi a la carpeta de trabajo
COPY ./fgapi /usr/src/app/fgapi

COPY ./requirements.txt /usr/src/app/fgapi/requirements.txt

# Editar el archivo server.py para que se ejecute en modo debug y escuche en todas las interfaces
RUN sed -i 's/app.run(debug = True, host="localhost", port=9999)/app.run(debug=True, host="0.0.0.0", port=6062)/' /usr/src/app/fgapi/server.py

# Establecer la carpeta de trabajo
WORKDIR /usr/src/app/fgapi

# Instalar dependencias de compilación necesarias para GeoAlchemy2
# RUN apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev

RUN apt-get update && apt-get install -y \
    g++ \
    gcc \
    make \
    libblas-dev \
    liblapack-dev \
    gfortran \
    python3-dev

# Instalar las dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Desinstalar dependencias de compilación
# RUN apk del .build-deps

# Exponer el puerto 6062
EXPOSE 6062

# Instalo curl pra luego usarla y hacer checkeos
RUN apt-get install -y curl

# Ejecutar el archivo server.py
ENTRYPOINT [ "python", "server.py", "--host", "0.0.0.0", "--port", "6062" ]