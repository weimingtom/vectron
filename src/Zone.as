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
	import orfaust.Utils;

	public class Zone extends AamapObject implements AamapObjectInterface
	{
		private var _center:Point;
		private var _radius:Number;

		private const COLOR_DEATH = Utils.getColor(1,0,0);

		public function Zone(center:Point,rad:Number,aamap):void
		{
			super(aamap);

			_center = center;
			_radius = rad;
			render();
		}

		public function moveCenter(center:Point):void
		{
			_center = center;
		}

		public function changeRadius(mouse:Point):void
		{
			var xDist = _center.x - mouse.x;
			var yDist = _center.y - mouse.y;

			_radius = Math.sqrt(xDist * xDist + yDist * yDist);
			render();
		}
		public function set radius(r:Number):void
		{
			_radius = r;
			render();
		}

		override public function render():void
		{
			_area.graphics.clear();
			_area.graphics.lineStyle(SIZE_SELECTED,COLOR_SELECTED,1,false,LineScaleMode.NONE);
			_area.graphics.drawCircle(_center.x,_center.y,_radius);

			graphics.clear();
			graphics.lineStyle(1,COLOR_DEATH,1,false,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER);
			graphics.drawCircle(_center.x,_center.y,_radius);
		}
	}
}