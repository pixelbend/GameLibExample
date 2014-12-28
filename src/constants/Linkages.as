package constants
{
	import test.popups.FirstPopup;
	import test.popups.TestPopup;
	import test.screens.fileReferenceTest.FileReferenceTestScreen;
	import test.screens.intro.IntroScreen;
	import test.screens.localeTest.LocaleTestScreen;
	import test.screens.popupTest.PopupTestScreen;
	import test.screens.soundTest.SoundTestScreen;
	import test.screens.soundQueueTest.SoundQueueTestScreen;
	import test.screens.tweenTest.TweenTestScreen;
	import test.transition.IntroTransition;
	import test.transition.LoopTransition;
	import test.transition.OutroTransition;

	// The class is just a hack to include imports in an organized fashion
	public class Linkages
	{
		// Screens
		IntroScreen;
		SoundTestScreen;
		SoundQueueTestScreen;
		FileReferenceTestScreen;
		TweenTestScreen;
		PopupTestScreen;
		LocaleTestScreen;
		// Transitions
		IntroTransition;
		LoopTransition;
		OutroTransition;
		// Popups
		TestPopup;
		FirstPopup;
	}
}