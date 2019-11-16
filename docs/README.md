# Electrónica Digital - 2019-2 - Grupo 02

* Javier Andres Africano Pachon - NIT: 1193381320
* David Miguel Garcia Palacios - NIT: 1001315936

***

# TRABAJO 02 - CAPTURA DE DATOS

Esta semana se realiza la creacion del modulo de captura de captura de datos, se realizan los cambios pertinentes para cambios pertinentes de la PLL, y se prueba los cambios de FPGA de Spartan 6 a Artix 7, y los cambio de dimension en el guardado de memoria y en la proyeccion en pantalla.

## Adaptacion y Alteraciones
Se tiene en cuanta las limitaciones en la capacidad de la memoria RAM descritas en la ultima practica. Asi que se decide configurar el proyecto para la FPGA Nexys 4, y se decide ajustar la pantalla a dimensiones (320x240). Para este proceso se cambian los parametros tanto en Test Cam, como en en en Buffer Ram.

* parameter CAM_SCREEN_X = 320;
* parameter CAM_SCREEN_Y = 240;
* DW = 8;
* AW = 17;

Una vez realizados los cambios en la configuracion de las dimensiones, se pasa a analizar la entrada de las señales de captura:

![alt text](https://raw.githubusercontent.com/unal-edigital1-2019-2/work02-captura-datos-0v7670-grupo-02/master/docs/figs/Se%C3%B1ales.png)

Nos dimos cuenta de que era necesario que con las señales actuales, la camara funciona como su proposito principal, hace falata añadir una nueva señal para indicar en que momento tomar una captura de fotografia, siendo asi, se decide añadir un poton con una señal de entrada llamada CBtn. La cual sera accionada como un pulsador, y le indicara al modulo de captura en que momento tomar una nueva captura de imagen.

## Modulo de captura
Para la realizacion del modulo de captura, se decidio pensar en este como una maquina de estados algoritmicos para comenzar a diseñarlos. La principal limitacion que notamos en el desarrolllo fue que el proceso debia sincornizarse corrrectamente con PCLK, ya que de este clok dependia la captura de los datos, y se debia sincronizar cualquier cambio utileizando el posedge.

![alt text](https://raw.githubusercontent.com/unal-edigital1-2019-2/work02-captura-datos-0v7670-grupo-02/master/docs/figs/Diagrama.jpeg)

Inicamos creando un mapa de flujo que describa el comportamiento del modulo, que se puede resumir de la siguiente manera: El modulo espera a que el usuario presione CBtn para luego prepararse para la captura en el proximo Vsync, una vez Vsync este en alto se encarga de resetear el addres. A partir de ese punto este se mantendra en espera hasta que Href se encuentre en alto, llevandolo a dos estados en bucle que son los encargados de realizar la captura y enviar a memoria. Este ciclo se repite hasta que Vsync este nuevamente en alto.

La idea funcional de CBtn que se tiene pensada, es que con pulsar el boton este realize una captura rapida, sin embargo si este se mantiene presionado este deberia poder actualizar constantemente la imagen mostrando video en pantalla.

![alt text](https://raw.githubusercontent.com/unal-edigital1-2019-2/work02-captura-datos-0v7670-grupo-02/master/docs/figs/Diagrama2.jpeg)

A partir del mapa de flujo nos dimos cuenta de que el modulo fisicamente requeriria de un regitro con escritura serial para el almacenamiento de datos, el cual se le debia indicar cuando captruar los datos de rojo y verde, y cuando capturar los datos de azul. Igualmente se necesitaria de un contador para el addres, con una señal para añadir 1, y una señal para resetar el contador. Tambien notamos que podria necesitarse un registro para regwrite, sin embargo, este podia ser manejado directamente desde la UC de manera combinacional. Aunque estos componentes no es necesario añadirlos estructuralmente gracias al lenguaje de verilog, consideramos pertinente reconocer como podria ser modelado estructuralmente el modulo.

Realizamos el grafico de estados con un mapa de More para la Unicad de Control, y obtuvimos seis estados diferentes, asi que con un registro de tres bits,bastaria para almacenar el estado actual.

![alt text](https://raw.githubusercontent.com/unal-edigital1-2019-2/work02-captura-datos-0v7670-grupo-02/master/docs/figs/Diagrama%20de%20estados.png)

Siendo asi, decidmos relizar la estructura del modulo como un conjunto de dos switch dentro de un unico always posedge, para que la primera parte se encargue de ajustar el estado de la UC, y el segundo, ejecutar los procesos que indica el estado actual. De utilizar un unico switch, la ejecucion se retrasaria un ciclo de reloj.

	always@(posedge PCLK) begin
     //Unidad de Control
		case(state)
			0: begin //Inactivo
			if (CBtn)	state <= 1;
			end
			1: begin //Iniciado
			if (VSYNC)	state <= 2;
			end
			2: begin //Reset
			if (~VSYNC)	state <= 3;
			end
			3: begin //Prepare
			if (VSYNC)	state <= 0;
			if (HREF)	state <= 4;
			end
			4: begin //Captura 1
			if (HREF)	state <= 5;
			else			state <= 3;
			end
			5: begin //Captura 2
			if (HREF)	state <= 4;
			else			state <= 3;
			end
		endcase
		//Ejecucion de Control
		case(state)
			2: begin //RESET
			addr <= 17'b111111111111111;
			end
			4: begin //CAPTURA 1
			regwrite <= 0;
			addr <= addr+1;
			data [7:2] <= {D[7:5],D[2:0]};
			end
			5: begin //CAPTURA 2;
			data [1:0] <= D[4:3];
			regwrite <= 1;
			end
			default: begin//DEFAULT
			regwrite <= 0;
			end
		endcase
	end

## Ajuste de PLL
Para ajustar el nuevo PLL se debe tener en cuenta que el PLL a ser usado debe tener como entrada 100MHz de frecuencia (Reloj de la Nexys 4), siendo asi debimos crerar un nuevo PLL utilizando la herramineta de core generator. Para esto tuvimos en cuenta los siguientes parametros:

* FPGA Artix 7
* Lenguaje Verilog
* Clock Global
* Entrada de 100MHz
* Salidas de 25MHz y 24MHz
* Ciclo util del 50%

Una vez creado el modulo desde un poryecto externo, copiamos el archivo .V a la carpeta de PLL, y reemplazamos pore el antiguo, sin la nacesidad de tener que asignar nuevas entradas o salidas.

## Simulacion

Para probar brevemente el comportamiento del modulo de captura, se creo un testbench sobre el archivo Capturador_DD.V y se le pidio realizar la simulacion, utilizando señales simuladas para las entradas. Se decidio probar usando unicamente un arreglo de 4x4 bits, con datos de entrada que i an aumentando de a 1 por cada dos ciclos de reloj.

Despues de realizar arreglos pertinentes, se obtiene una simulacion exitosa enviando los datos correspondientes de ROJO VERDE Y AZUL en formato 332, hacia la salida, con un regwread correctamente sincronizado al PCLK.

![alt text](https://raw.githubusercontent.com/unal-edigital1-2019-2/work02-captura-datos-0v7670-grupo-02/master/docs/figs/Testbench.png)

Se puede apreciar como antes de CBtn las señales de salida se mantienen constantes, y luego de el primer Vsync, este comienza a capturar los datos, con addresses correctos. La testbench se encuentra incluida dentos de src.

## Testeo pantalla
Para el testeo de pantalla se decidio cambiar no solamente a una pantalla monocolor, sino utilizar un archivo image men que contuviera las tres principales gamas de color, y blanco. Con ayuda de una programacion sencilla por c++ se creo una archivo de texto que repitiera un patron de 20 pixeles rojo, 20 verde, 20 azul y 20 blanco hasta llenar toda la matriz de (350x240). Para cada color se uso el siguiente codigo en hexadecimal:

* Blanco => FF
* Rojo => E0
* Verde => 1C
* Azul => 03

Los resultados depues de algunos ajustes con ensayo y error fueron los esperados, logramos que en la pantalla se proyectara adecuadamente sin pixeles corridos visibles en ningun punto. Vale la pena decir que curiosamente el resto de la pantalla parece adoptar el color del primer pixel de la memoria.

![alt text](https://raw.githubusercontent.com/unal-edigital1-2019-2/work02-captura-datos-0v7670-grupo-02/master/docs/figs/Pantalla1.jpg)

## Respuestas Cortas
* **Realizar el test de la pantalla. Programar la FPGA con el bitstream del proyecto y no conectar la cámara. ¿Qué espera visualizar?, ¿Es correcto este resultado ?**

Se esperaba que cambiando el archvo image, y llenarlo correctamente se visualizaran las barras de color. El resultado fue exitoso como se puede visualizar en la imagen del punto: Testeo de pantalla.

* **¿Qué falta implementar para tener el control de la toma de fotos ?**

Hacia falta implementar un boton de captura. Decidimos implementarlo en el modulo de captura bajo el nombre de CBtn. Todo el desarrollo de los avances fue realizado teniendo en cuenta la señal de captura.

**Le agradecemos por tormarse la molestia de leer el documento completo :D**

