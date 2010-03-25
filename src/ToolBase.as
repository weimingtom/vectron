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
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import orfaust.Debug;

	public class ToolBase extends SimpleButton implements ToolInterface
	{
		protected var _mouseDown:Boolean = false;

		public function handleMouse(e:MouseEvent,aamap:Aamap):void
		{
			var X = aamap.mouseX;
			var Y = aamap.mouseY;
			
			var mouse = new Point(X,Y);
			var func:Function;

			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					_mouseDown = true;
					func = mouseDown;
					break;

				case MouseEvent.MOUSE_UP:
					_mouseDown = false;
					func = mouseUp;
					break;

				case MouseEvent.MOUSE_MOVE:
					func = mouseMove;
					break;
			}

			var keys:Object =
			{
				ctrl:e.ctrlKey,
				alt:e.altKey,
				shift:e.shiftKey
			}

			func(mouse,keys);
		}

		protected function mouseDown(mouse:Point,keys:Object):void
		{
			forceOverride('mouseDown()');
		}
		protected function mouseUp(mouse:Point,keys:Object):void
		{
			forceOverride('mouseUp()');
		}
		protected function mouseMove(mouse:Point,keys:Object):void
		{
			forceOverride('mouseMove()');
		}

		public function close():void
		{
			forceOverride('close()');
		}


/* utils */

		protected function pointsEqual(a:Point,b:Point):Boolean
		{
			return a.x == b.x && a.y == b.y;
		}

		protected function getDistance(a:Point,b:Point):Number
		{
			var xDist = a.x - b.x;
			var yDist = a.y - b.y;

			return Math.sqrt(xDist * xDist + yDist * yDist);
		}



/* errors */

		protected function forceOverride(f:String):void
		{
			error(f + ' should be overridden');
		}
		protected function error(e:String):void
		{
			throw new Error(e);
		}

	}
}