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
	import flash.display.Sprite;

	import flash.geom.Point;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;

	import orfaust.Debug;
	import orfaust.CustomEvent;

	public class Home extends Base
	{
		private const NONE = 'none';
		private const WALL = 'wall';
		private const ZONE = 'zone';
		private const SELECT = 'select';
		
		private var _aamap:Aamap;
		private var _mouseDown:Boolean = false;

		private var _tool:ToolInterface;

		override protected function init():void
		{
			var php = 'aamap.php?url=';
			var xmlUrl = php;

			//xmlUrl += 'resource.armagetronad.net/
			//xmlUrl += 'resource.armagetronad.net/resource/ZURD/race/Crossdeath-1.0.1.aamap.xml';
			//xmlUrl += 'resource.armagetronad.net/resource/ZURD/race/ecdmazed-1.aamap.xml';
			//xmlUrl += 'resource.armagetronad.net/resource/hoop/motorace/tester-0.1.aamap.xml';
			//xmlUrl += 'resource.armagetronad.net/resource/hoop/race/alba-1.6.aamap.xml';
			//xmlUrl += 
			

			//xmlUrl = 'aamap/alba-1.6.aamap.xml';
			//xmlUrl = 'aamap/diamond-1.0.2.aamap.xml';
			//xmlUrl = 'aamap/for_old_clients-0.1.0.aamap.xml';
			//xmlUrl = 'aamap/40-gon-0.2.aamap.xml';
			//xmlUrl = 'aamap/fourfold_for_old_clients-0.1.0.aamap.xml';
			//xmlUrl = 'aamap/repeat-0.3.2.aamap.xml';
			//xmlUrl = 'aamap/square-1.0.1.aamap.xml';
			//xmlUrl = 'aamap/sumo_4x4-0.1.1.aamap.xml';
			//xmlUrl = 'aamap/sumo_8x2-0.1.0.aamap.xml';
			//xmlUrl = 'aamap/zonetest-0.1.0.aamap.xml';
			//xmlUrl = 'aamap/inaktek-0.7.2.aamap.xml';
			xmlUrl = 'aamap/PanormousDeath-1.0.1.aamap.xml';


			super.loadUrl(xmlUrl,xmlLoaded,loadingProgress);
			//createMap();


			stage.addEventListener(Event.RESIZE,onStageResize,false,0,true);
			onStageResize(null);

			toolBar.addEventListener(MouseEvent.CLICK,onToolClick,false,0,true);
			toolBar.addEventListener(MouseEvent.ROLL_OVER,toolBarHover,false,0,true);
			toolBar.addEventListener(MouseEvent.ROLL_OUT,toolBarHover,false,0,true);

			_tool = toolBar.select;
		}





/* zoom */

		private function zoom(e:MouseEvent):void
		{
			if(e.delta > 0)
				zoomIn();
			else
				zoomOut();
		}

		private const ZOOM_FACTOR = .95;
		private var _scale = 1;
		private var _cursor:Point = new Point(0,0);

		private function zoomIn():void
		{
			if(_scale > 50)
				return;

			var factor = _scale;
			_scale /= ZOOM_FACTOR;

			setScale();
			factor = _scale - factor;

			_aamap.x -= _cursor.x * factor;
			_aamap.y -= _cursor.y * factor;

			setCursor();
		}
		private function zoomOut():void
		{
			if(_scale < .05)
				return;

			var factor = _scale;
			_scale *= ZOOM_FACTOR;

			setScale();
			factor -= _scale;

			_aamap.x += _cursor.x * factor;
			_aamap.y += _cursor.y * factor;

			setCursor();
		}

		private function setScale():void
		{
			_aamap.scaleX = _scale;
			_aamap.scaleY = -_scale;
		}

		private function setCursor():void
		{
			_cursor.x = (stage.mouseX - _aamap.x) / _scale;
			_cursor.y = (stage.mouseY - _aamap.y) / _scale;

			info.txt.text =
				'x: ' + _cursor.x.toString() + '\n' + 
				'y: ' + (-_cursor.y).toString() + '\n' +
				'zoom: ' + Math.floor(_scale * 100).toString() + '%';
		}


/* tools */

		private function toolBarHover(e:MouseEvent):void
		{
			if(e.type == 'rollOver')
				removeMapListeners();
			else
				addMapListeners()
		}

		private function onToolClick(e:MouseEvent):void
		{
			var selected = e.target;
			if(selected == _tool || selected == toolBar || selected == toolBar.overlay)
				return;

			_tool.close();
			removeToolListeners();

			_tool = selected;
			toolBar.overlay.x = selected.x;
			addToolListeners();
		}

		private function addToolListeners():void
		{
			_tool.addEventListener('ADD_EDITING_OBJECT',addEditingObject,false,0,true);
			_tool.addEventListener('EDITING_OBJECT_COMPLETE',editingObjectComplete,false,0,true);
			_tool.addEventListener('REMOVE_EDITING_OBJECT',removeEditingObject,false,0,true);

			if(_tool == toolBar.select)
			{
				_aamap.addEventListener('OBJECT_CLICK',objectClick,false,0,true);
				_aamap.addEventListener('OBJECT_DRAG_START',objectDragStart,false,0,true);
				_aamap.addEventListener('OBJECT_DRAG_STOP',objectDragStop,false,0,true);
			}
		}

		private function removeToolListeners():void
		{
			_tool.removeEventListener('ADD_EDITING_OBJECT',addEditingObject);
			_tool.removeEventListener('EDITING_OBJECT_COMPLETE',editingObjectComplete);
			_tool.removeEventListener('REMOVE_EDITING_OBJECT',removeEditingObject);

			if(_tool == toolBar.select)
			{
				_aamap.removeEventListener('OBJECT_CLICK',objectClick);
				_aamap.removeEventListener('OBJECT_DRAG_START',objectDragStart);
				_aamap.removeEventListener('OBJECT_DRAG_STOP',objectDragStop);
			}
		}






/* map */

		private function xmlLoaded(e:Event):void
		{
			progBar.visible = false;
			_aamap = new Aamap(e.target.data);
			initMap();
		}

		private function createMap():void
		{
			_aamap = new Aamap();
			initMap();
		}

		private function initMap():void
		{
			mapContainer.addChild(_aamap);
			_aamap.scaleY = -1;

			_aamap.x = _sW / 2;
			_aamap.y = _sH / 2;

			addToolListeners();
			addMapListeners();
			stage.addEventListener(MouseEvent.MOUSE_WHEEL,zoom,false,0,true);
		}

		private function addMapListeners():void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN,handleMouse,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_UP,handleMouse,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,handleMouse,false,0,true);
		}
		private function removeMapListeners():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,handleMouse);
			stage.removeEventListener(MouseEvent.MOUSE_UP,handleMouse);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,handleMouse);
		}




