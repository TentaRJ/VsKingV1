package;

import flixel.system.FlxAssets.GraphicLogo;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

import TitleState._kingsave;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var logoBl:FlxSprite;
	var ghLogo:FlxSprite;
	var stickerFunny:FlxSprite;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.4.2" + nightly;
	public static var ghUpdateText:FlxText;
	public static var kingVer:String = "1.1.2";
	public static var kingTest:Bool = false;
	public static var versionResult:String;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.15;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.15;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFF974FD6;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(20, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			// menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0.05, 0.05);
			menuItem.antialiasing = true;
		}

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "VS. King Full Week -- Custom Kade Engine (Based on Version 1.4.2)", 0);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		logoBl = new FlxSprite(1299, 120);
		logoBl.scrollFactor.set(0,0);
		logoBl.scale.set(0.65, 0.65);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin', 'preload');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.scrollFactor.set(0, 0.25);
		logoBl.updateHitbox();
		add(logoBl);

		ghLogo = new FlxSprite(1299, 120).loadGraphic(Paths.image('githubLogo', 'preload'));
		ghLogo.scrollFactor.set(0,0);
		ghLogo.scale.set(0.2, 0.2);
		ghLogo.scrollFactor.set(0, 0.25);
		ghLogo.updateHitbox();
		add(ghLogo);

		stickerFunny = new FlxSprite(1299, 320).loadGraphic(Paths.image('stickerFunnyPublic', 'preload'));
		stickerFunny.scrollFactor.set(0,0);
		stickerFunny.antialiasing=true;
		stickerFunny.scrollFactor.set(0, 0.25);
		stickerFunny.setGraphicSize(285);
		stickerFunny.updateHitbox();
		add(stickerFunny);

		new FlxTimer().start(0.29, function(swagTimer:FlxTimer)
		{
			FlxTween.tween(logoBl,{x:699, y:120}, 1, {ease:FlxEase.expoInOut});
			new FlxTimer().start(0.2, function(swagTimer:FlxTimer){
				// FlxTween.tween(stickerFunny,{x:999, y:120}, 1, {ease:FlxEase.expoInOut});
				new FlxTimer().start(0.89, function(tmr:FlxTimer)
				{
					#if debug
					versionResult="Debug Mode! Not gonna check for updates!";
					#elseif !html
					var http = new haxe.Http("https://raw.githubusercontent.com/TentaRJ/VsKingV1/main-but-not-main-as-well/kingVersion.downloadMe");
					var returnedData:Array<String> = [];
					
					http.onData = function (data:String)
					{
						returnedData[0] = data.substring(0, data.indexOf(';'));
						returnedData[1] = data.substring(data.indexOf('-'), data.length);

						if (MainMenuState.kingTest)
						{
							trace("test build!");
							versionResult="This version is a test of the build " + kingVer + "! Please report any issues to Github!";
						}
						else if (MainMenuState.kingVer > returnedData[0].trim() && !MainMenuState.kingTest)
						{
							trace('outdated lmao! ' + returnedData[0] + ' > ' + kingVer);
							trace(returnedData[1]);
							versionResult="Version " + returnedData[0] + " is available! Check the mod repository in options to see the new changes!";
							FlxTween.tween(logoBl,{x:1499}, 1, {ease:FlxEase.expoInOut});
							FlxTween.tween(ghLogo,{x:799, y:190}, 1, {ease:FlxEase.expoInOut});
						}
						else
						{
							versionResult="No updates found! Your version is " + kingVer + "!";
						}

					}
					http.onError = function (error) {
						trace('error: $error');
						trace("They are probably offline lmaoooooo");
						versionResult="Could not check for updates!";
					}

					http.request();
					#end

					ghUpdateText = new FlxText(1299, FlxG.height - 48, 0, versionResult, 16);
					ghUpdateText.scrollFactor.set();
					ghUpdateText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
					add(ghUpdateText);

					FlxTween.tween(ghUpdateText,{x:5}, 1, {ease:FlxEase.expoOut});
				});
			});
		});

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		// #if debug
		if (FlxG.keys.justPressed.R)
		{
			new FlxTimer().start(0.05, function(tmr:FlxTimer)
			{
				trace("reset!");
				_kingsave.data.weekUnlocked = [true, true, false, false, false];
				trace(_kingsave.data.weekUnlocked);
				_kingsave.flush();
			});
		}
		// if (FlxG.keys.justPressed.T)
		// {
		// 	new FlxTimer().start(0.05, function(tmr:FlxTimer)
		// 	{
		// 		trace("t!");
		// 		_kingsave.data.weekUnlocked = [true, true, true, true, true];
		// 		trace(_kingsave.data.weekUnlocked);
		// 		_kingsave.flush();
		// 	});
		// }
		// #end
		if (FlxG.keys.pressed.T && FlxG.keys.pressed.A && FlxG.keys.pressed.C)
		{
			new FlxTimer().start(0.05, function(tmr:FlxTimer)
			{
				trace("TAC!");
				_kingsave.data.weekUnlocked = [true, true, true, true, true];
				trace(_kingsave.data.weekUnlocked);
				_kingsave.flush();
			});
		}
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			//This part below keeps crashing the game, so lets not, why don't we?
			// if (controls.BACK)
			// {
			// 	FlxG.switchState(new TitleState());
			// }

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game", "&"]);
					#else
					FlxG.openURL('https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					FlxTween.tween(logoBl,{x:1499}, 1, {ease:FlxEase.expoInOut});
					FlxTween.tween(ghLogo,{x:1499}, 1, {ease:FlxEase.expoInOut});
					FlxTween.tween(stickerFunny,{x:1499, y:120}, 1, {ease:FlxEase.expoInOut});
					new FlxTimer().start(1, function(swagTimer:FlxTimer){
						remove(logoBl);
						remove(stickerFunny);
					});
					

					if (FlxG.save.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);

		// menuItems.forEach(function(spr:FlxSprite)
		// {
		// 	spr.screenCenter(X);
		// });
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}