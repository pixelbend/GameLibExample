package test.screens.intro
{
	import com.pixelBender.helpers.DictionaryHelpers;
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.helpers.ScreenHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.vo.game.GameSizeVO;

	import constants.Constants;

	import flash.geom.Rectangle;

	import flash.utils.Dictionary;

	import helpers.ButtonHelpers;

	import org.puremvc.as3.interfaces.INotification;

	import starling.display.DisplayObjectContainer;
	import starling.textures.Texture;

	import test.screens.common.screen.BaseTestScreen;
	import test.screens.common.view.ButtonView;
	import test.screens.common.vo.ButtonLayoutVO;
	import test.screens.common.vo.IButtonDataVO;
	import test.screens.intro.vo.IntroButtonDataVO;

	public class IntroScreen extends BaseTestScreen
	{
		//==============================================================================================================
		// EMBEDDED MEMBERS
		//==============================================================================================================

		[Embed(source="../../../assets/generic/screens/intro/settings/logic.xml")]
		private const logicXML														:Class;

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * All the test screen buttons
		 */
		protected var testButtons													:Vector.<ButtonView>;

		/**
		 * Button textures
		 */
		protected var buttonTextures												:Dictionary;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function IntroScreen(mediatorName:String)
		{
			super(mediatorName);
			buttonTextures = new Dictionary(false);
		}
		
		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================
		
		override public function prepareForStart(starlingScreenContainer:DisplayObjectContainer,
												 	gameScreenProxy:GameScreenProxy):void
		{
			super.prepareForStart(starlingScreenContainer, gameScreenProxy);
			createTestButtons(gameScreenProxy as IntroScreenProxy);
			sendReadyToStart();
		}

		override public function start():void
		{
			IRunnableHelpers.start(testButtons);
		}

		override public function pause():void
		{
			IRunnableHelpers.pause(testButtons);
		}

		override public function resume():void
		{
			IRunnableHelpers.resume(testButtons);
		}

		override public function stop():void
		{
			IRunnableHelpers.dispose(testButtons);
			testButtons = null;
			super.stop();
		}

		override public function dispose():void
		{
			if (buttonTextures != null)
			{
				for (var key:String in buttonTextures)
				{
					var buttonTexturesPair:Vector.<Texture> = buttonTextures[key];
					for (var i:int=0; i<buttonTexturesPair.length; i++)
					{
						buttonTexturesPair[i].dispose();
						buttonTexturesPair[i] = null;
					}
				}
				DictionaryHelpers.deleteValues(buttonTextures);
				buttonTextures = null;
			}

			super.dispose();
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		override protected function getScreenAssetXML():XML { return null; }
		override protected function getScreenLogicXML():XML { return new XML(logicXML.data); }
		override protected function createGameScreenProxy():GameScreenProxy
		{
			return new IntroScreenProxy(getGameScreenProxyName(), mediatorName, getScreenLogicXML(), getScreenAssetXML());
		}

		//==============================================================================================================
		// IMediator OVERRIDES
		//==============================================================================================================

		public override function listNotificationInterests():Array
		{
			return [ getTestButtonNotificationName() ];
		}

		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case getTestButtonNotificationName():
					handleTestButtonTriggered(notification.getBody());
					break;
			}
		}

		//==============================================================================================================
		// NOTIFICATION HANDLERS
		//==============================================================================================================

		protected static function handleTestButtonTriggered(testButtonData:Object):void
		{
			var data:IntroButtonDataVO = testButtonData as IntroButtonDataVO;
			ScreenHelpers.showScreen(data.getScreenName(), Constants.TRANSITION_SEQUENCE_NAME);
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		protected function getTestButtonNotificationName():String
		{
			return mediatorName + ButtonView.BUTTON_TRIGGERED;
		}

		protected function createTestButtons(screenProxy:IntroScreenProxy):void
		{
			// Constants -> retrieved from XML
			const 	gameSize:GameSizeVO = gameFacade.getApplicationSize(),
					layout:ButtonLayoutVO = screenProxy.getButtonLayout(),
					buttonData:Vector.<IButtonDataVO> = screenProxy.getButtonsData(),
					buttonsPerRow:int = layout.getColumns(),
					buttonWidth:int = gameSize.getWidth() * layout.getWidth(),
					buttonHeight:int = gameSize.getHeight() * layout.getHeight(),
					buttonHorizontalGap:int = buttonWidth * layout.getHorizontalGap(),
					buttonVerticalGap:int = buttonHeight * layout.getVerticalGap(),
					startX:int = starlingGameScreen.stage.stageWidth * layout.getStartX(),
					startY:int = starlingGameScreen.stage.stageHeight * layout.getStartY(),
					buttonLength:int = buttonData.length,
					buttonFontSize:int = buttonHeight * 0.25,
					buttonTextBounds:Rectangle = new Rectangle();

			// Compute text bounds
			buttonTextBounds.x = buttonWidth * 0.05;
			buttonTextBounds.y = buttonHeight * 0.05;
			buttonTextBounds.width = buttonWidth * 0.85;
			buttonTextBounds.height = buttonHeight * 0.85;

			// Create buttons
			testButtons = new Vector.<ButtonView>(buttonLength);
			for (var i:int=0; i<buttonLength; i++)
			{
				var buttonRow:int = i / buttonsPerRow,
					buttonColumn:int = i % buttonsPerRow,
					textures:Vector.<Texture>;

				if (buttonTextures[buttonData[i].getButtonGraphics()] == null)
				{
					buttonTextures[buttonData[i].getButtonGraphics()] = ButtonHelpers.getButtonTextures(buttonData[i].getButtonGraphics(), 2, buttonWidth, buttonHeight);
				}
				textures = buttonTextures[buttonData[i].getButtonGraphics()];

				testButtons[i] = new ButtonView(mediatorName + ButtonView.BUTTON_TRIGGERED, buttonData[i]);
				testButtons[i].createButton(starlingGameScreen,
											textures[0],
											textures[1],
											LocalizationHelpers.getLocalizedText(mediatorName, buttonData[i].getTextID()),
											buttonTextBounds,
											(startX + buttonColumn * (buttonWidth + buttonHorizontalGap)),
											(startY + buttonRow * (buttonHeight + buttonVerticalGap)),
											buttonFontSize,
											0xFFFFFF);
			}
		}
	}
}