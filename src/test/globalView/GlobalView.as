package test.globalView
{
	import com.pixelBender.facade.GameFacade;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IDispose;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import flash.display.BitmapData;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class GlobalView implements IDispose
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		private const PAUSE_BUTTON_ID								:int = 0;
		private const RESUME_BUTTON_ID								:int = 1;
		private const DISPOSE_BUTTON_ID								:int = 2;

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var tests											:GameLibTests;
		private var container										:Sprite;
		private var background										:Image;
		private var pauseButton										:Button;
		private var resumeButton									:Button;
		private var disposeButton									:Button;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function GlobalView(tests:GameLibTests, gameContainer:Sprite, size:GameSizeVO)
		{
			this.tests = tests;

			container = new Sprite();
			container.x = size.getWidth() * 0.1;
			gameContainer.addChild(container);

			createBackground(container, size);

			pauseButton = createButton(PAUSE_BUTTON_ID, container, size);
			resumeButton = createButton(RESUME_BUTTON_ID, container, size);
			disposeButton = createButton(DISPOSE_BUTTON_ID, container, size);
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function dispose():void
		{
			StarlingHelpers.disposeContainer(container);
			container = null;
			background = null;
			pauseButton = null;
			resumeButton = null;
			disposeButton = null;
		}

		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================

		private function handleButtonTriggered(event:Event):void
		{
			switch(event.target)
			{
				case pauseButton:
					tests.testPause();
					break;
				case resumeButton:
					tests.testResume();
					break;
				case disposeButton:
					tests.testDispose();
					break;
			}
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		private function createBackground(container:Sprite, size:GameSizeVO):void
		{
			var bitmapData:BitmapData = new BitmapData(size.getWidth() * 0.8, size.getHeight() * 0.1, true, 0x33000000),
				texture:Texture = Texture.fromBitmapData(bitmapData, false, false);
			background = new Image(texture);
			container.addChild(background);
		}

		private function createButton(buttonID:int, container:Sprite, size:GameSizeVO):Button
		{
			var bitmapData:BitmapData = new BitmapData(size.getWidth() * 0.2, size.getHeight() * 0.08, true, 0xFF000000),
				texture:Texture = Texture.fromBitmapData(bitmapData, false, false),
				button:Button = new Button(texture, getTextForButton(buttonID));
			button.y = size.getHeight() * 0.01;
			button.x = size.getWidth() * 0.05 + size.getWidth() * 0.25 * buttonID;
			button.fontColor = 0xFFFFFF;
			button.addEventListener(Event.TRIGGERED, handleButtonTriggered);
			container.addChild(button);

			return button;
		}

		public function getTextForButton(buttonID:int):String
		{
			switch(buttonID)
			{
				case PAUSE_BUTTON_ID:
					return "PAUSE";
				case RESUME_BUTTON_ID:
					return "RESUME";
				case DISPOSE_BUTTON_ID:
					return "DISPOSE";
			}
			return "";
		}
	}
}
