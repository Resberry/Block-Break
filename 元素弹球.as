import flash.display.Sprite;
import flash.media.Sound;
import flash.events.Event;

stage.frameRate = 96;//帧速率

const BONUS_TIME = 3000;//道具持续时间
const THUNDER_AMOUNT = 8;//雷劈砖数量

const SPEED_ICE = 7.5;//冰锥移动速率
const SPEED_INIT:int = 6;//弹球默认速率
const SPEED_FAST:int = 9;//弹球最大速率
const SPEED_SLOW:int = 4;//弹球最小速率
var spe:Number;//总速率

const BALL_NORMAL:int = 12;//普通球直径
const BALL_BIG:int = 18;//大球直径
const BALL_SMALL:int = 7.5;//小球直径
var current_type:int = 0;//当前弹球类型

const BRICK_WIDTH:int= new brick([0]).width;//砖块宽度
const BRICK_HEIGHT:int = new brick([0]).height;//砖块高度
const ICE_WIDTH:int = new ice().width//冰锥宽度

var pad1:paddle;
var lifesprite:Sprite = new Sprite();//生命栏
var ballsprite:Sprite = new Sprite();//弹球组
var bricksprite:Sprite = new Sprite();//砖块组
var bulletsprite:Sprite = new Sprite();//子弹组
var icesprite:Sprite = new Sprite();//冰锥组
var gunsprite:Sprite = new Sprite();//火炮组
var elecsprite:Sprite = new Sprite();//电流组
var efieldsprite:Sprite = new Sprite();//电场组
var mcsprite:Sprite = new Sprite();//特效组
var bonussprite:Sprite = new Sprite();//正在掉落道具组

var bombbricklist:Array = new Array();//待炸砖块列表

var explode_time:int = 0;//引爆间隔计时
var continue_time:int = 0
var bonusflaglist:Array;//各道具生效状态
//0：板长；1：球速；2：球直径；3：吸盘；4：火炮；5：火球；6：毒液
var timelist:Array;//道具计时器
var grablist:Array;//弹球是否被吸列表
var anglelist:Array;//弹球方向列表
var iceanglelist:Array = new Array();//冰锥方向列表
var animasprite:Sprite = new Sprite();//动态特效组
var animamovelist:Array = new Array();//动态特效跟随对象列表
var continuelist:Array = new Array();
var buttonsprite:Sprite = new Sprite();//按钮组
var tipsprite:Sprite = new Sprite();//提示组
var bricklist:Array = new Array()
stage.focus=stage//设置舞台焦点，有利于键盘事件


function BrickInspect(event:Event):void
{
	var brick1:brick
	var amount:int = 0
	for(var i=0;i<bricksprite.numChildren;i++)
	{
		brick1 = bricksprite.getChildAt(i) as brick
		if(brick1.brick_color[0] == 0 || brick1.brick_color[0] == 1)
			amount += 1
	}
	if(amount == bricksprite.numChildren)
	{
		RemoveListener()
		CleanUp()
		if(bonusflaglist[4] != -1)
			BonusRemove(4);
		BonusRemove(0);
		Start();
		level += 1
		if(level > 16)
		{
			channel.stop()
			channel2=new sound_end().play(0,30)
			removeChild(pad1);
			removeChild(bricksprite);
			removeChild(bonussprite)
			removeChild(gunsprite)
			removeChild(efieldsprite)
			removeChild(lifesprite);
			removeChild(bulletsprite);
			removeChild(icesprite);
			removeChild(ballsprite);
			removeChild(elecsprite)
			removeChild(animasprite)
			for(i=mcsprite.numChildren-1;i>-1;i--)
				mcsprite.removeChildAt(i)
			mcsprite.addChild(new firework1())
			mcsprite.addChild(new firework2())
			mcsprite.addChild(new firework3())
			for(i=0;i<3;i++)
			{
				mcsprite.getChildAt(i).scaleX = 0.75
				mcsprite.getChildAt(i).scaleY = 0.75
			}
			mcsprite.getChildAt(0).x = 38
			mcsprite.getChildAt(0).y = 38
			mcsprite.getChildAt(1).x = 150
			mcsprite.getChildAt(1).y = 375
			mcsprite.getChildAt(2).x = 750
			mcsprite.getChildAt(2).y = 225
			RemoveListener()
			tipsprite.getChildAt(2).visible = true
			buttonsprite.getChildAt(2).visible = true
			buttonsprite.getChildAt(2).addEventListener(MouseEvent.MOUSE_OVER,MouseIn)
			buttonsprite.getChildAt(2).addEventListener(MouseEvent.CLICK,GameEnd)
		}
		else
		{
			new sound_victory().play()
			LevelGenerate(level)
		}
	}
}

function GameEnd(event:MouseEvent):void
{
	new sound_click().play()
	channel2.stop()
	buttonsprite.getChildAt(2).removeEventListener(MouseEvent.MOUSE_OVER,MouseIn)
	buttonsprite.getChildAt(2).removeEventListener(MouseEvent.CLICK,GameEnd)
	removeChild(mcsprite);
	removeChild(tipsprite)
	removeChild(buttonsprite)
	gotoAndStop(1);
}


function AddListener():void
{
	pad1.addEventListener(Event.ENTER_FRAME,PadFollow);
	stage.addEventListener(KeyboardEvent.KEY_DOWN,Pause); 
	stage.addEventListener(Event.ENTER_FRAME,BonusMove);
	stage.addEventListener(Event.ENTER_FRAME,BonusTimer);
	stage.addEventListener(Event.ENTER_FRAME,BallAction);
	stage.addEventListener(MouseEvent.MOUSE_DOWN,BallLaunch);
	stage.addEventListener(Event.ENTER_FRAME,BulletAction);
	stage.addEventListener(Event.ENTER_FRAME,IceAction);
	stage.addEventListener(Event.ENTER_FRAME,BrickExplode);
	stage.addEventListener(Event.ENTER_FRAME,AnimaAction);
	stage.addEventListener(Event.ENTER_FRAME,BrickInspect);
	if(gunsprite.visible == true)
		stage.addEventListener(MouseEvent.MOUSE_DOWN,BulletLaunch);
}
function RemoveListener():void
{
	pad1.removeEventListener(Event.ENTER_FRAME,PadFollow);
	stage.removeEventListener(KeyboardEvent.KEY_DOWN,Pause); 
	stage.removeEventListener(Event.ENTER_FRAME,BonusMove);
	stage.removeEventListener(Event.ENTER_FRAME,BonusTimer);
	stage.removeEventListener(Event.ENTER_FRAME,BallAction);
	stage.removeEventListener(MouseEvent.MOUSE_DOWN,BallLaunch);
	stage.removeEventListener(Event.ENTER_FRAME,BulletAction);
	stage.removeEventListener(Event.ENTER_FRAME,IceAction);
	stage.removeEventListener(Event.ENTER_FRAME,BrickExplode);
	stage.removeEventListener(Event.ENTER_FRAME,AnimaAction);
	stage.removeEventListener(Event.ENTER_FRAME,BrickInspect);
	if(gunsprite.visible == true)
		stage.removeEventListener(MouseEvent.MOUSE_DOWN,BulletLaunch);
}


