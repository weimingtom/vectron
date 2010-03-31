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
		private var _wallHeight:Number;

		public var defaultHeight = 0;

		public function Wall(aamap:Aamap,xml:XML,mouse:Point,wallHeight = null):void
		{
			super(aamap,xml);

			var a = mouse;
			_points.push(a);

			if(wallHeight == null)
				_wallHeight = defaultHeight;
			else
				_wallHeight = wallHeight;
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

		public function storePoint(mouse:Point):void
		{
			_points.push(mouse);
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


		override public function initXml():XML
		{
			_xml = new XML('<Wall/>');
			updateXml();
			return _xml;
		}

		override public function updateXml():void
		{
			if(_wallHeight != 0)
				_xml.@height = _wallHeight;

			_xml.setChildren(new XML('<Point/>'));

			var it = _points.iterator;

			_xml.Point.@x = x + it.data.x;
			_xml.Point.@y = y + it.data.y;

			it.next();
			while(!it.end)
			{
				var point = new XML('<Point/>');
				point.@x = x + it.data.x;
				point.@y = y + it.data.y;
				_xml.appendChild(point);
				it.next();
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
			var jit = _points.iterator;

			graphics.lineStyle(2,0,1,false,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER);
			graphics.moveTo(jit.data.x,jit.data.y);

			jit.next();

			while(!jit.end)
			{
				graphics.lineTo(jit.data.x,jit.data.y);
				jit.next();
			}
		}

		public function get vertices():uint
		{
			return _points.length;
		}

		public function set wallHeight(val:Number):void
		{
			if(val < 0)
				_wallHeight = defaultHeight;
			else
				_wallHeight = val;
		}

		public function get wallHeight():Number
		{
			return _wallHeight;
		}
	}
}