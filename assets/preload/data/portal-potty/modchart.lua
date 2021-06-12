function start (song)
	BlackFade = makeSprite('BlackFade','blackfade', false)
	setActorX(200,'blackfade')
	setActorY(500,'blackfade')
	setActorAlpha(0,'blackfade')
	setActorScale(2,'blackfade')
end

function update (elapsed)
	if curStep >= 1040 and curStep < 1210 then
		cameraAngle = cameraAngle + 0.850
		camHudAngle = camHudAngle + 0.850
	end
end

function stepHit (step)
	if step == 1040 then	
		tweenFadeIn(BlackFade,1,5)
	end
	if step == 896 then
		for i=0,7 do
			tweenFadeOut(i,0,4.5)
		end
	end
	if step == 928 then
		showOnlyStrums = true
	end
end
