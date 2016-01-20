package {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	[SWF(width="800", height="600", frameRate="60")]
	public class FP20Crash extends Sprite {
		
		[Embed(source='./assets/FP20CrashSkin.swf', symbol='friendsList')]
		private const clipClass:Class;
		private const m_clip:MovieClip = new clipClass() as MovieClip;
		
		private var m_tf:TextField;
		
		private var m_url:String = "http://resource.pokerist.com/poker/data/avatars/37037949.png";
		
		public function FP20Crash() {
			super();
			init();
		}
		
		private function init():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			addChild(m_tf = new TextField());
			m_tf.autoSize = TextFieldAutoSize.LEFT;
			m_tf.defaultTextFormat = new TextFormat("Arial", 14);
			
			startTest();
		}
		
		private function startTest():void {
			if (m_clip) {
				m_clip.gotoAndStop(1);
				m_clip.y = 100;
				addChild(m_clip);
				stopAll(m_clip);
				
				//every 1s go to frame 2
				setInterval(gotoFrame, 1000, 2);
				//wait 500ms and every 1s go to frame 1 
				setTimeout(setInterval, 500, gotoFrame, 1000, 1);
			}
			
			//this timer is used for loading image repeatedly which make system be loaded hardly
			setInterval(loadImage, 500, m_url);
		}
		
		private function stopAll(target:DisplayObject):void {
			if (target is MovieClip)
				MovieClip(target).stop();
			if (target is DisplayObjectContainer) {
				for (var i:int=0; i<DisplayObjectContainer(target).numChildren; i++) {
					var child:DisplayObject = DisplayObjectContainer(target).getChildAt(i);
					if (child)
						stopAll(child);
				}
			}
		}
		
		private function loadImage(url:String):void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onUrlLoaderError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onUrlLoaderError);
			urlLoader.addEventListener(Event.COMPLETE, onUrlLoaderComplete);
			urlLoader.load(new URLRequest(url + "?v=" + getTimer()));
		}
		
		private function loadImageBytes(bytes:ByteArray):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderError);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			loader.loadBytes(bytes);
		}
		
		private function gotoFrame(value:int):void {
			m_clip.gotoAndStop(value);
		}
		
		private function log(text:String):void {
			if (m_tf)
				m_tf.text = getTimer() + ": " + text;
		}
		
		private function onUrlLoaderError(event:Event):void {
			var urlLoader:URLLoader = event.target as URLLoader;
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onUrlLoaderError);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onUrlLoaderError);
			urlLoader.removeEventListener(Event.COMPLETE, onUrlLoaderComplete);
			log("onUrlLoaderError " + event.type);
		}
		
		private function onUrlLoaderComplete(event:Event):void {
			var urlLoader:URLLoader = event.target as URLLoader;
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onUrlLoaderError);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onUrlLoaderError);
			urlLoader.removeEventListener(Event.COMPLETE, onUrlLoaderComplete);
			
			var bytes:ByteArray = urlLoader.data as ByteArray;
			loadImageBytes(bytes);
		}
		
		private function onLoaderError(event:Event):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
			event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderError);
			event.target.removeEventListener(Event.COMPLETE, onLoaderComplete);
			log("onLoaderError " + event.type);
		}
		
		private function onLoaderComplete(event:Event):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
			event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderError);
			event.target.removeEventListener(Event.COMPLETE, onLoaderComplete);
			log("onLoaderComplete " + event.type);
		}
	}
}