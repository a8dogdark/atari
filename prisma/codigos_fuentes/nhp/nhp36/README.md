# code-nhp36-by-parche-negro
-Código assembler copiador nhp 3.6 by parche negro soft
-Copiador desamblado por Dogdark 2019
-Código bajo mads
-Este copiador fue uno de los más utilizados en Chile en los años 80 y 90 en distribución de ventas de juegos en casetes, Programado por Parche Negro Soft a fines de los años 80.
-Trabaja en dos sistemas de baudios, primera carga se realiza en 4 bloques de inicio, trabajando en 600 baudios, los primeros 3 contienen información de mini portada y el 4 que es la data para la cantidad de bytes a cargar el loader.
-Loader, contiene la data de la portada y la carga en memoria del juego para el atari.
Funciona tanto en los atari 65xe como en los 130xe, pero tiene un déficit, no se pueden cargar juegos superiores a 128 bloques de disco, o si no se produce un bucleo y no carga el juego a posterior.
Creado exclusivamente para atari 130xe, este copiador trabaja en dos sistemas, como ya mencionado anteriormente, desde loader hacia adelante, al elegir la opción “TURBO” dentro del título principal, este cambia la velocidad de carga en casette pasando a 961 baudios. 