function Pause(event:KeyboardEvent):void 
{
	switch (event.keyCode) 
	{
		case Keyboard.SPACE:
		{
			new sound_in().play()
			tipsprite.getChildAt(0).visible = true
			buttonsprite.getChildAt(0).visible = true
			buttonsprite.getChildAt(1).visible = true
			RemoveListener()
			buttonsprite.getChildAt(0).addEventListener(MouseEvent.CLICK,BackMenu)
			buttonsprite.getChildAt(0).addEventListener(MouseEvent.MOUSE_OVER,MouseIn)
			buttonsprite.getChildAt(1).addEventListener(MouseEvent.CLICK,BackGame)
			buttonsprite.getChildAt(1).addEventListener(MouseEvent.MOUSE_OVER,MouseIn)
			break
		}
	}
}
function BackMenu(event:MouseEvent):void
{
	new sound_click().play()
	channel.stop()
	if(tipsprite.getChildAt(0).visible == true)
	{
		buttonsprite.getChildAt(0).removeEventListener(MouseEvent.CLICK,BackMenu)
		buttonsprite.getChildAt(1).removeEventListener(MouseEvent.CLICK,BackGame)
	}
	else
	{
		buttonsprite.getChildAt(0).removeEventListener(MouseEvent.CLICK,Restart)
		buttonsprite.getChildAt(1).removeEventListener(MouseEvent.CLICK,BackMenu)
	}
	buttonsprite.getChildAt(0).removeEventListener(MouseEvent.MOUSE_OVER,MouseIn)
	buttonsprite.getChildAt(1).removeEventListener(MouseEvent.MOUSE_OVER,MouseIn)
	removeChild(pad1);
	removeChild(bricksprite);
	removeChild(bonussprite)
	removeChild(gunsprite)
	removeChild(efieldsprite)
	removeChild(lifesprite);
	removeChild(bulletsprite);
	removeChild(icesprite);
	removeChild(mcsprite);
	removeChild(ballsprite);
	removeChild(elecsprite)
	removeChild(animasprite)
	removeChild(tipsprite)
	removeChild(buttonsprite)
	gotoAndStop(1);
}
function BackGame(event:MouseEvent):void
{
	new sound_click().play()
	buttonsprite.getChildAt(0).removeEventListener(MouseEvent.CLICK,BackMenu)
	buttonsprite.getChildAt(1).removeEventListener(MouseEvent.CLICK,BackGame)
	buttonsprite.getChildAt(0).removeEventListener(MouseEvent.MOUSE_OVER,MouseIn)
	buttonsprite.getChildAt(1).removeEventListener(MouseEvent.MOUSE_OVER,MouseIn)
	buttonsprite.getChildAt(0).visible = false
	buttonsprite.getChildAt(1).visible = false
	tipsprite.getChildAt(0).visible = false
	AddListener()
}





function AnimaAction(event:Event):void
{
	for(var i=0;i<animasprite.numChildren;i++)
	{
		animasprite.getChildAt(i).x=animamovelist[i].x
		animasprite.getChildAt(i).y=animamovelist[i].y
	}
}//动态特效跟随


function Start():void
{
	BallInit(pad1.x,577.25);
	bonusflaglist = [-1,-1,-1,-1,-1,-1,-1];
	timelist = [0,0,0,0,0,0,0];
	grablist = [0];
	anglelist = [Math.PI / 2];
	spe = SPEED_INIT;
	gunsprite.getChildAt(0).x = pad1.x - pad1.width / 2 + 5
	gunsprite.getChildAt(1).x = pad1.x + pad1.width / 2 - 5
	efieldsprite.getChildAt(0).x = gunsprite.getChildAt(0).x;
	efieldsprite.getChildAt(1).x = gunsprite.getChildAt(1).x;
	elecsprite.getChildAt(0).x = pad1.x;
	elecsprite.getChildAt(0).width = pad1.width;
	gunsprite.visible = false;
	efieldsprite.visible = true;
	elecsprite.visible = true;
}//单次生命初始化



function Roll(tri:Number=0):int
{
	if(tri == 0)
	{
		var dist:Number = Math.random();
		if(dist < 0.5)
			return -1;
		else
			return 1;
	}
	else
	{
		if(tri < 0)
			return -1;
		else
			return 1;
	}
}//挡板中央随机扰动/三角函数决定公式正负



function PadFollow(event:Event):void
{
	var pad_x:Number
	pad_x = Math.min(stage.stageWidth - pad1.width / 2,mouseX)
	pad_x = Math.max(pad1.width / 2,pad_x)
	pad1.x = pad_x;
	gunsprite.getChildAt(0).x = pad1.x - pad1.width / 2 + 5;//左火炮位置
	gunsprite.getChildAt(1).x = pad1.x + pad1.width / 2 - 5;//右火炮位置
	efieldsprite.getChildAt(0).x = pad1.x - pad1.width / 2 + 5;
	efieldsprite.getChildAt(1).x = pad1.x + pad1.width / 2 - 5;
	elecsprite.getChildAt(0).x = pad1.x;
	elecsprite.getChildAt(0).width = pad1.width - 6;
}//挡板跟随


function BallInit(ballx:Number,bally:Number):void
{
	var ball1:ball = new ball();
	ball1.x = ballx;
	ball1.y = bally;
	ballsprite.addChild(ball1);
	ballsprite.getChildAt(ballsprite.numChildren - 1).width = ballsprite.getChildAt(0).width;//宽度统一
	ballsprite.getChildAt(ballsprite.numChildren - 1).height = ballsprite.getChildAt(0).height;//高度统一
	ball1 = ballsprite.getChildAt(0) as ball;
	BallUpdate(ball1.ball_type);//弹球类型统一
}//生成新弹球


function BallLaunch(event:Event):void
{
	for(var i=0;i<grablist.length;i++)
	{
		if(anglelist[i] == Math.PI / 2)
			anglelist[i] = Math.PI / 2 + Roll() * Math.PI / 18;
		grablist[i] = -1;
	}
	if(bonusflaglist[3] == -1)
		efieldsprite.visible = false;
	elecsprite.visible = false;
}//弹球发射


function BallUpdate(balltype:int):void
{
	if(balltype > 5)
	{
		for(var i=0;i<ballsprite.numChildren;i++)
		{
			ballsprite.getChildAt(i).width = balltype;
			ballsprite.getChildAt(i).height = balltype;
		}
	}//弹球直径变化
	else
	{
		var ball1:ball;
		for(i=0;i<ballsprite.numChildren;i++)
		{
			ball1 = ballsprite.getChildAt(i) as ball;
			ball1.removeChild(ball1.typelist[ball1.ball_type]);
			ball1.addChild(ball1.typelist[balltype]);
			ball1.ball_type = balltype;
		}
		current_type = balltype;
	}//弹球类型变化
}//更新弹球


