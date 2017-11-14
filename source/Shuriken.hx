package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Yope
 */
class Shuriken extends FlxSprite 
{
	private var direction:Int;
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		scale.set(0.7, 0.7);
		updateHitbox();
		loadGraphic(AssetPaths.Shuriken__png, true, 24, 24);
		animation.add("fly", [0, 1], 6, true);
		animation.play("fly");
		y = y - height / 2;
	}
	
	override public function update(elapsed:Float):Void 
	{
		velocity.x = 400 * direction;
		super.update(elapsed);
	}
	
	public function getDirection():Int 
	{
		return direction;
	}
	
	public function setDirection(value:Int):Void
	{
		direction = value;
	}
}