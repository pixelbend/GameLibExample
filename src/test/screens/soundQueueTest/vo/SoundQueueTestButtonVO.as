package test.screens.soundQueueTest.vo
{
	import test.screens.common.vo.IButtonDataVO;

	public class SoundQueueTestButtonVO implements IButtonDataVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var textID												:String;
		private var commandName											:String;
		private var sounds												:Vector.<String>;
		private var channelID											:int;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function SoundQueueTestButtonVO(textID:String, commandName:String, channelID:int, sounds:Array)
		{
			this.textID = textID;
			this.commandName = commandName;
			this.channelID = channelID;
			this.sounds = new Vector.<String>();
			for each (var soundName:String in sounds)
			{
				this.sounds.push(soundName);
			}
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getTextID():String
		{
			return textID;
		}

		public function getCommandName():String
		{
			return commandName;
		}

		public function getChannelID():int
		{
			return channelID;
		}

		public function getSounds():Vector.<String>
		{
			return sounds;
		}
	}
}
