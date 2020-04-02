var levellist:Array = [button_choose1,button_choose2,button_choose3,button_choose4,button_choose5,button_choose6,button_choose7,button_choose8,button_choose9,button_choose10,button_choose11,button_choose12,button_choose13,button_choose14,button_choose15,button_choose16]
for(i=0;i<levellist.length;i++)
{
	levellist[i].addEventListener(MouseEvent.CLICK,LevelEnter)
	levellist[i].addEventListener(MouseEvent.MOUSE_OVER,MouseIn)
}
button_back2.addEventListener(MouseEvent.MOUSE_OVER,MouseIn);
button_back2.addEventListener(MouseEvent.CLICK,BackStart2);

function LevelEnter(event:MouseEvent):void
{
	new sound_click().play()
	for(var i=0;i<levellist.length;i++)
	{
		if(levellist[i].hitTestPoint(mouseX,mouseY))
		{
			for(var j=0;j<levellist.length;j++)
			{
				levellist[j].removeEventListener(MouseEvent.CLICK,LevelEnter)
				levellist[j].removeEventListener(MouseEvent.MOUSE_OVER,MouseIn)
			}
			button_back2.removeEventListener(MouseEvent.MOUSE_OVER,MouseIn);
			button_back2.removeEventListener(MouseEvent.CLICK,BackStart2);
			level = i+1
			gotoAndStop(2);
			break
		}
	}
}


function BackStart2(event:MouseEvent):void
{
    new sound_click().play()
	for(var j=0;j<levellist.length;j++)
	{
		levellist[j].removeEventListener(MouseEvent.CLICK,LevelEnter)
		levellist[j].removeEventListener(MouseEvent.MOUSE_OVER,MouseIn)
	}
	button_back2.removeEventListener(MouseEvent.MOUSE_OVER,MouseIn);
	button_back2.removeEventListener(MouseEvent.CLICK,BackStart);
	gotoAndStop(1);
}
