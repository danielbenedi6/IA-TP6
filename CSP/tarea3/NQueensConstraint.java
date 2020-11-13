package aima.gui.nqueens.csp;

import java.util.List;

import aima.core.search.csp.Assignment;
import aima.core.search.csp.Constraint;
import aima.core.search.csp.Variable;

public class NQueensConstraint implements Constraint{
	NQueensVariable lhs, rhs;
	
	public NQueensConstraint(Variable lhs, Variable rhs) {
		this.lhs = (NQueensVariable) lhs;
		this.rhs = (NQueensVariable) rhs;
	}
	
	public List<Variable> getScope(){		
		return List.of(lhs, rhs);
	}

	private boolean mismaFila(int left, int right) {
		return left == right;
	}
	
	private boolean mismaDiagonal(int left, int right) {
		return 	Math.abs(lhs.getX() - rhs.getX() ) == Math.abs( left - right );
	}
	
	private boolean mismaColumna(NQueensVariable left, NQueensVariable right) {
		return left.getX() == right.getX();
	}
	
	public boolean isSatisfiedWith(Assignment assignment) {
		Integer value1 = (int) assignment.getAssignment(lhs);
		Integer value2 = (int) assignment.getAssignment(rhs);
		
		if( value1 == null || value2 == null ) {
			return false;
		}else {
			return !mismaFila(value1, value2) && !mismaDiagonal(value1, value2) && !mismaColumna(lhs, rhs);
		}
	}
}
