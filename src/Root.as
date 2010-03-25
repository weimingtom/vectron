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
	import flash.display.MovieClip;

	import flash.events.Event;
	import flash.events.ProgressEvent;

	import orfaust.*;

	public class Root extends Base
	{
		// INIT
		override protected function init():void
		{
			var monitor:Monitor = new Monitor(500);
			stuff.addChild(monitor);

			//Debug.active = false;
			//monitor.visible = false;

			super.loadMedia('home.swf',homeLoaded,homeProgress);

			stage.addEventListener(Event.RESIZE,onStageResize,false,0,true);
			onStageResize(null);
		}

		// HOME LOADING PROGRESS
		private function homeProgress(e:ProgressEvent):void
		{
			progBar.setProgress(e.bytesLoaded,e.bytesTotal);
		}

		// HOME LOADED
		private function homeLoaded(e:Event):void
		{
			var home:Base = e.target.content as Base;
			home.prepare();
			container.addChild(home);
			home.show(null);

			progBar.visible = false;
		}

		// STAGE RESIZE
		private function onStageResize(e:Event):void
		{
			if(progBar.visible)
			{
				progBar.x = _sW / 2 - progBar.width / 2;
				progBar.y = _sH / 2 - progBar.height / 2;
			}
		}
	}
}