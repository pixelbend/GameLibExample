package test.screens.tweenTest.vo
{
	import com.pixelBender.model.vo.game.GameSizeVO;

	import constants.Constants;

	import test.screens.common.vo.IButtonDataVO;

	public class TweenTestButtonVO implements IButtonDataVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var textID												:String;
		private var commandName											:String;
		private var tweenName											:String;
		private var buttonGraphics										:String;
		private var duration											:int;
		private var tweenProperties										:Object;
		private var needsUpdating										:Boolean;

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		public function TweenTestButtonVO(textID:String, commandName:String, tweenName:String, buttonGraphics:String,
										  	duration:int, tweenProperties:Object, needsUpdating:Boolean)
		{
			this.textID = textID;
			this.commandName = commandName;
			this.tweenName = tweenName;
			this.buttonGraphics = (buttonGraphics.length > 0) ? buttonGraphics: Constants.SIMPLE_BUTTON_GRAPHICS;
			this.duration = duration;
			this.tweenProperties = tweenProperties;
			this.needsUpdating = needsUpdating;
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function update(gameSize:GameSizeVO):void
		{
			for (var propertyName:String in tweenProperties)
			{
				switch(propertyName)
				{
					case "x":
						tweenProperties[propertyName] *= gameSize.getWidth();
						break;
					case "y":
						tweenProperties[propertyName] *= gameSize.getHeight();
						break;
				}
			}
			needsUpdating = false;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getTextID():String
		{
			return textID;
		}

		public function getButtonGraphics():String
		{
			return buttonGraphics;
		}

		public function getCommandName():String
		{
			return commandName;
		}

		public function getTweenName():String
		{
			return tweenName;
		}

		public function getDuration():int
		{
			return duration;
		}

		public function getTweenProperties():Object
		{
			return tweenProperties;
		}

		public function getNeedsUpdating():Boolean
		{
			return needsUpdating;
		}
	}
}
