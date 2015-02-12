package display
{
	
	import com.gestureworks.cml.events.StateEvent;
	import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import com.adobe.serialization.json.JSON
	
	public class RestCall extends EventDispatcher {
		private var requestor:URLLoader = new URLLoader();
		private var apiKey:String;
		private var urlEndPoint:String;
		public var data:Object;
		
		/**
		 * Initialize some class vars.
		 * @param	url - base api url
		 * @param	key - api key
		 */
		public function RestCall(url:String, key:String):void {
			urlEndPoint = url;
			apiKey = key;
		} 

		/**
		 * Make a HTTP request
		 * @param	reqType - GET, POST, PUT, DELETE
		 * @param	resource - where to make this request.
		 * @param	urlParameters - an associative array that can specify extra url parameters
		 */
		public function makeRequest(reqType:String, resource:String, urlParameters:Object=null, useKey:Boolean=true):void {
			var request:URLRequest = new URLRequest( urlEndPoint + slashPrepend(resource));
			switch(reqType.toUpperCase()) {
				case "GET":    // get info about item
					request.method = URLRequestMethod.GET;
					break;
				case "POST":   // create new item
					request.method = URLRequestMethod.POST;
					break;
				case "PUT":    // edit item
					request.method = URLRequestMethod.PUT;
					break;
				case "DELETE": // delete item
					request.method = URLRequestMethod.DELETE;
					break;
				default:
					throw Error("invalid HTTP request type");
					break;
			}
			
			//Add the URL variables
			var variables:URLVariables = new URLVariables();
			if (useKey) {
				variables.key = apiKey;
			}
			
			if(urlParameters){
				for (var key:String in urlParameters) {
					variables[key] = urlParameters[key];
				}
			}
			request.data = variables;
			
			//Initiate the transaction 
			requestor = new URLLoader();
			requestor.addEventListener( Event.COMPLETE, httpRequestComplete );
			requestor.addEventListener( IOErrorEvent.IO_ERROR, httpRequestError );
			requestor.addEventListener( SecurityErrorEvent.SECURITY_ERROR, httpRequestError );
			requestor.load( request );
			//trace(request.url, request.data.toString());
		}
		
		/**
		 * HTTP request callback, do stuff with the data here.
		 * @param	event
		 */
		private function httpRequestComplete( e:Event ):void {
			data = com.adobe.serialization.json.JSON.decode(e.target.data);
			dispatchEvent(new Event(Event.COMPLETE, false, false));
		} 
		 
		/**
		 * HTTP error callback.
		 * @param	error
		 */
		private function httpRequestError( error:ErrorEvent ):void {
			trace( "An error occured: " + error.formatToString);
		}
		
		/**
		 * prepend "/" on resource, if it's not already there or on urlEndPoint.
		 * @param	res
		 * @return  res with a "/" if it needed one
		 */
		private function slashPrepend(res:String):String {
			if (res.charAt(0) != "/" && urlEndPoint.charAt(urlEndPoint.length-1) != "/") {
				res = "/" + res;
			}
			else if (res.charAt(0) == "/" && urlEndPoint.charAt(urlEndPoint.length-1) == "/") {
				res = res.substr(1, res.length);
			}
			return res;
		}
	}
}