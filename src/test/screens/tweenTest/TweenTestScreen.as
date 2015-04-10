package test.screens.tweenTest
{
	import com.pixelBender.helpers.DictionaryHelpers;
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.helpers.ScreenHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.vo.game.GameSizeVO;

	import constants.Constants;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;

	import helpers.ButtonHelpers;

	import org.puremvc.as3.interfaces.INotification;

	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.textures.Texture;

	import test.screens.common.screen.TestScreenWithBackButton;

	import test.screens.tweenTest.view.TweenTestViewMediator;
	import test.screens.common.vo.TestButtonLayoutVO;
	import test.screens.common.vo.TestButtonVO;
	import test.screens.tweenTest.vo.TweenTestSetupVO;

	public class TweenTestScreen extends TestScreenWithBackButton
	{
		//==============================================================================================================
		// EMBEDDED MEMBERS
		//==============================================================================================================

		[Embed(source="../../../assets/generic/screens/tweenTest/settings/logic.xml")]
		private const logicXML												:Class;

		[Embed(source="../../../assets/generic/screens/tweenTest/settings/assets.xml")]
		private const assetsXML												:Class;

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Each tween test will be handled independently by it's own mediator
		 */
		protected var tweenTestViews										:Vector.<TweenTestViewMediator>;

		/**
		 * The tweened target
		 */
		protected var tweenTarget											:Sprite;

		/**
		 * Button textures map. Used by all tween test mediators
		 */
		protected var buttonTextures										:Dictionary;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function TweenTestScreen(mediatorName:String)
		{
			super(mediatorName);
			starlingGameScreen = new Sprite();
		}

		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================

		public override function prepareForStart(starlingScreenContainer:DisplayObjectContainer,
												 	gameScreenProxy:GameScreenProxy):void
		{
			super.prepareForStart(starlingScreenContainer, gameScreenProxy);

			var tweenGraphics:MovieClip = gameScreenProxy.getScreenAssetPackage().getSWFAsset("tweenGraphics").getMovieSwf(),
				gameSize:GameSizeVO = gameFacade.getApplicationSize(),
				tweenTestProxy:TweenTestProxy = gameScreenProxy as TweenTestProxy;

			createTweenTarget(tweenGraphics.tweenTarget, gameSize);
			createTweenTestViews(tweenTestProxy, gameSize);

			sendReadyToStart();
		}

		public override function start():void
		{
			IRunnableHelpers.start(tweenTestViews);
			super.start();
		}

		public override function pause():void
		{
			IRunnableHelpers.pause(tweenTestViews);
			super.pause();
		}

		public override function resume():void
		{
			IRunnableHelpers.resume(tweenTestViews);
			super.resume();
		}

		public override function stop():void
		{
			if (tweenTestViews != null)
			{
				for (var i:int=0; i<tweenTestViews.length; i++)
				{
					if (tweenTestViews[i] == null) continue;
					facade.removeMediator(tweenTestViews[i].getMediatorName());
					tweenTestViews[i].dispose();
				}
				tweenTestViews = null;
			}

			StarlingHelpers.removeFromParent(tweenTarget);
			tweenTarget = null;

			super.stop();
		}

		override public function dispose():void
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
			return new TweenTestProxy(getGameScreenProxyName(), mediatorName, getScreenLogicXML(), getScreenAssetXML());
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
		// LOCALS
		//==============================================================================================================

		private function createTweenTestViews(proxy:TweenTestProxy, gameSize:GameSizeVO):void
		{
			var tweenTestSetups:Vector.<TweenTestSetupVO> = proxy.getTestSetups(),
				buttonLayout:TestButtonLayoutVO = proxy.getButtonLayout(),
				testMediator:TweenTestViewMediator,
				i:int;

			createTextureMap(gameSize, buttonLayout);

			tweenTestViews = new Vector.<TweenTestViewMediator>();
			for (i=0; i<tweenTestSetups.length; i++)
			{
				tweenTestSetups[i].update(gameSize);
				testMediator = new TweenTestViewMediator(mediatorName, starlingGameScreen, gameSize, proxy.getTitleLayout(),
															proxy.getButtonLayout(), tweenTestSetups[i], buttonTextures, tweenTarget);
				facade.registerMediator(testMediator);
				tweenTestViews.push(testMediator);
			}
		}

		protected function createTweenTarget(tweenTargetVector:MovieClip, gameSize:GameSizeVO):void
		{
			// Internals
			var width:int = tweenTargetVector.width * gameSize.getScale(),
				height:int = tweenTargetVector.height * gameSize.getScale(),
				bitmapData:BitmapData = new BitmapData(width, height, true, 0x0),
				matrix:Matrix = new Matrix();
			// Create tween target and add to screen
			matrix.scale(gameSize.getScale(), gameSize.getScale());
			bitmapData.draw(tweenTargetVector, matrix, null, null, null, true);
			tweenTarget = StarlingHelpers.createTextureSprite(bitmapData, width, height, false);
			resetTweenTargetProperties(gameSize);
			starlingGameScreen.addChild(tweenTarget);
		}

		protected function resetTweenTargetProperties(gameSize:GameSizeVO):void
		{
			tweenTarget.scaleX = tweenTarget.scaleY = 1;
			tweenTarget.x = gameSize.getWidth() * 0.02;
			tweenTarget.y = gameSize.getHeight() * 0.75;
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
