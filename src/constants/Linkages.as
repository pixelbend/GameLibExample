package constants
{
	import flash.text.Font;
	import test.model.asset.MyImageAssetVO;
	import test.model.asset.MyImageLoader;
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
		// Fonts
		[Embed(source = "../assets/generic/global/fonts/neoteric.ttf",
				fontName = "ApplicationRegular",
				mimeType = "application/x-font",
				fontWeight="Regular",
				fontStyle="Regular",
				advancedAntiAliasing = "true",
				embedAsCFF="false")]
		public static const fontRegularClass:Class;
		public static const REGULAR:Font = new fontRegularClass();

		[Embed(source = "../assets/generic/global/fonts/voniqueBold.ttf",
				fontName = "ApplicationBold",
				mimeType = "application/x-font",
				fontWeight="Bold",
				fontStyle="Bold",
				advancedAntiAliasing = "true",
				embedAsCFF="false")]
		public static const fontBoldClass:Class;
		public static const BOLD:Font = new fontBoldClass();

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

		// Assets
		MyImageLoader;
		MyImageAssetVO;

		// Embedded graphics
		buttonLinkage;
		buttonPlayLinkage;
		buttonPauseLinkage;
		buttonStopLinkage;
		buttonResetLinkage;
		backButtonLinkage;
		checkBoxLinkage;
		buttonStopAllLinkage;
		buttonCloseLinkage;
	}
}