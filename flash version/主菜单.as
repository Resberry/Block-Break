stop();
var level:int = 1
var time:int = -1
button_start.addEventListener(MouseEvent.CLICK,StartGame);
function StartGame(event:MouseEvent):void
{
    new sound_click().play()
	button_start.removeEventListener(MouseEvent.CLICK,StartGame);
	button_bonus.removeEventListener(MouseEvent.CLICK,BonusExplain);
	button_start.removeEventListener(MouseEvent.MOUSE_OVER,MouseIn);
	button_bonus.removeEventListener(MouseEvent.MOUSE_OVER,MouseIn);
	button_level.removeEventListener(MouseEvent.CLICK,ChooseLevel);
	button_level.removeEventListener(MouseEvent.MOUSE_OVER,MouseIn);
	gotoAndStop(2);
}
button_bonus.addEventListener(MouseEvent.CLICK,BonusExplain);
function BonusExplain(event:MouseEvent):void
{
    new sound_click().play()
	button_start.removeEventListener(MouseEvent.CLICK,StartGame);
	button_bonus.removeEventListener(MouseEvent.CLICK,BonusExplain);
	button_start.removeEventListener(MouseEvent.MOUSE_OVER,MouseIn);
	button_bonus.removeEventListener(MouseEvent.MOUSE_OVER,MouseIn);
	button_level.removeEventListener(MouseEvent.CLICK,ChooseLevel);
	button_level.removeEventListener(MouseEvent.MOUSE_OVER,MouseIn);
	gotoAndStop(3);
}

button_bonus.addEventListener(MouseEvent.MOUSE_OVER,MouseIn);
button_start.addEventListener(MouseEvent.MOUSE_OVER,MouseIn);
function MouseIn(event:MouseEvent):void
{
	new sound_in().play()
}

button_level.addEventListener(MouseEvent.CLICK,ChooseLevel);
button_level.addEventListener(MouseEvent.MOUSE_OVER,MouseIn);
function ChooseLevel(event:MouseEvent):void
{
	new sound_click().play()
	button_start.removeEventListener(MouseEvent.CLICK,StartGame);
	button_bonus.removeEventListener(MouseEvent.CLICK,BonusExplain);
	button_start.removeEventListener(MouseEvent.MOUSE_OVER,MouseIn);
	button_bonus.removeEventListener(MouseEvent.MOUSE_OVER,MouseIn);
	button_level.removeEventListener(MouseEvent.CLICK,ChooseLevel);
	button_level.removeEventListener(MouseEvent.MOUSE_OVER,MouseIn);
	gotoAndStop(4);
}
