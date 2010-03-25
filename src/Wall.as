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
	import flash.geom.Point;

	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;

	import orfaust.Debug;
	import orfaust.containers.List;
	import orfaust.containers.Iterator;

	public class Wall extends AamapObject implements AamapObjectInterface
	{
		private var _points:List = new List;
		private var _lastSeg:Object;

		public function Wall(mouse:Point):void
		{
			var a = mouse;
			_points.push(a);
		}

		public function moveLastPoint(mouse:Point):void
		{
			if(_lastSeg)
			{
				_lastSeg.b.x = mouse.x;
				_lastSeg.b.y = mouse.y;
				renderLastSeg();
			}
			else
			{
				var p = _points.front;
				p.x = mouse.x;
				p.y = mouse.y;
			}
		}

		public function appendPoint(mouse:Point):void
		{
			var segment:Sprite = new Sprite;
			addChild(segment);

			var a = _points.back;
			var b = new Point(mouse.x,mouse.y);

			_lastSeg = {a:a,b:b,sprite:segment};
			renderLastSeg();
		}
		public function storeLastPoint():void
		{
			if(!_lastSeg)
				return;

			_points.push(_lastSeg.b);
			removeChild(_lastSeg.sprite);
			_lastSeg = null;
			render();
		}

		public function get lastPoint():Point
		{
			return _points.back;
		}

		public function renderLastSeg():void
		{
			with(_lastSeg)
			{
				sprite.graphics.clear();
				sprite.graphics.lineStyle(1,0,1,false,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER);
				sprite.graphics.moveTo(a.x,a.y);
				sprite.graphics.lineTo(b.x,b.y);
			}
		}
			override public function render():void
		{
			// draw selectable area

			var it:Iterator = _points.iterator;

			_area.graphics.clear();
			_area.graphics.lineStyle(SIZE_SELECTED,COLOR_SELECTED,1,false,LineScaleMode.NONE);
			_area.graphics.moveTo(it.data.x,it.data.y);

			it.next();

			while(!it.end)
			{
				_area.graphics.lineTo(it.data.x,it.data.y);
				it.next();
			}

			// draw visible object
			it = _points.iterator;

			graphics.lineStyle(1,0,1,false,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER);
			graphics.moveTo(it.data.x,it.data.y);

			it.next();

			while(!it.end)
			{
				graphics.lineTo(it.data.x,it.data.y);
				it.next();
			}
		}

		public function get vertices():uint
		{
			return _points.length;
		}
	}
}