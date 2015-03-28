package test.screens.common.view
{
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IRunnable;

	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	import test.facade.TestGameFacade;

	public class TestButtonView implements IRunnable
	{

		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const BUTTON_TRIGGERED							:String = "buttonTriggered";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var button												:Button;
		private var notificationName									:String;
		private var buttonID											:String;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function TestButtonView(mediatorName:String, buttonID:String)
		{
			this.notificationName = mediatorName + BUTTON_TRIGGERED;
			this.buttonID = buttonID;
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function createButton(container:Sprite, normalButtonTexture:Texture, downButtonTexture:Texture, x:int, y:int):void
		{
			button = new Button(normalButtonTexture, "", downButtonTexture);
			button.x = x;
			button.y = y;
			container.addChild(button);
		}

		public function enable():void
		{
			button.enabled = true;
		}

		public function disable():void
		{
			button.enabled = false;
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
		}

		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================

		private function handleTestButtonTriggered(event:Event):void
		{
			TestGameFacade.getInstance().sendNotification(notificationName, buttonID);
		}
	}
}
