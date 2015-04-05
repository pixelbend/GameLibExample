package test.screens.soundTest.view
{
	import com.pixelBender.helpers.IDisposeHelpers;
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.helpers.SoundHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IRunnable;
	import com.pixelBender.model.vo.game.GameSizeVO;

	import constants.Constants;

	import flash.geom.Rectangle;

	import org.puremvc.as3.interfaces.INotification;


	import org.puremvc.as3.patterns.mediator.Mediator;

	import starling.display.Sprite;
	import starling.text.TextField;

	import test.screens.soundTest.vo.MasterVolumeViewVO;

	public class MasterVolumeViewMediator extends Mediator implements IRunnable
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		protected static const MEDIATOR_NAME					:String = "_masterVolumeViewMediator";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var container									:Sprite;
		private var containerBounds								:Rectangle;
		private var name										:TextField;
		private var verticalScroller							:MasterVolumeVerticalScrollerView;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function MasterVolumeViewMediator(parentMediatorName:String, parentContainer:Sprite, viewVO:MasterVolumeViewVO,
													gameSize:GameSizeVO)
		{
			super(parentMediatorName + MEDIATOR_NAME);
			createContainer(parentContainer, viewVO, gameSize);
			createName(parentMediatorName, viewVO);
			createScroller(viewVO);
		}

		//==============================================================================================================
		// IRunnable IMPLEMENTATION
		//==============================================================================================================

		public function start():void
		{
			verticalScroller.start();
		}

		public function pause():void
		{
			verticalScroller.pause();
		}

		public function resume():void
		{
			verticalScroller.resume();
		}

		public function dispose():void
		{
			StarlingHelpers.removeFromParent(name);
			StarlingHelpers.removeFromParent(container);
			IDisposeHelpers.dispose(verticalScroller);

			container = null;
			name = null;
			verticalScroller = null;
			containerBounds = null;
		}

		//==============================================================================================================
		// Mediator API
		//==============================================================================================================

		public override function listNotificationInterests():Array
		{
			return [MasterVolumeVerticalScrollerView.VOLUME_CHANGED];
		}

		public override function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case MasterVolumeVerticalScrollerView.VOLUME_CHANGED:
					SoundHelpers.setMasterVolume(notification.getBody() as Number);
					break;
			}
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		private function createContainer(parentContainer:Sprite, vo:MasterVolumeViewVO, gameSize:GameSizeVO):void
		{
			container = new Sprite();
			parentContainer.addChild(container);

			containerBounds = new Rectangle();
			containerBounds.x = gameSize.getWidth() * vo.getX();
			containerBounds.y = gameSize.getHeight() * vo.getY();
			containerBounds.width = gameSize.getWidth() * vo.getWidth();
			containerBounds.height = gameSize.getHeight() * vo.getHeight();

			container.x = containerBounds.x;
			container.y = containerBounds.y;
		}

		private function createName(parentMediatorName:String, vo:MasterVolumeViewVO):void
		{
			var tfHeight:int = containerBounds.height * vo.getTextHeight();
			name = new TextField(containerBounds.width, tfHeight,
					LocalizationHelpers.getLocalizedText(parentMediatorName, vo.getTextID()),
					Constants.APPLICATION_FONT_REGULAR, tfHeight * 0.4, 0xFFFFFF, true);
			container.addChild(name);
		}

		private function createScroller(vo:MasterVolumeViewVO):void
		{
			verticalScroller = new MasterVolumeVerticalScrollerView(container, containerBounds, vo);
		}
	}
}
