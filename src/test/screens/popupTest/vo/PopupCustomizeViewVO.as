package test.screens.popupTest.vo
{
	import test.screens.common.vo.ViewVO;

	public class PopupCustomizeViewVO extends ViewVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var ID											:String;
		private var viewType									:String;
		private var textID										:String;
		private var noteType									:String;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function PopupCustomizeViewVO(x:Number, y:Number, width:Number, height:Number, ID:String, viewType:String,
											 textID:String, noteType:String)
		{
			super(x, y, width, height);
			this.ID = ID;
			this.viewType = viewType;
			this.textID = textID;
			this.noteType = noteType;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getID():String
		{
			return ID;
		}

		public function getViewType():String
		{
			return viewType;
		}

		public function getTextID():String
		{
			return textID;
		}

		public function getNoteType():String
		{
			return noteType;
		}
	}
}
