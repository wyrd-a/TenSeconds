package pkg.player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import pkg.config.Config;
import pkg.enemy.Enemy;

/**Real jank way of moving hitbox off of weapon to tip of weapon, but hey it works.**/
class WeaponGroup extends FlxSpriteGroup
{
	var weapon:Weapon;
	var weaponBox:FlxSprite;
	var wbDist:Float = 100;

	var damageCounter:FlxSprite;

	var weaponAngle:FlxText;
	var targetAngle:FlxText;

	public function new(x:Float = 0, y:Float = 0)
	{
		super();
		weapon = new Weapon();
		add(weapon);
		weaponBox = new FlxSprite().makeGraphic(16, 16, FlxColor.WHITE);
		add(weaponBox);
		weaponBox.alpha = 0;

		damageCounter = new FlxSprite(0, 0);
		damageCounter.loadGraphic(AssetPaths.dmgmarkerz__png, true, 16, 15);
		damageCounter.scale.set(3, 3);
		damageCounter.updateHitbox();

		damageCounter.alpha = 0;
		add(damageCounter);

		weaponAngle = new FlxText(0, 0);
		targetAngle = new FlxText(0, 20);
		// add(weaponAngle);
		// add(targetAngle);
	}

	override public function update(elapsed:Float):Void
	{
		weaponAngle.text = "Weapon Angle: " + Std.string(weapon.angle);
		targetAngle.text = "Target Angle: " + Std.string(weapon.targetAngle);

		if (damageCounter.alpha > 0)
		{
			damageCounter.alpha -= 0.01;
		}

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
		if (weapon.spunUp)
		{
			FlxG.overlap(enemy, weaponBox, hurtEnemy); // hurt the enemy!
		}
	}

	function hurtEnemy(objA:Enemy, objB:FlxSprite):Void
	{
		if (!objA.iframes)
		{
			damageCounter.reset(weaponBox.x, weaponBox.y - 50);
			damageCounter.alpha = 1;
			addAnimations();
			damageCounter.animation.play(Std.string(Config.playerDamage - 1));
			objA.takeDamage();
			weapon.spunUp = false;
			weapon.angularVelocity = -0.5 * weapon.angularVelocity;
		}
	}

	function addAnimations()
	{
		for (i in 0...15)
			damageCounter.animation.add(Std.string(i), [i]);
	}
}
