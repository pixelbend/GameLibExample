package test.screens.soundTest
{
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.helpers.ScreenHelpers;
	import com.pixelBender.helpers.SoundHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import com.pixelBender.view.gameScreen.StarlingGameScreen;

	import constants.Constants;

	import flash.display.BitmapData;

	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.system.ApplicationDomain;

	import flash.utils.Dictionary;

	import org.puremvc.as3.interfaces.INotification;

	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.textures.Texture;

	import test.screens.common.view.BackView;
	import test.screens.common.view.TitleView;
	import test.screens.common.vo.TestButtonLayoutVO;
	import test.screens.common.vo.TestButtonVO;
	import test.screens.soundTest.view.MasterVolumeViewMediator;
	import test.screens.soundTest.view.SoundTestViewMediator;
	import test.screens.soundTest.view.StopAllSoundsViewMediator;
	import test.screens.soundTest.vo.MasterVolumeViewVO;
	import test.screens.soundTest.vo.SoundTestSetupVO;
	import test.screens.soundTest.vo.StopAllSoundsViewVO;

	public class SoundTestScreen extends StarlingGameScreen
	{
		//==============================================================================================================
		// EMBEDDED MEMBERS
		//==============================================================================================================

		[Embed(source="../../../assets/generic/screens/soundTest/settings/logic.xml")]
		private const logicXML														:Class;

		[Embed(source="../../../assets/generic/screens/soundTest/settings/assets.xml")]
		private const assetsXML														:Class;

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
		 * Each sound test will be handled independently by it's own mediator
		 */
		protected var testViews												:Vector.<SoundTestViewMediator>;

		/**
		 * View mediator for stopping all playing sounds
		 */
		protected var stopAllSoundsMediator									:StopAllSoundsViewMediator;

		/**
		 * Mediator that handles the master volume scroller
		 */
		protected var masterVolumeMediator									:MasterVolumeViewMediator;

		/**
		 * Button textures map. Used by all tween test mediators
		 */
		protected var buttonTextures										:Dictionary;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function SoundTestScreen(mediatorName:String)
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
			var gameSize:GameSizeVO = gameFacade.getApplicationSize();

			registerDefaultPackageSounds();
			starlingScreenContainer.addChild(starlingGameScreen);
			title = new TitleView(mediatorName, starlingGameScreen, gameSize);
			backView = new BackView(facade, mediatorName, starlingGameScreen, gameSize);
			createTweenTestViews(gameScreenProxy as SoundTestProxy, gameSize);
			createStopAllSoundsMediator(gameScreenProxy as SoundTestProxy, gameSize);
			createMasterVolumeMediator(gameScreenProxy as SoundTestProxy, gameSize);

			sendReadyToStart();
		}

		override public function start():void
		{
			IRunnableHelpers.start(testViews);
			IRunnableHelpers.start(stopAllSoundsMediator);
			IRunnableHelpers.start(masterVolumeMediator);
			IRunnableHelpers.start(backView);
		}

		override public function pause():void
		{
			IRunnableHelpers.pause(testViews);
			IRunnableHelpers.pause(stopAllSoundsMediator);
			IRunnableHelpers.pause(masterVolumeMediator);
			IRunnableHelpers.pause(backView);
		}

		override public function resume():void
		{
			IRunnableHelpers.resume(testViews);
			IRunnableHelpers.resume(stopAllSoundsMediator);
			IRunnableHelpers.resume(masterVolumeMediator);
			IRunnableHelpers.resume(backView);
		}

		override public function stop():void
		{
			SoundHelpers.stopAllSoundsOnChannels();

			if (testViews != null)
			{
				for (var i:int=0; i<testViews.length; i++)
				{
					if (testViews[i] == null) continue;
					facade.removeMediator(testViews[i].getMediatorName());
					testViews[i].dispose();
				}
				testViews = null;
			}

			if (stopAllSoundsMediator != null)
			{
				facade.removeMediator(stopAllSoundsMediator.getMediatorName());
				stopAllSoundsMediator.dispose();
				stopAllSoundsMediator = null;
			}

			if (masterVolumeMediator != null)
			{
				facade.removeMediator(masterVolumeMediator.getMediatorName());
				masterVolumeMediator.dispose();
				masterVolumeMediator = null;
			}

			starlingGameScreen.removeFromParent();
			IRunnableHelpers.dispose([backView, title]);

			unregisterDefaultPackageSounds();
		}

		override public function dispose():void
		{
			StarlingHelpers.disposeContainer(starlingGameScreen);
			starlingGameScreen = null;
		}

		//==============================================================================================================
		// MEDIATOR API
		//==============================================================================================================

		public override function listNotificationInterests():Array
		{
			return [ getBackNotificationName() ];
		}

		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case getBackNotificationName():
					ScreenHelpers.showScreen(Constants.INTRO_SCREEN_NAME, Constants.TRANSITION_SEQUENCE_NAME);
					break;
			}
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		override protected function getScreenAssetXML():XML { return new XML(assetsXML.data); }
		override protected function getScreenLogicXML():XML { return new XML(logicXML.data); }
		override protected function createGameScreenProxy():GameScreenProxy
		{
			return new SoundTestProxy(getGameScreenProxyName(), mediatorName, getScreenLogicXML(), getScreenAssetXML());
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		protected function getBackNotificationName():String
		{
			return mediatorName + BackView.BACK_TRIGGERED;
		}

		private function createTweenTestViews(proxy:SoundTestProxy, gameSize:GameSizeVO):void
		{
			var tweenTestSetups:Vector.<SoundTestSetupVO> = proxy.getTestSetups(),
				buttonLayout:TestButtonLayoutVO = proxy.getButtonLayout(),
				testMediator:SoundTestViewMediator,
				i:int;

			createTextureMap(gameSize, buttonLayout);

			testViews = new Vector.<SoundTestViewMediator>();
			for (i=0; i<tweenTestSetups.length; i++)
			{
				testMediator = new SoundTestViewMediator(mediatorName, starlingGameScreen, gameSize, proxy.getTitleLayout(),
						proxy.getButtonLayout(), tweenTestSetups[i], buttonTextures);
				facade.registerMediator(testMediator);
				testViews.push(testMediator);
			}
		}

		private function createStopAllSoundsMediator(soundTestProxy:SoundTestProxy, gameSize:GameSizeVO):void
		{
			var stopSoundsViewVO:StopAllSoundsViewVO = soundTestProxy.getStopAllSoundsViewVO(),
				buttonWidth:Number = gameSize.getWidth() * stopSoundsViewVO.getButtonWidth(),
				buttonHeight:Number = gameSize.getHeight() * stopSoundsViewVO.getButtonHeight(),
				buttonSize:Number = Math.min(buttonWidth, buttonHeight);

			buttonTextures[stopSoundsViewVO.getButtonLinkage()] = getButtonTextures(2, stopSoundsViewVO.getButtonLinkage(), buttonSize);

			stopAllSoundsMediator = new StopAllSoundsViewMediator(mediatorName, starlingGameScreen, gameSize, stopSoundsViewVO, buttonTextures);
			facade.registerMediator(stopAllSoundsMediator);
		}

		private function createMasterVolumeMediator(soundTestProxy:SoundTestProxy, gameSize:GameSizeVO):void
		{
			var masterVolumeViewVO:MasterVolumeViewVO = soundTestProxy.getMasterVolumeViewVO();
			masterVolumeMediator = new MasterVolumeViewMediator(mediatorName, starlingGameScreen, masterVolumeViewVO, gameSize);
			facade.registerMediator(masterVolumeMediator);
		}

		protected function createTextureMap(gameSize:GameSizeVO, buttonLayout:TestButtonLayoutVO):void
		{
			if (buttonTextures != null) return;

			var buttonVOs:Vector.<TestButtonVO> = buttonLayout.getButtons(),
				buttonWidth:Number = gameSize.getWidth() * buttonLayout.getButtonWidth(),
				buttonHeight:Number = gameSize.getHeight() * buttonLayout.getButtonHeight(),
				buttonSize:Number = Math.min(buttonWidth, buttonHeight);

			buttonTextures = new Dictionary();
			for (var i:int=0; i<buttonVOs.length; i++)
			{
				buttonTextures[buttonVOs[i].getButtonID()] = getButtonTextures(2, buttonVOs[i].getLinkage(), buttonSize);
			}
		}

		protected static function getButtonTextures(numberOfFrames:int, buttonGraphicsLinkage:String, buttonSize:int):Vector.<Texture>
		{
			var buttonClass:Class,
					buttonGraphics:MovieClip,
					bitmapData:BitmapData,
					matrix:Matrix = new Matrix(),
					buttonTextures:Vector.<Texture>;

			buttonClass = ApplicationDomain.currentDomain.getDefinition(buttonGraphicsLinkage) as Class;
			buttonGraphics = new buttonClass();
			buttonTextures = new Vector.<Texture>(numberOfFrames, true);

			for (var i:int=0; i<buttonTextures.length; i++)
			{
				matrix.identity();
				buttonGraphics.gotoAndStop(i+1);
				matrix.scale(buttonSize/buttonGraphics.width, buttonSize/buttonGraphics.height);
				bitmapData = new BitmapData(buttonSize, buttonSize, true, 0x00000000);
				bitmapData.draw(buttonGraphics, matrix, null, null, null, true);
				buttonTextures[i] = Texture.fromBitmapData(bitmapData, false);
			}

			return buttonTextures;
		}
	}
}
