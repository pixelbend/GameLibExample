package test.transition
{
	public class OutroTransition extends TestTransition
	{
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function OutroTransition(name:String)
		{
			super(name);
		}

		//==============================================================================================================
		// OVERRIDES
		//==============================================================================================================

		override protected function playTransition():void
		{
			super.playTransition();
			starlingTransitionViewComponent.alpha = 1;
		}

		override protected function stopTransition():void
		{
			super.stopTransition();
			starlingTransitionViewComponent.alpha = 0;
		}

		override protected function updateTransition():void
		{
			if (delta < TRANSITION_TIME)
			{
				starlingTransitionViewComponent.alpha = 1 - delta / TRANSITION_TIME;
			}
			else
			{
				stop();
			}
		}
	}
}
