package pkg.config;

class Config
{
	public static var WINDOW_HEIGHT:Int = 576; // level1 height * 3
	public static var WINDOW_WIDTH:Int = 864; // level1 width * 3
	public static var CENTER_HEIGHT:Int = Math.floor(WINDOW_HEIGHT / 2);
	public static var CENTER_WIDTH:Int = Math.floor(WINDOW_WIDTH / 2);

	public static var roomLevel:Int = 4;
	public static var roomFlavor:String = "Bitter";
	public static var roomLevelName:String = AssetPaths.boss_room__png;
	public static var playerHealth:Float;
}
