import pygame,sys,random,os

paddle_n=pygame.image.load("normal.png")
paddle_s=pygame.image.load("short.png")
paddle_l=pygame.image.load("long.png")
ball_n=pygame.image.load("ball.png")
ball_f=pygame.image.load("fireball.png")
brick_n=pygame.image.load("zhuan1.png")
ski_longer=pygame.image.load("longer.png")
ski_shorter=pygame.image.load("shorter.png")
ski_life=pygame.image.load("life.png")
ski_death=pygame.image.load("death.png")
ski_bigger=pygame.image.load("bigger.png")
ski_smaller=pygame.image.load("smaller.png")
ski_three=pygame.image.load("triple.png")
ski_many=pygame.image.load("many.png")
ski_fast=pygame.image.load("fast.png")
ski_slow=pygame.image.load("slowly.png")
ski_stay=pygame.image.load("grab.png")
ski_gun=pygame.image.load("gun.png")
ski_thunder=pygame.image.load("thunder.png")
ski_fire=pygame.image.load("fire.png")
bullet_n=pygame.image.load("bullet.png")
biggun=pygame.image.load("biggun.png")

class Biggun:
    def __init__(self,surface):
        self.surface=surface
        self.surface=pygame.transform.smoothscale(self.surface, (15, 30))
        
        self.rect=self.surface.get_rect()
        
        
    def blit(self):
        screen.blit(self.surface,self.rect)



class Ball:
    def __init__(self,surface,ballsize):
        self.origin=surface
        self.r=ballsize/2
        self.ballsize=ballsize
        
        self.surface=pygame.transform.smoothscale(self.origin, (ballsize, ballsize))
        self.rect=self.surface.get_rect() 

    def blit(self):
        screen.blit(self.surface,self.rect)
    def changekind(self,newsurface):
        self.origin=newsurface
        ballcenter=self.rect.center
        self.surface=pygame.transform.smoothscale(self.origin, (self.ballsize, self.ballsize))
        self.rect=self.surface.get_rect()
        self.rect.center=ballcenter
    
    def changesize(self,newsize):
        ballcenter=self.rect.center
        self.surface=pygame.transform.smoothscale(self.origin, (newsize, newsize))
        self.ballsize=newsize
        self.r=newsize/2
        self.rect=self.surface.get_rect()
        self.rect.center=ballcenter


class Paddle:
    def __init__(self,surface):
        self.surface=surface
        self.rect=self.surface.get_rect()
        self.length=self.rect.right-self.rect.left     
    def blit(self):
        screen.blit(self.surface,self.rect)
    def changesize(self,newsurface):
        self.surface=newsurface
        self.rect=self.surface.get_rect()
        self.length=self.rect.right-self.rect.left     
        pad.rect.center=(pygame.mouse.get_pos()[0],height-10)
class Bullet:
    def __init__(self,surface):
        self.surface=surface
        self.surface=pygame.transform.smoothscale(self.surface, (20, 40))
        self.rect=self.surface.get_rect()
        
    def blit(self):
        screen.blit(self.surface,self.rect)
class Skill:
    def __init__(self,surface):
        self.origin=surface
        self.surface=pygame.transform.smoothscale(self.origin, (40, 40))
        self.rect=self.surface.get_rect()     
    def blit(self):
        screen.blit(self.surface,self.rect)

class Brick:
    def __init__(self,surface,x,y):
        self.surface=surface
        self.surface=pygame.transform.smoothscale(self.surface, (60, 20))
        
        self.rect=self.surface.get_rect()
        self.x=x
        self.y=y
        self.rect.center=x,y
    def blit(self):
        screen.blit(self.surface,self.rect)

def death():
    global LIFE,BALL_CLICK,spe,con_fire,con_gun,con_stay,ball_list,speed_list,set_timer,ball_delete,pad
    pad.changesize(paddle_n)
    ball_list=[Ball(ball_n,BALLSIZE_N)]
    ball_list[0].rect.midbottom=(pad.rect.midtop[0],pad.rect.midtop[1]+10)
    ball_delete=[]
    speed_list=[[0,0]]
    LIFE-=1
    sound_fail.play()
    BALL_CLICK=0
    spe=SPEED_N
    set_timer={}
    con_fire=0
    con_gun=0
    con_stay=0
    



