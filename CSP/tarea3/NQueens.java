package aima.gui.nqueens.csp;

import aima.core.search.csp.Assignment;
import aima.core.search.csp.Variable;

public class NQueens {
	private int[] celdas;
	private int size;
	
	private boolean correcto=false;
	private boolean completo=false;
	
	public NQueens(int size){
		this.size = size;
		celdas = new int[size];
	}
	public NQueens (int size, Assignment valores){
		this.size = size;
		celdas = new int[size];
		for (Variable var : valores.getVariables()) {
			NQueensVariable v = (NQueensVariable) var;
			this.celdas[v.getX()]= (int)valores.getAssignment(v);
		}
		this.asigna_completo();
	    if (this.completo()) this.asigna_correccion();
	}
	

	public boolean correcto() {
		return correcto;
	}

	public boolean completo() {
		return completo;
	}
	
	public void asigna_completo(){
		this.completo= true;
	}

	private boolean mismaDiagonal(int i, int j) {
		return Math.abs(i-j) == Math.abs(celdas[i] - celdas[j]);
	}
	
	public void asigna_correccion(){
		int i=0;
		int j=0;
		boolean correcto = true;
		
		while(i < this.size && correcto) {
			j = i+1;
			while(j < this.size && correcto) {
				correcto = celdas[i] != celdas[j] && !mismaDiagonal(i,j);
				j++;
			}
			i++;
		}
		
		this.correcto = correcto;
	}
	
	public void imprimeNQueens(){
		for (int i=0; i<size; i++){
			for (int j=0;j<size; j++){
				if (this.celdas[j]!=i) System.out.print("-");
				else System.out.print("Q");
			}
			System.out.println();
		}
	}
}
