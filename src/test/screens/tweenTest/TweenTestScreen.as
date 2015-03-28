package test.screens.tweenTest
{
	import com.pixelBender.helpers.DictionaryHelpers;
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
	import test.screens.tweenTest.view.TweenTestViewMediator;
	import test.screens.common.vo.TestButtonLayoutVO;
	import test.screens.common.vo.TestButtonVO;
	import test.screens.tweenTest.vo.TweenTestSetupVO;

	public class TweenTestScreen extends StarlingGameScreen
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

		public override function prepareForStart(starlingScreenContainer:DisplayObjectContainer, gameScreenProxy:GameScreenProxy):void
		{
			var tweenGraphics:MovieClip = gameScreenProxy.getScreenAssetPackage().getSWFAsset("tweenGraphics").getMovieSwf(),
				gameSize:GameSizeVO = gameFacade.getApplicationSize(),
				tweenTestProxy:TweenTestProxy = gameScreenProxy as TweenTestProxy;

			starlingScreenContainer.addChild(starlingGameScreen);
			createTweenTarget(tweenGraphics.tweenTarget, gameSize);
			title = new TitleView(mediatorName, starlingGameScreen, gameSize);
			backView = new BackView(facade, mediatorName, starlingGameScreen, gameSize);
			createTweenTestViews(tweenTestProxy, gameSize);

			sendReadyToStart();
		}

		public override function start():void
		{
			IRunnableHelpers.start(tweenTestViews);
			IRunnableHelpers.start(backView);
		}

		public override function pause():void
		{
			IRunnableHelpers.pause(tweenTestViews);
			IRunnableHelpers.pause(backView);
		}

		public override function resume():void
		{
			IRunnableHelpers.resume(tweenTestViews);
			IRunnableHelpers.resume(backView);
		}

		public override function stop():void
		{
			var i:int;

			if (tweenTestViews != null)
			{
				for (i=0; i<tweenTestViews.length; i++)
				{
					if (tweenTestViews[i] == null) continue;
					facade.removeMediator(tweenTestViews[i].getMediatorName());
					tweenTestViews[i].dispose();
				}
				tweenTestViews = null;
			}

			StarlingHelpers.removeFromParent(tweenTarget);
			tweenTarget = null;

			starlingGameScreen.removeFromParent();
			IRunnableHelpers.dispose([backView, title]);
		}

		override public function dispose():void
		{
			StarlingHelpers.disposeContainer(starlingGameScreen);
			starlingGameScreen = null;

			if (buttonTextures != null)
			{
				for each (var buttonTextureTriplet:Vector.<Texture> in buttonTextures)
				{
					for (var i:int = 0; i<buttonTextureTriplet.length; i++)
					{
						if (buttonTextureTriplet[i] == null) continue;
						buttonTextureTriplet[i].dispose();
						buttonTextureTriplet[i] = null;
					}
				}
				DictionaryHelpers.deleteValues(buttonTextures);
				buttonTextures = null;
			}
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

		protected function getBackNotificationName():String
		{
			return mediatorName + BackView.BACK_TRIGGERED;
		}

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
				buttonTextures[buttonVOs[i].getButtonID()] = getButtonTextures(2, buttonVOs[i].getLinkage(), buttonSize, buttonSize);
			}
		}

		protected static function getButtonTextures(numberOfFrames:int, buttonGraphicsLinkage:String, buttonWidth:int, buttonHeight:int):Vector.<Texture>
		{
			var buttonClass:Class,
				buttonGraphics:MovieClip,
				originalButtonBitmapData:BitmapData,
				originalButtonBitmap:ScaleBitmap,
				bitmapData:BitmapData,
				scale9Grid:Rectangle,
				buttonTextures:Vector.<Texture>;

			buttonClass = ApplicationDomain.currentDomain.getDefinition(buttonGraphicsLinkage) as Class;
			buttonGraphics = new buttonClass();
			scale9Grid = new Rectangle();
			buttonTextures = new Vector.<Texture>(numberOfFrames, true);

			// Compute vector scale 9 grid rect
			scale9Grid.x = buttonGraphics.width * 0.1;
			scale9Grid.y = buttonGraphics.height * 0.1;
			scale9Grid.width = buttonGraphics.width * 0.8;
			scale9Grid.height = buttonGraphics.height * 0.8;

			for (var i:int=0; i<buttonTextures.length; i++)
			{
				buttonGraphics.gotoAndStop(i+1);
				originalButtonBitmapData = new BitmapData(buttonGraphics.width, buttonGraphics.height, true, 0x0);
				originalButtonBitmapData.draw(buttonGraphics, null, null, null, null, true);
				originalButtonBitmap = new ScaleBitmap(originalButtonBitmapData, "auto", true);
				originalButtonBitmap.scale9Grid = scale9Grid;
				originalButtonBitmap.setSize(buttonWidth, buttonHeight);
				bitmapData = new BitmapData(buttonWidth, buttonHeight, true, 0x00000000);
				bitmapData.draw(originalButtonBitmap, null, null, null, null, true);
				buttonTextures[i] = Texture.fromBitmapData(bitmapData, false);
			}

			return buttonTextures;
		}
	}
}
