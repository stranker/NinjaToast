package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Yope
 */
class Enemy extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		acceleration.y = Global.GRAVITY;
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		FlxG.collide(this, Global.tilemap);
		super.update(elapsed);
	}
	
}