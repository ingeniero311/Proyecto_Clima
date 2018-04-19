# Proyecto_Clima
Proyecto de Clima

Este proyecto maneja la base de datos hecha en SQLite Maestro, y gestionada por LiteDAC en Embarcadero bajo el lenguaje Pascal en Delphi 10.2.
el apk, se llama clima.apk.

El modo de funcionamiento es, cuando inicia se abre una notificacion en la barra superior, y carga un listado de algunas ciudades al costado izquierdo, cuando se selecciona la ciudad, implementa la api del clima, en http://www.mywonderland.es/curso_js/json/json_api.html, donde optenemos los datos de latitud, longitud y temperatura entre otras, luego de tomar esos datos, se emplea la api de google maps, y se carga la ciudad en el mapa, por otra parte al lado derecho se crea un nuevo registro en la base de datos, y cuando se selecciona el registro derecho y se oprime el boton de informacion, muestra en una ventana la informacion del registro.
