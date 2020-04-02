import flash.display.Sprite;
stage.frameRate = 12
var bonusnum:Array = [0,1,4,5,2,3,11,12,6,7,8,9,13,17,10,16,14,15]
var bonusshow:Sprite = new Sprite()
var bonus1:bonus
var t_flag:int = 0
addChild(bonusshow)
for(i=0;i<3;i++)
{
	for(var j=0;j<6;j++)
	{
		bonus1=new bonus(bonusnum[6*i+j])
		bonus1.x = 78 + 161.5 * j
		bonus1.y = 75 + 167 * i
		bonusshow.addChild(bonus1)
	}
}
stage.addEventListener(Event.ENTER_FRAME,BonusVibrate)
function BonusVibrate(event:Event):void
{
	if(t_flag < 10)
	{
		for(var i=0;i<bonusshow.numChildren;i++)
			bonusshow.getChildAt(i).y -= 0.5
	}
	else
	{
		for(i=0;i<bonusshow.numChildren;i++)
			bonusshow.getChildAt(i).y += 0.5
	}
	t_flag += 1
	if(t_flag > 19)
		t_flag = 0
}
button_back1.addEventListener(MouseEvent.MOUSE_OVER,MouseIn);
button_back1.addEventListener(MouseEvent.CLICK,BackStart);
function BackStart(event:MouseEvent):void
{
    new sound_click().play()
	removeChild(bonusshow)
	stage.removeEventListener(Event.ENTER_FRAME,BonusVibrate)
	button_back1.removeEventListener(MouseEvent.MOUSE_OVER,MouseIn);
	button_back1.removeEventListener(MouseEvent.CLICK,BackStart);
	gotoAndStop(1);
}
