package test.popups.view
{
	import com.pixelBender.facade.GameFacade;
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IRunnable;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.textures.Texture;
	import test.popups.vo.PopupConfigurationVO;

	public class OpenSecondPopupView implements IRunnable
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const OPEN_SECOND_POPUP						:String = "openSecondPopup";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Button
		 */
		protected var button							:Button;

		/**
		 * Reference to the game facade
		 */
		protected var gameFacade						:GameFacade;

		/**
		 * Reference to the owner mediator name
		 */
		protected var mediatorName						:String;

		/**
		 * Reference to texture
		 */
		protected var buttonTexture						:Texture;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function OpenSecondPopupView(container:DisplayObjectContainer, configurationVO:PopupConfigurationVO,
											mediatorName:String, facade:GameFacade)
		{
			this.gameFacade = facade;
			this.mediatorName = mediatorName;

			createButton(container, configurationVO);
		}

		//==============================================================================================================
		// IRunnable IMPLEMENTATION
		//==============================================================================================================

		public function start():void
		{
			// Listener
			button.addEventListener(Event.TRIGGERED, handleButtonTriggered);
		}

		public function pause():void
		{
			button.removeEventListener(Event.TRIGGERED, handleButtonTriggered);
		}

		public function resume():void
		{
			button.addEventListener(Event.TRIGGERED, handleButtonTriggered);
		}

		public function dispose():void
		{
			if (button != null)
			{
				button.removeEventListener(Event.TRIGGERED, handleButtonTriggered);
				StarlingHelpers.removeFromParent(button);
				button = null;
			}
			if (buttonTexture != null)
			{
				buttonTexture.dispose();
				buttonTexture = null;
			}
			gameFacade = null;
			mediatorName = null;
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function setVisible(visible:Boolean):void
		{
			button.visible = visible;
		}

		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================

		private function handleButtonTriggered(event:Event):void
		{
			gameFacade.sendNotification(mediatorName + OPEN_SECOND_POPUP);
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		protected function createButton(container:DisplayObjectContainer, configurationVO:PopupConfigurationVO):void
		{
			// Internals
			var vectorSprite:Sprite = new Sprite(),
				width:int = configurationVO.getWidth() >> 2,
				height:int = configurationVO.getHeight() >> 2,
				bitmapData:BitmapData = new BitmapData(width, height, true, 0x0);
			// Draw from vector
			vectorSprite.graphics.beginFill(0x005555, 1);
			vectorSprite.graphics.drawRoundRect(0, 0, width, height, width * .1);
			vectorSprite.graphics.endFill();
			bitmapData.draw(vectorSprite, null, null, null, null, true);
			buttonTexture = Texture.fromBitmapData(bitmapData, false);
			// Add to container
			button = new Button(buttonTexture, LocalizationHelpers.getLocalizedText(mediatorName, "openSecondPopup"));
			button.fontSize = 20;
			button.fontBold = true;
			button.x = configurationVO.getX() + ((configurationVO.getWidth() - width) >> 1);
			button.y = configurationVO.getY() + configurationVO.getHeight() - height - (height >> 1);
			container.addChild(button);
		}
	}
}
