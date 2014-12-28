package test.screens.common.view
{
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IRunnable;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import org.puremvc.as3.interfaces.IFacade;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class BackView implements IRunnable
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const BACK_TRIGGERED					:String = "backTriggered";

		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		/**
		 * Button textures. Static due to performance optimizations
		 */
		protected static var normalTexture					:Texture;
		protected static var upTexture						:Texture;

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var facade									:IFacade;
		private var notificationName						:String;
		private var backButton								:Button;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function BackView(facade:IFacade, mediatorName:String, container:Sprite, gameSize:GameSizeVO)
		{
			this.facade = facade;
			notificationName = mediatorName + BACK_TRIGGERED;
			createBackButton(container, gameSize);
		}

		//==============================================================================================================
		// STATIC API
		//==============================================================================================================

		public static function dispose():void
		{
			if (normalTexture != null)
			{
				normalTexture.dispose();
				normalTexture = null;
			}
			if (upTexture != null)
			{
				upTexture.dispose();
				upTexture = null;
			}
		}

		//==============================================================================================================
		// IRunnable IMPLEMENTATION
		//==============================================================================================================

		public function start():void
		{
			backButton.addEventListener(Event.TRIGGERED, handleBackButtonTriggered);
		}

		public function pause():void
		{
			backButton.removeEventListener(Event.TRIGGERED, handleBackButtonTriggered);
		}

		public function resume():void
		{
			backButton.addEventListener(Event.TRIGGERED, handleBackButtonTriggered);
		}

		public function dispose():void
		{
			if (backButton != null)
			{
				backButton.removeEventListeners();
				StarlingHelpers.removeFromParent(backButton);
				backButton = null;
			}
			notificationName = null;
			facade = null;
		}

		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================

		private function handleBackButtonTriggered(event:Event):void
		{
			facade.sendNotification(notificationName);
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		protected function createBackButton(container:Sprite, gameSize:GameSizeVO):void
		{
			// Assure we have button textures
			createButtonTextures(gameSize);
			// Create back button
			backButton = new Button(normalTexture, "", upTexture);
			backButton.x = gameSize.getWidth() * 0.01;
			backButton.y = gameSize.getHeight() * 0.01;
			container.addChild(backButton);
		}

		protected static function createButtonTextures(gameSize:GameSizeVO):void
		{
			if (normalTexture == null || upTexture == null)
			{
				var buttonGraphics:MovieClip = new backButtonLinkage() as MovieClip,
					buttonWidth:int = gameSize.getWidth() * 0.08,
					buttonScale:Number = buttonWidth / buttonGraphics.width,
					buttonHeight:int = Math.ceil(buttonGraphics.height * buttonScale),
					bitmapData:BitmapData,
					matrix:Matrix = new Matrix();

				matrix.scale(buttonScale, buttonScale);

				// Create normal button texture from vector
				buttonGraphics.gotoAndStop(1);
				bitmapData = new BitmapData(buttonWidth, buttonHeight, true, 0x00000000);
				bitmapData.draw(buttonGraphics, matrix, null, null, null, true);
				normalTexture = Texture.fromBitmapData(bitmapData, false);

				// Create normal button texture from vector
				buttonGraphics.gotoAndStop(2);
				bitmapData = new BitmapData(buttonWidth, buttonHeight, true, 0x00000000);
				bitmapData.draw(buttonGraphics, matrix, null, null, null, true);
				upTexture = Texture.fromBitmapData(bitmapData, false);
			}
		}
	}
}
