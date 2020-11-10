;===========================
;		MODULO MAIN			
;===========================
(defmodule MAIN
	(export deftemplate nodo)
	(export deffunction heuristica)
)

(deftemplate nodo
	(multislot estado)
	(multislot camino)
	(slot heuristica)
	(slot coste (default 0))
	(slot clase (default abierto))
)

(defglobal MAIN
	?*estado-inicial* = (create$ B B B H V V V)
	?*estado-final* = (create$ V V V H B B B)
)

(deffunction MAIN::heuristica ($?estado)
	(bind ?res 0)
	(loop-for-count (?i 1 7)
		(if (neq (nth ?i $?estado)
				 (nth ?i ?*estado-final*)
			)
		then (bind ?res (+ ?res 1))
		)
	)
	?res
)

;===================================
;		MODULO MAIN::INICIAL		
;===================================
(deffacts nodoInicial
	(nodo	(estado ?*estado-inicial*)
			(camino)
			(heuristica (heuristica ?*estado-inicial*))
			(clase abierto)
	)
)


;=======================================
;		MODULO MAIN:CONTROL A*			
;=======================================


(defrule MAIN::pasa-el-mejor-a-cerrado
	?nodo <- (nodo	(heuristica ?h1)
					(coste ?c1)
					(clase abierto)
			)
	(not (nodo (clase abierto)
			(heuristica ?h2)
			(coste ?c2&:(< (+ ?c2 ?h2) (+ ?c1 ?h1)))
	     )
	)
	=>
	(modify ?nodo (clase cerrado))
	(focus OPERADORES)
)

;===============================
;		MODULO OPERADORES		
;===============================
(defmodule OPERADORES
	(import MAIN deftemplate nodo)
	(import MAIN deffunction heuristica)
)

(defrule OPERADORES::MH1I
	(nodo	(estado $?a ?f1 H $?c)
			(camino $?movimientos)
			(coste ?coste)
			(clase cerrado)
	)
	=>
	(bind $?nuevo-estado (create$ $?a H ?f1 $?c))
	(assert (nodo	(estado $?nuevo-estado)
					(camino $?movimientos I1)
					(heuristica (heuristica $?nuevo-estado))
					(coste (+ ?coste 1))
			)
	)
)

(defrule OPERADORES::MH2I
	(nodo	(estado $?a ?f1 ?f2 H $?c)
			(camino $?movimientos)
			(coste ?coste)
			(clase cerrado)
	)
	=>
	(bind $?nuevo-estado (create$ $?a H ?f2 ?f1 $?c))
	(assert (nodo	(estado $?nuevo-estado)
					(camino $?movimientos I2)
					(heuristica (heuristica $?nuevo-estado))
					(coste (+ ?coste 2))
			)
	)
)

(defrule OPERADORES::MH3I
	(nodo	(estado $?a ?f1 ?f2 ?f3 H $?c)
			(camino $?movimientos)
			(coste ?coste)
			(clase cerrado)
	)
	=>
	(bind $?nuevo-estado (create$ $?a H ?f2 ?f3 ?f1 $?c))
	(assert (nodo	(estado $?nuevo-estado)
					(camino $?movimientos I3)
					(heuristica (heuristica $?nuevo-estado))
					(coste (+ ?coste 3))
			)
	)
)


(defrule OPERADORES::MH1D
	(nodo	(estado $?a H ?f1 $?c)
			(camino $?movimientos)
			(coste ?coste)
			(clase cerrado)
	)
	=>
	(bind $?nuevo-estado (create$ $?a ?f1 H $?c))
	(assert (nodo	(estado $?nuevo-estado)
					(camino $?movimientos D1)
					(heuristica (heuristica $?nuevo-estado))
					(coste (+ ?coste 1))
			)
	)
)

(defrule OPERADORES::MH2D
	(nodo	(estado $?a H ?f1 ?f2 $?c)
			(camino $?movimientos)
			(coste ?coste)
			(clase cerrado))
	=>
	(bind $?nuevo-estado (create$ $?a ?f2 ?f1 H $?c))
	(assert (nodo	(estado $?nuevo-estado)
					(camino $?movimientos D2)
					(heuristica (heuristica $?nuevo-estado))
					(coste (+ ?coste 2))
			)
	)
)

(defrule OPERADORES::MH3D
	(nodo	(estado $?a H ?f1 ?f2 ?f3 $?c)
			(camino $?movimientos)
			(coste ?coste)
			(clase cerrado)
	)
	=>
	(bind $?nuevo-estado (create$ $?a ?f3 ?f1 ?f2 H $?c))
	(assert (nodo	(estado $?nuevo-estado)
					(camino $?movimientos D3)
					(heuristica (heuristica $?nuevo-estado))
					(coste (+ ?coste 3))
			)
	)
)

;===================================
;		MODULO RESTRICCIONES		
;===================================
(defmodule RESTRICCIONES
	(import MAIN deftemplate nodo)
)

(defrule RESTRICCIONES::repeticiones-de-nodo
	(declare (auto-focus TRUE))
	?nodo1 <-	(nodo (estado ?estado)
					(camino $?camino1)
				)
	(nodo	(estado ?estado)
			(camino $?camino2&:	(>	(length$ ?camino1)
									(length$ ?camino2)
								)
			)
	)
	=>
   (retract ?nodo1)
)


;===============================
;		MODULO SOLUCION			
;===============================

(defmodule SOLUCION
   (import MAIN deftemplate nodo)
)

(defrule SOLUCION::reconoce-solucion
   (declare (auto-focus TRUE))
   ?nodo <- (nodo (heuristica 0)
               (camino $?movimientos))
	=> 
   (retract ?nodo)
   (assert (solucion $?movimientos)))

(defrule SOLUCION::escribe-solucion
   (solucion $?movimientos)
 	=>
   (printout t "Solucion:" $?movimientos crlf)
   (halt))
