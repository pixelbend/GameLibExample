package test.screens.intro
{
	import com.pixelBender.helpers.ScreenHelpers;
	import com.pixelBender.interfaces.IFrameUpdate;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.update.FrameUpdateManager;

	import constants.Constants;

	import flash.display.Bitmap;

	import flash.display.BitmapData;
	import flash.geom.Vector3D;

	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Sprite3D;

	import test.screens.common.screen.AbstractScreen;
	import test.screens.intro.vo.IntroButtonDataVO;

	public class IntroScreen extends AbstractScreen //implements IFrameUpdate
	{
		//==============================================================================================================
		// EMBEDDED MEMBERS
		//==============================================================================================================

		[Embed(source="../../../assets/generic/screens/intro/settings/logic.xml")]
		private const logicXML														:Class;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function IntroScreen(mediatorName:String)
		{
			super(mediatorName);
		}
		
		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================
		
		override public function prepareForStart(starlingScreenContainer:DisplayObjectContainer,
												 	gameScreenProxy:GameScreenProxy):void
		{
			super.prepareForStart(starlingScreenContainer, gameScreenProxy);
			sendReadyToStart();
			/*
			cardHolder = new Sprite3D();
			cardHolder.x = gameFacade.getApplicationSize().getWidth()/2;
			cardHolder.y = gameFacade.getApplicationSize().getHeight()/2;

			cards = new Vector.<Sprite3D>();
			cards[0] = createCard();
			cards[1] = createCard();
			cards[2] = createCard();


			cards[0].x = -300;
			cards[2].x = 300;

			starlingScreenContainer.addChild(cardHolder);
			FrameUpdateManager.getInstance().registerForUpdate(this);
			*/
		}

		/*
		private function createCard():Sprite3D
		{
			var card:Sprite3D = new Sprite3D();

			var source:BitmapData = new BitmapData(100, 100, false, 0xFF0000);
			var image:Image = Image.fromBitmap(new Bitmap(source), false);
			var cardBack:Sprite = new Sprite();
			cardBack.addChild(image);
			cardBack.alignPivot();
			cardBack.scaleX = -1;
			card.addChild(cardBack);

			source.fillRect(source.rect, 0x00FF00);
			image = Image.fromBitmap(new Bitmap(source), false);
			var cardFront:Sprite = new Sprite();
			cardFront.addChild(image);
			cardFront.alignPivot();
			card.addChild(cardFront);

			cardHolder.addChild(card);

			return card;
		}

		private var cardHolder:Sprite3D;
		private var cards:Vector.<Sprite3D>;
		private var helperPoint:Vector3D = new Vector3D();

		public function frameUpdate(dt:int):void
		{
			for (var i:int = 0; i<cards.length; i++)
			{
				var card:Sprite3D = cards[i];
				var cardFront:Sprite = card.getChildAt(1) as Sprite;
				var cardBack:Sprite = card.getChildAt(0) as Sprite;


				card.rotationY += .01;
				card.stage.getCameraPosition(card, helperPoint);

				cardFront.visible = helperPoint.z <  0;
				cardBack.visible  = helperPoint.z >= 0;
			}
		}
		*/

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		override protected function getScreenAssetXML():XML { return null; }
		override protected function getScreenLogicXML():XML { return new XML(logicXML.data); }
		override protected function createGameScreenProxy():GameScreenProxy
		{
			return new IntroScreenProxy(getGameScreenProxyName(), mediatorName, getScreenLogicXML(), getScreenAssetXML());
		}

		//==============================================================================================================
		// NOTIFICATION HANDLERS
		//==============================================================================================================

		protected override function handleTestButtonTriggered(testButtonData:Object):void
		{
			var data:IntroButtonDataVO = testButtonData as IntroButtonDataVO;
			ScreenHelpers.showScreen(data.getScreenName(), Constants.TRANSITION_SEQUENCE_NAME);
		}
	}
}