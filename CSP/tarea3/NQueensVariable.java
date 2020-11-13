package aima.gui.nqueens.csp;

import aima.core.search.csp.Variable;

public class NQueensVariable extends Variable {
	private int valor;
	private int coordX;
	public NQueensVariable(String name, int X) {
		super(name);
		coordX = X;
		valor = 0;
	}
	
	public int getX() {
		return coordX;
	}

	public int getValue() {
		return valor;
	}

	public void setValue(int value) {
		valor = value;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result + coordX;
		result = prime * result + valor;
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (!super.equals(obj))
			return false;
		if (getClass() != obj.getClass())
			return false;
		NQueensVariable other = (NQueensVariable) obj;
		if (coordX != other.coordX)
			return false;
		if (valor != other.valor)
			return false;
		return true;
	}
	

}
