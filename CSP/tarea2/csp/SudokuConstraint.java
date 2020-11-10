package aima.gui.sudoku.csp;

import java.util.List;

import aima.core.search.csp.Assignment;
import aima.core.search.csp.Constraint;
import aima.core.search.csp.Variable;

public class SudokuConstraint implements Constraint{
	Variable lhs, rhs;
	
	public SudokuConstraint(Variable lhs, Variable rhs) {
		this.lhs = lhs;
		this.rhs = rhs;
	}
	
	public List<Variable> getScope(){		
		return List.of(lhs, rhs);
	}
	
	public boolean isSatisfiedWith(Assignment assignment) {
		Object value1 = assignment.getAssignment(lhs);
		return value1 == null || !value1.equals(assignment.getAssignment(rhs));
	}
}