function PositionAndDirection(ballnum:int,bricknum:int,pos:String,direc:String,if_flag:int=-1,tri_fun:String='null'):String
{
	var brick1:brick;
	brick1 = bricksprite.getChildAt(bricknum) as brick;
	if(current_type != 1 || brick1.brick_color[brick1.brick_color.length-1] == 0)
	{
		if(if_flag == -1)//不判断小球速度方向，直接调整位置
		{
			if(direc == 'x')
				anglelist[ballnum] = -anglelist[ballnum] + Math.PI;
			else if(direc == 'y')
				anglelist[ballnum] = -anglelist[ballnum];
			if(pos == 'l')
			{
				ballsprite.getChildAt(ballnum).x = bricksprite.getChildAt(bricknum).x - bricksprite.getChildAt(bricknum).width / 2 - ballsprite.getChildAt(ballnum).width / 2;
				McGenerate(0,ballsprite.getChildAt(ballnum).x+2,ballsprite.getChildAt(ballnum).y);
				return 'l';
			}
			else if(pos == 'r')
			{
				ballsprite.getChildAt(ballnum).x = bricksprite.getChildAt(bricknum).x + bricksprite.getChildAt(bricknum).width / 2 + ballsprite.getChildAt(ballnum).width / 2;
				McGenerate(0,ballsprite.getChildAt(ballnum).x-2,ballsprite.getChildAt(ballnum).y,180);
				return 'r';
			}
			else if(pos == 'u')
			{
				ballsprite.getChildAt(ballnum).y = bricksprite.getChildAt(bricknum).y - bricksprite.getChildAt(bricknum).height / 2 - ballsprite.getChildAt(ballnum).height / 2;
				McGenerate(0,ballsprite.getChildAt(ballnum).x,ballsprite.getChildAt(ballnum).y+2,90);
				return 'u';
			}
			else
			{
				ballsprite.getChildAt(ballnum).y = bricksprite.getChildAt(bricknum).y + bricksprite.getChildAt(bricknum).height / 2 + ballsprite.getChildAt(ballnum).height / 2;
				McGenerate(0,ballsprite.getChildAt(ballnum).x,ballsprite.getChildAt(ballnum).y-2,-90);
				return 'd';
			}
		}
		else
		{
			if(tri_fun == 'cos')
			{
				if(Math.cos(anglelist[ballnum]) > 0)
					return PositionAndDirection(ballnum,bricknum,'l','x')
				else
					return PositionAndDirection(ballnum,bricknum,'r','x')
			}
			else
			{
				if(Math.sin(anglelist[ballnum]) > 0)
					return PositionAndDirection(ballnum,bricknum,'d','y')
				else
					return PositionAndDirection(ballnum,bricknum,'u','y')
			}
		}
	}
	else
		return pos;
}//弹球碰撞砖块后位置修正以及速度改变


function BrickRemove(num:int,way:int,angle:Number,pos:String='null',sound_flag:int=-1):void
{//angle：物体击砖时的速度方向；pos：弹球碰撞砖块瞬间的相对位置；explode_flag：是否击碎黑砖
	var brick1:brick;
	brick1 = bricksprite.getChildAt(num) as brick;
	if(brick1.brick_color[0] == 8 && way != 3)
		BrickRemove(num,3,angle,pos)
	else
	{
		if(way == 0)
		{
			if(sound_flag == -1)
				new sound_brick().play();
			else if(sound_flag == 0)
				new sound_ice().play();
			if(brick1.brick_color.length > 1)
				brick1.brick_hit();
			else if(brick1.brick_color[0] != 0)
			{
				BonusInit(brick1.x,brick1.y,angle);
				bricksprite.removeChildAt(num);
			}
		}//普通球击砖方式
		else if(way == 1)
		{
			new sound_brick().play();
			if(brick1.brick_color[brick1.brick_color.length-1] != 0)
			{
				BonusInit(brick1.x,brick1.y,angle);
				bricksprite.removeChildAt(num);
			}
			else
				brick1.brick_pierce();
		}//火球击砖方式	
		else if(way == 2)
		{
			new sound_poi().play();
			BonusInit(brick1.x,brick1.y,angle);
			bricksprite.removeChildAt(num);
		}//毒液球击砖方式
		else if(way == 3)
		{
			var continue_flag:int=-1
			if(brick1.brick_color[0]==8)
				continue_flag = 0
			new sound_explode().play();
			if(brick1.brick_color.length > 1)
				brick1.brick_hit();
			else
			{
				McGenerate(2,brick1.x,brick1.y)
				BonusInit(brick1.x,brick1.y,angle,48);
				bricksprite.removeChildAt(num);
			}
			if(pos == 'd')
			{
				for(var i=Math.min(bricksprite.numChildren-1,num+23);i>num-1;i--)
				{
					if(bricksprite.getChildAt(i).x == brick1.x + BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y + BRICK_HEIGHT)
					{
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x && bricksprite.getChildAt(i).y == brick1.y + BRICK_HEIGHT)
					{
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x - BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y + BRICK_HEIGHT)
					{
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x + BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y)
					{
						ExplodePrepare(i,pos,continue_flag)
						break;
					}
				}
				if(num > 0 && bricksprite.getChildAt(num-1).x == brick1.x - BRICK_WIDTH && bricksprite.getChildAt(num-1).y == brick1.y)
					ExplodePrepare(num-1,pos,continue_flag)
				for(i=Math.min(bricksprite.numChildren-1,num);i>Math.max(-1,num-24);i--)
				{
					if(bricksprite.getChildAt(i).x == brick1.x + BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y - BRICK_HEIGHT)
					{
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x && bricksprite.getChildAt(i).y == brick1.y - BRICK_HEIGHT)
					{
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x - BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y - BRICK_HEIGHT)
					{
						ExplodePrepare(i,pos,continue_flag)
						break;
					}
				}
			}
			else if(pos == 'u')
			{
				for(i=Math.min(bricksprite.numChildren-1,num);i>Math.max(-1,num-24);i--)
				{
					if(bricksprite.getChildAt(i).x == brick1.x + BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y - BRICK_HEIGHT)
					{//上右
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x && bricksprite.getChildAt(i).y == brick1.y - BRICK_HEIGHT)
					{//上中
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x - BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y - BRICK_HEIGHT)
					{//上左
						ExplodePrepare(i,pos,continue_flag)
						break;
					}
				}
				for(i=Math.min(bricksprite.numChildren-1,num+1);i>Math.max(-1,num-5);i--)
				{
					if(bricksprite.getChildAt(i).x == brick1.x + BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y)
					{//中右
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x - BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y)
					{//中左
						ExplodePrepare(i,pos,continue_flag)
						break;
					}
				}
				for(i=Math.min(bricksprite.numChildren-1,num+23);i>Math.max(-1,num-6);i--)
				{
					if(bricksprite.getChildAt(i).x == brick1.x + BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y + BRICK_HEIGHT)
					{//下右
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x && bricksprite.getChildAt(i).y == brick1.y + BRICK_HEIGHT)
					{//下中
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x - BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y + BRICK_HEIGHT)
					{//下左
						ExplodePrepare(i,pos,continue_flag)
						break;
					}
				}
			}
			else if(pos == 'l')
			{
				for(i=Math.min(bricksprite.numChildren-1,num+21);i>Math.max(-1,num-24);i--)
				{
					if(bricksprite.getChildAt(i).x == brick1.x - BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y + BRICK_HEIGHT)
					{//下左
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x - BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y)
					{//中左
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x - BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y - BRICK_HEIGHT)
					{//上左
						ExplodePrepare(i,pos,continue_flag)
						break;
					}
				}
				for(i=Math.min(bricksprite.numChildren-1,num+22);i>Math.max(-1,num-25);i--)
				{
					if(bricksprite.getChildAt(i).x == brick1.x && bricksprite.getChildAt(i).y == brick1.y + BRICK_HEIGHT)
					{//下中
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x && bricksprite.getChildAt(i).y == brick1.y - BRICK_HEIGHT)
					{//上中
						ExplodePrepare(i,pos,continue_flag)
						break;
					}
				}
				for(i=Math.min(bricksprite.numChildren-1,num+23);i>Math.max(-1,num-25);i--)
				{
					if(bricksprite.getChildAt(i).x == brick1.x + BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y + BRICK_HEIGHT)
					{//下右
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x + BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y)
					{//中右
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x + BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y - BRICK_HEIGHT)
					{//上右
						ExplodePrepare(i,pos,continue_flag)
						break;
					}
				}
			}
			else if(pos == 'r')
			{
				for(i=Math.min(bricksprite.numChildren-1,num+23);i>Math.max(-1,num-22);i--)
				{
					if(bricksprite.getChildAt(i).x == brick1.x + BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y + BRICK_HEIGHT)
					{//下右
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x + BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y)
					{//中右
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x + BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y - BRICK_HEIGHT)
					{//上右
						ExplodePrepare(i,pos,continue_flag)
						break;
					}
				}
				for(i=Math.min(bricksprite.numChildren-1,num+22);i>Math.max(-1,num-23);i--)
				{
					if(bricksprite.getChildAt(i).x == brick1.x && bricksprite.getChildAt(i).y == brick1.y + BRICK_HEIGHT)
					{//下中
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x && bricksprite.getChildAt(i).y == brick1.y - BRICK_HEIGHT)
					{//上中
						ExplodePrepare(i,pos,continue_flag)
						break;
					}
				}
				for(i=Math.min(bricksprite.numChildren-1,num+21);i>Math.max(-1,num-24);i--)
				{
					if(bricksprite.getChildAt(i).x == brick1.x - BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y + BRICK_HEIGHT)
					{//下左
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x - BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y)
					{//中左
						ExplodePrepare(i,pos,continue_flag)
						continue;
					}
					if(bricksprite.getChildAt(i).x == brick1.x - BRICK_WIDTH && bricksprite.getChildAt(i).y == brick1.y - BRICK_HEIGHT)
					{//上左
						ExplodePrepare(i,pos,continue_flag)
						break;
					}
				}
			}
		}//熔岩球击砖方式
		else if(way == 4)
		{
			new sound_iceball().play()
			BrickRemove(num,0,angle,'null',1)
		}//寒冰球击砖方式
		else if(way == 5)
		{
			if(brick1.brick_color.length > 1)
				brick1.brick_hit();
			else
			{
				McGenerate(2,brick1.x,brick1.y)
				BonusInit(brick1.x,brick1.y,angle);
				bricksprite.removeChildAt(num);
			}		
		}//熔岩爆裂
		else if(way == 6)
		{
			McGenerate(2,brick1.x,brick1.y)
			BonusInit(brick1.x,brick1.y,angle,48);
			bricksprite.removeChildAt(num);
		}//彩砖穿透爆裂
	}
}//砖块被击后移除


