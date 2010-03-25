/*
*************************************************************************

Vectron - map editor for Armagetron Advanced.
Copyright (C) 2010 Carlo Veneziano (carlorfeo@gmail.com)

**************************************************************************

This file is part of Vectron.

Vectron is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Vectron is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Vectron.  If not, see <http://www.gnu.org/licenses/>.

*/

package
{
	import flash.display.Sprite;

	import orfaust.Debug;

	public class AamapObject extends Sprite implements AamapObjectInterface
	{
		protected var _area:Sprite;
		protected const SIZE_SELECTED = 8;
		protected const COLOR_SELECTED = 255;

		public function AamapObject():void
		{
			_area = new Sprite;
			_area.alpha = 0;
			addChild(_area);
		}

		public function render():void
		{
			
		}

		public function get selected():Boolean
		{
			return _area.alpha != 0;
		}
		public function set selected(state:Boolean):void
		{
			_area.alpha = int(state) * .5;
		}
	}
}