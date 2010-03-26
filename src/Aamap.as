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
	import flash.display.Graphics;

	import flash.geom.Point;

	import flash.events.MouseEvent;

	import orfaust.Debug;
	import orfaust.CustomEvent;

	public class Aamap extends Base
	{
		private var _xml:XML;
		private var _editing:Sprite;

		public function Aamap(xml:String = null):void
		{
			if(xml != null)
			{
				_xml = new XML(xml);
				createObjects();
			}

			_editing = new Sprite;
			addChild(_editing);
		}
		public function get editing():Sprite
		{
			return _editing;
		}

		override protected function init():void
		{
		}





/* events */

		private function objectRollOver(e:MouseEvent):void
		{
			dispatchEvent(new CustomEvent('OBJECT_ROLL_OVER',e.target));
		}

		private function objectRollOut(e:MouseEvent):void
		{
			dispatchEvent(new CustomEvent('OBJECT_ROLL_OUT',e.target));
		}

		/*
		private function objectClick(e:MouseEvent):void
		{
			var obj = e.target.parent;
			dispatchEvent(new CustomEvent('OBJECT_CLICK',obj));
		}

		private function objectDrag(e:MouseEvent):void
		{
			var obj = e.target.parent;
			if(e.type == MouseEvent.MOUSE_DOWN)
				dispatchEvent(new CustomEvent('OBJECT_DRAG_START',obj));
			else
				dispatchEvent(new CustomEvent('OBJECT_DRAG_STOP',obj));
		}
		*/



/* objects creation */

		public function addObject(obj:AamapObject):void
		{
			addChild(obj);
			obj.addEventListener(MouseEvent.ROLL_OVER,objectRollOver,false,0,true);
			obj.addEventListener(MouseEvent.ROLL_OUT,objectRollOut,false,0,true);

			/*
			obj.addEventListener(MouseEvent.CLICK,objectClick,false,0,true);
			obj.addEventListener(MouseEvent.MOUSE_DOWN,objectDrag,false,0,true);
			obj.addEventListener(MouseEvent.MOUSE_UP,objectDrag,false,0,true);
			*/
		}

		private function createObjects():void
		{
			var field:XMLList = _xml.Map.World.Field;

			for each(var s in field.Spawn)
			{
				drawSpawn(s);
			}
			for each(var z in field.Zone)
			{
				drawZone(z);
			}
			for each(var w in field.Wall)
			{
				drawWall(w);
			}
		}

		private function drawSpawn(xml:XML):void
		{
			var p = new Point(xml.attribute('x'),xml.attribute('y'));

			var zone = new Zone(p,1);
			addObject(zone);
		}

		private function drawZone(xml:XML):void
		{
			var effect = xml.attribute('effect');
			var shape = xml.ShapeCircle;
			var radius = shape.attribute('radius');
			var center = new Point(shape.Point.attribute('x'),shape.Point.attribute('y'));

			var zone = new Zone(center,radius);
			addObject(zone);
		}

		private function drawWall(xml:XML):void
		{
			var wallHeight = xml.attribute('height');

			for(var i in xml.Point)
			{
				var p = new Point(xml.Point[i].attribute('x'),xml.Point[i].attribute('y'));

				if(i == 0)
					var wall = new Wall(p);
				else
				{
					wall.appendPoint(p);
					wall.storeLastPoint();
				}
			}
			addObject(wall);
		}
	}
}