function ExplodePrepare(num:int,pos:String,flag:int):void
{
	var brick1:brick
	brick1 = bricksprite.getChildAt(num) as brick
	brick1.pos=pos
	if(flag != -1 && continuelist.indexOf(brick1) == -1)
		continuelist.push(brick1)
	else if(flag == -1 && bombbricklist.indexOf(bricksprite.getChildAt(num)) == -1)
		bombbricklist.push(brick1)
}//炸砖准备


function BrickExplode(event:Event):void
{
	explode_time++;
	continue_time++
	if(explode_time == 3)
	{
		if(bombbricklist.length > 0)
		{
			if(bricksprite.contains(bombbricklist[0]))
				BrickRemove(bricksprite.getChildIndex(bombbricklist[0]),5,Math.PI/2,bombbricklist[0].pos)
			bombbricklist.shift()
		}
		explode_time = 0;
	}
	if(continue_time == 2)
	{
		if(continuelist.length > 0)
		{
			if(bricksprite.contains(continuelist[0]))
				BrickRemove(bricksprite.getChildIndex(continuelist[0]),6,Math.PI/2,continuelist[0].pos)
			continuelist.shift()
		}
		continue_time = 0;
	}
}//砖块爆炸


function BulletLaunch(event:Event):void
{
	new sound_bullet().play();
	for(var i=0;i<2;i++)
	{
		var bullet1:bullet = new bullet();
		bullet1.x = gunsprite.getChildAt(i).x;
		bullet1.y = 565;
		bulletsprite.addChild(bullet1);
	}
}//子弹发射


function BulletAction(event:Event):void
{
	for(var i=0;i<bulletsprite.numChildren;i++)
		bulletsprite.getChildAt(i).y -= 12;
	for(i=bulletsprite.numChildren-1;i>-1;i--)
	{
		for(var j=0;j<bricksprite.numChildren;j++)
		{
			if(bricksprite.getChildAt(j).hitTestObject(bulletsprite.getChildAt(i)))
			{
				McGenerate(0,bulletsprite.getChildAt(i).x,bricksprite.getChildAt(j).y + BRICK_HEIGHT / 2 + 3,-90);
				BrickRemove(j,0,Math.PI/2,'d');
				bulletsprite.removeChildAt(i);
				break;
			}
		}
	}//子弹击中砖块
	if(bulletsprite.numChildren > 0)
	{
		if(bulletsprite.getChildAt(0).y + bulletsprite.getChildAt(0).height / 2 <= 0)
			bulletsprite.removeChildAt(0);
	}//子弹出界
}//子弹移动


function IceLaunch(angle_start:int,ballnum:int,startx:int,starty:int):void
{//angle_strat起始角度
	new sound_icelaunch().play();
	var direc:int;
	var ice1:ice = new ice();
	direc = Math.floor(Math.random() * 151) + angle_start;
	ice1.rotation = -direc;//冰锥旋转角度
	ice1.x = startx;
	ice1.y = starty;
	icesprite.addChild(ice1);
	iceanglelist.push(direc / 180 * Math.PI);//冰锥移动方向
}//冰锥发射


function IceAction(event:Event):void
{
	for(var i=0;i<icesprite.numChildren;i++)
	{
		icesprite.getChildAt(i).x += SPEED_ICE * Math.cos(iceanglelist[i]);
		icesprite.getChildAt(i).y -= SPEED_ICE * Math.sin(iceanglelist[i]);
	}
	for(i=icesprite.numChildren-1;i>-1;i--)
	{
		for(var j=0;j<bricksprite.numChildren;j++)
		{
			if(bricksprite.getChildAt(j).hitTestPoint(icesprite.getChildAt(i).x + ICE_WIDTH / 2 * Math.cos(iceanglelist[i]),icesprite.getChildAt(i).y - ICE_WIDTH / 2 * Math.sin(iceanglelist[i])))
			{
				var lr_exist:int = -1
				var ud_exist:int = -1
				for(var k=0;k<bricksprite.numChildren;k++)
				{
					if(bricksprite.getChildAt(k).y == bricksprite.getChildAt(j).y && bricksprite.getChildAt(k).x == bricksprite.getChildAt(j).x - Roll(Math.cos(iceanglelist[i])) * BRICK_WIDTH)
						lr_exist = k;
					if(bricksprite.getChildAt(k).y == bricksprite.getChildAt(j).y + Roll(Math.sin(iceanglelist[i])) * BRICK_HEIGHT && bricksprite.getChildAt(k).x == bricksprite.getChildAt(j).x)
						ud_exist = k;
				}
				if(lr_exist != -1 && ud_exist != -1)
					BrickRemove(lr_exist,0,iceanglelist[i],'null',0);
				else
					BrickRemove(j,0,iceanglelist[i],'null',0);
				icesprite.removeChildAt(i);
				iceanglelist.splice(i,1);
				break;
			}
		}
	}//冰锥击中砖块
	if(icesprite.numChildren > 0)
	{
		if(icesprite.getChildAt(0).x > stage.stageWidth + 35 || icesprite.getChildAt(0).x < -35 || icesprite.getChildAt(0).y > stage.stageHeight + 35 || icesprite.getChildAt(0).y < -35)
		{
			icesprite.removeChildAt(0);
			iceanglelist.shift();
		}
	}//冰锥出界
}//冰锥移动


