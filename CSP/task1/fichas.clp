;;;
;	MODULO MAIN
;;;
(defmodule MAIN
	(export deftemplate nodo)
)

(deftemplate nodo
	(multislot estado)
	(multislot camino)
	(slot heuristica)
	(slot coste)
	(slot clase (default abierto))
)

(defglobal MAIN?*estado-inicial* = (create$ B B B H V V V))

;
;	MODULO MAIN::OPERACIONES
;
(defmodule OPERACIONES
	(import MAINT deftemplate node)
)

(defrule MH1I
	(nodo	(estado $?a ?f1 H $?c)
			(camino $?movimientos)
			(heuristica ?h)
			(coste ?coste)
			(clase ?clase)
	)
	=>
	(bind $?nuevo-estado (create$ $?a H ?b $?c))
	(assert nodo	(estado $?nuevo-estado)
					(camino $?movimientos ^)
					(heuristica ?h)
					(coste ?coste+1)
					(clase ?clase)
	)
)

(defrule MH2I
	(nodo	(estado $?a ?f1 ?f2 H $?c)
			(camino $?movimientos)
			(heuristica ?h)
			(coste ?coste)
			(clase ?clase)
	)
	=>
	(bind $?nuevo-estado (create$ $?a H ?f1 ?f2 $?c))
	(assert nodo	(estado $?nuevo-estado)
					(camino $?movimientos ^)
					(heuristica ?h)
					(coste ?coste+1)
					(clase ?clase)
	)
)

(defrule MH3I
	(nodo	(estado $?a ?f1 ?f2 ?f3 H $?c)
			(camino $?movimientos)
			(heuristica ?h)
			(coste ?coste)
			(clase ?clase)
	)
	=>
	(bind $?nuevo-estado (create$ $?a H ?f1 ?f2 ?f3 $?c))
	(assert nodo	(estado $?nuevo-estado)
					(camino $?movimientos ^)
					(heuristica ?h)
					(coste ?coste+1)
					(clase ?clase)
	)
)


(defrule MH1D
	(nodo	(estado $?a ?H f1 $?c)
			(camino $?movimientos)
			(heuristica ?h)
			(coste ?coste)
			(clase ?clase)
	)
	=>
	(bind $?nuevo-estado (create$ $?a ?b H $?c))
	(assert nodo	(estado $?nuevo-estado)
					(camino $?movimientos ^)
					(heuristica ?h)
					(coste ?coste+1)
					(clase ?clase)
	)
)

(defrule MH2D
	(nodo	(estado $?a H ?f1 ?f2 $?c)
			(camino $?movimientos)
			(heuristica ?h)
			(coste ?coste)
			(clase ?clase)
	)
	=>
	(bind $?nuevo-estado (create$ $?a ?f1 ?f2 H $?c))
	(assert nodo	(estado $?nuevo-estado)
					(camino $?movimientos ^)
					(heuristica ?h)
					(coste ?coste+1)
					(clase ?clase)
	)
)

(defrule MH3D
	(nodo	(estado $?a H ?f1 ?f2 ?f3 $?c)
			(camino $?movimientos)
			(heuristica ?h)
			(coste ?coste)
			(clase ?clase)
	)
	=>
	(bind $?nuevo-estado (create$ $?a ?f1 ?f2 ?f3 H $?c))
	(assert nodo	(estado $?nuevo-estado)
					(camino $?movimientos ^)
					(heuristica ?h)
					(coste ?coste+1)
					(clase ?clase)
	)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;    MODULO MAIN::SOLUCION        ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmodule SOLUCION
   (import MAIN deftemplate nodo)
)

(defrule SOLUCION::reconoce-solucion
   (declare (auto-focus TRUE))
   ?nodo <- (nodo (estado  V V V H B B B B)
               (camino $?movimientos))
 => 
   (retract ?nodo)
   (assert (solucion $?movimientos)))

(defrule SOLUCION::escribe-solucion
   (solucion $?movimientos)
  =>
   (printout t "Solucion:" $?movimientos crlf)
   (halt))
