package test.screens.common.view
{
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IRunnable;

	import constants.Constants;

	import flash.geom.Rectangle;

	import starling.display.Button;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import test.facade.TestGameFacade;

	public class ButtonView implements IRunnable
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const BUTTON_TRIGGERED							:String = "buttonTriggered";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var notificationName									:String;
		private var buttonData											:Object;
		private var button												:Button;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function ButtonView(mediatorName:String, buttonData:Object)
		{
			this.notificationName = mediatorName + BUTTON_TRIGGERED;
			this.buttonData = buttonData;
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function createButton(container:Sprite, normalButtonTexture:Texture, downButtonTexture:Texture,
									 	text:String, textBounds:Rectangle, x:int, y:int, fontSize:int, fontColor:int):void
		{
			button = new Button(normalButtonTexture, text, downButtonTexture);
			button.x = x;
			button.y = y;
			if (text != null && text.length > 0)
			{
				button.fontName = Constants.APPLICATION_FONT_REGULAR;
				button.fontSize = fontSize;
				button.fontColor = fontColor;
			}
			if (textBounds != null)
			{
				button.textBounds = textBounds;
			}
			container.addChild(button);
		}

		//==============================================================================================================
		// IRunnable IMPLEMENTATION
		//==============================================================================================================

		public function start():void
		{
			button.addEventListener(Event.TRIGGERED, handleTestButtonTriggered);
		}

		public function pause():void
		{
			button.removeEventListener(Event.TRIGGERED, handleTestButtonTriggered);
		}

		public function resume():void
		{
			button.addEventListener(Event.TRIGGERED, handleTestButtonTriggered);
		}

		public function dispose():void
		{
			if (button != null)
			{
				button.removeEventListeners();
				StarlingHelpers.removeFromParent(button);
				button = null;
			}
			notificationName = null;
			buttonData = null;
		}

		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================

		private function handleTestButtonTriggered(event:Event):void
		{
			TestGameFacade.getInstance().sendNotification(notificationName, buttonData);
		}
	}
}
