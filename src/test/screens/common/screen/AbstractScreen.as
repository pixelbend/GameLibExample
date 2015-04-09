package test.screens.common.screen
{
	import com.pixelBender.helpers.DictionaryHelpers;
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import com.pixelBender.view.gameScreen.StarlingGameScreen;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import org.puremvc.as3.interfaces.INotification;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import test.screens.common.model.AbstractScreenProxy;
	import test.screens.common.utils.ScaleBitmap;
	import test.screens.common.view.ButtonView;
	import test.screens.common.view.TitleView;
	import test.screens.common.vo.ButtonLayoutVO;
	import test.screens.common.vo.IButtonDataVO;

	public class AbstractScreen extends StarlingGameScreen
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Starling screen graphics container
		 */
		protected var starlingGameScreen											:Sprite;

		/**
		 * Welcome intro text
		 */
		protected var title															:TitleView;

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

		public function AbstractScreen(mediatorName:String)
		{
			super(mediatorName);
			starlingGameScreen = new Sprite();
		}

		//==============================================================================================================
		// IRunnable OVERRIDES
		//==============================================================================================================

		override public function prepareForStart(starlingScreenContainer:DisplayObjectContainer,
												 gameScreenProxy:GameScreenProxy):void
		{
			starlingScreenContainer.addChild(starlingGameScreen);
			title = new TitleView(mediatorName, starlingGameScreen, gameFacade.getApplicationSize());
			createTestButtons(gameScreenProxy as AbstractScreenProxy);
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
			IRunnableHelpers.dispose([title]);
			title = null;
			StarlingHelpers.removeFromParent(starlingGameScreen, false);
		}

		override public function dispose():void
		{
			StarlingHelpers.disposeContainer(starlingGameScreen);
			starlingGameScreen = null;
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
		}

		//==============================================================================================================
		// IMediator OVERRIDES
		//==============================================================================================================

		public override function listNotificationInterests():Array
		{
			return [
					getTestButtonNotificationName()
					];
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

		protected function handleTestButtonTriggered(testButtonData:Object):void {}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		protected function getTestButtonNotificationName():String
		{
			return mediatorName + ButtonView.BUTTON_TRIGGERED;
		}

		protected function createTestButtons(screenProxy:AbstractScreenProxy):void
		{
			var t:int = getTimer();
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

			Logger.debug(this + "Button common computation took: " + (getTimer()-t) + " ms.");

			// Create buttons
			testButtons = new Vector.<ButtonView>(buttonLength);
			for (var i:int=0; i<buttonLength; i++)
			{
				var buttonRow:int = i / buttonsPerRow,
					buttonColumn:int = i % buttonsPerRow,
					textures:Vector.<Texture> = getButtonTexturePair(buttonData[i].getButtonGraphics(), buttonWidth, buttonHeight);
				testButtons[i] = new ButtonView(mediatorName, buttonData[i]);
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

		protected function getButtonTexturePair(buttonGraphicsLinkage:String, buttonWidth:int, buttonHeight:int):Vector.<Texture>
		{
			// Internals
			var buttonClass:Class,
				buttonGraphics:MovieClip,
				originalButtonBitmapData:BitmapData,
				originalButtonBitmap:ScaleBitmap,
				bitmapData:BitmapData,
				scale9Grid:Rectangle,
				buttonTexturesPair:Vector.<Texture>;


			if (buttonTextures == null)
			{
				buttonTextures = new Dictionary();
			}

			if (buttonTextures[buttonGraphicsLinkage])
			{
				return buttonTextures[buttonGraphicsLinkage];
			}

			buttonClass = ApplicationDomain.currentDomain.getDefinition(buttonGraphicsLinkage) as Class;
			buttonGraphics = new buttonClass();
			scale9Grid = new Rectangle();
			buttonTexturesPair = new Vector.<Texture>(2, true);

			// Compute vector scale 9 grid rect
			scale9Grid.x = buttonGraphics.width * 0.1;
			scale9Grid.y = buttonGraphics.height * 0.1;
			scale9Grid.width = buttonGraphics.width * 0.8;
			scale9Grid.height = buttonGraphics.height * 0.8;

			for (var j:int=0; j<buttonTexturesPair.length; j++)
			{
				buttonGraphics.gotoAndStop(j+1);
				originalButtonBitmapData = new BitmapData(buttonGraphics.width, buttonGraphics.height, true, 0x0);
				originalButtonBitmapData.draw(buttonGraphics, null, null, null, null, true);
				originalButtonBitmap = new ScaleBitmap(originalButtonBitmapData, "auto", true);
				originalButtonBitmap.scale9Grid = scale9Grid;
				originalButtonBitmap.setSize(buttonWidth, buttonHeight);
				bitmapData = new BitmapData(buttonWidth, buttonHeight, true, 0x00000000);
				bitmapData.draw(originalButtonBitmap, null, null, null, null, true);
				buttonTexturesPair[j] = Texture.fromBitmapData(bitmapData, false);
			}

			buttonTextures[buttonGraphicsLinkage] = buttonTexturesPair;
			return buttonTexturesPair;
		}
	}
}
