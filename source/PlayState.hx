package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	var ninja:NinjaToast;
	var pig:Pig;
	var tilemap:FlxTilemap;
	var bagui:Baguette;
	private var loader:FlxOgmoLoader;
	override public function create():Void
	{
		super.create();
		ninja = new NinjaToast(FlxG.camera.width / 2, FlxG.camera.height / 2);
		pig = new Pig(FlxG.camera.width / 2, FlxG.camera.height / 2);
		tilemap = new FlxTilemap();
		loader = new FlxOgmoLoader(AssetPaths.test__oel);
		tilemap = loader.loadTilemap(AssetPaths.tiles__png, 32, 32, "tiles");
		tilemap.setTileProperties(0, FlxObject.NONE);
		tilemap.setTileProperties(1, FlxObject.ANY);
		bagui = new Baguette(100 , 300);
		
		FlxG.camera.bgColor = 0xFFc7e2ff;
		
		add(tilemap);
		add(ninja);
		add(pig);
		add(bagui);
		FlxG.camera.follow(ninja, FlxCameraFollowStyle.PLATFORMER, 1);
		Global.tilemap = tilemap;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}