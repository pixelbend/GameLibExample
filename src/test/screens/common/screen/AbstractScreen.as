package test.screens.common.screen
{
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
		protected var buttonTextures												:Vector.<Texture>;

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
				for (var i:int=0; i<buttonTextures.length; i++)
				{
					buttonTextures[i].dispose();
					buttonTextures[i] = null;
				}
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
					buttonFontSize:int = layout.getFontSize(),
					buttonsPerRow:int = layout.getColumns(),
					buttonWidth:int = gameSize.getWidth() * layout.getWidth(),
					buttonHeight:int = gameSize.getHeight() * layout.getHeight(),
					buttonHorizontalGap:int = buttonWidth * layout.getHorizontalGap(),
					buttonVerticalGap:int = buttonHeight * layout.getVerticalGap(),
					startX:int = starlingGameScreen.stage.stageWidth * layout.getStartX(),
					startY:int = starlingGameScreen.stage.stageHeight * layout.getStartY(),
					buttonLength:int = buttonData.length;

			// Internals
			var buttonGraphics:MovieClip,
				originalButtonBitmapData:BitmapData,
				originalButtonBitmap:ScaleBitmap,
				bitmapData:BitmapData,
				scale9Grid:Rectangle,
				buttonTextBounds:Rectangle = new Rectangle();

			if (buttonTextures == null)
			{
				buttonGraphics = new buttonLinkage();
				scale9Grid = new Rectangle();
				buttonTextures = new Vector.<Texture>(2, true);

				// Compute vector scale 9 grid rect
				scale9Grid.x = buttonGraphics.width * 0.1;
				scale9Grid.y = buttonGraphics.height * 0.1;
				scale9Grid.width = buttonGraphics.width * 0.8;
				scale9Grid.height = buttonGraphics.height * 0.8;

				for (var j:int=0; j<2; j++)
				{
					buttonGraphics.gotoAndStop(j+1);
					originalButtonBitmapData = new BitmapData(buttonGraphics.width, buttonGraphics.height, true, 0x0);
					originalButtonBitmapData.draw(buttonGraphics, null, null, null, null, true);
					originalButtonBitmap = new ScaleBitmap(originalButtonBitmapData, "auto", true);
					originalButtonBitmap.scale9Grid = scale9Grid;
					originalButtonBitmap.setSize(buttonWidth, buttonHeight);
					bitmapData = new BitmapData(buttonWidth, buttonHeight, true, 0x00000000);
					bitmapData.draw(originalButtonBitmap, null, null, null, null, true);
					buttonTextures[j] = Texture.fromBitmapData(bitmapData, false);
				}
			}

			// Compute text bounds
			buttonTextBounds.x = buttonWidth * 0.15;
			buttonTextBounds.y = buttonHeight * 0.15;
			buttonTextBounds.width = buttonWidth * 0.7;
			buttonTextBounds.height = buttonHeight * 0.7;

			Logger.debug(this + "Button common computation took: " + (getTimer()-t) + " ms.");

			// Create buttons
			testButtons = new Vector.<ButtonView>(buttonLength);
			for (var i:int=0; i<buttonLength; i++)
			{
				var buttonRow:int = i / buttonsPerRow,
					buttonColumn:int = i % buttonsPerRow;
				testButtons[i] = new ButtonView(mediatorName, buttonData[i]);
				testButtons[i].createButton(starlingGameScreen,
												buttonTextures[0],
												buttonTextures[1],
												LocalizationHelpers.getLocalizedText(mediatorName, buttonData[i].getTextID()),
												buttonTextBounds,
												(startX + buttonColumn * (buttonWidth + buttonHorizontalGap)),
												(startY + buttonRow * (buttonHeight + buttonVerticalGap)),
												buttonFontSize,
												0x333333);
			}
		}
	}
}
