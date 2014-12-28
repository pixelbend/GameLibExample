package test.screens.tweenTest
{
	import com.pixelBender.helpers.DictionaryHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.helpers.TweenHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import constants.Constants;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import test.screens.common.screen.TestScreen;
	import test.screens.tweenTest.vo.TweenTestButtonVO;

	public class TweenTestScreen extends TestScreen
	{
		//==============================================================================================================
		// EMBEDDED MEMBERS
		//==============================================================================================================

		[Embed(source="../../../assets/generic/screens/tweenTest/settings/logic.xml")]
		private const logicXML														:Class;

		[Embed(source="../../../assets/generic/screens/tweenTest/settings/assets.xml")]
		private const assetsXML														:Class;

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var tweens															:Dictionary;

		private var tweenTarget														:Sprite;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function TweenTestScreen(mediatorName:String)
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
			tweens = new Dictionary();
			var tweenGraphics:MovieClip = gameScreenProxy.getScreenAssetPackage().getSWFAsset("tweenGraphics").getMovieSwf();
			createTweenTarget(tweenGraphics.tweenTarget);
			sendReadyToStart();
		}

		public override function stop():void
		{
			if (tweens != null)
			{
				for (var tweenName:String in tweens)
				{
					TweenHelpers.removeTween(tweens[tweenName]);
					delete tweens[tweenName];
				}
				tweens = null;
			}

			StarlingHelpers.removeFromParent(tweenTarget);
			tweenTarget = null;

			super.stop();
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
		// NOTIFICATION/CALLBACK HANDLERS
		//==============================================================================================================

		protected override function handleTestButtonTriggered(testButtonData:Object):void
		{
			var data:TweenTestButtonVO = testButtonData as TweenTestButtonVO;
			switch(data.getCommandName())
			{
				case Constants.START_TWEEN:
					handleStartTween(data);
					break;
				case Constants.PAUSE_TWEEN:
					handlePauseTween(data);
					break;
				case Constants.RESUME_TWEEN:
					handleResumeTween(data);
					break;
				case Constants.STOP_TWEEN:
					handleStopTween(data);
					break;
				case Constants.RESET_TARGET:
					handleResetTarget();
					break;
			}
		}

		private function handleStartTween(data:TweenTestButtonVO):void
		{
			// Internals
			var tweenName:String = data.getTweenName();
			// Remove tween if need be
			if (tweens[tweenName] != null )
			{
				TweenHelpers.removeTween(tweens[tweenName]);
			}
			// Update properties
			if (data.getNeedsUpdating())
			{
				data.update(gameFacade.getApplicationSize());
			}
			// Start tween
			tweens[tweenName] = TweenHelpers.tween(tweenTarget, data.getDuration(), data.getTweenProperties(), handleTweenEnded);
		}

		private function handlePauseTween(data:TweenTestButtonVO):void
		{
			// Internals
			var tweenName:String = data.getTweenName();
			// Remove tween if need be
			if (tweens[tweenName] != null )
			{
				TweenHelpers.pauseTween(tweens[tweenName]);
			}
		}

		private function handleResumeTween(data:TweenTestButtonVO):void
		{
			// Internals
			var tweenName:String = data.getTweenName();
			// Remove tween if need be
			if (tweens[tweenName] != null )
			{
				TweenHelpers.resumeTween(tweens[tweenName]);
			}
		}

		private function handleStopTween(data:TweenTestButtonVO):void
		{
			// Internals
			var tweenName:String = data.getTweenName();
			// Remove tween if need be
			if (tweens[tweenName] != null )
			{
				TweenHelpers.removeTween(tweens[tweenName]);
			}
			// Check state
			if (DictionaryHelpers.dictionaryLength(tweens) == 0)
			{
				handleResetTarget();
			}
		}

		private function handleResetTarget():void
		{
			// Stop all tweens
			for (var tweenName:String in tweens)
			{
				TweenHelpers.removeTween(tweens[tweenName]);
			}
			// Reset properties
			resetTweenTargetProperties(gameFacade.getApplicationSize());
		}

		private function handleTweenEnded(tweenID:int):void
		{
			for (var tweenName:String in tweens)
			{
				if (tweens[tweenName] == tweenID)
				{
					delete tweens[tweenName];
					return;
				}
			}
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		protected function createTweenTarget(tweenTargetVector:MovieClip):void
		{
			// Internals
			var gameSize:GameSizeVO = gameFacade.getApplicationSize(),
				width:int = tweenTargetVector.width * gameSize.getScale(),
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

		private function resetTweenTargetProperties(gameSize:GameSizeVO):void
		{
			tweenTarget.scaleX = tweenTarget.scaleY = 1;
			tweenTarget.x = gameSize.getWidth() * 0.02;
			tweenTarget.y = gameSize.getHeight() * 0.70;
		}
	}
}
