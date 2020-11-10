package aima.gui.sudoku.csp;


import java.lang.reflect.Array;

import aima.core.search.csp.Assignment;
import aima.core.search.csp.CSP;
import aima.core.search.csp.CSPStateListener;
import aima.core.search.csp.ImprovedBacktrackingStrategy;
import aima.core.search.csp.SolutionStrategy;

public class SudokuApp {
	public static void main(String[] args) {
		Sudoku []easy = Sudoku.listaSudokus2("easy50.txt");
		Sudoku []top = Sudoku.listaSudokus2("top95.txt");
		Sudoku []hard = Sudoku.listaSudokus2("hardest.txt");
		
		Sudoku []lista = union(easy, union(top, hard));
		
		int solucionados = 0;
		
		for(Sudoku i : lista) {
			i.imprimeSudoku();
			System.out.println("SUDOKU INCOMPLETO - Resolviendo");
			
			CSP sudoku = new SudokuProblem(i.pack_celdasAsignadas());
			StepCounter stepCounter = new StepCounter();
			SolutionStrategy solver;

			solver = new ImprovedBacktrackingStrategy(true, true, true, true);
			solver.addCSPStateListener(stepCounter);
			stepCounter.reset();
			double start= System.currentTimeMillis();
			Assignment acciones = solver.solve(sudoku.copyDomains());
			double end= System.currentTimeMillis();
			System.out.println(acciones);
			System.out.println("Time to solve = "+ (end -start)/1000 + " segundos" );
			
			Sudoku solucion = new Sudoku(acciones);
			solucion.asigna_correccion();
			if(solucion.correcto()) {
				System.out.println("SOLUCION:");
				solucion.imprimeSudoku();
				solucionados++;
			}else {
				System.out.println("No hay solucion");
			}
			System.out.println("+++++++++++");
		}
		
		System.out.println("Numero sudokus solucionados: " + Integer.toString(solucionados));
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
	
	private static Sudoku[] union(Sudoku[] s1, Sudoku[] s2) {
        int len1 = s1.length;
        int len2 = s2.length;

        Sudoku[] sudoku = (Sudoku[]) Array.newInstance(s1.getClass().getComponentType(), len1 + len2);
        System.arraycopy(s1, 0, sudoku, 0, len1);
        System.arraycopy(s2, 0, sudoku, len1, len2);

        return sudoku;
    }
}
