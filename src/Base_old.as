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
	import flash.display.Loader;

	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;

	import orfaust.*

	public class Base extends MovieClip
	{
		public function Base():void
		{
			addEventListener(Event.ADDED_TO_STAGE,addDebug);
		}

/* init */

		private function addDebug(e:Event):void
		{
			Debug.addToStage(stage,Const.RIGHT,Const.BOTTOM);
			Debug.setColor(new Rgb(0,0,0));
			Debug.setSize(400,300);

			stage.addEventListener(Event.RESIZE,setStageVars,false,0,true);
			setStageVars(null);
			init();
		}

		protected var _sW:Number;
		protected var _sH:Number;
		private function setStageVars(e:Event):void
		{
			_sW = stage.stageWidth;
			_sH = stage.stageHeight;
		}

		protected function init():void
		{
			forceOverride('init()');
		}

		private function forceOverride(f:String):void
		{
			throw new Error('function ' + f + ' should be overridden');
		}

		public function prepare():void{}
		public function show(callBack:Function):void{}
		public function hide(callBack:Function):void{}

/* loading */

		protected function loadUrl(url:String,onComplete:Function,onProgress:Function = null):void
		{
			var loader:URLLoader = new URLLoader;
			loader.addEventListener(IOErrorEvent.IO_ERROR,onIOError,false,0,true);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError,false,0,true);
			loader.addEventListener(Event.COMPLETE,onComplete,false,0,true);

			if(onProgress != null)
				loader.addEventListener(ProgressEvent.PROGRESS,onProgress,false,0,true);

			loader.load(new URLRequest(url));
		}

		protected function loadMedia(url:String,onComplete:Function,onProgress:Function = null):void
		{
			var loader:Loader = new Loader;
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOError,false,0,true);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete,false,0,true);

			if(onProgress != null)
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress,false,0,true);

			loader.load(new URLRequest(url));
		}

		private function onIOError(e:IOErrorEvent):void
		{
			Debug.log(e);
		}
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			Debug.log(e);
		}

		protected function error(e:String):void
		{
			throw(new Error(e));
		}
	}
}