package test.screens.popupTest
{
	import com.pixelBender.helpers.IDisposeHelpers;
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.helpers.PopupHelpers;
	import com.pixelBender.helpers.ScreenHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import com.pixelBender.model.vo.popup.PopupTranslucentLayerVO;
	import com.pixelBender.view.gameScreen.StarlingGameScreen;

	import constants.Constants;

	import flash.display.BitmapData;

	import flash.display.MovieClip;

	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.profiler.profile;
	import flash.system.ApplicationDomain;

	import org.puremvc.as3.interfaces.INotification;

	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.textures.Texture;

	import test.screens.common.view.BackView;
	import test.screens.common.view.ButtonView;
	import test.screens.common.view.TitleView;
	import test.screens.popupTest.command.ChangeCustomizationStateCommand;
	import test.screens.popupTest.view.AlphaSwitchCustomizeView;
	import test.screens.popupTest.view.CheckBoxCustomizeView;
	import test.screens.popupTest.view.ColorSwitchCustomizeView;
	import test.screens.popupTest.view.PopupCustomizeView;
	import test.screens.popupTest.view.TranslucentLayerResultView;
	import test.screens.popupTest.vo.CustomizationStateVO;
	import test.screens.popupTest.vo.PopupButtonVO;
	import test.screens.popupTest.vo.PopupCustomizeViewVO;

	public class PopupTestScreen extends StarlingGameScreen
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		private static const STACK_POPUPS_VIEW_ID						:String = "enableStackPopups";
		private static const ENABLE_LAYER_VIEW_ID						:String = "enableTranslucentLayer";
		private static const LAYER_COLOR_VIEW_ID						:String = "changeTranslucentLayerColor";
		private static const LAYER_ALPHA_VIEW_ID						:String = "changeTranslucentLayerAlpha";

		//==============================================================================================================
		// EMBEDDED MEMBERS
		//==============================================================================================================

		[Embed(source="../../../assets/generic/screens/popupTest/settings/logic.xml")]
		private const logicXML														:Class;

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Starling screen graphics container
		 */
		protected var starlingGameScreen									:Sprite;

		/**
		 * Back view
		 */
		protected var backView												:BackView;

		/**
		 * Welcome intro text
		 */
		protected var title													:TitleView;

		/**
		 * All the customized views
		 */
		protected var customizeViews										:Vector.<PopupCustomizeView>;

		/**
		 * All the changes done to the translucent layer properties will be aggregated and shown in this view
		 */
		protected var resultView											:TranslucentLayerResultView;

		/**
		 * The button that will start the first popup
		 */
		protected var openPopupButton										:ButtonView;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function PopupTestScreen(mediatorName:String)
		{
			super(mediatorName);
			starlingGameScreen = new Sprite();
		}

		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================

		override public function prepareForStart(starlingScreenContainer:DisplayObjectContainer,
												 gameScreenProxy:GameScreenProxy):void
		{
			var popupScreenProxy:PopupTestProxy = gameScreenProxy as PopupTestProxy,
				gameSize:GameSizeVO = gameFacade.getApplicationSize();

			starlingScreenContainer.addChild(starlingGameScreen);

			title = new TitleView(mediatorName, starlingGameScreen, gameSize);
			backView = new BackView(facade, mediatorName, starlingGameScreen, gameSize);
			createCustomizeViews(popupScreenProxy, gameSize);
			createButton(popupScreenProxy, gameSize);

			sendReadyToStart();
		}

		public override function start():void
		{
			IRunnableHelpers.start(backView);
			IRunnableHelpers.start(customizeViews);
			IRunnableHelpers.start(openPopupButton);
		}

		public override function pause():void
		{
			IRunnableHelpers.pause(backView);
			IRunnableHelpers.pause(customizeViews);
			IRunnableHelpers.pause(openPopupButton);
		}

		public override function resume():void
		{
			IRunnableHelpers.resume(backView);
			IRunnableHelpers.resume(customizeViews);
			IRunnableHelpers.resume(openPopupButton);
		}

		public override function stop():void
		{
			starlingGameScreen.removeFromParent();
			IRunnableHelpers.dispose([backView, title, openPopupButton]);
			IRunnableHelpers.dispose(customizeViews);
			IDisposeHelpers.dispose(resultView);
			openPopupButton = null;
			customizeViews = null;
			resultView = null;
			backView = null;
			title = null;
		}

		override public function dispose():void
		{
			StarlingHelpers.disposeContainer(starlingGameScreen);
			starlingGameScreen = null;
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
		// MEDIATOR API
		//==============================================================================================================

		public override function onRegister():void
		{
			super.onRegister();
			facade.registerCommand(Constants.CHANGE_POPUP_CUSTOMIZATION_STATE, ChangeCustomizationStateCommand);
		}

		public override function onRemove():void
		{
			super.onRemove();
			facade.removeCommand(Constants.CHANGE_POPUP_CUSTOMIZATION_STATE);
		}

		public override function listNotificationInterests():Array
		{
			return [ getBackNotificationName(), Constants.POPUP_CUSTOMIZATION_STATE_CHANGED, mediatorName + ButtonView.BUTTON_TRIGGERED ];
		}

		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case getBackNotificationName():
					ScreenHelpers.showScreen(Constants.INTRO_SCREEN_NAME, Constants.TRANSITION_SEQUENCE_NAME);
					break;
				case Constants.POPUP_CUSTOMIZATION_STATE_CHANGED:
					assignValues(notification.getBody() as CustomizationStateVO);
					break;
				case mediatorName + ButtonView.BUTTON_TRIGGERED:
					PopupHelpers.openPopup(Constants.FIRST_POPUP_NAME);
					break;
			}
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		protected function assignValues(customizationVO:CustomizationStateVO):void
		{
			var translucentPropertiesVO:PopupTranslucentLayerVO = customizationVO.getTranslucentLayerVO();

			for (var i:int=0; i<customizeViews.length; i++)
			{
				switch(customizeViews[i].getID())
				{
					case STACK_POPUPS_VIEW_ID:
						CheckBoxCustomizeView(customizeViews[i]).setState(customizationVO.getStackPopups());
						break;
					case ENABLE_LAYER_VIEW_ID:
						CheckBoxCustomizeView(customizeViews[i]).setState(translucentPropertiesVO.getLayerEnabled());
						break;
					case LAYER_COLOR_VIEW_ID:
						ColorSwitchCustomizeView(customizeViews[i]).setColor(translucentPropertiesVO.getLayerColor());
						break;
					case LAYER_ALPHA_VIEW_ID:
						AlphaSwitchCustomizeView(customizeViews[i]).setAlpha(translucentPropertiesVO.getLayerAlpha());
						break;
				}
			}
			resultView.update(translucentPropertiesVO);
		}

		protected function getBackNotificationName():String
		{
			return mediatorName + BackView.BACK_TRIGGERED;
		}

		private function createCustomizeViews(proxy:PopupTestProxy, gameSize:GameSizeVO):void
		{
			proxy.initializeState();

			var size:int = gameSize.getHeight() * 0.1,
				checkBoxTextures:Vector.<Texture> = getGraphicsTextures("checkBoxLinkage", 2, size, size),
				customizationVO:CustomizationStateVO = proxy.getCustomizationStateVO(),
				viewVOs:Vector.<PopupCustomizeViewVO> = proxy.getCustomizeVOs(),
				view:PopupCustomizeView;

			resultView = new TranslucentLayerResultView(mediatorName, starlingGameScreen, proxy.getResultViewVO(), gameSize, size);
			customizeViews = new Vector.<PopupCustomizeView>(viewVOs.length, true);

			for (var i:int=0; i<viewVOs.length; i++)
			{
				switch(viewVOs[i].getViewType())
				{
					case PopupCustomizeView.TYPE_CHECKBOX:
						view = new CheckBoxCustomizeView(mediatorName, starlingGameScreen, viewVOs[i], gameSize, checkBoxTextures);
						break;
					case PopupCustomizeView.TYPE_COLOR_SWITCH:
						view = new ColorSwitchCustomizeView(mediatorName, starlingGameScreen, viewVOs[i], gameSize, size);
						break;
					case PopupCustomizeView.TYPE_ALPHA_SWITCH:
						view = new AlphaSwitchCustomizeView(mediatorName, starlingGameScreen, viewVOs[i], gameSize, size);
						break;
				}
				customizeViews[i] = view;
			}
			// Assign the initial values
			assignValues(customizationVO);
		}

		private function createButton(proxy:PopupTestProxy, gameSize:GameSizeVO):void
		{
			var buttonVO:PopupButtonVO = proxy.getButtonVO(),
				buttonX:int = gameSize.getWidth() * buttonVO.getX(),
				buttonY:int = gameSize.getHeight() * buttonVO.getY(),
				buttonWidth:int = gameSize.getWidth() * buttonVO.getWidth(),
				buttonHeight:int = gameSize.getHeight() * buttonVO.getHeight(),
				buttonTextures:Vector.<Texture> = getGraphicsTextures("buttonLinkage", 2, buttonWidth, buttonHeight),
				buttonText:String = LocalizationHelpers.getLocalizedText(mediatorName, buttonVO.getTextID()),
				buttonFontSize:int = buttonHeight * 0.15;

			openPopupButton = new ButtonView(mediatorName, null);
			openPopupButton.createButton(starlingGameScreen, buttonTextures[0], buttonTextures[1], buttonText, null, buttonX, buttonY, buttonFontSize, 0xFFFFFF)
		}

		protected static function getGraphicsTextures(linkage:String, numberOfFrames:int, width:int, height:int):Vector.<Texture>
		{
			var buttonClass:Class,
				buttonGraphics:MovieClip,
				bitmapData:BitmapData,
				matrix:Matrix = new Matrix(),
				buttonTextures:Vector.<Texture>;

			buttonClass = ApplicationDomain.currentDomain.getDefinition(linkage) as Class;
			buttonGraphics = new buttonClass();
			buttonTextures = new Vector.<Texture>(numberOfFrames, true);

			for (var i:int=0; i<buttonTextures.length; i++)
			{
				matrix.identity();
				buttonGraphics.gotoAndStop(i+1);
				matrix.scale(width/buttonGraphics.width, height/buttonGraphics.height);
				bitmapData = new BitmapData(width, height, true, 0x00000000);
				bitmapData.draw(buttonGraphics, matrix, null, null, null, true);
				buttonTextures[i] = Texture.fromBitmapData(bitmapData, false);
			}

			return buttonTextures;
		}
	}
}
