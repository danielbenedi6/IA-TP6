;-------------------------------------------------------------
; MODULO MAIN
;-------------------------------------------------------------
(defmodule MAIN
	(export deftemplate nodo)
)

(deftemplate MAIN::nodo
	(slot estado)
	(multislot camino)
	(slot coste (default 0))
	(slot clase (default abierto))
)

(deffacts MAIN::estadoInicial
	(nodo
		(estado 1)
		(camino)
	)
)

(defrule MAIN::pasa-el-mejor-a-cerrado-CU
	?nodo <- (nodo 	(clase abierto)
					(coste ?c1)
			 )
	(not (nodo 	(clase abierto)
				(coste ?c2&:(< ?c2 ?c1))
		 )
	)
	=>
	(modify ?nodo (clase cerrado))
	(focus OPERADORES)
)


;-------------------------------------------------------------
; MODULO OPERADORES
;-------------------------------------------------------------
; Acciones andar y saktar con sus restricciones
(defmodule OPERADORES
	(import MAIN deftemplate nodo)
)

(deffunction OPERADORES::Contar-Andar ($?camino)
	(bind ?res 0)
	(loop-for-count (?i 1 (length$ $?camino))
		(if (eq (nth ?i $?camino) A)
		then (bind ?res (+ ?res 1))
		)
	)
	?res
)
(deffunction OPERADORES::Contar-Saltar ($?camino)
	(bind ?res 0)
	(loop-for-count (?i 1 (length$ $?camino))
		(if (eq (nth ?i $?camino) S)
		then (bind ?res (+ ?res 1))
		)
	)
	?res
)

(defrule OPERADORES::Andar
	(nodo
		(estado ?s&:(<= (+ ?s 1) 8))
		(camino $?camino)
		(coste ?coste)
		(clase cerrado)
	)
	=>
	(assert
		(nodo
			(estado (+ ?s 1))
			(camino $?camino A)
			(coste (+ ?coste 1))
		)
	)
)

(defrule OPERADORES::Saltar
	(nodo
		(estado ?s&:(<= (* ?s 2) 8))
		(camino $?camino&:(<= (+ (Contar-Saltar $?camino) 1) (Contar-Andar $?camino)))
		(coste ?coste)
		(clase cerrado)
	)
	=>
	(assert
		(nodo
			(estado (* ?s 2))
			(camino $?camino S)
			(coste (+ ?coste 2))
		)
	)
)


;-------------------------------------------------------------
; MODULO RESTRICCIONES
;-------------------------------------------------------------
; Nos quedamos con el nodo de menor coste
; La longitud del camino no es el coste

(defmodule RESTRICCIONES
	(import MAIN deftemplate nodo)
)

(defrule RESTRICCIONES::repeticiones-de-nodo
	(declare (auto-focus TRUE))
	?nodo <-	(nodo	(estado ?estado)
						(coste ?c1)
				)
	(nodo	(estado ?estado)
			(coste ?c2&:(< ?c2 ?c1 ))
	)
	=>
   (retract ?nodo)
)

;===============================
;		MODULO SOLUCION			
;===============================

(defmodule SOLUCION
	(import MAIN deftemplate nodo)
)

(defrule SOLUCION::reconoce-solucion
   (declare (auto-focus TRUE))
   ?nodo <- (nodo (estado 8)
               (camino $?movimientos))
	=> 
   (retract ?nodo)
   (assert (solucion $?movimientos)))

(defrule SOLUCION::escribe-solucion
     (solucion $?movimientos)
	=>
	(printout t "La solucion tiene " (-(length ?movimientos) 1)
				" pasos" crlf)
	(loop-for-count (?i 1 (length ?movimientos))
		(printout t "(" (nth ?i $?movimientos) ")" " "))
	(printout t crlf)
	(halt)
)
