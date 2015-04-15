package test.popups.view
{
	import com.pixelBender.facade.GameFacade;
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IPauseResume;
	import com.pixelBender.interfaces.IRunnable;
	import com.pixelBender.model.vo.game.GameSizeVO;

	import constants.Constants;

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.system.ApplicationDomain;

	import helpers.ButtonHelpers;

	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import test.popups.vo.PopupConfigurationVO;

	public class PopupBaseView implements IRunnable
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const CLOSE_BUTTON_TRIGGERED			:String = "closeButtonTriggered";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Background sprite
		 */
		protected var background							:starling.display.Sprite;

		/**
		 * Close button
		 */
		protected var closeButton							:Button;

		/**
		 * Popup title
		 */
		protected var title									:TextField;

		/**
		 * Reference to the game facade
		 */
		protected var gameFacade							:GameFacade;

		/**
		 * Reference to the owner mediator name
		 */
		protected var mediatorName							:String;

		/**
		 * Reference to all button textures
		 */
		protected var buttonTextures						:Vector.<Texture>;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function PopupBaseView(container:DisplayObjectContainer, configurationVO:PopupConfigurationVO,
									  	mediatorName:String, facade:GameFacade)
		{
			this.gameFacade = facade;
			this.mediatorName = mediatorName;

			createBackground(container, configurationVO);
			createTitle(container, configurationVO);
			createCloseButton(container, configurationVO);
		}

		//==============================================================================================================
		// IPauseResume IMPLEMENTATION
		//==============================================================================================================

		public function start():void
		{
			closeButton.addEventListener(Event.TRIGGERED, handleButtonTriggered);
		}

		public function pause():void
		{
			closeButton.removeEventListener(Event.TRIGGERED, handleButtonTriggered);
		}

		public function resume():void
		{
			closeButton.addEventListener(Event.TRIGGERED, handleButtonTriggered);
		}

		public function dispose():void
		{
			if (closeButton != null)
			{
				closeButton.removeEventListener(Event.TRIGGERED, handleButtonTriggered);
				StarlingHelpers.removeFromParent(closeButton);
				closeButton = null;
			}

			if (buttonTextures != null)
			{
				for (var i:int=0; i<buttonTextures.length; i++)
				{
					buttonTextures[i].dispose();
					buttonTextures[i] = null;
				}
				buttonTextures = null;
			}

			StarlingHelpers.disposeTextureSprite(background);
			StarlingHelpers.removeFromParent(title);

			title = null;
			background = null;
			gameFacade = null;
			mediatorName = null;
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function setVisible(visible:Boolean):void
		{
			background.visible = visible;
			title.visible = visible;
			closeButton.visible = visible;
		}

		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================

		protected function handleButtonTriggered(event:Event):void
		{
			gameFacade.sendNotification(mediatorName + CLOSE_BUTTON_TRIGGERED);
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		protected function createBackground(container:DisplayObjectContainer, configurationVO:PopupConfigurationVO):void
		{
			// Internals
			var vectorSprite:flash.display.Sprite = new flash.display.Sprite(),
				width:int = configurationVO.getWidth(),
				height:int = configurationVO.getHeight(),
				bitmapData:BitmapData = new BitmapData(width, height, true, 0x0);
			// Draw from vector
			vectorSprite.graphics.beginFill(configurationVO.getColor(), 1);
			vectorSprite.graphics.drawRoundRect(0, 0, width, height, width * .1);
			vectorSprite.graphics.endFill();
			bitmapData.draw(vectorSprite, null, null, null, null, true);
			// Add to container
			background = StarlingHelpers.createTextureSprite(bitmapData, width, height);
			container.addChild(background);
			background.x = configurationVO.getX();
			background.y = configurationVO.getY();
		}

		protected function createTitle(container:DisplayObjectContainer, configurationVO:PopupConfigurationVO):void
		{
			var titleText:String = LocalizationHelpers.getLocalizedText(mediatorName, "title");
			title = new TextField(configurationVO.getWidth(), configurationVO.getHeight() * 0.2, titleText, Constants.APPLICATION_FONT_BOLD, 40, 0xFFFFFF, true);
			title.x = configurationVO.getX();
			title.y = configurationVO.getY() + (configurationVO.getHeight() >> 2);
			container.addChild(title);
		}

		protected function createCloseButton(container:DisplayObjectContainer, configurationVO:PopupConfigurationVO):void
		{
			var size:int = configurationVO.getWidth() * 0.1;
			buttonTextures = ButtonHelpers.getSquareButtonTextures("buttonCloseLinkage", 2, size);
			closeButton = new Button(buttonTextures[0], "", buttonTextures[1]);
			container.addChild(closeButton);
			closeButton.x = configurationVO.getX() + configurationVO.getWidth() - closeButton.width - (closeButton.width >> 2);
			closeButton.y = configurationVO.getY() + (closeButton.height >> 2);
		}
	}
}