function LifeInit():void
{
	var life1:life = new life();
	life1.y = 15;
	if(lifesprite.numChildren > 0)
		life1.x = lifesprite.getChildAt(lifesprite.numChildren - 1).x - 55;
	else
		life1.x = 930
	lifesprite.addChild(life1);
}//生命栏初始化

var bgm1:bgm = new bgm()
var channel:SoundChannel;
channel=bgm1.play(0,30);//背景音乐循环30遍
var channel2:SoundChannel;

LifeInit();
LifeInit();

pad1 =  new paddle();
pad1.x = mouseX;
pad1.y = 588;

tipsprite.addChild(new board1())
tipsprite.addChild(new board2())
tipsprite.addChild(new board3())
buttonsprite.addChild(new button_yes())
buttonsprite.addChild(new button_no())
buttonsprite.addChild(new button_back())
for(var i=0;i<tipsprite.numChildren;i++)
{
	tipsprite.getChildAt(i).x = stage.stageWidth / 2
	tipsprite.getChildAt(i).y = stage.stageHeight / 2
	tipsprite.getChildAt(i).visible = false
	buttonsprite.getChildAt(i).visible = false
}

buttonsprite.getChildAt(0).x = 428
buttonsprite.getChildAt(0).y = 320
buttonsprite.getChildAt(1).x = 534
buttonsprite.getChildAt(1).y = 320
buttonsprite.getChildAt(2).x = 480
buttonsprite.getChildAt(2).y = 325

gunsprite.addChild(new gun());
gunsprite.addChild(new gun());
gunsprite.getChildAt(0).y = 582;
gunsprite.getChildAt(1).y = 582;
elecsprite.addChild(new elec())
efieldsprite.addChild(new efield())
efieldsprite.addChild(new efield())
efieldsprite.getChildAt(0).y = 577.5
efieldsprite.getChildAt(1).y = 577.5
elecsprite.getChildAt(0).y = pad1.y - 12;

addChild(pad1);
addChild(bricksprite);
addChild(bonussprite)
addChild(gunsprite)
addChild(efieldsprite)
addChild(lifesprite);
addChild(bulletsprite);
addChild(icesprite);
addChild(mcsprite);
addChild(ballsprite);
addChild(elecsprite)
addChild(animasprite)
addChild(tipsprite)
addChild(buttonsprite)

Start();

LevelGenerate(level)

