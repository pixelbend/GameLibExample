package test.screens.tweenTest.vo
{
	import com.pixelBender.model.vo.game.GameSizeVO;

	public class TweenTestSetupVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var y									:Number;
		private var properties							:Object;
		private var duration							:int;
		private var tweenNameTextID						:String;
		private var updated								:Boolean;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function TweenTestSetupVO(y:Number, properties:Object, duration:int, tweenNameTextID:String)
		{
			this.y = y;
			this.properties = properties;
			this.duration = duration;
			this.tweenNameTextID = tweenNameTextID;
			this.updated = false;
		}

		//==============================================================================================================
		// UPDATE
		//==============================================================================================================

		public function update(gameSize:GameSizeVO):void
		{
			if (updated) return;

			for (var propertyName:String in properties)
			{
				switch (propertyName)
				{
					case "x":
						properties.x *= gameSize.getWidth();
						break;
					case "y":
						properties.y *= gameSize.getHeight();
						break;
				}
			}
			updated = true;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getY():Number
		{
			return y;
		}

		public function getProperties():Object
		{
			return properties;
		}

		public function getDuration():int
		{
			return duration;
		}

		public function getTweenNameTextID():String
		{
			return tweenNameTextID;
		}
	}
}
