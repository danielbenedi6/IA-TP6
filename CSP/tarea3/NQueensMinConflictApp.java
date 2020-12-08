package aima.gui.nqueens.csp;

import aima.core.search.csp.Assignment;
import aima.core.search.csp.CSP;
import aima.core.search.csp.CSPStateListener;
import aima.core.search.csp.MinConflictsStrategy;
import aima.core.search.csp.SolutionStrategy;

public class NQueensMinConflictApp {
	public static void main(String[] args) {
				
		CSP tablero = new NQueensProblem(8);
		StepCounter stepCounter = new StepCounter();
		SolutionStrategy solver;

		solver = new MinConflictsStrategy(1000);
		solver.addCSPStateListener(stepCounter);
		stepCounter.reset();
		
		NQueens solucion = new NQueens(8);
		Assignment acciones = new Assignment();
		double start= System.currentTimeMillis();
		do {
			acciones = solver.solve(tablero.copyDomains());
			
			if(acciones != null) {
				solucion = new NQueens(8, acciones);
				//solucion.asigna_correccion();
			}
		}while(acciones != null && !solucion.correcto());
		
		double end= System.currentTimeMillis();
		System.out.println(acciones);
		System.out.println("Time to solve = "+ (end -start)/1000 + " segundos" );
		System.out.println("SOLUCION:");
		solucion.imprimeNQueens();
	}
	
		/** Counts assignment and domain changes during CSP solving. */
		protected static class StepCounter implements CSPStateListener {
			private int assignmentCount = 0;
			private int domainCount = 0;
			
			@Override
			public void stateChanged(Assignment assignment, CSP csp) {
				++assignmentCount;
			}
			
			@Override
			public void stateChanged(CSP csp) {
				++domainCount;
			}
			
			public void reset() {
				assignmentCount = 0;
				domainCount = 0;
			}
			
			public String getResults() {
				StringBuffer result = new StringBuffer();
				result.append("assignment changes: " + assignmentCount);
				if (domainCount != 0)
					result.append(", domain changes: " + domainCount);
				return result.toString();
			}
		}
}
