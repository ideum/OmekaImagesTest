package display
{
	import adobe.utils.CustomActions;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.events.GWGestureEvent;
	import com.greensock.events.LoaderEvent;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.*;
	import flash.net.URLRequest;

	import display.RestCall;
	
	public class OmekaImageViewer extends TouchContainer
	{
		
		private var url:String = "http://ideumtest01.omeka.net/api/";
		private var apiKey:String = "26ee48493d9b540742a35e6216da965d1187548a";
		private var requester:RestCall;
		
		public function OmekaImageViewer(stage:Stage=null) 
		{
			super.init();
			
			nativeTransform = false; 
			affineTransform = true;
			
			trace("ready");
			requester = new RestCall(url, apiKey);
			requester.addEventListener(Event.COMPLETE, processData);
			fetch("GET", "items", { collection:2 } );
			
			x = 0;
			y = 0;
			stage.addChild(this);
		}
				
		private function fetch(type:String, endpoint:String, parameters:Object=null, useKey:Boolean=false):void 
		{
			requester.makeRequest(type, endpoint, parameters, useKey);
		}
		
		private function processData(e:Event):void {
			//trace(e.target.data);
			var data = requester.data;
			if (data.length == 0) {
				trace("No data in request");
			}
			else if (data[0].files) {
				fetchImages(e.target.data);
			}
			else if (data[0].file_urls) {
				loadImages(e.target.data);
			}
		}
		
		private function fetchImages(data:Array):void {
			for (var i:int = 0; i < data.length; i++ ) {
				fetch("GET", "files", {item: data[i].id}, false);
			}
		}
		
		private function loadImages(data:Array):void {
			for (var i:int = 0; i < data.length; i++ ) {
				//trace("loading image...");
				//var image:Image = new Image();
				//image.x = Math.random() * 1280/2;
				//image.y = Math.random() * 720/2;
				//image.src = data[i].file_urls.fullsize;
				//image.init();
				//this.addChild(image);
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.OPEN, function(){
					trace("loaded and opened");
				});
				
				var container:TouchContainer = new TouchContainer();
				container.x = Math.random() * 1280 / 2;
				container.y = Math.random() * 720 / 2;
				container.scale = 0.75
				
				container.nativeTransform = false; 
				container.affineTransform = true;
				container.addEventListener(GWGestureEvent.DRAG, dragHandler);
				container.addEventListener(GWGestureEvent.SCALE, scaleHandler);
				container.addChild(loader);
				this.addChild(container);
				if(data[i].mime_type == "image/jpeg"){ 
					loader.load(new URLRequest(data[i].file_urls.fullsize));		
				}
			}
		}
		
		private function dragHandler(e:GWGestureEvent):void {
			e.target.x += e.value.drag_dx;
			e.target.y += e.value.drag_dy;
		}
		
		private function scaleHandler(e:GWGestureEvent):void {
			if (e.target.scaleX + e.value.scale_dsx <= 0.1) {
				e.target.scaleX = e.target.scaleY = 0.1;
			}
			else if (e.target.scaleX + e.value.scale_dsx >= 3.0) {
				e.target.scaleX = e.target.scaleY = 3.0;
			}
			else {
				e.target.scaleX = e.target.scaleY += e.value.scale_dsy;
			}
		}
	}
	
}