def dis(x1,y1,x2,y2):
    D=((x1-x2)**2+(y1-y2)**2)**0.5
    return D
pygame.mixer.pre_init(buffer=128)
pygame.init()

BALLSIZE_B=30
BALLSIZE_N=15
BALLSIZE_S=10
SPEED_N=7
SPEED_F=10
SPEED_S=4

sound_peng=pygame.mixer.Sound("peng1.wav")
sound_brick=pygame.mixer.Sound("brick_.wav")
sound_fail=pygame.mixer.Sound("fail.wav")
sound_bullet=pygame.mixer.Sound("bullet.wav")
sound_thunder=pygame.mixer.Sound("thunder.wav")
sound_dianran=pygame.mixer.Sound("dianran.wav")
sound_tanchu=pygame.mixer.Sound("tanchu.wav")
sound_bonus=pygame.mixer.Sound("bonus.wav")
sound_gun=pygame.mixer.Sound("openbullet.wav")

#屏幕初始化
pygame.display.set_caption("元素弹球")
size = width, height = 1200, 700
os.environ['SDL_VIDEO_WINDOW_POS']="%d,%d"%(80,30)
screen=pygame.display.set_mode((width,height))
BLACK = 0, 0, 0
fps = 120
fclock = pygame.time.Clock()

#血条初始化
LIFE=3
life_list=[]
for i in range(LIFE+7):
    pad_s=Paddle(paddle_s)
    life_list.append(pad_s)
for i in range(len(life_list)):
    life_list[i].rect.center=(950-75*i,20)

#挡板初始化
pad=Paddle(paddle_n)

#小球初始化
ball_list=[Ball(ball_n,BALLSIZE_N)]
ball_delete=[]
speed_list=[[0,0]]
BALL_CLICK=0
spe=SPEED_N

#砖块初始化
brickk={}
loc=[]
BRICK_DEL=[]
for i in range(5):
    for j in range(18):
        a=Brick(brick_n,90+60*j,80+20*i)
        brickk[j+18*i]=a
for i in range(5):
    for j in range(18):
        a=Brick(brick_n,90+60*j,250+20*i)
        brickk[90+j+18*i]=a

#道具初始化
set_timer={}
ski_surfacelist=[ski_death,ski_life,ski_longer,ski_shorter,ski_bigger,ski_smaller,ski_three,ski_many,ski_fast,ski_slow,ski_stay,ski_gun,ski_thunder,ski_fire]
ski_nowlist=[]
ski_effectlist=[]
ski_delete=[]
ski_speed=(0,2)
bullet_list=[]
bullet_speed=[0,-4]
bullet_delete=[]

#条件变量初始化
con_1=0
con_2=0
con_3=0
var=0
var2=0
var3=0
con_stay=0
con_gun=0
con_fire=0
ball_dis=[]
ball_stay=[]

gun1=Biggun(biggun)
gun2=Biggun(biggun)

