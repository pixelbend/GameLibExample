package test.screens.localeTest.command
{
	import com.pixelBender.constants.GameConstants;

	import constants.Constants;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	import test.screens.localeTest.LocaleTestProxy;

	public class SwitchLocaleCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================

		/**
		 * Will change the current locale of the application
		 * @param notification INotification
		 */
		override public function execute(notification:INotification):void
		{
			var proxy:LocaleTestProxy = facade.retrieveProxy(Constants.LOCALE_TEST_SCREEN + GameConstants.GAME_SCREEN_PROXY_SUFFIX) as LocaleTestProxy;
			proxy.switchLocale();
		}
	}
}
