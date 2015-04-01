package test.screens.popupTest.command
{
	import com.pixelBender.constants.GameConstants;

	import constants.Constants;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	import test.screens.popupTest.PopupTestProxy;

	public class ChangeCustomizationStateCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================

		/**
		 * Will change the current customization state of the popup test screen
		 * @param notification INotification
		 */
		override public function execute(notification:INotification):void
		{
			var proxy:PopupTestProxy = facade.retrieveProxy(Constants.POPUP_TEST_SCREEN + GameConstants.GAME_SCREEN_PROXY_SUFFIX) as PopupTestProxy;
			proxy.changeState(String(notification.getBody()));
		}
	}
}
