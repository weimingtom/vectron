﻿/*
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
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Graphics;

	import flash.geom.Point;

	import flash.events.MouseEvent;

	import orfaust.Debug;
	import orfaust.CustomEvent;
	import orfaust.containers.List;

	public class Aamap extends Base
	{
		private var _xml:XML;
		private var _field:XML;

		private var _editing:Sprite;

		private var _axes:uint = 4;

		public function Aamap(xml:String):void
		{
			_xml = new XML(xml);
			createObjects();

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

		public function get xml():XML
		{
			resetXml();
			return _xml;
		}

		private function resetXml():void
		{
			// use a temporary xml to keep objects ordered by type
			var tempXml:XML = new XML('<temp/>');

			_objects.each(appendXml);
			function appendXml(obj:AamapObject)
			{
				tempXml.appendChild(obj.xml);
			}

			_field.setChildren(tempXml.Spawn);
			_field.appendChild(tempXml.Zone);
			_field.appendChild(tempXml.Wall);
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



/* objects creation */

		private var _objects:List = new List;

		public function addObject(obj:AamapObject):void
		{
			if(obj.xml == null)
			{
				var xml = obj.initXml();
				_field.appendChild(xml);
			}

			_objects.push(obj);
			addChild(obj);
			obj.addEventListener(MouseEvent.ROLL_OVER,objectRollOver,false,0,true);
			obj.addEventListener(MouseEvent.ROLL_OUT,objectRollOut,false,0,true);
		}

		public function removeObject(obj:AamapObject):void
		{
			if(!contains(obj))
			{
				error(obj + ' not found in aamap');
				return;
			}
			if(!_objects.find(obj))
			{
				error(obj + ' not found in _objects List');
				return;
			}
			
			obj.removeEventListener(MouseEvent.ROLL_OVER,objectRollOver);
			obj.removeEventListener(MouseEvent.ROLL_OUT,objectRollOut);
			removeChild(obj);
			_objects.remove(obj);
		}

		public function get objects():List
		{
			//return a clone of _objects to keep the list private

			var list = new List;
			var it = _objects.iterator;
			while(!it.end)
			{
				list.push(it.data);
				it.next();
			}

			return list;
		}

		private function createObjects():void
		{
			_field = _xml.Map.World.Field[0];

			for each(var s in _field.Spawn)
			{
				drawSpawn(s);
			}
			for each(var z in _field.Zone)
			{
				drawZone(z);
			}
			for each(var w in _field.Wall)
			{
				drawWall(w);
			}
		}

		private function drawSpawn(xml:XML):void
		{
			var xPos = parseFloat(xml.attribute('x'));
			var yPos = parseFloat(xml.attribute('y'));
			var p = new Point(xPos,yPos);

			var xDir = parseFloat(xml.attribute('xdir'));
			var yDir = parseFloat(xml.attribute('ydir'));
			var dir = new Point(xDir,yDir);

			var spawn = new Spawn(this,xml,p,dir);
			addObject(spawn);
		}

		private function drawZone(xml:XML):void
		{
			var effect = xml.attribute('effect');
			var shape = xml.ShapeCircle;
			var radius = shape.attribute('radius');
			var center = new Point(shape.Point.attribute('x'),shape.Point.attribute('y'));

			var zone = new Zone(this,xml,center,radius,effect);
			addObject(zone);
		}

		private function drawWall(xml:XML):void
		{
			var wallHeight = xml.attribute('height');

			for(var i in xml.Point)
			{
				var p = new Point(xml.Point[i].attribute('x'),xml.Point[i].attribute('y'));

				if(i == 0)
					var wall = new Wall(this,xml,p);
				else
					wall.storePoint(p);
			}
			wall.render();
			addObject(wall);
		}

		public function set axes(val:uint):void
		{
			if(val <= 2)
				return;
			_axes = val;
		}
		public function get axes():uint
		{
			return _axes;
		}
	}
}