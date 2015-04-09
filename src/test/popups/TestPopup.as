package test.popups
{
	import com.pixelBender.helpers.PopupHelpers;
	import com.pixelBender.model.AssetProxy;
	import com.pixelBender.model.PopupProxy;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import com.pixelBender.view.popup.StarlingPopup;
	import constants.Constants;
	import org.puremvc.as3.interfaces.INotification;
	import starling.display.DisplayObjectContainer;

	import test.popups.model.TestPopupProxy;
	import test.popups.view.PopupBaseView;
	import test.popups.vo.PopupConfigurationVO;

	public class TestPopup extends StarlingPopup
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		protected var testPopupProxy								:TestPopupProxy;
		protected var backgroundView								:PopupBaseView;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function TestPopup(mediatorName:String)
		{
			super(mediatorName);
		}

		//==============================================================================================================
		// NEEDED PUBLIC OVERRIDES
		//==============================================================================================================

		/**
		 * Create views and show them
		 * @param container
		 * @param assetProxy
		 */
		public override function prepareForOpen(container:DisplayObjectContainer, assetProxy:AssetProxy):void
		{
			backgroundView = new PopupBaseView(container, testPopupProxy.getConfigurationVO(), mediatorName, gameFacade);
		}

		/**
		 * Opens the popup and start functionality
		 */
		public override function open():void
		{
			backgroundView.start();
		}

		/**
		 * Pause functionality.
		 */
		public override function pause():void
		{
			backgroundView.pause();
		}

		/**
		 * Resume functionality.
		 */
		public override function resume():void
		{
			backgroundView.resume();
		}

		/**
		 * Show/hide mechanism
		 * @param visible Boolean
		 */
		public override function setVisible(visible:Boolean):void
		{
			backgroundView.setVisible(visible);
		}

		/**
		 * Remove the popup from screen.
		 */
		public override function close():void
		{
			if (backgroundView != null)
			{
				backgroundView.dispose();
				backgroundView = null;
			}
		}

		public override function dispose():void
		{
			testPopupProxy = null;
		}

		//==============================================================================================================
		// IMediator OVERRIDES
		//==============================================================================================================

		public override function listNotificationInterests():Array
		{
			return [
					Constants.SECOND_POPUP_NAME + PopupBaseView.CLOSE_BUTTON_TRIGGERED
					];
		}

		public override function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case Constants.SECOND_POPUP_NAME + PopupBaseView.CLOSE_BUTTON_TRIGGERED:
					PopupHelpers.closePopup(mediatorName);
					break;
			}
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		protected override function createPopupProxy():PopupProxy
		{
			testPopupProxy = new TestPopupProxy(mediatorName);
			return testPopupProxy;
		}
	}
}
