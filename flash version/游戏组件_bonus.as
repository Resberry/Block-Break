package  {
	
	import flash.display.MovieClip;
	
	
	public class bonus extends MovieClip {
		
		public var bonus_type:int;
		public var t:int;
		public var bonus_angle:Number;
		public function bonus(type:int) {
			t=0;
			bonus_type=type;
			switch(type)
			{
				case 0:bonus_longer.alpha=100;break;
				case 1:bonus_shorter.alpha=100;break;
				case 2:bonus_faster.alpha=100;break;
				case 3:bonus_slowlier.alpha=100;break;
				case 4:bonus_bigger.alpha=100;break;
				case 5:bonus_smaller.alpha=100;break;
				case 6:bonus_three.alpha=100;break;
				case 7:bonus_many.alpha=100;break;
				case 8:bonus_grab.alpha=100;break;
				case 9:bonus_gun.alpha=100;break;
				case 10:bonus_fire.alpha=100;break;
				case 11:bonus_life.alpha=100;break;
				case 12:bonus_death.alpha=100;break;
				case 13:bonus_thunder.alpha=100;break;
				case 14:bonus_poison.alpha=100;break;
				case 15:bonus_explode.alpha=100;break;
				case 16:bonus_ice.alpha=100;break;
				case 17:bonus_crush.alpha=100;break;
			}
				
		}
		
	}
	
}
