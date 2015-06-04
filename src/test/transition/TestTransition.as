package test.transition
{
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IFrameUpdate;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import com.pixelBender.update.FrameUpdateManager;
	import com.pixelBender.view.transition.TransitionView;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.PixelSnapping;

	import starling.display.Image;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;

	import test.facade.TestGameFacade;

	public class TestTransition extends TransitionView implements IFrameUpdate
	{
		//==============================================================================================================
		// STATIC CONSTANTS
		//==============================================================================================================

		protected static const TRANSITION_TIME								:int = 300; // in ms

		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		/**
		 * All the transitions that extend this class will use the same sprite
		 */
		protected static var transitionView									:Sprite;

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * The time difference (in ms) since the transition has started
		 */
		protected var delta													:int;

		/**
		 * Reference to update manager singleton
		 */
		protected var updateManager											:FrameUpdateManager;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function TestTransition(name:String)
		{
			super(name);
			updateManager = FrameUpdateManager.getInstance();
		}

		//==============================================================================================================
		// IFrameUpdate IMPLEMENTATION
		//==============================================================================================================

		public function frameUpdate(dt:int):void
		{
			delta += dt;
			updateTransition();
		}

		//==============================================================================================================
		// API OVERRIDES
		//==============================================================================================================

		public override function addViewComponentParents(parent:flash.display.DisplayObjectContainer,
														 	starlingParent:starling.display.DisplayObjectContainer):void
		{
			createTransitionView();
			super.addViewComponentParents(parent, starlingParent);
		}

		public override function dispose():void
		{
			super.dispose();
			if (transitionView != null)
			{
				StarlingHelpers.disposeTextureSprite(transitionView);
				transitionView = null;
			}
			updateManager = null;
		}

		//==============================================================================================================
		// LOCAL OVERRIDES
		//==============================================================================================================

		/**
		 * Starts the timeout
		 */
		override protected function playTransition():void
		{
			delta = 0;
			updateManager.registerForUpdate(this);
		}

		/**
		 * Paused the timeout
		 */
		override protected function pauseTransition():void
		{
			updateManager.unregisterFromUpdate(this);
		}

		/**
		 * Resumes the timeout
		 */
		override protected function resumeTransition():void
		{
			updateManager.registerForUpdate(this);
		}

		/**
		 * Removes the timeout
		 */
		override protected function stopTransition():void
		{
			delta = 0;
			updateManager.unregisterFromUpdate(this);
		}

		//==============================================================================================================
		// OVERRIDES
		//==============================================================================================================

		protected function createTransitionView():void
		{
			const 	imageSize:int = 128,
					invertedSize:Number = 1 / imageSize;

			if (transitionView == null)
			{
				var gameSize:GameSizeVO = TestGameFacade.getInstance().getApplicationSize(),
					bitmapData:BitmapData = new BitmapData(imageSize, imageSize, false, 0xBBBBBB),
					image:Image = Image.fromBitmap(new Bitmap(bitmapData, PixelSnapping.AUTO, true));

				transitionView = new Sprite();
				transitionView.addChild(image);

				image.scaleX = gameSize.getWidth() * invertedSize;
				image.scaleY = gameSize.getHeight() * invertedSize;
			}
			starlingTransitionViewComponent = transitionView;
		}

		protected function updateTransition():void
		{
			// Will be overridden in extend classes
		}
	}
}
