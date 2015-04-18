package test.popups
{
	import com.pixelBender.helpers.PopupHelpers;
	import com.pixelBender.model.AssetProxy;
	import constants.Constants;
	import org.puremvc.as3.interfaces.INotification;
	import starling.display.DisplayObjectContainer;
	import test.popups.view.OpenSecondPopupView;
	import test.popups.view.PopupBaseView;

	public class FirstPopup extends TestPopup
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		protected var openSecondPopupView										:OpenSecondPopupView;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function FirstPopup(mediatorName:String)
		{
			super(mediatorName);
		}

		//==============================================================================================================
		// OVERRIDES
		//==============================================================================================================

		/**
		 * Create views and show them
		 * @param container
		 * @param assetProxy
		 * @param popupInitVO
		 */
		public override function prepareForOpen(container:DisplayObjectContainer, assetProxy:AssetProxy, popupInitVO:Object=null):void
		{
			super.prepareForOpen(container, assetProxy);
			openSecondPopupView = new OpenSecondPopupView(container, testPopupProxy.getConfigurationVO(), mediatorName, gameFacade);
		}

		public override function open():void
		{
			openSecondPopupView.start();
			super.open();
		}

		/**
		 * Pause functionality.
		 */
		public override function pause():void
		{
			openSecondPopupView.pause();
			super.pause();
		}

		/**
		 * Resume functionality.
		 */
		public override function resume():void
		{
			openSecondPopupView.resume();
			super.resume();
		}

		/**
		 * Show/hide mechanism
		 * @param visible Boolean
		 */
		public override function setVisible(visible:Boolean):void
		{
			openSecondPopupView.setVisible(visible);
			super.setVisible(visible);
		}

		/**
		 * Remove the popup from screen.
		 */
		public override function close():void
		{
			if (openSecondPopupView != null)
			{
				openSecondPopupView.dispose();
				openSecondPopupView = null;
			}
			super.close();
		}

		//==============================================================================================================
		// IMediator OVERRIDES
		//==============================================================================================================

		public override function listNotificationInterests():Array
		{
			return [
						Constants.FIRST_POPUP_NAME + PopupBaseView.CLOSE_BUTTON_TRIGGERED,
						Constants.FIRST_POPUP_NAME + OpenSecondPopupView.OPEN_SECOND_POPUP
					];
		}

		public override function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case Constants.FIRST_POPUP_NAME + OpenSecondPopupView.OPEN_SECOND_POPUP:
					PopupHelpers.openPopup(Constants.SECOND_POPUP_NAME);
					break;
				case Constants.FIRST_POPUP_NAME + PopupBaseView.CLOSE_BUTTON_TRIGGERED:
					PopupHelpers.closePopup(Constants.FIRST_POPUP_NAME);
					break;
			}
		}
	}
}