/* editing */

		private function handleMouse(e:MouseEvent):void
		{
			// drag map
			if(e.ctrlKey && e.type != MouseEvent.MOUSE_MOVE)
			{
				switch(e.type)
				{
					case MouseEvent.MOUSE_DOWN:
						_aamap.startDrag();
						break;

					case MouseEvent.MOUSE_UP:
						_aamap.stopDrag();
						break;

					case MouseEvent.MOUSE_MOVE:
						break;
				}
			}

			else
				_tool.handleMouse(e,_aamap);

			setCursor();
		}






/* tool listeners */

		private function addEditingObject(e:CustomEvent):void
		{
			if(_aamap.editing.numChildren != 0)
				error('editing is not empty');
			else
			{
				toolBar.visible = false;
				_aamap.editing.addChild(e.data);
			}
		}
		private function editingObjectComplete(e:Event):void
		{
			if(_aamap.editing.numChildren == 0)
				error('editing is empty');

			else if(_aamap.editing.numChildren > 1)
				error('editing contains more than 1 object');

			else
			{
				var obj = _aamap.editing.getChildAt(0);
				_aamap.addObject(obj);
				toolBar.visible = true;
			}
		}
		private function removeEditingObject(e:Event):void
		{
			if(_aamap.editing.numChildren == 0)
				error('editing is empty');

			else if(_aamap.editing.numChildren > 1)
				error('editing contains more than 1 object');

			else
			{
				var obj = _aamap.editing.getChildAt(0);
				_aamap.editing.removeChild(obj);
			}
		}

		private function objectClick(e:CustomEvent):void
		{
			var obj = e.data as AamapObject;
			obj.selected = !obj.selected;
		}

		private function objectDragStart(e:CustomEvent):void
		{
			var obj = e.data as AamapObject;
			obj.startDrag();
		}

		private function objectDragStop(e:CustomEvent):void
		{
			var obj = e.data as AamapObject;
			obj.stopDrag();
		}



/* loading */

		// LOADING PROGRESS
		private function loadingProgress(e:ProgressEvent):void
		{
			progBar.setProgress(e.bytesLoaded,e.bytesTotal);
		}


/* resize */

		private function onStageResize(e:Event):void
		{
			toolBar.x = _sW;

			if(progBar.visible)
			{
				progBar.x = _sW / 2 - progBar.width / 2;
				progBar.y = _sH / 2 - progBar.height / 2;
			}
		}
	}
}