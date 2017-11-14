package;

/**
 * ...
 * @author Yope
 */
class Baguette extends Enemy 
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.baguete__png, false, 64, 128);
		scale.x = 0.5;
		scale.y = 0.5;
		updateHitbox();
	}
	
}