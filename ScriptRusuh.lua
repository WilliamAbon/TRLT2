if game.CoreGui:FindFirstChild("RusuhTRLT2") then
	game.CoreGui:FindFirstChild("RusuhTRLT2"):Destroy()
end

local m = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame")
local UIGradient = Instance.new("UIGradient")
local TextButton = Instance.new("TextButton")
local UIPadding = Instance.new("UIPadding")
local TextLabel = Instance.new("TextLabel")

Frame.Active = true
Frame.Draggable = true

m.Name = "RusuhTRLT2"

Frame.Parent = m
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, 0, 0.47551021, 0)
Frame.Size = UDim2.new(0, 142,0, 54)

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(9, 2, 5)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(39, 9, 9))}
UIGradient.Parent = Frame

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(143, 35, 35)
TextButton.BackgroundTransparency = 0.500
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0, 0,0.352, 0)
TextButton.Size = UDim2.new(1, 0,0.65, 0)
TextButton.Font = Enum.Font.Ubuntu
TextButton.Text = "Off"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 14.000
TextButton.TextWrapped = true

UIPadding.Parent = Frame
UIPadding.PaddingBottom = UDim.new(0, 5)
UIPadding.PaddingLeft = UDim.new(0, 5)
UIPadding.PaddingRight = UDim.new(0, 5)

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(-0.038, 0,0, 0)
TextLabel.Size = UDim2.new(0.873, 0,0.296, 0)
TextLabel.Font = Enum.Font.Ubuntu
TextLabel.Text = "Script Rusuh TRLT2"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1

if not getgenv().Network then
	getgenv().Network = {
		BaseParts = {},
		Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
	}

	Network.RetainPart = function(Part)
		if typeof(Part) == "Instance" and Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
			table.insert(Network.BaseParts, Part)
			Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
			Part.CanCollide = false
		end
	end

	local function EnablePartControl()
		LocalPlayer.ReplicationFocus = Workspace
		RunService.Heartbeat:Connect(function()
			sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
			for _, Part in pairs(Network.BaseParts) do
				if Part:IsDescendantOf(Workspace) then
					Part.Velocity = Network.Velocity
				end
			end
		end)
	end

	EnablePartControl()
end

