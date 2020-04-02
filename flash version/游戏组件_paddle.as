package  {
	
	import flash.display.MovieClip;
	
	
	public class paddle extends MovieClip {
		
		
		public var pad_type:int;
		public var typelist:Array
		public function paddle() {
			pad_type = 1;
			typelist = [pad_short,pad_normal,pad_long]
			removeChild(pad_short);
			removeChild(pad_long);
		}
		public function pad_change(type:int):void
		{
			removeChild(typelist[pad_type])
			pad_type = type;
			addChild(typelist[type])
		}
	}
}
