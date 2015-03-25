package test.screens.soundTest.vo
{
	import constants.Constants;

	import test.screens.common.vo.IButtonDataVO;

	public class SoundTestButtonDataVO implements IButtonDataVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var textID										:String;
		private var noteName									:String;
		private var noteType									:String;
		private var soundName									:String;
		private var channelID									:int;
		private var priority									:int;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function SoundTestButtonDataVO(textID:String, noteName:String, noteType:String, soundName:String,
											  	channelID:int, priority:int)
		{
			this.textID = textID;
			this.noteName = noteName;
			this.noteType = noteType;
			this.soundName = soundName;
			this.channelID = channelID;
			this.priority = priority;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getTextID():String
		{
			return textID;
		}

		public function getNoteName():String
		{
			return noteName;
		}

		public function getNoteType():String
		{
			return noteType;
		}

		public function getSoundName():String
		{
			return soundName;
		}

		public function getChannelID():int
		{
			return channelID;
		}

		public function getPriority():int
		{
			return priority;
		}

		public function getButtonGraphics():String
		{
			return Constants.SIMPLE_BUTTON_GRAPHICS;
		}
	}
}
