package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.addons.effects.FlxTrail;
import flixel.addons.util.FlxFSM;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author Daniel Natarelli
 */
class NinjaToast extends FlxSprite 
{
	private static inline var VEL:Int = 300;
	private var fsm:FlxFSM<NinjaToast>;
	private var trail:FlxTrail;
	public var graceTime:Float = 0;
	private var jumped:Bool;
	private var direction:Int;
	private var swordArea:SwordArea;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Toast__png, true, 64, 48);
		animation.add("idle", [0], 6, true, false, false);
		animation.add("melee", [0,1,2,3], 6, true,false,false);
		acceleration.y = Global.GRAVITY;
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		facing = FlxObject.RIGHT;
		direction = 1;
		maxVelocity.set(VEL, Global.GRAVITY);
		//Set Escala
		scale.x = 0.5;
		updateHitbox();
		scale.x = 1;
		
		swordArea = new SwordArea(x + width, y);
		FlxG.state.add(swordArea);
		
		fsm = new FlxFSM<NinjaToast>(this);
		fsm.transitions
			.add(Idle, Jump, Conditions.jump)
			.add(Idle, Fall, Conditions.falling)
			.add(Jump, Idle, Conditions.grounded)
			.add(Jump, Fall, Conditions.falling)
			.add(Fall, Idle, Conditions.grounded)
			.add(Fall, Jump, Conditions.jump)
			.add(Idle, AttackShuriken, Conditions.attackingShuriken)
			.add(Jump, AttackShuriken, Conditions.attackingShuriken)
			.add(Fall, AttackShuriken, Conditions.attackingShuriken)
			.add(AttackShuriken, Idle, Conditions.grounded)
			.add(AttackShuriken, Fall, Conditions.falling)
			.add(AttackShuriken, Jump, Conditions.jump)
			.add(Idle, AttackMelee, Conditions.attackingMelee)
			.add(Jump, AttackMelee, Conditions.attackingMelee)
			.add(Fall, AttackMelee, Conditions.attackingMelee)
			.add(AttackMelee, Idle, Conditions.grounded)
			.add(AttackMelee, Jump, Conditions.jump)
			.add(AttackMelee, Fall, Conditions.falling)
			.start(Idle);
		
		trail = new FlxTrail(this, null, 5, 2, 0.4, 0.05);
		trail.kill();
		FlxG.state.add(trail);
		
		Global.ninja = this;
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if(!swordArea.alive)
			fsm.update(elapsed);
		else
		{
			if(direction == 1)
				swordArea.reset(x + width, y);
			else
				swordArea.reset(x - swordArea.width, y);
		}
		super.update(elapsed);
		FlxG.collide(this, Global.tilemap);
		//trace(Type.getClassName(fsm.stateClass));
	}
	
	public function Movement():Void
	{
		if (FlxG.keys.pressed.LEFT)
		{
			velocity.x = -VEL;
			direction = -1;
		}
		else if(FlxG.keys.pressed.RIGHT)
		{
			velocity.x = VEL;
			direction = 1;
		}
		else
			velocity.x = 0;
		facing = (direction==1) ? FlxObject.RIGHT : FlxObject.LEFT;
	}
	
	public function setJumped(t:Bool):Void
	{
		jumped = t;
	}
	
	public function getJumped():Bool
	{
		return jumped;
	}
	
	public function getDirection():Int
	{
		return direction;
	}
	
	public function meleeAttack():Void
	{
		swordArea.resetTimer();
		if(direction == 1)
			swordArea.reset(x + width, y);
		else
			swordArea.reset(x - swordArea.width, y);
	}
	
}

class Conditions
{
	public static function jump(owner:NinjaToast):Bool
	{
		return (FlxG.keys.justPressed.UP && owner.getJumped() && (owner.isTouching(FlxObject.FLOOR) || owner.graceTime<0.12));
	}
	
	public static function grounded(owner:NinjaToast):Bool
	{
		return owner.isTouching(FlxObject.FLOOR);
	}
	
	public static function falling(owner:NinjaToast):Bool
	{
		return (owner.velocity.y > 0 && !owner.isTouching(FlxObject.FLOOR));
	}
	
	public static function attackingMelee(owner:NinjaToast):Bool
	{
		return (FlxG.keys.justPressed.A);
	}
	
	public static function attackingShuriken(owner:NinjaToast):Bool
	{
		return (FlxG.keys.justPressed.S);
	}
	
	public static function animationFinished(owner:NinjaToast):Bool
	{
		return owner.animation.finished;
	}
	
}


class Idle extends FlxFSMState<NinjaToast>
{
	override public function enter(owner:NinjaToast, fsm:FlxFSM<NinjaToast>):Void
	{
		owner.setJumped(true);
		owner.animation.play("idle");
	}
	override public function update(elapsed:Float, owner:NinjaToast, fsm:FlxFSM<NinjaToast>):Void 
	{
		owner.Movement();
	}
}

class Jump extends FlxFSMState<NinjaToast>
{
	override public function enter(owner:NinjaToast, fsm:FlxFSM<NinjaToast>):Void
	{
		// animacion play (jump)
		owner.setJumped(false);
		owner.velocity.y = -500;
	}
	override public function update(elapsed:Float, owner:NinjaToast, fsm:FlxFSM<NinjaToast>):Void 
	{
		owner.Movement();
	}
}

class Fall extends FlxFSMState<NinjaToast>
{
	override public function enter(owner:NinjaToast, fsm:FlxFSM<NinjaToast>):Void
	{
		owner.graceTime = 0;
	}
	override public function update(elapsed:Float, owner:NinjaToast, fsm:FlxFSM<NinjaToast>):Void 
	{
		owner.Movement();
		owner.graceTime += elapsed;
	}
}

class AttackMelee extends FlxFSMState<NinjaToast>
{
	override public function enter(owner:NinjaToast, fsm:FlxFSM<NinjaToast>):Void
	{
		owner.animation.play("melee");
		owner.meleeAttack();
		owner.velocity.x = 0;
	}
	override public function update(elapsed:Float, owner:NinjaToast, fsm:FlxFSM<NinjaToast>):Void 
	{
		
	}
}

class AttackShuriken extends FlxFSMState<NinjaToast>
{
	override public function enter(owner:NinjaToast, fsm:FlxFSM<NinjaToast>):Void
	{
		// animacion play (shuriken)
		var shuriken:Shuriken;
		if(owner.getDirection() == 1)
			shuriken = new Shuriken(owner.x + owner.width, owner.y + owner.height / 2);
		else
			shuriken = new Shuriken(owner.x , owner.y + owner.height / 2);
		shuriken.setDirection(owner.getDirection());
		FlxG.state.add(shuriken);
	}
	override public function update(elapsed:Float, owner:NinjaToast, fsm:FlxFSM<NinjaToast>):Void 
	{
		owner.Movement();
	}
}