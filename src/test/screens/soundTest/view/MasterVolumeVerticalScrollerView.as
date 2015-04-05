package test.screens.soundTest.view
{
	import com.pixelBender.helpers.MathHelpers;
	import com.pixelBender.helpers.SoundHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IRunnable;

	import flash.display.BitmapData;
	import flash.geom.Point;

	import flash.geom.Rectangle;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	import test.facade.TestGameFacade;

	import test.screens.soundTest.vo.MasterVolumeViewVO;

	public class MasterVolumeVerticalScrollerView implements IRunnable
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const VOLUME_CHANGED				:String = "masterVolumeChanged";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var track								:Image;
		private var thumb								:Image;

		private var currentPoint						:Point;
		private var thumbMinY							:Number;
		private var thumbMaxY							:Number;
		private var thumbMaxDiff						:Number;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function MasterVolumeVerticalScrollerView(parentContainer:Sprite, bounds:Rectangle, vo:MasterVolumeViewVO)
		{
			createScrollerImages(parentContainer, bounds, vo);
			currentPoint = new Point();
		}

		//==============================================================================================================
		// IRunnable IMPLEMENTATION
		//==============================================================================================================

		public function start():void
		{
			thumb.y = thumbMinY + (1 - SoundHelpers.getMasterVolume()) * thumbMaxDiff;
			thumb.addEventListener(TouchEvent.TOUCH, handleThumbTouch);
		}

		public function pause():void
		{
			thumb.removeEventListener(TouchEvent.TOUCH, handleThumbTouch);
		}

		public function resume():void
		{
			thumb.addEventListener(TouchEvent.TOUCH, handleThumbTouch);
		}

		public function dispose():void
		{
			if (thumb != null)
			{
				thumb.removeEventListener(TouchEvent.TOUCH, handleThumbTouch);
			}

			StarlingHelpers.removeFromParent(track);
			StarlingHelpers.removeFromParent(thumb);

			track = null;
			thumb = null;
			currentPoint = null;
		}

		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================

		private function handleThumbTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(thumb);
			if (touch != null)
			{
				switch (touch.phase)
				{
					case TouchPhase.BEGAN:
						currentPoint.y = touch.globalY;
						break;
					case TouchPhase.MOVED:
						var diff:Number = touch.globalY - currentPoint.y,
							valueToSend:Number;
						thumb.y = MathHelpers.clamp(thumb.y + diff, thumbMinY, thumbMaxY);
						valueToSend = 1 - ((thumb.y - thumbMinY) / thumbMaxDiff);
						currentPoint.y = touch.globalY;
						TestGameFacade.getInstance().sendNotification(VOLUME_CHANGED, valueToSend);
						break;
				}
			}
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		private function createScrollerImages(parentContainer:Sprite, bounds:Rectangle, vo:MasterVolumeViewVO):void
		{
			var bmpData:BitmapData = new BitmapData(100, 100, false, 0xFFFFFF),
				texture:Texture = Texture.fromBitmapData(bmpData, false);

			track = new Image(texture);
			track.scaleX = (bounds.width * 0.05) / bmpData.width;
			track.scaleY = (vo.getScrollHeight() * bounds.height) / bmpData.height;
			track.x = (bounds.width - track.width) >> 1;
			track.y = bounds.height * vo.getScrollY();
			track.color = 0xCCCCCC;
			parentContainer.addChild(track);

			thumb = new Image(texture);
			thumb.scaleX = (bounds.width >> 1) / bmpData.width;
			thumb.scaleY = (bounds.height * 0.1) / bmpData.height;
			thumb.x = (bounds.width - thumb.width) >> 1;
			thumb.y = bounds.height * vo.getScrollY();
			parentContainer.addChild(thumb);

			thumbMinY = thumb.y;
			thumbMaxY = bounds.height - thumb.height;
			thumbMaxDiff = thumbMaxY - thumbMinY;
		}
	}
}
