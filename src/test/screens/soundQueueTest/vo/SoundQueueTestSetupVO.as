package test.screens.soundQueueTest.vo
{
	public class SoundQueueTestSetupVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var setupID								:String;
		private var textID								:String;
		private var y									:Number;
		private var soundIDs							:Vector.<String>;
		private var channelID							:int;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function SoundQueueTestSetupVO(setupID:String, textID:String, y:Number, soundIDs:Vector.<String>, channelID:int)
		{
			this.setupID = setupID;
			this.textID = textID;
			this.y = y;
			this.soundIDs = soundIDs;
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

		public function getSoundIDs():Vector.<String>
		{
			return soundIDs;
		}

		public function getChannelID():int
		{
			return channelID;
		}
	}
}
