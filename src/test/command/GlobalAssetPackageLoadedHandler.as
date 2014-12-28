package test.command
{
	import com.pixelBender.controller.asset.GlobalAssetPackageLoadedCommand;
	import com.pixelBender.helpers.ScreenHelpers;

	import constants.Constants;

	import org.puremvc.as3.interfaces.INotification;

	public class GlobalAssetPackageLoadedHandler extends GlobalAssetPackageLoadedCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================

		/**
		 * Handles the global package queue loaded notification. Will init transition views that depend on lazy assets,
		 * 	popups and localization proxy.
		 * @param notification INotification
		 */
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			ScreenHelpers.showScreen(Constants.INTRO_SCREEN_NAME);
		}
	}
}