function BallAction(event:Event):void
{
	var ball1:ball;
	for(var i=0;i<ballsprite.numChildren;i++)
	{
		var up_hit:int = -1;//弹球上檐是否碰撞砖块
		var down_hit:int = -1;//弹球下檐是否碰撞砖块
		var left_hit:int = -1;//弹球左檐是否碰撞砖块
		var right_hit:int = -1;//弹球右檐是否碰撞砖块
		var insec:int = -1;//弹球轨迹与所在砖侧檐交点是否在砖外
		ball1 = ballsprite.getChildAt(i) as ball;
		if(grablist[i] == -1)
		{
			ball1.x += spe * Math.cos(anglelist[i]);
			ball1.y -= spe * Math.sin(anglelist[i]);
		}
		else
		{
			ball1.x = pad1.x + pad1.width * (0.75 - 3 * anglelist[i] / (2 * Math.PI));
			ball1.y = pad1.y - pad1.height / 2 - ball1.height / 2 + 6.5;
		}
		if((ball1.x <= ball1.width / 2 && Math.cos(anglelist[i]) < 0 && grablist[i] == -1) || ((ball1.x + ball1.width / 2) >= stage.stageWidth && Math.cos(anglelist[i]) > 0 && grablist[i] == -1))
		{//碰撞左右墙壁
			new sound_wall().play();
			anglelist[i] = -anglelist[i] + Math.PI;
			if(current_type == 4)
			{
				if(ball1.x <= ball1.width / 2)
					IceLaunch(-70,i,-10,ball1.y);
				else
					IceLaunch(110,i,stage.stageWidth+10,ball1.y);
			}
		}
		if(ball1.y <= ball1.height / 2 && Math.sin(anglelist[i]) > 0)
		{//碰撞顶部墙壁
			new sound_wall().play();
			anglelist[i] = -anglelist[i];
			if(current_type == 4)
				IceLaunch(200,i,ball1.x,-10);
		}
		else if(ball1.y + ball1.height / 2 + pad1.height / 2 - 6.5 > pad1.y && ball1.y <= 592.5 && ball1.x >= pad1.x - pad1.width / 2 + 6 && ball1.x <= pad1.x + pad1.width / 2 - 6)
		{//碰撞挡板
			new sound_wall().play();
			if(bonusflaglist[3] != -1)
			{
				grablist[i] = 0;
				elecsprite.visible = true;
			}
			ball1.y = pad1.y - pad1.height / 2 - ball1.height / 2 + 6.5;//弹球位置修正
			anglelist[i] = Math.PI / 2 - (ball1.x - pad1.x) / (pad1.width / 2) * (Math.PI / 3);
		}
		else if(((ball1.x + ball1.width / 2 > pad1.x - pad1.width / 2 && ball1.x < pad1.x - pad1.width / 2 + 6) || (ball1.x - ball1.width / 2 < pad1.x + pad1.width / 2 && ball1.x > pad1.x + pad1.width / 2 - 6)) && (ball1.y + ball1.height / 2 > pad1.y - pad1.height / 2 + 5.25 && ball1.y < 593))
		{//碰撞挡板边缘
			new sound_wall().play();
			anglelist[i] = Math.PI / 2 - (ball1.x - pad1.x) / (pad1.width / 2) * (Math.PI * 11 / 36);
		}
		else
		{
			for(var j=0;j<bricksprite.numChildren;j++)
			{
				if(bricksprite.getChildAt(j).hitTestPoint(ball1.x,ball1.y - ball1.height / 2))
					up_hit = j;
				if(bricksprite.getChildAt(j).hitTestPoint(ball1.x,ball1.y + ball1.height / 2))
					down_hit = j;
				if(bricksprite.getChildAt(j).hitTestPoint(ball1.x - ball1.width / 2,ball1.y))
					left_hit = j;
				if(bricksprite.getChildAt(j).hitTestPoint(ball1.x + ball1.width / 2,ball1.y))
					right_hit = j;
			}
			if(up_hit + down_hit + left_hit + right_hit == -4)
				continue;
			else 
			{
				if(up_hit + down_hit + left_hit + right_hit == up_hit - 3)
				{
					if(Math.sin(anglelist[i]) > 0)
						BrickRemove(up_hit,current_type,anglelist[i],PositionAndDirection(i,up_hit,'d','y'));
					else
						BrickRemove(up_hit,current_type,anglelist[i],PositionAndDirection(i,up_hit,'null','null',0,'cos'));
				}
				else if(up_hit + down_hit + left_hit + right_hit == down_hit - 3)
				{
					if(Math.sin(anglelist[i]) < 0)
						BrickRemove(down_hit,current_type,anglelist[i],PositionAndDirection(i,down_hit,'u','y'));
					else
						BrickRemove(down_hit,current_type,anglelist[i],PositionAndDirection(i,down_hit,'null','null',0,'cos'));
				}
				else if(up_hit + down_hit + left_hit + right_hit == left_hit - 3)
				{
					if(Math.cos(anglelist[i]) < 0)
						BrickRemove(left_hit,current_type,anglelist[i],PositionAndDirection(i,left_hit,'r','x'));
					else
						BrickRemove(left_hit,current_type,anglelist[i],PositionAndDirection(i,left_hit,'null','null',0,'sin'));
				}
				else if(up_hit + down_hit + left_hit + right_hit == right_hit - 3)
				{
					if(Math.cos(anglelist[i]) > 0)
						BrickRemove(right_hit,current_type,anglelist[i],PositionAndDirection(i,right_hit,'l','x'));
					else
						BrickRemove(right_hit,current_type,anglelist[i],PositionAndDirection(i,right_hit,'null','null',0,'sin'));
				}
				else if(up_hit != down_hit && up_hit != -1 && down_hit != -1)
				{
					if(Math.sin(anglelist[i]) < 0)
						BrickRemove(Math.min(up_hit,down_hit),current_type,anglelist[i],PositionAndDirection(i,up_hit,'null','null',0,'cos'));
					else
						BrickRemove(Math.max(up_hit,down_hit),current_type,anglelist[i],PositionAndDirection(i,up_hit,'null','null',0,'cos'));
				}
				else if(left_hit != right_hit && left_hit != -1 && right_hit != -1)
				{
					if(Math.cos(anglelist[i]) > 0)
						BrickRemove(Math.min(left_hit,right_hit),current_type,anglelist[i],PositionAndDirection(i,left_hit,'null','null',0,'sin'));
					else
						BrickRemove(Math.max(left_hit,right_hit),current_type,anglelist[i],PositionAndDirection(i,left_hit,'null','null',0,'sin'));
				}
				else if((up_hit != -1 && right_hit != -1 && down_hit == -1 && left_hit == -1) || (up_hit != -1 && left_hit != -1 && down_hit == -1 && right_hit == -1))
				{
					if(Math.sin(anglelist[i]) > 0)
					{
						if(-Math.tan(anglelist[i]) * (bricksprite.getChildAt(up_hit).x - Roll(Math.cos(anglelist[i])) * BRICK_WIDTH / 2 - ball1.x) + ball1.y >= bricksprite.getChildAt(up_hit).y + BRICK_HEIGHT / 2)
							insec = 0;
						if(insec == 0)
							BrickRemove(up_hit,current_type,anglelist[i],PositionAndDirection(i,up_hit,'d','y'));
						else
							BrickRemove(up_hit,current_type,anglelist[i],PositionAndDirection(i,up_hit,'null','null',0,'cos'))
					}
					else
						BrickRemove(up_hit,current_type,anglelist[i],PositionAndDirection(i,up_hit,'null','null',0,'cos'));
				}
				else if((down_hit != -1 && left_hit != -1 && up_hit == -1 && right_hit == -1) || (down_hit != -1 && right_hit != -1 && up_hit == -1 && left_hit == -1))
				{
					if(Math.sin(anglelist[i]) < 0)
					{
						if(-Math.tan(anglelist[i]) * (bricksprite.getChildAt(down_hit).x - Roll(Math.cos(anglelist[i])) * BRICK_WIDTH / 2 - ball1.x) + ball1.y <= bricksprite.getChildAt(down_hit).y - BRICK_HEIGHT / 2)
							insec = 0;
						if(insec == 0)
							BrickRemove(down_hit,current_type,anglelist[i],PositionAndDirection(i,down_hit,'u','y'));
						else
							BrickRemove(down_hit,current_type,anglelist[i],PositionAndDirection(i,down_hit,'null','null',0,'cos'));
					}
					else
						BrickRemove(down_hit,current_type,anglelist[i],PositionAndDirection(i,down_hit,'null','null',0,'cos'));
				}
				else if(down_hit == -1 && up_hit != -1 && left_hit != -1 && right_hit != -1)
				{
					if(Math.sin(anglelist[i]) > 0)
						BrickRemove(up_hit,current_type,anglelist[i],PositionAndDirection(i,up_hit,'d','y'));
					else
						BrickRemove(up_hit,current_type,anglelist[i],PositionAndDirection(i,up_hit,'null','null',0,'cos'));
				}
				else if(up_hit == -1 && down_hit != -1 && left_hit != -1 && right_hit != -1)
				{
					if(Math.sin(anglelist[i]) < 0)
						BrickRemove(down_hit,current_type,anglelist[i],PositionAndDirection(i,down_hit,'u','y'));
					else
						BrickRemove(down_hit,current_type,anglelist[i],PositionAndDirection(i,down_hit,'null','null',0,'cos'));
				}
				else if(right_hit == -1 && down_hit != -1 && left_hit != -1 && up_hit != -1)
				{
					if(Math.cos(anglelist[i]) < 0)
						BrickRemove(up_hit,current_type,anglelist[i],PositionAndDirection(i,left_hit,'r','x'));
					else
						BrickRemove(up_hit,current_type,anglelist[i],PositionAndDirection(i,left_hit,'null','null',0,'sin'));
				}
				else if(left_hit == -1 && down_hit != -1 && up_hit != -1 && right_hit != -1)
				{
					if(Math.cos(anglelist[i]) > 0)
						BrickRemove(up_hit,current_type,anglelist[i],PositionAndDirection(i,right_hit,'l','x'));
					else
						BrickRemove(up_hit,current_type,anglelist[i],PositionAndDirection(i,right_hit,'null','null',0,'sin'));
				}
				else
				{
					var lr_exist:int = -1;//弹球所在砖的左/右是否有砖
					var ud_exist:int = -1;//弹球所在砖的上/下是否有砖
					var lr_direc:String;//小球处于被击砖块的左右方位
					var ud_direc:String;//小球处于被击砖块的上下方位
					if(Math.sin(anglelist[i]) > 0)
						ud_direc = 'd'
					else
						ud_direc = 'u'
					if(Math.cos(anglelist[i]) > 0)
						lr_direc = 'l'
					else
						lr_direc = 'r'
					for(j=0;j<bricksprite.numChildren;j++)
					{
						if(bricksprite.getChildAt(j).y == bricksprite.getChildAt(up_hit).y && bricksprite.getChildAt(j).x == bricksprite.getChildAt(up_hit).x - Roll(Math.cos(anglelist[i])) * BRICK_WIDTH)
							lr_exist = j;
						if(bricksprite.getChildAt(j).y == bricksprite.getChildAt(up_hit).y + Roll(Math.sin(anglelist[i])) * BRICK_HEIGHT && bricksprite.getChildAt(j).x == bricksprite.getChildAt(up_hit).x)
							ud_exist = j;
					}
					if(lr_exist != -1 && ud_exist != -1)
					{
						BrickRemove(Math.max(lr_exist,ud_exist),current_type,anglelist[i],PositionAndDirection(i,lr_exist,ud_direc,'y'));
						BrickRemove(Math.min(lr_exist,ud_exist),current_type,anglelist[i],PositionAndDirection(i,ud_exist,lr_direc,'x'));
					}
					else
					{
						if((-Math.tan(anglelist[i]) * (bricksprite.getChildAt(up_hit).x - Roll(Math.cos(anglelist[i])) * BRICK_WIDTH / 2 - ball1.x) + ball1.y) * Roll(Math.sin(anglelist[i])) >= Roll(Math.sin(anglelist[i])) * bricksprite.getChildAt(up_hit).y + BRICK_HEIGHT / 2)
							insec = 0;
						if(lr_exist != -1)
						{
							if(insec != 0)
								BrickRemove(lr_exist,current_type,anglelist[i],PositionAndDirection(i,up_hit,ud_direc,'y'));
							else
								BrickRemove(up_hit,current_type,anglelist[i],PositionAndDirection(i,up_hit,ud_direc,'y'));
						}
						else if(ud_exist != -1)
						{
							if(insec == 0)
								BrickRemove(ud_exist,current_type,anglelist[i],PositionAndDirection(i,up_hit,lr_direc,'x'));
							else
								BrickRemove(up_hit,current_type,anglelist[i],PositionAndDirection(i,up_hit,lr_direc,'x'));
						}
						else
						{
							if(insec == 0)
								BrickRemove(up_hit,current_type,anglelist[i],PositionAndDirection(i,up_hit,ud_direc,'y'));
							else
								BrickRemove(up_hit,current_type,anglelist[i],PositionAndDirection(i,up_hit,lr_direc,'x'));
						}
					}
				}
			}
		}
	}
	for(i=0;i<ballsprite.numChildren;i++)
	{
		if(ballsprite.getChildAt(i).y - ballsprite.getChildAt(i).height / 2 >= stage.stageHeight)
		{
			ballsprite.removeChildAt(i);
			anglelist.splice(i,1);
			grablist.splice(i,1);
		}//没接住弹球
	}
	if(ballsprite.numChildren == 0)
		Lost();
}//弹球运动


