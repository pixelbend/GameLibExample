package test.screens.soundQueueTest
{
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.helpers.ScreenHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import com.pixelBender.view.gameScreen.StarlingGameScreen;

	import constants.Constants;

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	import org.puremvc.as3.interfaces.INotification;

	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.textures.Texture;

	import test.screens.common.utils.ScaleBitmap;

	import test.screens.common.view.BackView;
	import test.screens.common.view.TitleView;
	import test.screens.common.vo.TestButtonLayoutVO;
	import test.screens.common.vo.TestButtonVO;
	import test.screens.soundQueueTest.view.SoundQueueTestViewMediator;
	import test.screens.soundQueueTest.vo.SoundQueueTestSetupVO;

	public class SoundQueueTestScreen extends StarlingGameScreen
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
			createTweenTestViews(gameScreenProxy as SoundQueueTestProxy, gameSize);

			sendReadyToStart();
		}

		override public function start():void
		{
			IRunnableHelpers.start(testViews);
			IRunnableHelpers.start(backView);
		}

		override public function pause():void
		{
			IRunnableHelpers.pause(testViews);
			IRunnableHelpers.pause(backView);
		}

		override public function resume():void
		{
			IRunnableHelpers.resume(testViews);
			IRunnableHelpers.resume(backView);
		}

		override public function stop():void
		{
			var i:int;

			if (testViews != null)
			{
				for (i=0; i<testViews.length; i++)
				{
					if (testViews[i] == null) continue;
					facade.removeMediator(testViews[i].getMediatorName());
					testViews[i].dispose();
				}
				testViews = null;
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
			return new SoundQueueTestProxy(getGameScreenProxyName(), mediatorName, getScreenLogicXML(), getScreenAssetXML());
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		protected function getBackNotificationName():String
		{
			return mediatorName + BackView.BACK_TRIGGERED;
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
