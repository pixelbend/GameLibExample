package test.screens.popupTest.view
{
	import com.pixelBender.model.vo.game.GameSizeVO;

	import starling.display.Image;

	import starling.display.Sprite;
	import starling.textures.Texture;

	import test.screens.popupTest.vo.PopupCustomizeViewVO;

	public class CheckBoxCustomizeView extends PopupCustomizeView
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var checkBoxImages										:Vector.<Image>;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function CheckBoxCustomizeView(localizationModule:String, parentContainer:Sprite, vo:PopupCustomizeViewVO,
											  	gameSize:GameSizeVO, checkBoxTextures:Vector.<Texture>)
		{
			super(localizationModule, parentContainer, vo, gameSize);
			checkBoxImages = new Vector.<Image>(checkBoxTextures.length, true);
			for (var i:int=0; i<checkBoxImages.length; i++)
			{
				checkBoxImages[i] = new Image(checkBoxTextures[i]);
				checkBoxImages[i].x = containerBounds.width >> 1;
				checkBoxImages[i].y = (containerBounds.height - checkBoxImages[i].height) >> 1;
			}
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function setState(value:Boolean):void
		{
			if (value)
			{
				checkBoxImages[0].removeFromParent();
				container.addChild(checkBoxImages[1]);
			}
			else
			{
				container.addChild(checkBoxImages[0]);
				checkBoxImages[1].removeFromParent();
			}
		}

		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================

		public override function dispose():void
		{
			if (checkBoxImages != null)
			{
				for (var i:int=0; i<checkBoxImages.length; i++)
				{
					checkBoxImages[i].removeFromParent(true);
					checkBoxImages[i] = null;
				}
				checkBoxImages = null;
			}
			super.dispose();
		}
	}
}
