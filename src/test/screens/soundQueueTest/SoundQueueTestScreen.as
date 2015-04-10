package test.screens.soundQueueTest
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
	import test.screens.soundQueueTest.view.SoundQueueTestViewMediator;
	import test.screens.soundQueueTest.vo.SoundQueueTestSetupVO;

	public class SoundQueueTestScreen extends TestScreenWithBackButton
	{
		//==============================================================================================================
		// EMBEDDED MEMBERS
		//==============================================================================================================

		[Embed(source="../../../assets/generic/screens/soundQueueTest/settings/logic.xml")]
		private const logicXML												:Class;

		[Embed(source="../../../assets/generic/screens/soundQueueTest/settings/assets.xml")]
		private const assetsXML												:Class;

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Each sound queue test will be handled independently by it's own mediator
		 */
		protected var testViews												:Vector.<SoundQueueTestViewMediator>;

		/**
		 * Button textures map. Used by all tween test mediators
		 */
		protected var buttonTextures										:Dictionary;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function SoundQueueTestScreen(mediatorName:String)
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
			createTweenTestViews(gameScreenProxy as SoundQueueTestProxy, gameSize);

			sendReadyToStart();
		}

		override public function start():void
		{
			IRunnableHelpers.start(testViews);
			super.start();
		}

		override public function pause():void
		{
			IRunnableHelpers.pause(testViews);
			super.pause();
		}

		override public function resume():void
		{
			IRunnableHelpers.resume(testViews);
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
			return new SoundQueueTestProxy(getGameScreenProxyName(), mediatorName, getScreenLogicXML(), getScreenAssetXML());
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

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

		private function createTweenTestViews(proxy:SoundQueueTestProxy, gameSize:GameSizeVO):void
		{
			var tweenTestSetups:Vector.<SoundQueueTestSetupVO> = proxy.getTestSetups(),
				buttonLayout:TestButtonLayoutVO = proxy.getButtonLayout(),
				testMediator:SoundQueueTestViewMediator,
				i:int;

			createTextureMap(gameSize, buttonLayout);

			testViews = new Vector.<SoundQueueTestViewMediator>();
			for (i=0; i<tweenTestSetups.length; i++)
			{
				testMediator = new SoundQueueTestViewMediator(mediatorName, starlingGameScreen, gameSize, proxy.getTitleLayout(),
																proxy.getButtonLayout(), tweenTestSetups[i], buttonTextures);
				facade.registerMediator(testMediator);
				testViews.push(testMediator);
			}
		}
	}
}
