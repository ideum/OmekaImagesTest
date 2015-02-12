package 
{
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.core.CMLCore;
	import com.gestureworks.core.GestureWorks;
	import flash.events.Event;
	
	import display.OmekaImageViewer;
	
	[SWF(width = "1280", height = "720", backgroundColor = "0x000000", frameRate = "30")]
	
	public class Main extends GestureWorks{
		
		public function Main():void 
		{
			super();

			CMLParser.addEventListener(CMLParser.COMPLETE, cmlInit);
			
			gml = "library/gml/gestures.gml";
			cml = "library/cml/main.cml";
		}
		
		override protected function gestureworksInit():void {
			trace("gestureWorksInit()");
		}
		
		private function cmlInit(e:Event):void 
		{
			trace("cmlInit()");
			
			var map:OmekaImageViewer = new OmekaImageViewer(stage);
		}
	}
	
}