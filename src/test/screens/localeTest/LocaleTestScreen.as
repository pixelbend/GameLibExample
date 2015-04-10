package test.screens.localeTest
{
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.helpers.ScreenHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import constants.Constants;
	import flash.display.Bitmap;

	import helpers.ButtonHelpers;

	import org.puremvc.as3.interfaces.INotification;

	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;

	import test.screens.common.screen.TestScreenWithBackButton;
	import test.screens.common.view.ButtonView;
	import test.screens.localeTest.vo.LocaleTestButtonVO;

	public class LocaleTestScreen extends TestScreenWithBackButton
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		private const LANGUAGES						:Vector.<String> = new <String> [
																						Constants.LANGUAGE_ENGLISH,
																						Constants.LANGUAGE_ROMANIAN
																					];

		//==============================================================================================================
		// EMBEDDED MEMBERS
		//==============================================================================================================

		[Embed(source="../../../assets/generic/screens/localeTest/settings/logic.xml")]
		private const logicXML										:Class;

		[Embed(source="../../../assets/generic/screens/localeTest/settings/assets.xml")]
		private const assetsXML										:Class;

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var changeLanguageButton							:ButtonView;
		private var currentLanguageText								:TextField;
		private var languageImage									:Image;
		private var languageIndex									:int;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function LocaleTestScreen(mediatorName:String)
		{
			super(mediatorName);
			languageIndex = 0;
		}

		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================

		override public function prepareForStart(starlingScreenContainer:DisplayObjectContainer,
												 	gameScreenProxy:GameScreenProxy):void
		{
			super.prepareForStart(starlingScreenContainer, gameScreenProxy);
			// Create locals
			createText();
			createImage(gameScreenProxy);
			createButton(gameScreenProxy as LocaleTestProxy, gameFacade.getApplicationSize());
			// Send ready
			sendReadyToStart();
		}

		public override function start():void
		{
			IRunnableHelpers.start(changeLanguageButton);
			super.start();
		}

		public override function pause():void
		{
			IRunnableHelpers.pause(changeLanguageButton);
			super.pause();
		}

		public override function resume():void
		{
			IRunnableHelpers.resume(changeLanguageButton);
			super.pause();
		}

		public override function stop():void
		{
			IRunnableHelpers.dispose(changeLanguageButton);
			changeLanguageButton = null;
			StarlingHelpers.removeFromParent(currentLanguageText);
			currentLanguageText = null;
			StarlingHelpers.removeFromParent(languageImage);
			languageImage = null;
			super.stop();
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		override protected function getScreenAssetXML():XML { return new XML(assetsXML.data); }
		override protected function getScreenLogicXML():XML { return new XML(logicXML.data); }
		override protected function createGameScreenProxy():GameScreenProxy
		{
			return new LocaleTestProxy(getGameScreenProxyName(), mediatorName, getScreenLogicXML(), getScreenAssetXML());
		}

		//==============================================================================================================
		// NOTIFICATION/CALLBACK HANDLERS
		//==============================================================================================================

		public override function listNotificationInterests():Array
		{
			return [ getBackNotificationName(), mediatorName + ButtonView.BUTTON_TRIGGERED ];
		}

		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case getBackNotificationName():
					ScreenHelpers.showScreen(Constants.INTRO_SCREEN_NAME, Constants.TRANSITION_SEQUENCE_NAME);
					break;
				case mediatorName + ButtonView.BUTTON_TRIGGERED:
					handleChangeLanguage();
					break;
			}
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		private function handleChangeLanguage():void
		{
			++languageIndex;
			LocalizationHelpers.changeLocale(LANGUAGES[languageIndex % LANGUAGES.length]);
			ScreenHelpers.showScreen(mediatorName, Constants.TRANSITION_SEQUENCE_NAME);
		}

		private function createText():void
		{
			const 	gameSize:GameSizeVO = gameFacade.getApplicationSize(),
					width:int = gameSize.getWidth() >> 1,
					halfScreenHeight:int = gameSize.getHeight() >> 1,
					height:int = gameSize.getHeight() >> 2,
					localizedText:String = LocalizationHelpers.getLocalizedText(mediatorName, "currentLanguage") +
												LocalizationHelpers.getCurrentLocale().toUpperCase();

			currentLanguageText = new TextField(width, height, localizedText, Constants.APPLICATION_FONT_REGULAR, 40);
			currentLanguageText.x = 0;
			currentLanguageText.y = halfScreenHeight;
			starlingGameScreen.addChild(currentLanguageText);
		}

		private function createImage(gameScreenProxy:GameScreenProxy):void
		{
			const 	gameSize:GameSizeVO = gameFacade.getApplicationSize(),
					halfScreenWidth:int = gameSize.getWidth() >> 1,
					halfScreenHeight:int = gameSize.getHeight() >> 1,
					picture:Bitmap = gameScreenProxy.getScreenAssetPackage().getAsset("picture").getContent() as Bitmap;

			languageImage = Image.fromBitmap(picture);
			languageImage.x = halfScreenWidth;
			languageImage.y = halfScreenHeight;
			languageImage.scaleX = (gameSize.getWidth() * 0.33) / languageImage.width;
			languageImage.scaleY = (gameSize.getHeight()* 0.33) / languageImage.height;
			starlingGameScreen.addChild(languageImage);
		}
		private function createButton(proxy:LocaleTestProxy, gameSize:GameSizeVO):void
		{
			var buttonVO:LocaleTestButtonVO = proxy.getButtonVO(),
				buttonX:int = gameSize.getWidth() * buttonVO.getX(),
				buttonY:int = gameSize.getHeight() * buttonVO.getY(),
				buttonWidth:int = gameSize.getWidth() * buttonVO.getWidth(),
				buttonHeight:int = gameSize.getHeight() * buttonVO.getHeight(),
				buttonTextures:Vector.<Texture> = ButtonHelpers.getButtonTextures("buttonLinkage", 2, buttonWidth, buttonHeight),
				buttonText:String = LocalizationHelpers.getLocalizedText(mediatorName, buttonVO.getTextID()),
				buttonFontSize:int = buttonHeight * 0.2;

			changeLanguageButton = new ButtonView(mediatorName, null);
			changeLanguageButton.createButton(starlingGameScreen, buttonTextures[0], buttonTextures[1], buttonText, null, buttonX, buttonY, buttonFontSize, 0xFFFFFF)
		}
	}
}
