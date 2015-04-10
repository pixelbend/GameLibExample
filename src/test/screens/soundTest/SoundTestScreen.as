package test.screens.soundTest
{
	import com.pixelBender.helpers.DictionaryHelpers;
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.helpers.SoundHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.vo.game.GameSizeVO;

	import flash.utils.Dictionary;

	import helpers.ButtonHelpers;

	import starling.display.DisplayObjectContainer;
	import starling.textures.Texture;

	import test.screens.common.screen.TestScreenWithBackButton;

	import test.screens.common.vo.TestButtonLayoutVO;
	import test.screens.common.vo.TestButtonVO;
	import test.screens.soundTest.view.MasterVolumeViewMediator;
	import test.screens.soundTest.view.SoundTestViewMediator;
	import test.screens.soundTest.view.StopAllSoundsViewMediator;
	import test.screens.soundTest.vo.MasterVolumeViewVO;
	import test.screens.soundTest.vo.SoundTestSetupVO;
	import test.screens.soundTest.vo.StopAllSoundsViewVO;

	public class SoundTestScreen extends TestScreenWithBackButton
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
		}

		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================

		override public function prepareForStart(starlingScreenContainer:DisplayObjectContainer,
												 gameScreenProxy:GameScreenProxy):void
		{
			super.prepareForStart(starlingScreenContainer, gameScreenProxy);

			var gameSize:GameSizeVO = gameFacade.getApplicationSize();
			registerDefaultPackageSounds();
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
			super.start();
		}

		override public function pause():void
		{
			IRunnableHelpers.pause(testViews);
			IRunnableHelpers.pause(stopAllSoundsMediator);
			IRunnableHelpers.pause(masterVolumeMediator);
			super.pause();
		}

		override public function resume():void
		{
			IRunnableHelpers.resume(testViews);
			IRunnableHelpers.resume(stopAllSoundsMediator);
			IRunnableHelpers.resume(masterVolumeMediator);
			super.resume();
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

			unregisterDefaultPackageSounds();

			super.stop();
		}

		public override function dispose():void
		{
			if (buttonTextures != null)
			{
				for each (var buttonTexturePair:Vector.<Texture> in buttonTextures)
				{
					for (var i:int = 0; i<buttonTexturePair.length; i++)
					{
						if (buttonTexturePair[i] == null) continue;
						buttonTexturePair[i].dispose();
						buttonTexturePair[i] = null;
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

		override protected function getScreenAssetXML():XML { return new XML(assetsXML.data); }
		override protected function getScreenLogicXML():XML { return new XML(logicXML.data); }
		override protected function createGameScreenProxy():GameScreenProxy
		{
			return new SoundTestProxy(getGameScreenProxyName(), mediatorName, getScreenLogicXML(), getScreenAssetXML());
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

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

			if (buttonTextures[stopSoundsViewVO.getButtonLinkage()] == null)
			{
				buttonTextures[stopSoundsViewVO.getButtonLinkage()] = ButtonHelpers.getSquareButtonTextures(stopSoundsViewVO.getButtonLinkage(), 2, buttonSize);
			}

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
				buttonTextures[buttonVOs[i].getButtonID()] = ButtonHelpers.getSquareButtonTextures(buttonVOs[i].getLinkage(), 2, buttonSize);
			}
		}
	}
}