local function ForcePart(v)
	if v:IsA("Part") and not v.Anchored and not v.Parent:FindFirstChild("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
		for _, x in next, v:GetChildren() do
			if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity") or x:IsA("RocketPropulsion") then
				x:Destroy()
			end
		end
		if v:FindFirstChild("Attachment") then
			v:FindFirstChild("Attachment"):Destroy()
		end
		if v:FindFirstChild("AlignPosition") then
			v:FindFirstChild("AlignPosition"):Destroy()
		end
		if v:FindFirstChild("Torque") then
			v:FindFirstChild("Torque"):Destroy()
		end
		v.CanCollide = false
		local Torque = Instance.new("Torque", v)
		Torque.Torque = Vector3.new(100000, 100000, 100000)
		local AlignPosition = Instance.new("AlignPosition", v)
		local Attachment2 = Instance.new("Attachment", v)
		Torque.Attachment0 = Attachment2
		AlignPosition.MaxForce = 9999999999999999
		AlignPosition.MaxVelocity = math.huge
		AlignPosition.Responsiveness = 200
		AlignPosition.Attachment0 = Attachment2
		AlignPosition.Attachment1 = Attachment1
	end
end

local blackHoleActive = false

local function toggleBlackHole()
	blackHoleActive = not blackHoleActive
	if blackHoleActive then
		TextButton.Text = "On"
	else
		TextButton.Text = "Off"
	end
	if blackHoleActive then
		for _, v in next, Workspace:GetDescendants() do
			ForcePart(v)
		end

		Workspace.DescendantAdded:Connect(function(v)
			if blackHoleActive then
				ForcePart(v)
			end
		end)

		spawn(function()
			while blackHoleActive and RunService.Heartbeat:Wait() do
				Attachment1.WorldCFrame = humanoidRootPart.CFrame
			end
		end)
	end
end

TextButton.MouseButton1Click:Connect(toggleBlackHole)
--sengaja gw bikin script yang di bawah ini bikin ga bisa di baca
return(function(...)local T={"\065\111\078\109\087\053\068\043\105\104\080\075\087\090\061\061","\102\085\112\099\068\118\120\085\105\098\116\111\087\120\105\106\112\090\061\061","\054\043\097\065\118\052\109\052\099\049\090\087\076\112\050\066\110\090\061\061";"\055\111\078\075\055\118\098\086\087\085\121\061","\085\078\109\081\074\084\061\061";"\119\120\090\083\068\113\098\099\072\067\080\120\052\066\070\117\050\054\057\050\065\067\090\070\098\054\067\117\065\049\049\088\065\085\043\085\114\122\079\118\055\054\120\119\104\089\098\066\053\122\055\054\090\073\110\098\069\089\101\114\120\077\108\108\071\117\083\053\065\071\120\048\083\114\084\106\108\078\075\088\078\089\121\072\098\089\116\115\120\104\099\086\100\087\086\081\116\081\070\061","\102\109\082\071\047\084\084\110\102\119\061\061","\102\086\084\080\087\107\114\116\102\084\061\061";"\055\111\079\086\065\111\047\061";"\119\052\050\050\105\088\061\061";"","\119\085\109\073\112\120\050\113\073\120\087\085\055\069\087\052\120\120\080\075","\120\118\113\114\068\079\057\100\047\098\081\071\068\085\088\071\118\119\061\061","\105\104\120\108\065\106\087\080";"\119\104\086\055\087\075\098\056\048\082\070\107\056\110\118\073","\084\088\086\115\055\084\061\061","\073\118\090\090\120\080\067\056\110\079\055\109\055\106\087\057";"\102\084\061\061";"\104\071\068\052\082\068\107\072","\085\098\078\116\065\104\112\080\110\088\061\061","\081\100\109\109\105\084\061\061","\068\103\080\114\055\106\105\100\068\111\067\104\072\103\113\115";"\105\100\120\043\065\118\120\043\081\085\112\109\081\104\113\080","\121\118\111\079\098\107\106\090\089\116\106\080\116\109\050\066\121\105\067\069\112\088\061\061";"\105\104\120\113\055\118\120\089\055\088\061\061","\065\048\103\061","\072\069\067\100\073\098\087\071\055\053\087\050\055\048\109\117\118\088\061\061","\085\098\078\051\087\118\071\061";"\105\104\079\075\087\111\078\108","\114\049\070\107\077\081\116\102\101\056\048\074\073\076\043\101\109\084\061\061";"\087\106\068\098\081\084\061\061";"\070\057\119\090\070\043\113\070\070\043\103\100\102\120\087\119\073\088\061\061","\109\068\078\072\079\119\061\061","\085\098\078\108\087\085\112\109\055\111\079\086\065\111\047\061";"\111\052\080\103\075\090\061\061","\105\106\112\049\073\118\056\052";"\065\118\079\043\073\088\061\061";"\055\111\078\089\055\053\067\116\065\104\105\061";"\088\071\115\089\109\122\107\069\117\088\069\057\101\074\100\074\122\100\067\105\056\077\119\088\069\090\056\115\117\099\103\043\103\110\068\086\078\074\079\078\043\055\051\103\106\099\086\054\086\067\067\118\072\108\067\104\112\049\055\074\070\097\074\078\053\076\103\061";"\113\079\103\061";"\073\098\109\076","\087\100\098\109\055\111\068\114","\047\098\112\107\070\057\116\113\083\120\105\071\055\118\068\047";"\115\114\117\111\108\084\061\061","\072\053\112\043\105\103\055\080\055\088\061\061","\087\104\113\097\065\106\121\061","\068\120\087\116\120\080\120\052\070\043\121\056\105\048\105\071";"\087\085\067\049\065\106\121\061";"\122\070\084\071\086\047\118\111\121\084\061\061","\120\111\079\108\105\111\120\049\121\103\112\080\055\111\120\069\055\111\120\057\121\119\061\061","\055\118\056\090\081\118\068\115";"\087\048\079\070\110\057\112\090\072\057\078\075\087\053\067\107\072\083\084\061","\081\052\080\043\087\119\061\061","\088\118\101\107\043\053\076\067\114\052\085\082\116\098\071\061";"\087\100\079\108\087\119\061\061","\112\100\120\043\047\100\120\049\055\104\080\069\087\119\061\061","\054\102\072\117\122\098\108\043\118\119\061\061","\065\048\121\061";"\081\100\078\075\081\100\079\043","\072\080\068\074\083\057\120\075\081\100\078\057\087\119\061\061";"\085\098\078\052\081\090\061\061","\065\111\120\075","\072\079\121\090\118\120\109\118\070\089\080\112\105\085\080\073\105\083\070\061","\072\048\068\113\072\089\119\089\118\088\061\061";"\118\057\116\109\105\079\055\069\102\111\116\118\119\098\109\066\047\088\061\061";"\087\114\110\089";"\118\104\089\071\100\117\081\121\087\086\110\112\116\043\090\061","\105\111\068\109\065\111\090\061"}for Y,I in ipairs({{582548-582547,-531781-(-531849)},{-801113+801114,-330434-(-330476)};{-542974-(-543017),-655873-(-655941)}})do while I[116960-116959]<I[-83379-(-83381)]do T[I[-650719-(-650720)]],T[I[181632-181630]],I[-836731-(-836732)],I[-297095+297097]=T[I[444744-444742]],T[I[966673-966672]],I[-344370+344371]+(-5089-(-5090)),I[-626989+626991]-(29814-29813)end end local function Y(Y)return T[Y+(891725-876946)]end do local Y=string.char local I=type local f=math.floor local O=T local V=table.concat local F={o=-1008409+1008415;["\050"]=-356814+356815;e=992291-992228;D=-209899-(-209912),A=-844036-(-844063);["\048"]=310886+-310883,k=-214099-(-214101),t=-1028180+1028221;v=991823+-991801,["\043"]=-568251-(-568303);p=-672933+672950,E=-346338+346373;N=-869854-(-869915);I=550511-550485;["\049"]=-856293+856343,n=-331545-(-331575);C=771303-771294,M=863185-863126;F=-976273+976285;Z=1031449+-1031401;m=159117+-159084,c=-423131-(-423142),a=411820-411773;["\054"]=82370+-82308,R=-999320-(-999351),W=295947-295922;U=754811-754788,g=919917+-919913;x=-144776+144797,J=-620371+620386;K=831323+-831277,["\057"]=-379819+379855,s=231883+-231840;P=953057-953020;["\056"]=19921+-19864,y=803386+-803378,i=-96702+96730;w=-952737-(-952753);j=168604-168549,d=-375711-(-375765),B=-1004941+1004951,T=391141-391109,X=-578620-(-578620);["\055"]=-1041346+1041375,["\053"]=-392425-(-392432),H=203619+-203601;G=-1007955+1008011,l=-351780+351825,Q=-989582-(-989606);O=536388+-536383;u=362898-362840;q=48409+-48360;V=-582011+582045;["\051"]=-86268+86312;b=192334-192281;["\052"]=-990483+990522;f=-507919+507933,S=618291-618272,r=-383958-(-383998);Y=-207542+207593;h=571864-571826,z=310899-310839,["\047"]=-89743+89763,L=811226+-811184}local A=string.sub local D=string.len local n=table.insert for T=14887+-14886,#O,-937095+937096 do local q=O[T]if I(q)=="\115\116\114\105\110\103"then local I=D(q)local v={}local t=311862-311861 local G=890461-890461 local B=-837399-(-837399)while t<=I do local T=A(q,t,t)local O=F[T]if O then G=G+O*(543587+-543523)^((11611-11608)-B)B=B+(-754774-(-754775))if B==1020002-1019998 then B=752376-752376 local T=f(G/(334337-268801))local I=f((G%(-546193-(-611729)))/(-223188-(-223444)))local O=G%(1004895-1004639)n(v,Y(T,I,O))G=-348062-(-348062)end elseif T=="\061"then n(v,Y(f(G/(-216355-(-281891)))))if t>=I or A(q,t+(-441019-(-441020)),t+(638240+-638239))~="\061"then n(v,Y(f((G%(748265-682729))/(-877909+878165))))end break end t=t+(903760-903759)end O[T]=V(v)end end end return(function(T,f,O,V,F,A,D,n,g,l,o,Q,h,j,B,I,b,s,G,q,v,t)G,n,v,h,j,g,b,o,s,Q,l,I,B,q,t=function(T)for Y=-536143-(-536144),#T,-895398+895399 do q[T[Y]]=(-718188-(-718189))+q[T[Y]]end if O then local I=O(true)local f=F(I)f[Y(46547-61264)],f[Y(-253993+239249)],f[Y(171073+-185850)]=T,B,function()return-1625222-(-253878)end return I else return V({},{[Y(20454+-35198)]=B;[Y(423675-438392)]=T;[Y(320132+-334909)]=function()return 906615+-2277959 end})end end,{},function()t=t+(660958+-660957)q[t]=735093-735092 return t end,function(T,Y)local f=G(Y)local O=function(O,V,F,A)return I(T,{O;V,F;A},Y,f)end return O end,function(T,Y)local f=G(Y)local O=function(O,V,F)return I(T,{O;V;F},Y,f)end return O end,function(T,Y)local f=G(Y)local O=function(O)return I(T,{O},Y,f)end return O end,function(T,Y)local f=G(Y)local O=function(...)return I(T,{...},Y,f)end return O end,function(T,Y)local f=G(Y)local O=function(O,V,F,A,D)return I(T,{O;V,F,A,D},Y,f)end return O end,function(T,Y)local f=G(Y)local O=function()return I(T,{},Y,f)end return O end,function(T)q[T]=q[T]-(1020295+-1020294)if q[T]==-679940+679940 then q[T],n[T]=nil,nil end end,function(T,Y)local f=G(Y)local O=function(O,V)return I(T,{O;V},Y,f)end return O end,function(I,O,V,F)local k,R,D,E,x,a,K,W,P,p,N,Z,H,M,q,r,i,b,d,U,z,e,L,J,y,C,S,G,t,m,w,B,c,X while I do if I<8841071-935735 then if I<3956485-384456 then if I<2116881-(-55445)then if I<4138+1579971 then if I<1246604-26501 then if I<845360+59264 then if I<-135034-(-654189)then w=-947405-(-947407)X=x[w]I=-472591+8485273 w=n[L]Z=X==w K=Z else E=-1018064+1018064 U=-976537-(-976792)t=G I=n[V[-1034325-(-1034326)]]d=I(E,U)q[t]=d t=nil I=-501291+7063365 end else d=nil B=nil e=nil I=5170089-(-825777)end else if I<-115172+1656283 then q=Y(631091+-645846)D=Y(-558455+543698)I=T[D]D=I(q)D={}I=T[Y(-725504+710746)]else G=n[V[304328-304319]]t=497420-497419 I={}q=I B=G G=-882952+882953 b=G G=-773566+773566 e=b<G G=t-b I=-179758+6741832 end end else if I<2291909-554729 then if I<-959044+2596124 then D=-750720+4877710 t=Y(-97369+82642)G=564569+13083135 q=t^G I=D-q q=I D=Y(-226357+211616)I=D/q D={I}I=T[Y(-509031-(-494296))]else P=Q(P)R=Q(R)I=601202+9968857 L=Q(L)N=Q(N)y=Q(y)k=Q(k)x=nil end else if I<-238263+2193295 then p=p+i M=not z E=p<=U E=M and E M=p>=U M=z and M E=M or E M=2818308-727760 I=E and M E=926401-(-282569)I=I or E else W=Y(654081+-668850)E=p H=T[W]W=Y(-467413+452661)r=H[W]H=r(q,E)r=n[V[-941076+941082]]W=r()J=H+W c=J+e J=73224+-72968 M=c%J J=G[t]e=M I=983317+950806 W=53904-53903 H=e+W r=B[H]E=nil c=J..r G[t]=c end end end else if I<3345077-273923 then if I<3280145-607629 then if I<3123443-867076 then if I<1637066-(-607003)then P=not k J=J+R c=J<=a c=P and c P=J>=a P=k and P c=P or c P=-871960+8614916 I=c and P c=-486060+3983409 I=I or c else W=Y(382101+-396868)R=Y(-1050938-(-1036227))I=T[W]a=T[R]W=I(a)I=Y(951968-966715)T[I]=W I=67758+10000584 end else I=true I=I and 13300428-1016960 or 6529643-916757 end else if I<3386752-446786 then U=v()n[U]=D c=j(825095+794127,{})i=-919902+919967 p=-309438+309441 W=Y(809593-824360)I=n[d]D=I(p,i)p=v()M=Y(204600+-219337)I=-236096+236096 i=I n[p]=D I=-247746-(-247746)z=I D=T[M]M={D(c)}D=-91174+91176 I={f(M)}M=I I=M[D]D=Y(-113033+98300)c=I I=T[D]J=n[G]H=T[W]W=H(c)H=Y(496155+-510884)r=J(W,H)J={r()}D=I(f(J))J=v()n[J]=D D=1028472-1028471 r=n[p]H=r r=969945-969944 W=r r=-835717+835717 I=10930379-360320 a=W<r r=D-W else B=Q(B)b=Q(b)i=nil E=nil G=Q(G)t=Q(t)e=nil E=Y(-581217-(-566489))U=Q(U)d=Q(d)t=nil J=Q(J)c=nil G=nil p=Q(p)M=nil c=380176+-380175 z=nil e=Y(-357379-(-342611))b=T[e]e=Y(-169297-(-154538))B=b[e]b=v()d=Y(-641678-(-626910))p=v()n[b]=B e=T[d]d=Y(715503-730279)B=e[d]d=T[E]E=Y(-776190+761467)e=d[E]z=v()U=Y(-1060821-(-1046052))E=T[U]J=555228+-554972 U=Y(523386-538102)d=E[U]U=v()a=J M={}i={}E=-673019+673019 n[U]=E E=-189394+189396 n[p]=E E={}I=1326601-(-876708)J=-834883-(-834884)n[z]=i i=-103928+103928 R=J J=436766-436766 k=R<J J=c-R end end else if I<3990716-566771 then if I<2487775-(-771450)then G=Y(837014-851742)t=T[G]G=Y(657571-672294)I=T[Y(-138417-(-123702))]q=t[G]G=n[V[706637-706636]]t={q(G)}D={f(t)}else m=n[t]I=m and 10795837-(-538660)or-504136+10216330 K=m end else if I<2901422-(-643385)then J=#M I=544706+7527861 a=-972269-(-972269)c=J==a else k=Y(81189+-95957)R=v()N=-65760+66015 n[R]=r D=T[k]P=-683834+683934 k=Y(-866158+851382)I=D[k]k=57204-57203 D=I(k,P)P=889466+-889466 k=v()n[k]=D I=n[d]D=I(P,N)P=v()x=-152325+152327 n[P]=D N=-376922-(-376923)I=n[d]y=n[k]D=I(N,y)C=-976221+976221 L=874203-874202 N=v()n[N]=D D=n[d]y=D(L,x)S=-449169+459169 D=-483801-(-483802)I=y==D D=Y(-14898-(-169))x=Y(-315393-(-300674))Z=Y(883718-898485)y=v()n[y]=I m=T[Z]X=n[d]w={X(C,S)}I=Y(-265238-(-250464))Z=m(f(w))m=Y(-952088+937369)K=Z..m I=c[I]L=x..K x=Y(-522256+507519)I=I(c,D,L)L=v()n[L]=I K=g(798516+13186876,{d,R,p,G,t,J,y;L;k,N,P,U})D=T[x]x={D(K)}I={f(x)}x=I I=n[y]I=I and 10371021-(-550225)or-792370+4068468 end end end end else if I<982624+4211321 then if I<4217876-(-272236)then if I<-472512+4608119 then if I<4812246-1019507 then if I<968002+2654766 then G=429458+-429253 t=n[V[-889056-(-889058)]]q=t*G t=2252077393995-353330 D=q+t q=35184372167100-78268 I=D%q n[V[-590903-(-590905)]]=I t=1015960+-1015959 q=n[V[-786810+786813]]I=651996+15338830 D=q~=t else n[t]=D I=1543958-(-129820)end else U=l(803960+10128188,{})E=Y(-103026+88289)D=Y(-36151+21418)I=T[D]q=n[V[-833208+833212]]B=Y(890195-904962)G=T[B]d=T[E]E={d(U)}e={f(E)}d=-201251-(-201253)b=e[d]B=G(b)G=Y(598522+-613251)t=q(B,G)q={t()}D=I(f(q))q=D t=n[V[-885176+885181]]D=t I=t and 9218800-(-184723)or-380363+16229438 end else if I<-955768+5385823 then I=n[V[-292662-(-292672)]]t=n[V[-602460-(-602471)]]q[I]=t I=n[V[486945-486933]]t={I(q)}I=T[Y(-177147-(-162405))]D={f(t)}else q=n[V[-516447+516448]]D=#q q=-152209+152209 I=D==q I=I and 3873496-297484 or 4007967-766246 end end else if I<4477055-(-144047)then if I<3655104-(-878360)then w=99568-99567 m=I X=x[w]w=false Z=X==w K=Z I=Z and 717299+-408629 or 8321379-308697 else t=n[V[-722929-(-722931)]]G=n[V[319210-319207]]q=t==G I=740803+12459939 D=q end else if I<4519453-(-190656)then D={}I=true n[V[-101603+101604]]=I I=T[Y(66259-81012)]else q=O[-489444+489445]t=O[834188-834186]I=n[V[885977+-885976]]G=I I=G[t]I=I and 10067600-(-175631)or-1040055+17704511 end end end else if I<-818729+7906923 then if I<5917424-(-389996)then if I<5591769-(-505397)then if I<590641+5149370 then D={}I=T[Y(-54587-(-39809))]else I=T[Y(-554887+540125)]D={t}end else I=n[V[-702716-(-702723)]]I=I and 10130965-115191 or 1196674-(-358187)end else if I<8024973-956586 then d=not e G=G+b t=G<=B t=d and t d=G>=B d=e and d t=d or t d=1514908-807106 I=t and d t=151838+4180834 I=I or t else I=647941+12241418 H=i==z r=H end end else if I<-520604+7847927 then if I<7944835-697371 then Z=nil J=v()c={}R=v()a=s(-398564+4846597,{J,U;p;b})P={}n[J]=c c=v()n[c]=a y=Y(797163-811880)a={}k=Y(123227-137941)n[R]=a a=T[k]e=nil L=n[R]M=nil x=Y(516481-531252)b=Q(b)B=nil N={[y]=L;[x]=Z}b=Y(-585275+570525)k=a(P,N)a=h(5087955-84937,{R,J,z;U;p;c})z=Q(z)D={}p=Q(p)N=Y(-397767+383019)c=Q(c)G=a p=Y(-1011877+997105)U=Q(U)J=Q(J)B=T[b]R=Q(R)E=nil d=nil E=Y(888411+-903142)i=nil i=-923664+867330218403 U=1164079088430-(-147184)b=Y(-596370+581610)c=Y(-577578+562812)b=B[b]t=k d=G(E,U)e=t[d]M=7320177223089-219233 b=b(B,e)E=Y(249986+-264755)e=Y(-759165-(-744429))B=T[e]e=B(b)B=e()z=-841213+30518433189248 y=-344674+5845353712899 d=T[E]U=G(p,i)Z=9890115125270-(-512487)E=t[U]J=21623+22580812207260 I=T[Y(-991722+976998)]R=Y(-772036+757286)e=d[E]i=Y(-918495-(-903763))p=G(i,z)U=t[p]i=Y(-106449-(-91715))z=-978101+1155183980238 E=B[U]p=G(i,z)X=23264857758704-684447 U=t[p]z=Y(282921-297696)i=G(z,M)p=t[i]i=Y(-531558-(-516793))M=-8333+18862643282652 z=7960641753855-(-949115)d=e(E,U,p)p=G(i,z)U=t[p]z=Y(-833481-(-818725))E=B[U]e=E..d E=e i=G(z,M)p=t[i]M=G(c,J)z=t[M]a=T[R]P=G(N,y)R=t[P]N=30139013802128-(-282178)J=a[R]P=Y(323261+-337999)R=G(P,N)x=Y(913844-928566)a=t[R]L=1023106+8081881641521 R=Y(-24762+10041)P=-535312+8242567068174 c=J[a]N=426448+26252354956784 a=G(R,P)J=t[a]e=nil M=c[J]R=Y(-674193-(-659454))i=z..M c=Y(-617886+603135)J=-416301+11305014996669 U={[p]=i}i=Y(634050-648800)B=nil p=T[i]M=G(c,J)z=t[M]d=nil i=Y(204276+-219025)i=p[i]i=i(p,z)P=31571+7117505466783 p=Y(-73687+58942)b=nil M=Y(-1040077+1025365)y=-415871+30614459224110 p=i[p]p=p(i,U)z=T[M]a=G(R,P)J=t[a]P=Y(47907-62625)R=G(P,N)a=t[R]N=Y(-459104-(-444334))P=G(N,y)y=Y(672930-687660)R=t[P]N=G(y,L)P=t[N]L=G(x,Z)Z=Y(92139+-106852)y=t[L]x=G(Z,X)U=nil Z=667413+7539544776353 i=nil L=t[x]N={[y]=L}x=Y(-411272-(-396511))L=G(x,Z)y=t[L]c={[J]=E,[a]=R,[P]=N,[y]=p}G=nil t=nil M=z(c)E=nil p=nil else I=s(14413850-(-753477),{B})H={I()}I=T[Y(691771+-706511)]D={f(H)}end else if I<1008473+6783524 then I=3216194-1012885 c=J P=c M[c]=P c=nil else J=#M a=913602-913602 c=J==a I=c and 8109974-994876 or 7189104-(-883463)end end end end end else if I<-656362+13456060 then if I<-570018+11227055 then if I<488630+9322014 then if I<8980384-(-72923)then if I<-677147+8765893 then if I<8991571-951464 then D=K I=m I=60735+3576873 else J=974807+-974806 a=#M c=B(J,a)P=-7265+7266 J=e(M,c)I=567044+7309342 a=n[z]k=J-P R=d(k)a[J]=R c=nil J=nil end else I=true I=I and 28044+13503653 or 8323894-1040469 end else if I<752829+8695630 then G=n[V[659258-659252]]I=-425795+16274870 t=G==q D=t else n[t]=K w=n[N]C=656290+-656289 X=w+C Z=x[X]m=i+Z Z=267068-266812 I=m%Z i=I X=n[P]I=1330175-(-343603)Z=z+X X=373575+-373319 m=Z%X z=m end end else if I<10199912-85620 then if I<9588596-(-454951)then q=Y(565164-579921)I=T[q]t=n[V[410711-410703]]G=-575521+575521 q=I(t,G)I=-977183+2532044 else I=2875+2275788 end else if I<354205+10195925 then I=-616595+6612461 else R=not a r=r+W D=r<=H D=R and D R=r>=H R=a and R D=R or D R=4425823-874594 I=D and R D=17046110-339864 I=I or D end end end else if I<-115981+11446551 then if I<11180464-257075 then if I<11448892-554913 then if I<-839155+11707651 then I=true I=I and-388102+13733912 or-103116+16686958 else M=Y(559097+-573825)z=T[M]I=14231520-(-368232)M=Y(-757170-(-742416))i=z[M]U=i end else K=n[t]I=K and 4976319-462503 or 4576589-938981 D=K end else if I<11529674-511401 then D=213204+1635266 t=Y(-467015-(-452251))G=2274359-8632 q=t^G I=D-q q=I D=Y(-342487-(-327762))I=D/q D={I}I=T[Y(-378503-(-363783))]else I=-401130+3313300 p=Y(362233+-376987)U=T[p]D=U end end else if I<12435197-119396 then if I<-42075+11642101 then I=-823172+10535366 Z=-90740+90741 m=x[Z]K=m else W=278994+-278993 a=387979-387973 I=n[d]H=I(W,a)I=Y(-973722-(-958975))a=Y(865610-880357)T[I]=H W=T[a]a=333740+-333738 I=W>a I=I and 1975655-(-279024)or 15101413-(-1034091)end else if I<-737167+13447769 then e=n[b]D=e I=-334599+15042759 else t=n[V[711258-711255]]G=55382+-55350 q=t%G U=160751-160749 B=n[V[489582-489578]]d=n[V[1000694+-1000692]]c=n[V[634989+-634986]]M=c-q i=-1019315-(-1019328)c=-158663+158695 z=M/c p=i-z E=U^p I=-1017566+4259287 e=d/E b=B(e)E=-149979-(-149980)B=4294099055-(-868241)G=b%B b=-993730+993732 B=b^q t=G/B B=n[V[-417483-(-417487)]]d=t%E E=628728+4294338568 e=d*E b=B(e)B=n[V[-898340+898344]]d=343273-277737 e=B(t)G=b+e U=733644-733388 b=637268-571732 t=nil B=G%b e=G-B b=e/d q=nil i=279447+-279191 d=63469-63213 e=B%d G=nil E=B-e d=E/U U=13797-13541 E=b%U B=nil p=b-E U=p/i b=nil p={e;d;E,U}U=nil d=nil e=nil n[V[-706909-(-706910)]]=p E=nil end end end end else if I<15440523-343491 then if I<594724+13008568 then if I<13652412-178139 then if I<946498+12279952 then if I<226454+12763548 then n[t]=r I=n[t]I=I and 14563523-966362 or 13966840-320225 else I=D and 670256+3325067 or 6234425-(-35003)end else q=Y(144741-159452)D=Y(883820+-898567)I=T[D]D=T[q]q=Y(-331650-(-316939))T[q]=I q=Y(-704673+689926)I=9843901-(-1003409)T[q]=D q=n[V[-350089+350090]]t=q()end else if I<-627755+14212518 then I=249676+2028987 else I=-486703+3437455 end end else if I<-964012+15138034 then if I<14327998-446437 then I=true I=-603940+7887365 else t=n[V[766480+-766479]]b=-926596+926598 B=826622-826621 G=t(B,b)t=-340678+340679 q=G==t I=q and-907206+14107948 or 5571736-998438 D=q end else if I<-628064+15243269 then I=p I=U and 337569+2574601 or 849878+10251268 D=U else e=D d=Y(1035721+-1050489)D=T[d]E=Y(1027954-1042682)d=Y(910049-924825)I=D[d]d=v()n[d]=I D=T[E]E=Y(998165+-1012911)I=D[E]p=I z=Y(-735295-(-720567))E=I i=T[z]I=i and 11589850-718019 or 15045193-445441 U=i end end end else if I<-1000068+17030842 then if I<16839556-982270 then if I<14883004-(-918300)then if I<14768279-(-405385)then I=-892433+11739743 else b=v()t=v()G=Y(445127-459896)I=true n[t]=I D=T[G]G=Y(318603+-333366)q=O I=D[G]B=v()G=v()n[G]=I I=h(1538801-301891,{})n[B]=I d=Y(767434-782171)I=false E=o(155831+4481393,{b})n[b]=I e=T[d]d=e(E)D=d I=d and 12348805-(-302729)or 15518218-810058 end else n[V[102594-102589]]=D q=nil I=588582+5680846 end else if I<-629554+16525456 then G=932759-932758 t=n[V[497338+-497335]]q=t~=G I=q and-340211+13054364 or 329341+15661485 else G=-9447+9461 t=n[V[-465099+465102]]q=t*G t=-784737-(-784994)D=q%t I=-991918+16851399 n[V[389197-389194]]=D end end else if I<-552328+17155729 then if I<16480702-(-88770)then a=Y(660749+-675496)I=T[a]a=Y(396559+-411270)T[a]=I I=10548722-480380 else I=T[Y(974295-989068)]D={}end else if I<16089070-(-575766)then I={}n[V[-72743+72745]]=I b=35184372299871-211039 E=Y(964702-979471)d=-50776+51031 D=n[V[-512459-(-512462)]]B=D D=t%b n[V[544361-544357]]=D e=t%d d=-694204+694206 b=e+d I=1546601-(-387522)n[V[-976320-(-976325)]]=b d=T[E]E=Y(-646115+631372)p=-731030+731031 e=d[E]d=e(q)e=Y(-732418-(-717692))U=d E=-741783-(-741784)G[t]=e e=-929952-(-930108)i=p p=-617346-(-617346)z=i<p p=E-i else H=n[t]I=H and 7089530-4989 or-325392+13214751 r=H end end end end end end end I=#F return f(D)end,function(T)local Y,I=589597-589596,T[449541+-449540]while I do q[I],Y=q[I]-(-54285-(-54286)),(-279149-(-279150))+Y if q[I]==-430430+430430 then q[I],n[I]=nil,nil end I=T[Y]end end,{},-23470-(-23470)return(b(14802741-(-374431),{}))(f(D))end)(getfenv and getfenv()or _ENV,unpack or table[Y(-955296+940542)],newproxy,setmetatable,getmetatable,select,{...})end)(...)
