package  {
	
	import flash.display.MovieClip;
	
	
	public class brick extends MovieClip {
		
		public var pos:String;
		public var brick_color:Array;
		public var colorlist:Array;
		public function brick(color:Array) {
			colorlist = [brick_hard,brick_clear,brick_red,brick_pink,brick_yellow,brick_green,brick_blue,brick_purple,brick_flash,brick_orange,brick_cyan,brick_deepblue,brick_deepdeepblue,brick_lightyellow,brick_black,brick_white]
			brick_color = color;
			colorlist[brick_color[0]].alpha = 100;
			
		}
		public function brick_hit():void
		{
			colorlist[brick_color[0]].alpha = 0;
			brick_color.shift();
			colorlist[brick_color[0]].alpha = 100;
		}
		public function brick_pierce():void
		{
			colorlist[brick_color[0]].alpha = 0;
			brick_color=[brick_color[brick_color.length-1]]
			colorlist[brick_color[0]].alpha = 100;
		}
	}
}
