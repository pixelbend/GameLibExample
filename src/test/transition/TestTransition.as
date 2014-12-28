package test.transition
{
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IFrameUpdate;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import com.pixelBender.update.FrameUpdateManager;
	import com.pixelBender.view.transition.TransitionView;
	import flash.display.BitmapData;
	import starling.display.Sprite;
	import test.facade.TestGameFacade;

	public class TestTransition extends TransitionView implements IFrameUpdate
	{
		//==============================================================================================================
		// STATIC CONSTANTS
		//==============================================================================================================

		protected static const TRANSITION_TIME								:int = 500; // in ms

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
			if (transitionView == null)
			{
				var gameSize:GameSizeVO = TestGameFacade.getInstance().getApplicationSize(),
					bitmapData:BitmapData = new BitmapData(gameSize.getWidth(), gameSize.getHeight(), false, 0xBBBBBB);
				transitionView = StarlingHelpers.createTextureSprite(bitmapData, gameSize.getWidth(), gameSize.getHeight(), true);
			}
			starlingTransitionViewComponent = transitionView;
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

		public override function dispose():void
		{
			super.dispose();
			if (transitionView != null)
			{
				StarlingHelpers.disposeContainer(transitionView, true);
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

		protected function updateTransition():void
		{
			// Will be overridden in extend classes
		}
	}
}