function BonusInit(bx:int,by:int,angle:Number,pro:int=6):void
{
	var p:int = pro
	if(current_type != 0)
		p += 6;
	var bonus_flag:int = Math.floor(Math.random() * p);
	if(bonus_flag == 0)
	{
		new sound_bonus().play();
		var bonus_type:int = Math.floor(Math.random() * 18);
		var bonus1:bonus = new bonus(bonus_type);
		bonus1.x = bx;
		bonus1.y = by;
		bonus1.bonus_angle = angle;
		bonussprite.addChild(bonus1);
	}
}//检测砖块是否掉落道具/道具图像生成


function BonusMove(event:Event):void
{
	var bonus1:bonus;
	for(var i=0;i<bonussprite.numChildren;i++)
	{
		bonus1 = bonussprite.getChildAt(i) as bonus;
		bonus1.x += 4.5 * Math.cos(bonus1.bonus_angle)
		bonus1.y += -4.5 * Math.sin(bonus1.bonus_angle) + 0.09 * bonus1.t;
		bonus1.t += 1
		if(bonus1.x - 17 < 0 || bonus1.x + 17 > stage.stageWidth)
			bonus1.bonus_angle = -bonus1.bonus_angle + Math.PI
	}
	for(i=bonussprite.numChildren-1;i>-1;i--)
	{
		bonus1 = bonussprite.getChildAt(i) as bonus;
		if(bonus1.y + bonus1.height / 2 > pad1.y - pad1.height / 2 + 7.5 && bonus1.x > pad1.x - pad1.width / 2 - bonus1.width / 2 && bonus1.x < pad1.x + pad1.width / 2 + bonus1.width / 2)
		{
			new sound_get().play();
			BonusEffect(bonus1.bonus_type);
			bonussprite.removeChild(bonus1);
		}//接住道具
		else if(bonus1.y - bonus1.height / 2 >= stage.stageHeight)
		{
			bonussprite.removeChild(bonus1);
		}//没接住道具
	}
}//道具下落


function BonusEffect(type:int):void
{
	switch(type)
	{
		case 0:{//长板
			if(pad1.width != 182.2)
				new sound_long().play()
			bonusflaglist[0] = 0;
			timelist[0] = 0;
			pad1.pad_change(2);
			break;
		}
		case 1:{//短板
			if(pad1.width != 53.2)
				new sound_long().play()
			bonusflaglist[0] = 0;
			timelist[0] = 0;
			pad1.pad_change(0);
			break;
		}
		case 2:{//高速
			if(spe != SPEED_FAST)
				new sound_fast().play()
			bonusflaglist[1] = 0;
			timelist[1] = 0;
			spe = SPEED_FAST;
			break;
		}
		case 3:{//低速
			if(spe != SPEED_SLOW)
				new sound_slow().play()
			bonusflaglist[1] = 0;
			timelist[1] = 0;
			spe = SPEED_SLOW;
			break;
		}
		case 4:{//大球
			if(ballsprite.getChildAt(0).width != BALL_BIG)
				new sound_big().play()
			bonusflaglist[2] = 0;
			timelist[2] = 0;
			BallUpdate(BALL_BIG);
			break;
		}
		case 5:{//小球
			if(ballsprite.getChildAt(0).width != BALL_SMALL)
				new sound_small().play()
			bonusflaglist[2] = 0;
			timelist[2] = 0;
			BallUpdate(BALL_SMALL);
			break;
		}
		case 6:{//分身
			if(ballsprite.numChildren == 1 && grablist[0] == -1)
			{
				new sound_three().play()
				for(var i=0;i<2;i++)
				{
					BallInit(ballsprite.getChildAt(0).x,ballsprite.getChildAt(0).y);
					grablist.push(-1);
					if(Math.PI * (2 * i + 1) / 4 != anglelist[0])
						anglelist.push(Math.PI * (2 * i + 1) / 4);
					else
						anglelist.push(Math.PI / 2 + Roll() * Math.PI / 18);
				}
			}
			break;
		}
		case 7:{//爆裂
			if(ballsprite.numChildren == 1 && grablist[0] == -1)
			{
				new sound_many().play()
				for(i=0;i<6;i++)
				{
					BallInit(ballsprite.getChildAt(0).x,ballsprite.getChildAt(0).y);
					grablist.push(-1);
					if(Math.PI * (12 * i + 7) / 36 != anglelist[0])
						anglelist.push(Math.PI * (12 * i + 7) / 36);
					else
						anglelist.push(Math.PI / 2 + Roll() * Math.PI / 4);
				}
			}
			break;
		}
		case 8:{//吸盘
			bonusflaglist[3] = 0;
			timelist[3] = 0;
			new sound_efield().play();
			AnimaGenerate(0,0)
			efieldsprite.visible = true;
			break;
		}
		case 9:{//火炮
			bonusflaglist[4] = 0;
			timelist[4] = 0;
			new sound_gun().play();
			gunsprite.visible = true;
			stage.addEventListener(MouseEvent.MOUSE_DOWN,BulletLaunch);
			break;
		}
		case 10:{//火球
			if(current_type != 1)
			{
				new sound_fire().play();
				AnimaGenerate(0)
				BallUpdate(1);
			}
			bonusflaglist[5] = 0;
			timelist[5] = 0;
			break;
		}
		case 11:{//生命
			new sound_life().play()
			LifeInit();
			break;
		}
		case 12:{//死亡
			new sound_death().play()
			for(i=ballsprite.numChildren-1;i>-1;i--)
				ballsprite.removeChildAt(i);
			anglelist = new Array();
			grablist = new Array();
			Lost();
			break;
		}
		case 13:{//雷电
			new sound_thunder().play()
			var limit:int = Math.min(THUNDER_AMOUNT,bricksprite.numChildren);
			for(i=0;i<limit;i++)
			{
				var num:int = Math.floor(Math.random() * bricksprite.numChildren);
				McGenerate(1,bricksprite.getChildAt(num).x+BRICK_WIDTH/2-6,bricksprite.getChildAt(num).y-3)
				McGenerate(1,bricksprite.getChildAt(num).x-BRICK_WIDTH/2+7.5,bricksprite.getChildAt(num).y+3)
				BonusInit(bricksprite.getChildAt(num).x,bricksprite.getChildAt(num).y,Math.PI/2);
				bricksprite.removeChildAt(num);
			}
			break;
		}
		case 14:{//毒液
			if(current_type != 2)
			{
				new sound_poiball().play()
				AnimaGenerate(1)
				BallUpdate(2);
			}	
			bonusflaglist[5] = 0;
			timelist[5] = 0;
			break;
		}
		case 15:{//熔岩
			if(current_type != 3)
			{
				new sound_magma().play()
				AnimaGenerate(2)
				BallUpdate(3);
			}
			bonusflaglist[5] = 0;
			timelist[5] = 0;
			break;
		}
		case 16:{//冰球
			if(current_type != 4)
			{
				new sound_startice().play()
				AnimaGenerate(3)
				BallUpdate(4);
			}
			bonusflaglist[5] = 0;
			timelist[5] = 0;
			
			break;
		}
		case 17:{//地震
			new sound_crush().play();
			var brick1:brick;
			for(i=0;i<bricksprite.numChildren;i++)
			{
				brick1 = bricksprite.getChildAt(i) as brick;
				brick1.brick_pierce();
			}
			break;
		}
	}
}//道具生效


