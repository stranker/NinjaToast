package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Yope
 */
class Pig extends FlxSprite 
{
	private static inline var VEL:Int = 200;
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		loadGraphic(AssetPaths.Pig__png, false, 32, 18);
		acceleration.y = Global.GRAVITY;
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		facing = FlxObject.RIGHT;
	}
	
	override public function update(elapsed:Float):Void 
	{
		Movement();
		Jumping();
		CloseToNinja();
		FlxG.collide(this, Global.tilemap);
		super.update(elapsed);
	}
	
	private function CloseToNinja():Void
	{
		if (y > Global.ninja.y + 200 || y < Global.ninja.y - 200)
			setPosition(Global.ninja.x, Global.ninja.y);
	}
	
	private function Jumping():Void 
	{
		if (FlxG.keys.justPressed.UP && isTouching(FlxObject.FLOOR))
			velocity.y = -450;
	}
	
	private function Movement():Void
	{
		if (x < Global.ninja.x - 64)
			x = Global.ninja.x - 64;
		else if (x > Global.ninja.x + 64)
			x = Global.ninja.x + 64;
		facing = (x< Global.ninja.x) ? FlxObject.RIGHT: FlxObject.LEFT;
	}
	
}