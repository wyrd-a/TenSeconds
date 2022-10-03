package pkg.player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

/**Real jank way of moving hitbox off of weapon to tip of weapon, but hey it works.**/
class WeaponGroup extends FlxSpriteGroup
{
	var weapon:Weapon;
	var weaponBox:FlxSprite;
	var wbDist:Float;

	public function new(x:Float = 0, y:Float = 0)
	{
		super();
		weapon = new Weapon();
		add(weapon);
		weaponBox = new FlxSprite().makeGraphic(16, 16);
		add(weaponBox);
		weaponBox.alpha = 0;

		wbDist = weapon.DIST;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	public function positioning(player:FlxSprite, enemy:FlxSprite)
	{
		weapon.move(player, enemy);
		weaponBox.x = (-1 * wbDist * Math.sin(weapon.angle / 180 * Math.PI)) + player.x + (player.width / 2) - (weaponBox.width / 2);
		weaponBox.y = (wbDist * Math.cos(weapon.angle / 180 * Math.PI)) + player.y + (player.height / 2) - (weaponBox.height / 2);
		dealDamage(enemy);
	}

	function dealDamage(enemy:FlxSprite)
	{
		if (Math.abs(weapon.angularVelocity) > weapon.CHARGE)
		{
			FlxG.overlap(enemy, weaponBox, hurtEnemy); // hurt the enemy!
		}
	}

	function hurtEnemy(objA:FlxSprite, objB:FlxSprite):Void
	{
		objA.health -= 1;
		weapon.angularVelocity = 0; // This creates the "hit" feel
	}
}
