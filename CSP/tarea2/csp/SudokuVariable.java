package aima.gui.sudoku.csp;

import aima.core.search.csp.Variable;
import aima.core.util.datastructure.XYLocation;

public class SudokuVariable extends Variable {
	private int valor;
	private XYLocation loc;
	public SudokuVariable(String name, int X, int Y) {
		super(name);
		loc = new XYLocation(X, Y);
		valor = 0;
	}
	
	public int getX() {
		return loc.getXCoOrdinate();
	}
	
	public int getY() {
		return loc.getYCoOrdinate();
	}

	public int getValue() {
		return valor;
	}

	public void setValue(int value) {
		valor = value;
	}

	@Override
	public int hashCode() {
		return loc.hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		if(obj == null) {
			return false;
		}
		if(obj.getClass() == getClass()) {
			return this.loc.equals(((SudokuVariable) obj).loc);
		}
		return false;
	}

	
}
