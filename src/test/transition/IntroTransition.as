package test.transition
{
	public class IntroTransition extends TestTransition
	{
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function IntroTransition(name:String)
		{
			super(name);
		}

		//==============================================================================================================
		// OVERRIDES
		//==============================================================================================================

		override protected function playTransition():void
		{
			super.playTransition();
			starlingTransitionViewComponent.alpha = 0;
		}

		override protected function stopTransition():void
		{
			super.stopTransition();
			starlingTransitionViewComponent.alpha = 1;
		}

		override protected function updateTransition():void
		{
			if (delta < TRANSITION_TIME)
			{
				starlingTransitionViewComponent.alpha = delta / TRANSITION_TIME;
			}
			else
			{
				stop();
			}
		}
	}
}
