package  {
	
	import flash.display.MovieClip;
	
	
	public class ball extends MovieClip {
		
		
		public var ball_type:int;
		public var typelist:Array;
		public function ball() {
			typelist = [normalball,fireball,poiball,exploball,iceball];
			ball_type = 0;
			removeChild(fireball)
			removeChild(poiball)
			removeChild(exploball)
			removeChild(iceball)
		}
	}
}
