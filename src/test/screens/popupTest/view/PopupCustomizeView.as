package test.screens.popupTest.view
{
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IRunnable;
	import com.pixelBender.model.vo.game.GameSizeVO;

	import constants.Constants;

	import flash.geom.Rectangle;

	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	import starling.text.TextField;

	import test.facade.TestGameFacade;

	import test.screens.popupTest.vo.PopupCustomizeViewVO;

	public class PopupCustomizeView implements IRunnable
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const TYPE_CHECKBOX									:String = "checkBox";
		public static const TYPE_COLOR_SWITCH								:String = "colorSwitch";
		public static const TYPE_ALPHA_SWITCH								:String = "alphaSwitch";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		protected var container												:Sprite;
		protected var containerBounds										:Rectangle;
		protected var name													:TextField;

		protected var ID													:String;
		protected var noteType												:String;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function PopupCustomizeView(localizationModule:String, parentContainer:Sprite, vo:PopupCustomizeViewVO, gameSize:GameSizeVO)
		{
			ID = vo.getID();
			noteType = vo.getNoteType();

			container = new Sprite();
			container.x = vo.getX() * gameSize.getWidth();
			container.y = vo.getY() * gameSize.getHeight();
			parentContainer.addChild(container);

			var containerWidth:int = vo.getWidth() * gameSize.getWidth(),
				containerHeight:int = vo.getHeight() * gameSize.getHeight(),
				text:String = LocalizationHelpers.getLocalizedText(localizationModule, vo.getTextID());

			containerBounds = new Rectangle(container.x, container.y, containerWidth, containerHeight);

			name = new TextField(containerWidth * 0.5, containerHeight, text, Constants.APPLICATION_FONT_REGULAR, containerHeight * 0.1, 0xFFFFFF, true);
			container.addChild(name);
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function getID():String
		{
			return ID;
		}

		//==============================================================================================================
		// IRunnable IMPLEMENTATION
		//==============================================================================================================

		public function start():void
		{
			container.addEventListener(TouchEvent.TOUCH, handleTouch);
		}

		public function pause():void
		{
			container.removeEventListener(TouchEvent.TOUCH, handleTouch);
		}

		public function resume():void
		{
			container.addEventListener(TouchEvent.TOUCH, handleTouch);
		}

		public function dispose():void
		{
			if (container != null)
			{
				container.removeEventListener(TouchEvent.TOUCH, handleTouch);
			}

			StarlingHelpers.disposeContainer(name);
			StarlingHelpers.disposeContainer(container);

			containerBounds = null;
			name = null;
			container = null;
			ID = null;
			noteType = null;
		}

		private function handleTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(container);
			if (touch != null && touch.phase == TouchPhase.ENDED)
			{
				TestGameFacade.getInstance().sendNotification(Constants.CHANGE_POPUP_CUSTOMIZATION_STATE, noteType);
			}
		}
	}
}
