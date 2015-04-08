package test.screens.localeTest
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.helpers.ScreenHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import constants.Constants;
	import flash.display.Bitmap;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.text.TextField;
	import test.screens.common.screen.TestScreen;
	import test.screens.localeTest.vo.LocaleTestButtonVO;

	public class LocaleTestScreen extends TestScreen
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
			// Send ready
			sendReadyToStart();
		}

		public override function stop():void
		{
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

		protected override function handleTestButtonTriggered(testButtonData:Object):void
		{
			var data:LocaleTestButtonVO = testButtonData as LocaleTestButtonVO;
			switch(data.getCommandName())
			{
				case GameConstants.CHANGE_APPLICATION_LOCALE:
					handleChangeLanguage();
					break;
			}
		}

		private function handleChangeLanguage():void
		{
			++languageIndex;
			LocalizationHelpers.changeLocale(LANGUAGES[languageIndex % LANGUAGES.length]);
			ScreenHelpers.showScreen(mediatorName, Constants.TRANSITION_SEQUENCE_NAME);
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

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
	}
}