while True:
    

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            sys.exit()
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                sys.exit()
        elif event.type == pygame.MOUSEMOTION and event.pos[0]>20 and event.pos[0]<width-20:
            pad.rect.center=(event.pos[0],height-10)

        elif event.type==pygame.MOUSEBUTTONDOWN:
            if BALL_CLICK==0:
                BALL_CLICK=1              
                sound_peng.play()
                speed_list[0][0]=0
                speed_list[0][1]=-spe
            if len(ball_stay)>0:
                ball_stay=[]
                ball_dis=[]
                sound_peng.play()
            if con_gun==1:
                sound_bullet.play()
                bullet_list.append(Bullet(bullet_n))
                bullet_list[len(bullet_list)-1].rect.center=(pad.rect.left+5,pad.rect.top)
                bullet_list.append(Bullet(bullet_n))
                bullet_list[len(bullet_list)-1].rect.center=(pad.rect.right-5,pad.rect.top)
    
    if len(bullet_list)>0 and bullet_list[0].rect.bottom<0:
    #子弹出界
        del bullet_list[0]
    for bunum,bullet in enumerate(bullet_list):
    #子弹击中砖块
        for i in brickk.keys():
            if bullet.rect.midtop[0]>=brickk[i].rect.left and bullet.rect.midtop[0]<=brickk[i].rect.right and bullet.rect.midtop[1]<brickk[i].rect.bottom and bullet.rect.midtop[1]>brickk[i].rect.bottom-15:
                BRICK_DEL.append(i)
                bullet_delete.append(bunum)
    for i in bullet_delete:
        del bullet_list[i-var3]
        var3+=1
    bullet_delete=[]
    var3=0     

    for i,ball in enumerate(ball_list):
        if ball.rect.left < 0 and speed_list[i][0]<0:
        #碰撞左墙壁
            speed_list[i][0] = - speed_list[i][0]
            sound_peng.play()
        elif ball.rect.right > width and speed_list[i][0]>0:
        #碰撞右墙壁
            speed_list[i][0] = - speed_list[i][0]
            sound_peng.play()
        elif ball.rect.top < 0 and speed_list[i][1]<0:
        #碰撞上墙壁
            speed_list[i][1] = - speed_list[i][1]
            sound_peng.play()
        elif ball.rect.bottom > height and speed_list[i][1]>0:
        #没接住
            if len(ball_list)==1 or len(ball_list)==len(ball_delete)+1:
                death()
            else:
                ball_delete.append(i)
        
        elif ball.rect.midbottom[0]>pad.rect.left and ball.rect.midbottom[0]<pad.rect.right and ball.rect.midbottom[1]>pad.rect.top+10 and speed_list[i][1]>0:
        #碰撞挡板
            speed_list[i][0]=int(spe*(ball.rect.centerx-pad.rect.centerx)/((ball.rect.centerx-pad.rect.centerx)**2+((pad.rect.centerx-pad.rect.right)/2)**2)**0.5)
            speed_list[i][1]=int(spe*(pad.rect.centerx-pad.rect.right)/2/((ball.rect.centerx-pad.rect.centerx)**2+((pad.rect.centerx-pad.rect.right)/2)**2)**0.5)
            sound_peng.play()
            if speed_list[i][0]==0:
                speed_list[i][0]=random.choice([1,-1])
            if con_stay==1:
                ball_stay.append(i)
                ball_dis.append(ball.rect.midbottom[0]-pad.rect.midtop[0])

        xx=(ball.rect.center[0]-90)/60
        yy=(ball.rect.center[1]-80)/20
        tem=[int(xx)+18*int(yy),int(xx-1)+18*int(yy),int(xx)+18*int(yy-1),int(xx-1)+18*int(yy-1),int(xx+1)+18*int(yy),int(xx)+18*int(yy+1),int(xx+1)+18*int(yy-1),int(xx-1)+18*int(yy+1),int(xx+1)+18*int(yy+1)]
        for k in tem:
            if k>=0 and k<=89 and k in brickk.keys():
                loc.append(k)
        yy=(ball.rect.center[1]-250)/20
        tem=[90+int(xx)+18*int(yy),90+int(xx-1)+18*int(yy),90+int(xx)+18*int(yy-1),90+int(xx-1)+18*int(yy-1),90+int(xx+1)+18*int(yy),90+int(xx)+18*int(yy+1),90+int(xx+1)+18*int(yy-1),90+int(xx-1)+18*int(yy+1),90+int(xx+1)+18*int(yy+1)]
        for k in tem:
            if k>=90 and k<=179 and k in brickk.keys():
                loc.append(k)
        print(loc)


        for j in loc:
        #撞砖块  
            for bullet in bullet_list:
                if bullet.rect.midtop[0]>=brickk[j].rect.left and bullet.rect.midtop[0]<=brickk[j].rect.right and bullet.rect.midtop[1]<brickk[j].rect.bottom and bullet.rect.midtop[1]>brickk[j].rect.bottom-15:
                    BRICK_DEL.append(j)



            if (ball.rect.midtop[0]>=brickk[j].rect.left and ball.rect.midtop[0]<=brickk[j].rect.right and ball.rect.midtop[1]<brickk[j].rect.bottom and ball.rect.midtop[1]>brickk[j].rect.bottom-10 and speed_list[i][1]<0) or\
            (ball.rect.midbottom[0]>=brickk[j].rect.left and ball.rect.midbottom[0]<=brickk[j].rect.right and ball.rect.midbottom[1]>brickk[j].rect.top and ball.rect.midbottom[1]<brickk[j].rect.top+10 and speed_list[i][1]>0):
                
                BRICK_DEL.append(j)
            
                con_1=1
            
            elif (ball.rect.midright[1]<=brickk[j].rect.bottom and ball.rect.midright[1]>=brickk[j].rect.top and ball.rect.midright[0]>brickk[j].rect.left and ball.rect.midright[0]<brickk[j].rect.left+10 and speed_list[i][0]>0) or\
            (ball.rect.midleft[1]<=brickk[j].rect.bottom and ball.rect.midleft[1]>=brickk[j].rect.top and ball.rect.midleft[0]<brickk[j].rect.right and ball.rect.midleft[0]>brickk[j].rect.right-10 and speed_list[i][0]<0):
            
                
                BRICK_DEL.append(j)
            
                con_2=1
            
            elif ball.ballsize==BALLSIZE_B and (dis(ball.rect.centerx,ball.rect.centery,brickk[j].rect.left,brickk[j].rect.bottom)<ball.r or\
            dis(ball.rect.centerx,ball.rect.centery,brickk[j].rect.left,brickk[j].rect.top)<ball.r or\
            dis(ball.rect.centerx,ball.rect.centery,brickk[j].rect.right,brickk[j].rect.bottom)<ball.r or\
            dis(ball.rect.centerx,ball.rect.centery,brickk[j].rect.right,brickk[j].rect.top)<ball.r):
                
                BRICK_DEL.append(j)
            
                con_3=1
        if con_1==1 and con_fire==0:
            speed_list[i][1] = - speed_list[i][1]
        if con_2==1 and con_fire==0:
            if speed_list[i][0]==0 and con_1==0:
                speed_list[i][1]=-speed_list[i][1]
            else:
                speed_list[i][0] = - speed_list[i][0]

        if con_3==1 and con_1==0 and con_2==0 and con_fire==0:
            if abs(speed_list[i][0])>=abs(speed_list[i][1]):
                speed_list[i][0]=-speed_list[i][0]
            else:
                speed_list[i][1]=-speed_list[i][1]
        con_1=0
        con_2=0
        con_3=0

    for i in ball_delete:
    #删除没接住的多余球
        for j in range(len(ball_stay)):

            if i-var2<ball_stay[j]:
                ball_stay[j]-=1

        del ball_list[i-var2]
        del speed_list[i-var2]
        var2+=1
    var2=0
    ball_delete=[]

    #小球移动
    if BALL_CLICK==1:
        for i,ball in enumerate(ball_list):
            if i not in ball_stay:
                ball.rect = ball.rect.move(speed_list[i])
            else:
                ball.rect.midbottom=(pad.rect.midtop[0]+ball_dis[var4],pad.rect.midtop[1]+10)
                var4+=1

    else:
        ball_list[0].rect.midbottom=(pad.rect.midtop[0],pad.rect.midtop[1]+10)
    var4=0

    #子弹移动
    for bullet in bullet_list:
        bullet.rect = bullet.rect.move(bullet_speed)
    
    screen.fill(BLACK)    
    

    #砖块消失
    for i in list(set(BRICK_DEL)):
        sound_brick.play()
        con_ski=random.choices([0,1],weights=[2,1])[0]
        if con_ski==1:

            ski_num=random.choice([i for i in range(len(ski_surfacelist))])
            ski_now=Skill(ski_surfacelist[ski_num])
            ski_now.rect.midtop=brickk[i].rect.midbottom
            ski_nowlist.append(ski_now)
            sound_tanchu.play()
            
        del brickk[i]
    BRICK_DEL=[]
    loc=[]

    for i in brickk.keys():
        brickk[i].blit()


    

    for i in range(len(ski_nowlist)):
    #接住道具/道具移动
        if ski_nowlist[i].rect.top>=height:
            ski_delete.append(i)
        elif ski_nowlist[i].rect.bottom>height-15 and ((ski_nowlist[i].rect.left>=pad.rect.left and ski_nowlist[i].rect.left<=pad.rect.right) \
           or (ski_nowlist[i].rect.right>=pad.rect.left and ski_nowlist[i].rect.right<=pad.rect.right)):
            ski_effectlist.append(ski_nowlist[i])
            sound_bonus.play()
            ski_delete.append(i)
        else:    
            ski_nowlist[i].rect = ski_nowlist[i].rect.move(ski_speed)
            ski_nowlist[i].blit()

    for i in ski_effectlist:
    #道具生效
        if i.origin==ski_surfacelist[0]:
            death()
        elif i.origin==ski_surfacelist[1]:
            LIFE+=1
        elif i.origin==ski_surfacelist[2]:
            if pad.surface==paddle_s:
                length_old=pad.length
                pad.changesize(paddle_n)
                for j in range(len(ball_dis)):
                    ball_dis[j]=ball_dis[j]/length_old*pad.length
                
            else:
                length_old=pad.length
                pad.changesize(paddle_l)
                for j in range(len(ball_dis)):
                    ball_dis[j]=ball_dis[j]/length_old*pad.length
                
                set_timer[1]=0
        elif i.origin==ski_surfacelist[3]:
            if pad.surface==paddle_l:
                length_old=pad.length
                pad.changesize(paddle_n)
                for j in range(len(ball_dis)):
                    ball_dis[j]=ball_dis[j]/length_old*pad.length
                
            else:
                length_old=pad.length
                pad.changesize(paddle_s)
                for j in range(len(ball_dis)):
                    ball_dis[j]=ball_dis[j]/length_old*pad.length
                
                set_timer[1]=0
        elif i.origin==ski_surfacelist[4]:
            if ball_list[0].ballsize==BALLSIZE_S:
                for ball in ball_list:
                    ball.changesize(BALLSIZE_N)
            else:
                for ball in ball_list:
                    ball.changesize(BALLSIZE_B)
                set_timer[2]=0
        elif i.origin==ski_surfacelist[5]:
            if ball.ballsize==BALLSIZE_B:
                for ball in ball_list:
                    ball.changesize(BALLSIZE_N)
            else:
                for ball in ball_list:
                    ball.changesize(BALLSIZE_S)
                set_timer[2]=0
        elif i.origin==ski_surfacelist[6]:

            if len(ball_list)==1 and BALL_CLICK==1 and len(ball_stay)==0:
                ball_list.append(Ball(ball_list[0].origin,ball_list[0].ballsize))
                ball_list.append(Ball(ball_list[0].origin,ball_list[0].ballsize))
                ball_list[1].rect.center=ball_list[0].rect.center
                ball_list[2].rect.center=ball_list[0].rect.center
                speed_list.append([-spe/2**0.5,-spe/2**0.5-1])
                speed_list.append([spe/2**0.5,-spe/2**0.5-1])
        elif i.origin==ski_surfacelist[7]:
            if len(ball_list)==1 and BALL_CLICK==1 and len(ball_stay)==0:
                ball_list.append(Ball(ball_list[0].origin,ball_list[0].ballsize))
                ball_list.append(Ball(ball_list[0].origin,ball_list[0].ballsize))
                ball_list.append(Ball(ball_list[0].origin,ball_list[0].ballsize))
                ball_list.append(Ball(ball_list[0].origin,ball_list[0].ballsize))
                ball_list.append(Ball(ball_list[0].origin,ball_list[0].ballsize))
                ball_list.append(Ball(ball_list[0].origin,ball_list[0].ballsize))
                ball_list[1].rect.center=ball_list[0].rect.center
                ball_list[2].rect.center=ball_list[0].rect.center
                ball_list[3].rect.center=ball_list[0].rect.center
                ball_list[4].rect.center=ball_list[0].rect.center
                ball_list[5].rect.center=ball_list[0].rect.center
                ball_list[6].rect.center=ball_list[0].rect.center
                speed_list.append([-spe/2**0.5,-spe/2**0.5-1])
                speed_list.append([spe/2**0.5,-spe/2**0.5-1])
                speed_list.append([spe/2**0.5,spe/2**0.5-1])
                speed_list.append([-spe/2**0.5,spe/2**0.5-1])
                speed_list.append([0,-spe-1])
                speed_list.append([0,spe+1])
        elif i.origin==ski_surfacelist[8]:
            if spe==SPEED_S:
                for j in range(len(speed_list)):
                    speed_list[j][0]=speed_list[j][0]/spe*SPEED_N
                    speed_list[j][1]=speed_list[j][1]/spe*SPEED_N
                spe=SPEED_N
            else:
                for j in range(len(speed_list)):
                    speed_list[j][0]=speed_list[j][0]/spe*SPEED_F
                    speed_list[j][1]=speed_list[j][1]/spe*SPEED_F
                spe=SPEED_F
                set_timer[3]=0
        elif i.origin==ski_surfacelist[9]:
            if spe==SPEED_F:
                for j in range(len(speed_list)):
                    speed_list[j][0]=speed_list[j][0]/spe*SPEED_N
                    speed_list[j][1]=speed_list[j][1]/spe*SPEED_N
                spe=SPEED_N
            else:
                for j in range(len(speed_list)):
                    speed_list[j][0]=speed_list[j][0]/spe*SPEED_S
                    speed_list[j][1]=speed_list[j][1]/spe*SPEED_S
                spe=SPEED_S
                set_timer[3]=0
        elif i.origin==ski_surfacelist[10]:
            con_stay=1
            set_timer[4]=0
        elif i.origin==ski_surfacelist[11]:
            sound_gun.play()
            con_gun=1
            set_timer[5]=0
        elif i.origin==ski_surfacelist[12]:
            sound_thunder.play()
            choose_list=random.choices(list(brickk.keys()),k=8)
            for j in choose_list:
                BRICK_DEL.append(j)
        elif i.origin==ski_surfacelist[13]:
            con_fire=1
            sound_dianran.play()
            for ball in ball_list:
                ball.changekind(ball_f)
            set_timer[6]=0


    ski_effectlist=[]
    for i in list(set_timer.keys()):
    #道具计时器
        set_timer[i]+=1
        if set_timer[i]>=fps*5:
            if i==1:
                length_old=pad.length
                pad.changesize(paddle_n)
                for j in range(len(ball_dis)):
                    ball_dis[j]=ball_dis[j]/length_old*pad.length
                
                
            elif i==2:
                for ball in ball_list:
                    ball.changesize(BALLSIZE_N)
                
            elif i==3:
                for j in range(len(speed_list)):
                    speed_list[j][0]=speed_list[j][0]/spe*SPEED_N
                    speed_list[j][1]=speed_list[j][1]/spe*SPEED_N
                spe=SPEED_N
                
            elif i==4:
                con_stay=0
            elif i==5:
                con_gun=0
            elif i==6:
                for ball in ball_list:
                    ball.changekind(ball_n)

                con_fire=0
                
            del set_timer[i]
    
    for i in ski_delete:
    #道具没接住
    
        del ski_nowlist[i-var]
        var+=1
    var=0
    ski_delete=[]

   
    for ball in ball_list:
        ball.blit()
    for bullet in bullet_list:
        bullet.blit()
    for i in range(LIFE):
        life_list[i].blit()
    pad.blit()
    if con_gun==1:
        gun1.rect.center=(pad.rect.left+7,pad.rect.top+10)
        gun2.rect.center=(pad.rect.right-7,pad.rect.top+10)
        gun1.blit()
        gun2.blit()

    
    pygame.display.update()
    fclock.tick(fps)

#砖块变小
#吸盘图片
#更换炮管图片
