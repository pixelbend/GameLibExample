package helpers
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.system.ApplicationDomain;

	import starling.textures.Texture;

	public class ButtonHelpers
	{
		public static function getButtonTextures(buttonGraphicsLinkage:String, numberOfFrames:int, width:int, height:int):Vector.<Texture>
		{
			var buttonClass:Class,
				buttonGraphics:MovieClip,
				bitmapData:BitmapData,
				matrix:Matrix = new Matrix(),
				buttonTextures:Vector.<Texture>;

			buttonClass = ApplicationDomain.currentDomain.getDefinition(buttonGraphicsLinkage) as Class;
			buttonGraphics = new buttonClass();
			buttonTextures = new Vector.<Texture>(numberOfFrames, true);

			for (var i:int=0; i<buttonTextures.length; i++)
			{
				matrix.identity();
				buttonGraphics.gotoAndStop(i+1);
				matrix.scale(width/buttonGraphics.width, height/buttonGraphics.height);
				bitmapData = new BitmapData(width, height, true, 0x00000000);
				bitmapData.draw(buttonGraphics, matrix, null, null, null, true);
				buttonTextures[i] = Texture.fromBitmapData(bitmapData, false);
			}

			return buttonTextures;
		}

		public static function getSquareButtonTextures(buttonGraphicsLinkage:String, numberOfFrames:int, buttonSize:int):Vector.<Texture>
		{
			return getButtonTextures(buttonGraphicsLinkage, numberOfFrames, buttonSize, buttonSize);
		}
	}
}