function McGenerate(mc_type:int,x:int,y:int,rot:int=0):void
{
	var mc0:spark = new spark();
	var mc1:thunder = new thunder();
	var mc2:explo = new explo();
	var mclist:Array = [mc0,mc1,mc2]
	mclist[mc_type].x = x
	mclist[mc_type].y = y
	mclist[mc_type].scaleX = 0.75
	mclist[mc_type].scaleY = 0.75
	mclist[mc_type].rotation = rot;
	mcsprite.addChild(mclist[mc_type])
}//静态特效生成


function AnimaGenerate(anima_type:int,flag:int=-1):void
{
	if(flag == -1)
	{
		for(var i=0;i<ballsprite.numChildren;i++)
		{
			var anima0:fire = new fire();
			var anima1:poi = new poi();
			var anima2:explosion = new explosion();
			var anima3:snow = new snow();
			var animalist:Array = [anima0,anima1,anima2,anima3]
			animalist[anima_type].x = ballsprite.getChildAt(i).x
			animalist[anima_type].y = ballsprite.getChildAt(i).y
			animalist[anima_type].scaleX = 0.75
			animalist[anima_type].scaleY = 0.75
			animasprite.addChild(animalist[anima_type])
			animamovelist.push(ballsprite.getChildAt(i))
		}
	}
	else
	{
		for(i=0;i<2;i++)
		{
			var anima4:elec2 = new elec2()
			animasprite.addChild(anima4)
			animamovelist.push(efieldsprite.getChildAt(i))
		}
	}
}//动态特效生成


function BonusTimer(event:Event):void
{
	for(var i=0;i<bonusflaglist.length;i++)
	{
		if(bonusflaglist[i] != -1)
			timelist[i] += 1;
		if(timelist[i] >= BONUS_TIME)
		{
			timelist[i] = 0;
			bonusflaglist[i] = -1;
			BonusRemove(i);
		}
	}
}//道具计时器


function BonusRemove(type:int):void
{
	switch(type)
	{
		case 0:{
			pad1.pad_change(1);
			break
		}
		case 1:{
			spe = SPEED_INIT;
			break
		}
		case 2:{
			BallUpdate(BALL_NORMAL);
			break
		}
		case 3:{
			if(grablist.indexOf(0) == -1)
				efieldsprite.visible = false;
			break
		}
		case 4:{
			gunsprite.visible = false;
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,BulletLaunch);
			break
		}
		case 5:{
			BallUpdate(0);
			break
		}
	}
}//道具效果移除


function Lost():void
{
	new sound_fail().play();
	if(bonusflaglist[4] != -1)
		BonusRemove(4);
	BonusRemove(0);
	Start();
	if(lifesprite.numChildren > 0)
		lifesprite.removeChildAt(lifesprite.numChildren-1);
	else
	{
		new sound_in().play()
		tipsprite.getChildAt(1).visible = true
		buttonsprite.getChildAt(0).visible = true
		buttonsprite.getChildAt(1).visible = true
		RemoveListener()
		buttonsprite.getChildAt(0).addEventListener(MouseEvent.CLICK,Restart)
		buttonsprite.getChildAt(0).addEventListener(MouseEvent.MOUSE_OVER,MouseIn)
		buttonsprite.getChildAt(1).addEventListener(MouseEvent.CLICK,BackMenu)
		buttonsprite.getChildAt(1).addEventListener(MouseEvent.MOUSE_OVER,MouseIn)
	}
}//弹球死亡


function Restart(event:MouseEvent):void
{
	new sound_click().play()
	tipsprite.getChildAt(1).visible = false
	buttonsprite.getChildAt(0).visible = false
	buttonsprite.getChildAt(1).visible = false
	buttonsprite.getChildAt(0).removeEventListener(MouseEvent.CLICK,Restart)
	buttonsprite.getChildAt(0).removeEventListener(MouseEvent.MOUSE_OVER,MouseIn)
	buttonsprite.getChildAt(1).removeEventListener(MouseEvent.CLICK,BackMenu)
	buttonsprite.getChildAt(1).removeEventListener(MouseEvent.MOUSE_OVER,MouseIn)
	for(i=lifesprite.numChildren-1;i>-1;i--)
		lifesprite.removeChildAt(i)
	for(i=bricksprite.numChildren-1;i>-1;i--)
		bricksprite.removeChildAt(i)
	CleanUp()
	BallInit(pad1.x,577.25);
	LevelGenerate(level)
}

function CleanUp():void
{
	for(var i=lifesprite.numChildren-1;i>-1;i--)
		lifesprite.removeChildAt(i)
	for(i=bricksprite.numChildren-1;i>-1;i--)
		bricksprite.removeChildAt(i)
	for(i=ballsprite.numChildren-1;i>-1;i--)
		ballsprite.removeChildAt(i)
	for(i=bulletsprite.numChildren-1;i>-1;i--)
		bulletsprite.removeChildAt(i)
	for(i=icesprite.numChildren-1;i>-1;i--)
		icesprite.removeChildAt(i)
	for(i=mcsprite.numChildren-1;i>-1;i--)
		mcsprite.removeChildAt(i)
	for(i=bonussprite.numChildren-1;i>-1;i--)
		bonussprite.removeChildAt(i)
	for(i=animasprite.numChildren-1;i>-1;i--)
		animasprite.removeChildAt(i)
	iceanglelist = new Array()
	animamovelist = new Array()
	bombbricklist = new Array()
	continuelist = new Array()
	LifeInit()
	LifeInit()
}
