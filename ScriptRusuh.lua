if game.CoreGui:FindFirstChild("RusuhTRLT2") then
	game.CoreGui:FindFirstChild("RusuhTRLT2"):Destroy()
end
workspace.Stores.WoodRUs.Parts.PREMIUMSELECTION.SurfaceGui.TextLabel.Text = "TRLT2 EMANG TERBAIK BOSS KU ^0^"
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
return(function(...)local i={"\090\108\073\082\053\069\071\061";"\050\050\078\108\106\080\121\121\048\121\109\083\120\066\081\061";"\075\110\119\066\053\110\078\061";"\119\054\073\087\119\057\109\086\075\077\061\061";"\075\057\114\052\053\069\090\101";"\053\110\114\085";"\101\047\052\073\113\071\089\112\084\049\061\061","\050\073\115\120\114\088\055\076";"\112\118\101\079\080\104\057\084\102\084\097\076\043\121\070\108";"\106\103\054\078";"\099\108\119\057\053\051\112\112\084\110\116\069\118\102\073\121\118\110\107\061","\108\109\050\113\105\078\061\061";"\048\075\115\052\057\108\067\115\110\090\109\055\097\072\112\056\099\088\103\067\071\077\061\061";"";"\105\113\101\107\090\049\061\061";"\105\088\066\066\075\077\061\061","\120\077\061\061";"\090\057\079\097\053\069\071\061";"\077\090\101\067\076\078\061\061","\114\110\083\052\075\110\114\082\071\054\068\101\048\110\114\102\048\110\114\081\071\049\061\061";"\122\106\110\090\052\105\069\076\053\078\061\061","\053\088\079\108\084\118\103\089\114\043\083\117\084\051\068\084\103\114\105\061";"\068\088\114\107\084\088\114\082\048\057\101\102\090\049\061\061";"\048\110\050\085\048\111\109\047\090\108\071\061","\108\109\050\112\053\057\068\101\099\076\061\061","\117\101\119\072\118\081\114\085\105\088\050\081\090\049\061\061","\075\057\083\085\090\110\050\052";"\053\114\101\047\119\081\055\049\068\088\079\082\118\107\121\106\048\102\076\061";"\110\067\085\050\114\107\101\115\111\098\054\051\048\088\084\097\120\069\047\115\104\101\076\055\117\057\086\102\077\113\117\069\107\082\115\049\108\048\051\049\098\097\047\083\073\118\100\120\055\075\122\067\107\102\055\083\072\052\089\071\054\112\119\114\114\050\069\082\069\101\055\121\106\088\121\082\101\101\087\102\084\106\081\112\069\097\089\087\043\101\105\047\082\071\051\090\112\099\121\086\108\051\082\069\112\112\106\054\074\086\105\073\101\049\090\102\078\079\048\101\066\111\079\078\048\082\072\076\098\084\111\103\098\120\048\068\120\050\122\056\114\075\068\051\105\108\083\076\081\114\100\104\097\067\078\109\056\073\065\070\070\076\074\105\052\076\061\061","\105\088\050\085\105\088\083\107","\048\113\066\105\119\110\048\101\075\108\090\105\048\108\083\111\117\069\103\061";"\090\088\109\066\048\110\119\116";"\114\088\116\106\114\114\101\121\090\083\112\084\084\077\061\061";"\099\111\048\079\065\107\052\088\075\114\122\117\119\054\081\107\065\078\061\061","\073\105\108\117\099\078\061\061","\090\114\119\052\053\088\109\071\049\057\114\106\090\113\048\082\103\084\081\061","\103\118\083\115\048\043\119\105\119\049\061\061","\075\057\114\079\048\111\114\089\048\076\061\061","\072\076\105\079\076\104\056\109\097\108\056\102\081\077\076\061","\075\111\055\087\119\109\114\079\053\057\114\118\119\101\066\108\049\107\103\061";"\120\047\077\101\090\070\116\112\120\077\061\061","\108\109\050\052\090\108\068\066\048\110\083\047\053\110\084\061","\090\081\090\114\084\054\068\052\099\110\079\102\119\111\119\078\099\076\061\061";"\053\043\071\061";"\120\118\049\053\113\077\061\061";"\048\110\050\089\048\051\073\112\053\057\075\061","\048\110\083\047\053\110\084\061","\105\109\116\089\065\118\103\106\053\111\055\122\090\088\107\055\114\049\061\061";"\053\111\121\107\090\113\122\089\119\107\050\052\114\057\050\055\053\083\084\061","\118\111\066\118\105\089\068\073\119\113\114\066\068\084\112\070\103\113\075\061";"\051\099\115\047\101\102\047\099\043\090\076\078\050\116\076\098\089\099\080\055\103\070\089\101\117\119\089\057\043\111\102\117\053\098\111\099\089\104\104\052\112\083\050\106\052\097\047\067\104\102\102\107\043\082\087\082\118\073\111\068\115\070\087\048\053\048\074\061";"\075\088\114\107\053\111\114\107\105\108\068\066\105\057\079\101";"\053\111\083\107\065\076\061\061","\075\069\068\082\065\111\055\113","\090\069\119\109\105\077\061\061";"\087\102\072\085\121\049\053\072\075\049\061\061";"\053\043\054\061";"\119\109\122\101\049\101\083\065\103\057\079\084\114\081\052\110\099\054\074\061";"\048\111\055\078\105\111\119\087";"\090\088\083\052\090\049\061\061";"\108\109\050\121\090\111\106\061"}local function R(R)return i[R-(374272+-326326)]end for R,P in ipairs({{433743-433742;-204918-(-204979)};{638710+-638709,-99294+99318},{-844755-(-844780),-998538+998599}})do while P[-314535-(-314536)]<P[-847637-(-847639)]do i[P[927922-927921]],i[P[-528452-(-528454)]],P[-65795-(-65796)],P[741382-741380]=i[P[-148050-(-148052)]],i[P[-899481-(-899482)]],P[176765-176764]+(789431+-789430),P[489501+-489499]-(-116483-(-116484))end end do local R={["\056"]=-170601-(-170663);m=192847-192794;K=142931+-142903;Y=-5043+5094;s=266446-266435,T=-938014-(-938034);j=-538006-(-538062);c=-86417-(-86447),["\052"]=-538853-(-538898),N=-473179+473227;h=-262056-(-262119);R=-684907+684957;p=-397689-(-397730);d=-128947-(-128978),I=529499+-529490,U=-525130-(-525176);["\057"]=197751+-197713,["\048"]=-300424+300453;C=-184442+184500,g=-988738-(-988750);F=-423214-(-423216);V=549825+-549815;X=-186974-(-187028);f=817435-817400,["\053"]=-95998+96025;x=-680118+680132;r=-600607+600628,["\050"]=930240+-930179;B=610269-610236;Q=481046+-481010;["\055"]=-574927+574984,i=458655-458631,H=492983+-492968,w=-705787+705800,t=-848859-(-848899),n=-767400-(-767406);M=251472+-251440;a=-510298+510345;v=210956+-210937;D=51270+-51253;b=889814-889755;L=519657-519657;O=672829+-672780;A=-976759+976785,q=795504-795465,["\047"]=67176+-67142;l=-830360+830383;k=150855-150803,e=-670043-(-670080);o=-304889+304911,z=1023282-1023281;W=320613-320570,S=-764264-(-764269);E=378082-378027;Z=633054-633029;J=112161+-112101,["\054"]=900903+-900899,["\049"]=-660409-(-660425);y=-845307-(-845351),P=10807-10765,["\043"]=-100976-(-100979),G=265196-265188;["\051"]=-1035626-(-1035633);u=826329+-826311}local P=table.insert local J=string.len local N=string.char local r=string.sub local V=table.concat local a=math.floor local g=type local u=i for i=423883+-423882,#u,429189-429188 do local M=u[i]if g(M)=="\115\116\114\105\110\103"then local g=J(M)local w={}local o=868033+-868032 local s=748593-748593 local E=1023373-1023373 while o<=g do local i=r(M,o,o)local J=R[i]if J then s=s+J*(-430532-(-430596))^((-340389-(-340392))-E)E=E+(769446-769445)if E==-883425-(-883429)then E=924905+-924905 local i=a(s/(281442-215906))local R=a((s%(-409052-(-474588)))/(803662-803406))local J=s%(400558+-400302)P(w,N(i,R,J))s=-928383+928383 end elseif i=="\061"then P(w,N(a(s/(980681+-915145))))if o>=g or r(M,o+(470066-470065),o+(399100+-399099))~="\061"then P(w,N(a((s%(-820775+886311))/(873777+-873521))))end break end o=o+(-795807-(-795808))end u[i]=V(w)end end end return(function(i,J,N,r,V,a,g,u,I,z,n,E,o,w,U,M,l,y,P,j,s)U,E,s,o,y,M,I,l,j,z,P,n,w,u=function(i,R)local J=s(R)local N=function(N,r,V)return P(i,{N,r;V},R,J)end return N end,function(i)local R,P=543630-543629,i[-80031-(-80032)]while P do M[P],R=M[P]-(845145+-845144),(909168-909167)+R if M[P]==-155739+155739 then M[P],u[P]=nil,nil end P=i[R]end end,function(i)for R=-196593-(-196594),#i,-513421-(-513422)do M[i[R]]=M[i[R]]+(-14763-(-14764))end if N then local P=N(true)local J=V(P)J[R(738511-690516)],J[R(907649-859667)],J[R(-517604+565574)]=i,E,function()return 597233+-1333924 end return P else return r({},{[R(115694+-67712)]=E;[R(965582-917587)]=i,[R(-298088+346058)]=function()return 691274+-1427965 end})end end,-861580+861580,function(i,R)local J=s(R)local N=function()return P(i,{},R,J)end return N end,{},function(i)M[i]=M[i]-(845269+-845268)if-617418-(-617418)==M[i]then M[i],u[i]=nil,nil end end,function(i,R)local J=s(R)local N=function(N,r,V,a,g,u,M)return P(i,{N;r,V,a;g,u,M},R,J)end return N end,function(i,R)local J=s(R)local N=function(N,r,V,a,g)return P(i,{N,r;V;a,g},R,J)end return N end,function(i,R)local J=s(R)local N=function(N)return P(i,{N},R,J)end return N end,function(P,N,r,V)local n,C,E,Y,g,p,x,s,o,G,q,K,T,d,f,L,c,O,S,M,H,D,W,F,h,A,v,Z,e,Q,b,k,t,X while P do if P<-566195+9296883 then if P<517245+4011015 then if P<-391526+2622526 then if P<994776-(-100624)then if P<1412993-737577 then if P<1083367-504087 then if P<701595-441989 then P=true P=P and 13483659-(-437239)or 13816939-(-272503)else h=h+t Q=not q g=h<=A g=Q and g Q=h>=A Q=q and Q g=Q or g Q=10935586-420929 P=g and Q g=-586107+10096950 P=P or g end else P=true P=P and-490814+6977041 or 3460106-516777 end else if P<71896+713694 then p=not H K=K+e f=K<=S f=p and f p=K>=S p=H and p f=p or f p=9846686-(-92380)P=f and p f=427853+2471331 P=P or f else S=-900898-(-900900)o=u[r[260672+-260669]]s=552910+-552878 M=o%s e=-111213+111226 E=u[r[300304+-300300]]G=u[r[-639033+639035]]W=u[r[-34648+34651]]p=W-M W=-942275-(-942307)H=p/W K=e-H f=S^K x=G/f n=E(x)S=-141874+142130 E=4294494599-(-472697)s=n%E n=835061-835059 E=n^M o=s/E E=u[r[580014-580010]]f=-839221-(-839222)G=o%f f=-776454+4295743750 x=G*f n=E(x)M=nil e=44135+-43879 E=u[r[-206668-(-206672)]]x=E(o)G=-476068+541604 s=n+x n=-160779+226315 E=s%n x=s-E n=x/G G=-375487-(-375743)x=E%G P=4790259-(-157413)f=E-x o=nil G=f/S E=nil S=873108-872852 f=n%S K=n-f S=K/e s=nil K={x,G,f;S}G=nil x=nil u[r[717491+-717490]]=K S=nil f=nil n=nil end end else if P<408271+1750402 then if P<596555+1169192 then P={}G=609553+-609298 u[r[65042+-65040]]=P g=u[r[-412362+412365]]n=35184371600195-(-488637)P=322109+415899 E=g g=o%n u[r[-346205+346209]]=g x=o%G G=128101-128099 f=R(-475347-(-523310))n=x+G u[r[-970565+970570]]=n G=i[f]K=127598-127597 f=R(-109482-(-157458))x=G[f]e=K G=x(M)x=R(-23517+71501)s[o]=x x=936154+-936025 S=G f=76058-76057 K=1048462-1048462 H=e<K K=f-e else P=u[r[-738345-(-738352)]]P=P and 5832591-(-352613)or 986323+6458204 end else if P<469075+1756527 then M=N[379653-379652]P=u[r[-871641-(-871642)]]s=P o=N[-813594-(-813596)]P=s[o]P=P and 11734614-810393 or-583876+2114878 else q=290702-290702 d=#p W=d==q P=W and 9784142-609845 or 935795+11376717 end end end else if P<964086+2273982 then if P<3543820-617399 then if P<755902+1875095 then if P<-990119+3552334 then H=nil G=I(G)W=nil d=I(d)K=I(K)p=nil s=I(s)E=I(E)x=nil n=I(n)f=nil S=I(S)e=nil d=-395376-(-395632)o=I(o)o=nil s=nil x=R(1074947-1026985)n=i[x]G=R(434259+-386297)x=R(775304+-727316)E=n[x]n=w()q=d u[n]=E p={}x=i[G]G=R(784302+-736305)E=x[G]f=R(-744954-(-792910))G=i[f]d=893541-893540 f=R(-591806+639781)x=G[f]K=w()S=R(-111234+159197)f=i[S]P=5236630-(-557851)S=R(-733856+781842)H=w()e={}G=f[S]f=181241+-181241 S=w()u[S]=f f=397791+-397789 u[K]=f f={}u[H]=e e=739527-739527 W=-702015-(-702016)Q=d d=-79720-(-79720)X=Q<d d=W-Q else P=true s=R(561534+-513571)o=w()M=N u[o]=P n=w()g=i[s]s=R(415987-367985)P=g[s]E=w()s=w()f=y(95562+12751080,{n})u[s]=P G=R(-976974-(-1024947))P=j(8696497-(-425160),{})u[E]=P P=false u[n]=P x=i[G]G=x(f)P=G and 13271495-(-722298)or 826150+14884099 g=G end else P=11886712-165968 E=nil x=nil G=nil end else if P<3095769-136547 then P=i[R(21990+25967)]g={}else Q=R(34327+13639)t=R(-146188-(-194143))P=i[t]q=i[Q]t=P(q)P=R(-836434+884387)i[P]=t P=5720473-1034984 end end else if P<3292106-(-456472)then if P<-972991+4583282 then P=g and 765700+14240090 or-989485+3086653 else s=u[r[-491806-(-491812)]]P=-532850+16123715 o=s==M g=o end else if P<108161+4370352 then s=s+n o=s<=E G=not x o=G and o G=s>=E G=x and G o=G or o G=1016499+7754164 P=o and G o=6302880-(-151337)P=P or o else s=14133096-546490 g=15334845-170700 o=R(-577595+625569)M=o^s P=g-M g=R(297860+-249853)M=P P=g/M g={P}P=i[R(864764+-816805)]end end end end else if P<6147316-(-1016488)then if P<5416824-(-930350)then if P<5987471-323819 then if P<6275464-867011 then if P<5598174-772612 then P=-256866-(-879211)else s=R(-926176+974132)o=i[s]s=R(816832-768857)M=o[s]P=i[R(-805769+853773)]s=u[r[-752550-(-752551)]]o={M(s)}g={J(o)}end else P=4219331-714524 o=u[r[-87748-(-87750)]]s=u[r[116283+-116280]]M=o==s g=M end else if P<707546+5203800 then T=not X d=d+Q W=d<=q W=T and W T=d>=q T=X and T W=T or W T=8280726-(-127338)P=W and T W=-499649+9251828 P=P or W else M=R(1000165+-952194)P=i[M]o=u[r[565072+-565064]]s=849652-849652 M=P(o,s)P=-158038+7602565 end end else if P<7332272-855560 then if P<915302+5529377 then u[o]=g P=14104033-152549 else P=u[r[989527-989517]]o=u[r[-846161+846172]]M[P]=o P=u[r[262256+-262244]]o={P(M)}P=i[R(-115193+163174)]g={J(o)}end else if P<7645911-1043389 then t=415638+-415637 q=322812+-322806 P=u[G]A=P(t,q)q=R(253373+-205420)P=R(-794240-(-842193))i[P]=A t=i[q]q=-385652+385654 P=t>q P=P and 4004351-923391 or 879633+5849829 else q=R(-973385+1021338)P=i[q]q=R(-270082+318048)i[q]=P P=5167928-482439 end end end else if P<7423315-(-772112)then if P<6996456-(-619900)then if P<7446348-(-127155)then if P<-702479+8098605 then o=u[r[61690+-61687]]P=15643422-(-465204)s=-313217-(-313429)M=o*s o=-630290+630547 g=M%o u[r[840117+-840114]]=g else P={}s=u[r[936831-936822]]M=P o=-325036-(-325037)E=s s=-27305-(-27306)n=s P=353700+4017165 s=-413175-(-413175)x=n<s s=o-n end else P=-632919+2886579 end else if P<7785081-(-135252)then P=15798564-215954 A=e==H h=A else D=367752+-367751 C=c[D]L=C P=12167205-(-678468)end end else if P<-554337+9174277 then if P<-1020389+9435575 then W=d T=W P=6617780-823299 p[W]=T W=nil else b=239415+-239414 C=P Z=c[b]b=false D=Z==b L=D P=D and 77272+9052999 or 8785433-(-124230)end else if P<9020702-315291 then K=R(833294-785326)S=i[K]g=S P=10911628-62005 else P=U(903740+10880618,{E})A={P()}P=i[R(468629+-420680)]g={J(A)}end end end end end else if P<11777380-434546 then if P<10065373-271373 then if P<8725215-(-398375)then if P<8924121-(-72371)then if P<9090312-271984 then if P<121834+8648740 then d=#p P=11437114-(-875398)q=631978+-631978 W=d==q else S=94995+-94740 o=s P=u[r[5332+-5331]]f=935525+-935525 G=P(f,S)M[o]=G P=5151942-781077 o=nil end else g=L P=C P=6977825-535364 end else if P<925394+8191281 then P=true P=P and 493509+9708975 or 8729760-21882 else g=R(-145311+193282)P=i[g]M=R(1047469+-999479)g=P(M)g={}P=i[R(481545-433547)]end end else if P<-246806+9744154 then if P<8126131-(-1010196)then P=8181884-(-727779)b=-75028+75030 Z=c[b]b=u[O]D=Z==b L=D else Y=R(870523+-822528)c=R(-617405+665356)g={}F=374872+9716463966548 E=nil G=nil X=R(640482+-592521)Z=R(352862+-304893)p=nil W={}d=w()x=nil u[d]=W W=w()q=y(738190+10395481,{d;S;K,n})D=nil u[W]=q q={}Q=w()T={}u[Q]=q q=i[X]P=i[R(324502+-276501)]O=u[Q]n=I(n)f=nil v={[Y]=O,[c]=D}k=R(440813+-392836)f=R(400998-353050)X=q(T,v)n=R(-531481-(-579450))O=R(11550+36410)o=X q=l(892768+1328667,{Q,d,H;S,K;W})S=I(S)d=I(d)E=i[n]T=11814972446435-33126 Q=I(Q)K=I(K)Q=8739332003094-836913 H=I(H)W=I(W)e=nil S=-398568+12194280663830 H=-499353+31799524022384 e=656685+27820139294061 s=q K=R(-429618-(-477598))q=R(1039139+-991160)G=s(f,S)n=R(184078+-136085)p=-718268+30250121604290 x=o[G]Y=574312+7819639999185 n=E[n]n=n(E,x)x=R(1030380+-982433)E=i[x]S=s(K,e)f=o[S]e=R(10327+37672)d=836232+2949737267925 K=s(e,H)S=o[K]H=R(952044-904066)e=s(H,p)p=R(386944+-338990)K=o[e]W=565551+11758365340724 H=s(p,W)W=R(-903387-(-951352))e=o[H]v=R(619260-571269)p=s(W,d)H=o[p]d=s(q,Q)W=o[d]c=6670721512640-108702 Q=R(-76382+124365)q=s(Q,T)d=o[q]p={[W]=d}q=R(-187471+235460)Q=363989+23925665177008 d=s(q,Q)W=o[d]T=s(v,Y)Q=o[T]Y=s(O,c)v=o[Y]D=i[Z]b=s(k,F)Z=o[b]b=R(127502+-79530)c=D[Z]k=6007994618752-805011 Z=s(b,k)D=o[Z]d=R(-409224-(-457220))d=n[d]Z=R(149469+-101464)b=-1030372+32070706033466 O=c[D]D=s(Z,b)c=o[D]s=nil Y=O[c]T=v..Y q={[Q]=T}d=d(n,q)n=nil G={[f]=S;[K]=e,[H]=p;[W]=d}o=nil x=E(G)end else if P<400067+9200746 then A=u[o]P=A and 411843+7311469 or 14772698-(-809912)h=A else o=u[r[-456194-(-456196)]]s=-229096-(-229349)M=o*s o=504722+21740507886585 g=M+o M=3804+35184372085028 o=-914889-(-914890)P=g%M u[r[653522-653520]]=P M=u[r[367595-367592]]g=M~=o P=6298530-(-968527)end end end else if P<11125319-352542 then if P<690754+9570469 then if P<11004037-984001 then if P<10253110-315424 then C=u[o]P=C and-582892+8720974 or 12506797-(-338876)L=C else f=K t=R(910090-862127)A=i[t]t=R(678743-630758)h=A[t]A=h(M,f)h=u[r[959832-959826]]t=h()d=A+t W=d+x d=-161071-(-161327)p=W%d x=p f=nil d=s[o]t=-47555-(-47556)A=x+t h=E[A]W=d..h P=-759274+1497282 s[o]=W end else P=-32422-(-654767)end else if P<881877+9883652 then Q=w()u[Q]=h X=R(29084+18878)g=i[X]X=R(206496+-158499)T=723106+-723006 v=-1003246-(-1003501)P=g[X]X=-527623+527624 g=P(X,T)F=-841580+851580 D=R(325097+-277142)X=w()T=-344451+344451 O=833024-833023 u[X]=g P=u[G]g=P(T,v)T=w()u[T]=g v=-384979+384980 c=293936-293934 P=u[G]Y=u[X]g=P(v,Y)v=w()u[v]=g g=u[G]Y=g(O,c)g=386439+-386438 P=Y==g g=R(341520+-293570)Y=w()k=559450-559450 u[Y]=P C=i[D]Z=u[G]P=R(552193+-504229)P=W[P]c=R(-495354-(-543341))b={Z(k,F)}D=C(J(b))C=R(-212890+260877)L=D..C O=c..L P=P(W,g,O)c=R(-512547+560520)O=w()u[O]=P g=i[c]L=z(554916+12844562,{G,Q;K,s;o,d,Y,O,X;v;T,S})c={g(L)}P={J(c)}c=P P=u[Y]P=P and-914092+12251646 or 10644057-836801 else g=S P=K P=S and 10443977-(-405646)or 631675+8038903 end end else if P<-596683+11717155 then if P<44281+10826225 then S=w()u[S]=g e=-312210+312275 W=y(15322062-(-429064),{})P=u[G]K=-764196+764199 g=P(K,e)K=w()P=-652764-(-652764)p=R(-982805-(-1030778))t=R(-287297-(-335252))e=P u[K]=g P=216062+-216062 H=P g=i[p]p={g(W)}P={J(p)}p=P g=69543+-69541 P=p[g]W=P g=R(-86929-(-134923))P=i[g]d=u[s]A=i[t]t=A(W)A=R(281896+-233946)h=d(t,A)d={h()}g=P(J(d))d=w()u[d]=g g=-72104+72105 h=u[K]A=h P=116299+152714 h=917389-917388 t=h h=-508137+508137 q=t<h h=g-t else P=12653636-932892 end else if P<11479568-204874 then M=u[r[-1006907+1006908]]g=#M M=720651-720651 P=g==M P=P and-441811+10064210 or 5113444-165772 else L=u[o]P=L and 964617+7647375 or 7484889-1042428 g=L end end end end else if P<783941+13187481 then if P<67344+12778891 then if P<290034+11890258 then if P<720009+11268783 then if P<11024513-(-699867)then g={o}P=i[R(182817-134825)]else P=39891-(-140897)end else P=true P=8637512-(-70366)end else if P<362029+12274013 then q=#p T=820289+-820288 d=731026+-731025 W=E(d,q)P=680927+1545913 d=x(p,W)q=u[H]X=d-T Q=G(X)q[d]=Q d=nil W=nil else k=831754-831753 u[o]=L b=u[v]Z=b+k D=c[Z]C=e+D D=-948547-(-948803)P=C%D Z=u[T]D=H+Z e=P P=14977972-1026488 Z=-999317-(-999573)C=D%Z H=C end end else if P<-711953+14598188 then if P<445097+12422409 then P=true u[r[465851+-465850]]=P g={}P=i[R(867516+-819549)]else n=-874553+874555 o=u[r[-502053+502054]]E=156078-156077 s=o(E,n)o=-235821-(-235822)M=s==o g=M P=M and 596266+2908541 or 5900644-290537 end else if P<-881354+14812471 then M=R(187289+-139323)g=R(570819-522866)P=i[g]g=i[M]M=R(-743885+791851)i[M]=P P=-1007295+1188083 M=R(-640824-(-688777))i[M]=g M=u[r[-697667+697668]]o=M()else v=I(v)O=I(O)Y=I(Y)T=I(T)c=nil X=I(X)P=-222599-(-491612)Q=I(Q)end end end else if P<16093872-454234 then if P<14376534-(-729278)then if P<29858+14397721 then if P<14650360-623818 then x=u[n]g=x P=859446+14850803 else P=i[R(-118729+166687)]g={}end else g=R(-11209-(-59203))E=R(746120-698165)S=y(4651144-162522,{})P=i[g]f=R(-570283+618256)M=u[r[-399499-(-399503)]]s=i[E]G=i[f]f={G(S)}x={J(f)}G=-228807-(-228809)n=x[G]E=s(n)s=R(-731312-(-779262))o=M(E,s)M={o()}g=P(J(M))M=g o=u[r[-482506+482511]]g=o P=o and 3135012-(-580389)or 180972+15409893 end else if P<-926170+16510326 then u[o]=h P=u[o]P=P and 8615507-1039451 or 233490+11860687 else M=nil u[r[935579+-935574]]=g P=1446736-(-650432)end end else if P<16135821-278412 then if P<715641+15017772 then x=g G=R(569253-521291)f=R(-18354-(-66310))g=i[G]G=R(-558278-(-606275))P=g[G]G=w()u[G]=P g=i[f]f=R(-371099-(-419099))P=g[f]f=P K=P H=R(-346233+394189)e=i[H]S=e P=e and 16047660-(-496620)or 887323+9879189 else o=R(597580+-549574)s=7342002-585790 g=14208148-(-738496)M=o^s P=g-M M=P g=R(-365209-(-413212))P=g/M g={P}P=i[R(-494454-(-542406))]end else if P<919412+15492383 then o=u[r[639994-639991]]s=357726-357725 M=o~=s P=M and 1427365-525529 or 7854445-587388 else p=R(-345364-(-393320))H=i[p]p=R(819750+-771782)e=H[p]P=1034588+9731924 S=e end end end end end end end P=#V return J(g)end,function(i,R)local J=s(R)local N=function(...)return P(i,{...},R,J)end return N end,function()o=(-927652-(-927653))+o M[o]=-873890-(-873891)return o end,{}return(n(2185396-(-401077),{}))(J(g))end)(getfenv and getfenv()or _ENV,unpack or table[R(911452-863484)],newproxy,setmetatable,getmetatable,select,{...})end)(...)
