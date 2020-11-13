package aima.gui.nqueens.csp;

import java.util.ArrayList;
import java.util.List;

import aima.core.search.csp.CSP;
import aima.core.search.csp.Domain;
import aima.core.search.csp.Variable;

public class NQueensProblem extends CSP {
    private int size = 8;
    private List<Variable> variables = null;
    
    /**
    *
    * @return Devuelve la lista de variables del NQueens. 
    * 			Inicializa las variables de CSP
    *         Nombre Cell at [i], y coordenada i
    */
    private List<Variable> collectVariables() {
        variables = new ArrayList<Variable>();
        for (int i = 0; i < size; i++) {
        	variables.add(new NQueensVariable("Cell at [" + i + "]", i));
        	addVariable(new NQueensVariable("Cell at [" + i + "]", i));
        }
        return variables;
   }
   
  /**
   * Define como un CSP. Define variables, sus dominios y restricciones.
   * @param pack
   */
	public NQueensProblem(int size) {
		//variables
		super();
		this.size = size;
		collectVariables();

		List<Integer> options = new ArrayList<Integer>();
		for (int i=0;i<size;i++) {
			options.add(i);
		}
		
		//Define dominios de variables
		Domain domain = new Domain(options);
		for (Variable var : getVariables()) {
			setDomain(var, domain);
		}
		//restricciones
		doConstraint();
	}
  
	private void doConstraint() {
		for(int i = 0; i < this.size; i++)
			for(int j = i+1; j < this.size; j++)
				addConstraint(new NQueensConstraint(variables.get(i), variables.get(j)));
	}
}
