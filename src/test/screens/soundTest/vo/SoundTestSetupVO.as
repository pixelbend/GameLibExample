package test.screens.soundTest.vo
{
	public class SoundTestSetupVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var setupID								:String;
		private var textID								:String;
		private var y									:Number;
		private var soundID								:String;
		private var channelID							:int;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function SoundTestSetupVO(setupID:String, textID:String, y:Number, soundID:String, channelID:int)
		{
			this.setupID = setupID;
			this.textID = textID;
			this.y = y;
			this.soundID = soundID;
			this.channelID = channelID;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getSetupID():String
		{
			return setupID;
		}

		public function getTextID():String
		{
			return textID;
		}

		public function getY():Number
		{
			return y;
		}

		public function getSoundID():String
		{
			return soundID;
		}

		public function getChannelID():int
		{
			return channelID;
		}
	}
}
