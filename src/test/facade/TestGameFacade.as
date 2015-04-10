package test.facade
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.facade.GameFacade;
	import com.pixelBender.helpers.StarlingHelpers;

	import constants.Constants;

	import flash.display.BitmapData;

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Matrix;

	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;

	import test.command.GlobalAssetPackageLoadedHandler;

	public class TestGameFacade extends GameFacade
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var rootBackground													:Sprite;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function TestGameFacade()
		{
			super();
		}
		
		//==============================================================================================================
		// STATIC INSTANCE
		//==============================================================================================================
		
		/**
		 * 
		 * It will create an instance if it wasn't already created. Otherwise will return the former created instance
		 * 
		 * @return the instance of the TestGameFacade
		 */
		public static function getInstance():TestGameFacade
		{
			if (instance == null)
			{
				instance = new TestGameFacade();
			}
			return instance as TestGameFacade;
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function createStageBackground(stageBackgroundVector:MovieClip):void
		{
			var bitmapData:BitmapData = new BitmapData(gameSize.getWidth(), gameSize.getHeight(), true, 0x00000000),
				matrix:Matrix = new Matrix();

			matrix.scale(gameSize.getScale(), gameSize.getScale());
			matrix.translate(((gameSize.getWidth() - Constants.WIDTH * gameSize.getScale()) >> 1), 0);
			bitmapData.draw(stageBackgroundVector, matrix, null, null, null, true);

			rootBackground = StarlingHelpers.createTextureSpriteBackground(bitmapData, bitmapData.width, bitmapData.height, true);
			starlingGameRoot.addChildAt(rootBackground, 0);
		}
		
		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================
		
		override public function dispose():void
		{
			StarlingHelpers.disposeContainer(rootBackground);
			rootBackground = null;
			removeCommand(GameConstants.GLOBAL_ASSET_PACKAGE_LOADED);
			super.dispose();
		}


		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(GameConstants.GLOBAL_ASSET_PACKAGE_LOADED, GlobalAssetPackageLoadedHandler);
		}
	}
}