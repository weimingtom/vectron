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
	import flash.display.SimpleButton;
	import flash.geom.Point;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import orfaust.Debug;
	import orfaust.CustomEvent;

	public class ToolSpawn extends ToolBase implements ToolInterface
	{
		private var _spawn:Spawn;
		private var _a:Point;
		private var _b:Point;

		override protected function mouseDown(mouse:Point,keys:Object):void
		{
			if(_spawn != null)
			{
				error('newzone != null');
				return;
			}

			_a = mouse;
			_spawn = new Spawn(_aamap,null,_a);
			dispatchEvent(new CustomEvent('ADD_EDITING_OBJECT',_spawn));
		}
		override protected function mouseUp(mouse:Point,keys:Object):void
		{
			close();
		}
		override protected function mouseMove(mouse:Point,keys:Object):void
		{
			if(!_mouseDown)
				return;

			if(_spawn == null)
			{
				error('mouseDown but _spawn == null');
				return;
			}

			_b = mouse;

			_spawn.moveCenter(_a);
		}

		// CLOSE
		override public function close():void
		{
			if(_spawn == null)
				return;

			_mouseDown = false;
			dispatchEvent(new Event('EDITING_OBJECT_COMPLETE'));
			_spawn = null;
		}
	}
}