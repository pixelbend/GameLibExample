package test.screens.popupTest
{
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.helpers.PopupHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import com.pixelBender.model.vo.popup.PopupTranslucentLayerVO;
	import starling.display.DisplayObjectContainer;
	import starling.text.TextField;
	import test.screens.common.screen.TestScreen;
	import test.screens.popupTest.vo.PopupTestButtonVO;

	public class PopupTestScreen extends TestScreen
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		private static const OPEN_POPUP							:String = "_popupScreen__openPopup";
		private static const SWITCH_STACK_POPUPS				:String = "_popupScreen__switchStackPopups";
		private static const SWITCH_TRANSLUCENT_LAYER_ENABLED	:String = "_popupScreen__switchTranslucentLayerEnabled";
		private static const CHANGE_TRANSLUCENT_LAYER_ALPHA		:String = "_popupScreen__changeTranslucentLayerAlpha";
		private static const CHANGE_TRANSLUCENT_LAYER_COLOR		:String = "_popupScreen__changeTranslucentLayerColor";

		//==============================================================================================================
		// EMBEDDED MEMBERS
		//==============================================================================================================

		[Embed(source="../../../assets/generic/screens/popupTest/settings/logic.xml")]
		private const logicXML														:Class;

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var statusTexts								:Vector.<TextField>;

		private var availableAlphas							:Vector.<Number>;
		private var currentAlphaIndex						:int;
		private var availableColors							:Vector.<int>;
		private var currentColorIndex						:int;

		private var stackPopups								:Boolean;
		private var translucentLayerEnabled					:Boolean;
		private var translucentLayerColor					:int;
		private var translucentLayerAlpha					:Number;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function PopupTestScreen(mediatorName:String)
		{
			super(mediatorName);
		}

		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================

		override public function prepareForStart(starlingScreenContainer:DisplayObjectContainer,
												 gameScreenProxy:GameScreenProxy):void
		{
			var popupTranslucentLayerProperties:PopupTranslucentLayerVO;
			super.prepareForStart(starlingScreenContainer, gameScreenProxy);
			// Get data from proxy
			availableAlphas = PopupTestProxy(gameScreenProxy).getTranslucentLayerAlphaValues();
			availableColors = PopupTestProxy(gameScreenProxy).getTranslucentLayerColorValues();
			currentColorIndex = -1;
			currentAlphaIndex = -1;
			// Retrieve all current configuration values from PopupManager
			stackPopups = PopupHelpers.getStackPopups();
			popupTranslucentLayerProperties = PopupHelpers.getTranslucentLayerProperties();
			translucentLayerEnabled = popupTranslucentLayerProperties.getLayerEnabled();
			translucentLayerColor = popupTranslucentLayerProperties.getLayerColor();
			translucentLayerAlpha = popupTranslucentLayerProperties.getLayerAlpha();
			// Status texts
			createStatusTexts();
			// Send ready
			sendReadyToStart();
		}

		public override function stop():void
		{
			if (statusTexts != null)
			{
				for (var i:int = 0; i<statusTexts.length; i++)
				{
					statusTexts[i].removeFromParent(true);
					statusTexts[i] = null;
				}
				statusTexts = null;
			}
			availableAlphas = null;
			availableColors = null;
			super.stop();
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		override protected function getScreenAssetXML():XML { return null; }
		override protected function getScreenLogicXML():XML { return new XML(logicXML.data); }
		override protected function createGameScreenProxy():GameScreenProxy
		{
			return new PopupTestProxy(getGameScreenProxyName(), mediatorName, getScreenLogicXML(), getScreenAssetXML());
		}

		//==============================================================================================================
		// NOTIFICATION/CALLBACK HANDLERS
		//==============================================================================================================

		protected override function handleTestButtonTriggered(testButtonData:Object):void
		{
			var data:PopupTestButtonVO = testButtonData as PopupTestButtonVO;
			switch(data.getCommandName())
			{
				case OPEN_POPUP:
					PopupHelpers.openPopup(data.getPopupName());
					break;
				case SWITCH_STACK_POPUPS:
					stackPopups = !stackPopups;
					PopupHelpers.setStackPopups(stackPopups);
					updateStatusTexts(0);
					break;
				case SWITCH_TRANSLUCENT_LAYER_ENABLED:
					translucentLayerEnabled = !translucentLayerEnabled;
					PopupHelpers.setTranslucentLayerEnabled(translucentLayerEnabled);
					updateStatusTexts(1);
					break;
				case CHANGE_TRANSLUCENT_LAYER_COLOR:
					currentColorIndex = (currentColorIndex+1) % availableColors.length;
					translucentLayerColor = availableColors[currentColorIndex];
					PopupHelpers.setTranslucentLayerColor(translucentLayerColor);
					updateStatusTexts(2);
					break;
				case CHANGE_TRANSLUCENT_LAYER_ALPHA:
					currentAlphaIndex = (currentAlphaIndex+1) % availableAlphas.length;
					translucentLayerAlpha = availableAlphas[currentAlphaIndex];
					PopupHelpers.setTranslucentLayerAlpha(translucentLayerAlpha);
					updateStatusTexts(3);
					break;
			}
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		private function createStatusTexts():void
		{
			const statusTextsLength:int = 4;

			var gameSize:GameSizeVO = gameFacade.getApplicationSize(),
				width:int = gameSize.getWidth() >> 1,
				halfScreenHeight:int = gameSize.getHeight() >> 1,
				height:int = gameSize.getHeight() >> 2;

			statusTexts = new Vector.<TextField>(statusTextsLength, true);
			for (var i:int=0; i<statusTextsLength; i++)
			{
				var statusText:TextField = new TextField(width, height, "", "Tahoma", 40);
				statusText.x = (i%2 == 0) ? 0 : width;
				statusText.y = halfScreenHeight + Math.floor(i/2) * height;
				starlingGameScreen.addChild(statusText);
				statusTexts[i] = statusText;
			}
			updateStatusTexts();
		}

		private function updateStatusTexts(index:int = -1):void
		{
			var statusTextsIDs:Array = ["stackPopups", "translucentLayerEnabled", "translucentLayerColor", "translucentLayerAlpha"],
				statusesToShow:Array = [stackPopups, translucentLayerEnabled, translucentLayerColor, translucentLayerAlpha];

			for (var i:int=0; i<statusTexts.length; i++)
			{
				if (index == i || index < 0)
				{
					var statusValue:String = (i == 2) ? int(statusesToShow[i]).toString(16) : statusesToShow[i].toString();
					statusTexts[i].text = LocalizationHelpers.getLocalizedText(mediatorName, statusTextsIDs[i]) + statusValue;
				}
			}
		}
	}
}
