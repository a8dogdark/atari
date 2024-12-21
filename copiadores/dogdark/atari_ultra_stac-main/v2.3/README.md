# CONVERSOR DE ARCHIVOS XEX A CASETTE PARA COMPUTADORAS ATARI
# MODELOS 800XL - 65XE - 130XE - 256K
En esta nueva versión, se han mejorado muchos aspectos relación a lo que ya había.
#
07-03-2020 - Willysoft mejora la selección de opción de sistema donde se debía ingresar a través de un *, ahora solo debes presionar la tecla "OPTION", para cambiar el sistema y velocidad de grabación a cinta.
#
09-03-2020 Se cambia formato de ultimo byte en bloque 001 y se regula bytes faltantes, bug que se generaba en la versión anterior.
#
10-03-2020 Se realiza cambio a la validación de el byte de 256k.
#
15-03-2020 se modifica valor B00800 = $0457  	;TIMER  800 BPS, a B00800 = $0458  	;TIMER  800 BPS, error de byte de velocidad
