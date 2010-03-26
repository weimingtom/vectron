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
	import orfaust.containers.List;

	public class ToolSelect extends ToolBase implements ToolInterface
	{
		private var _dragStart:Point;
		private var _selected:List;

		override protected function mouseDown(mouse:Point,keys:Object):void
		{
			
		}
		override protected function mouseUp(mouse:Point,keys:Object):void
		{
			_dragStart = null;
		}
		override protected function mouseMove(mouse:Point,keys:Object):void
		{
			if(_dragStart == null)
				return;

			var it = _selected.iterator;

			// move each selected objects
			while(!it.end)
			{
				var obj = it.data;
				var lastPos = obj.lastPos;

				obj.x = lastPos.x + mouse.x - _dragStart.x;
				obj.y = lastPos.y + mouse.y - _dragStart.y;

				it.next();
			}
		}

		override protected function objectMouseDown(obj:AamapObject,cursor:Point,keys:Object):void
		{
			// dragging the map?
			if(keys.ctrl)
				return;

			_dragStart = new Point(cursor.x,cursor.y);

			if(_selected == null)
			{
				_selected = new List;
				_selected.push(obj);
				obj.selected = true;
				obj.dragStart();
			}
			else
			{
				if(keys.shift)
				{
					if(_selected.find(obj))
					{
						_selected.remove(obj);
						obj.selected = false;
						_dragStart = null;
						if(_selected.length == 0)
							_selected = null;
					}
					else
					{
						_selected.push(obj);
						obj.selected = true;
					}
				}
				else
				{
					if(_selected.find(obj))
					{
						
					}
					else
					{
						var it = _selected.iterator;
						while(!it.end)
						{
							it.data.selected = false;
							it.next();
						}
						_selected = new List;
						_selected.push(obj);
						obj.selected = true;
						obj.dragStart();
					}
				}

				if(_selected != null)
				{
					it = _selected.iterator;
					while(!it.end)
					{
						it.data.dragStart();
						it.next();
					}
				}
			}
		}

		override protected function objectMouseUp(obj:AamapObject,cursor:Point,keys:Object):void
		{
		}

		override protected function objectMouseMove(obj:AamapObject,cursor:Point,keys:Object):void
		{
		}


		// CLOSE
		override public function close():void
		{
		}
	}
}