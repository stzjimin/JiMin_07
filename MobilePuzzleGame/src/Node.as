package
{
	public class Node
	{
		private var _cell:Cell;
		private var _f:Number;
		private var _g:Number;
		private var _h:Number;
		
		public function Node()
		{
		}

		public function get cell():Cell
		{
			return _cell;
		}

		public function set cell(value:Cell):void
		{
			_cell = value;
		}

		public function get f():Number
		{
			return _f;
		}

		public function set f(value:Number):void
		{
			_f = value;
		}

		public function get g():Number
		{
			return _g;
		}

		public function set g(value:Number):void
		{
			_g = value;
		}

		public function get h():Number
		{
			return _h;
		}

		public function set h(value:Number):void
		{
			_h = value;
		}


	}
}