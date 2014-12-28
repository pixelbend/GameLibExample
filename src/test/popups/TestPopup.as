package test.popups
{
	import com.pixelBender.helpers.PopupHelpers;
	import com.pixelBender.model.AssetProxy;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import com.pixelBender.view.popup.StarlingPopup;
	import constants.Constants;
	import org.puremvc.as3.interfaces.INotification;
	import starling.display.DisplayObjectContainer;
	import test.popups.view.PopupBaseView;
	import test.popups.vo.PopupConfigurationVO;

	public class TestPopup extends StarlingPopup
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		protected var configurationVO								:PopupConfigurationVO;
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
			backgroundView = new PopupBaseView(container, configurationVO, mediatorName, gameFacade);
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
			configurationVO = null;
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
		// NEEDED PROTECTED OVERRIDES
		//==============================================================================================================

		protected override function parseLogicXML():void
		{
			var gameSize:GameSizeVO = gameFacade.getApplicationSize(),
				popupWidth:int = parseFloat(String(logicXML.@width)) * gameSize.getWidth(),
				popupHeight:int = parseFloat(String(logicXML.@height)) * gameSize.getHeight();

			configurationVO = new PopupConfigurationVO(
															(gameSize.getWidth() - popupWidth) >> 1,
															(gameSize.getHeight() - popupHeight) >> 1,
															popupWidth,
															popupHeight,
															parseInt(String(logicXML.@color))
														);
		}
	}
}
