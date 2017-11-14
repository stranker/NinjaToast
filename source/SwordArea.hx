package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Yope
 */
class SwordArea extends FlxSprite 
{
	private var timer:Float = 0;
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		makeGraphic(20, 48, 0xFF000000);
		kill();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		timer += elapsed;
		if (timer > 0.7)
			kill();
	}
	
	public function resetTimer():Void
	{
		timer = 0;
	}
	
}