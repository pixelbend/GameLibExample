package test.screens.tweenTest.view
{
	import com.pixelBender.helpers.IDisposeHelpers;
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.helpers.TweenHelpers;
	import com.pixelBender.interfaces.IRunnable;
	import com.pixelBender.model.vo.game.GameSizeVO;

	import constants.Constants;

	import flash.utils.Dictionary;

	import org.puremvc.as3.interfaces.INotification;

	import org.puremvc.as3.patterns.mediator.Mediator;

	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;

	import test.screens.common.view.TestButtonView;

	import test.screens.common.vo.TestTitleLayoutVO;

	import test.screens.common.vo.TestButtonLayoutVO;
	import test.screens.common.vo.TestButtonVO;
	import test.screens.tweenTest.vo.TweenTestSetupVO;

	public class TweenTestViewMediator extends Mediator implements IRunnable
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		protected static const MEDIATOR_NAME						:String = "TweenTestViewMediator";

		protected static const ACTION_PLAY							:String = "play";
		protected static const ACTION_PAUSE							:String = "pause";
		protected static const ACTION_STOP							:String = "stop";
		protected static const ACTION_RESET							:String = "reset";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var container										:Sprite;
		private var tweenName										:TextField;
		private var buttons											:Dictionary;
		private var tweenTarget										:Object;
		private var tweenProperties									:Object;
		private var initialProperties								:Object;
		private var tweenDuration									:int;
		private var currentTweenID									:int;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function TweenTestViewMediator(parentMediatorName:String, parentContainer:Sprite, gameSize:GameSizeVO,
											  	titleLayout:TestTitleLayoutVO, buttonLayout:TestButtonLayoutVO,
													setup:TweenTestSetupVO, buttonTexturesMap:Dictionary, tweenTarget:Object)
		{
			super(parentMediatorName + MEDIATOR_NAME + setup.getTweenNameTextID());

			this.tweenTarget = tweenTarget;
			this.tweenProperties = setup.getProperties();
			this.tweenDuration = setup.getDuration();

			initialProperties = {};
			for (var propertyName:String in tweenProperties)
			{
				initialProperties[propertyName] = tweenTarget[propertyName];
			}

			createContainer(parentContainer, setup, gameSize);
			createTweenName(parentMediatorName, titleLayout, setup, gameSize);
			createButtons(buttonLayout, buttonTexturesMap, gameSize);

			enableButtons(ACTION_PLAY);

			currentTweenID = -1;
		}

		//==============================================================================================================
		// Mediator API
		//==============================================================================================================

		public override function listNotificationInterests():Array
		{
			return [mediatorName + TestButtonView.BUTTON_TRIGGERED];
		}

		public override function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case mediatorName + TestButtonView.BUTTON_TRIGGERED:
					handleTweenAction(String(notification.getBody()));
					break;
			}
		}

		//==============================================================================================================
		// IRunnable IMPLEMENTATION
		//==============================================================================================================

		public function start():void
		{
			IRunnableHelpers.start(buttons);
		}

		public function pause():void
		{
			IRunnableHelpers.pause(buttons);
		}

		public function resume():void
		{
			IRunnableHelpers.resume(buttons);
		}

		public function dispose():void
		{
			StarlingHelpers.removeFromParent(container);
			container = null;

			StarlingHelpers.removeFromParent(tweenName);
			tweenName = null;

			IDisposeHelpers.dispose(buttons);
			buttons = null;

			tweenTarget = null;
			tweenProperties = null;
			initialProperties = null;
		}

		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================

		private function handleTweenAction(actionID:String):void
		{
			switch(actionID)
			{
				case ACTION_PLAY:
					playTween();
					break;
				case ACTION_PAUSE:
					pauseTween();
					break;
				case ACTION_STOP:
					stopTween();
					break;
				case ACTION_RESET:
					resetProperties();
					break;
			}
		}

		private function handleTweenEnded(tweenID:int):void
		{
			stopTween();
		}

		private function playTween():void
		{
			if (getIsTweenActive())
			{
				TweenHelpers.resumeTween(currentTweenID);
			}
			else
			{
				resetProperties();
				currentTweenID = TweenHelpers.tween(tweenTarget, tweenDuration, tweenProperties, handleTweenEnded);
			}
			enableButtons(ACTION_PAUSE, ACTION_STOP);
		}

		private function pauseTween():void
		{
			if (getIsTweenActive())
			{
				TweenHelpers.pauseTween(currentTweenID);
				enableButtons(ACTION_PLAY, ACTION_STOP);
			}
		}

		private function stopTween():void
		{
			if (getIsTweenActive())
			{
				TweenHelpers.removeTween(currentTweenID);
				currentTweenID = -1;
				enableButtons(ACTION_PLAY, ACTION_RESET);
			}
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		private function getIsTweenActive():Boolean
		{
			return currentTweenID >= 0;
		}

		private function resetProperties():void
		{
			for (var propertyName:String in initialProperties)
			{
				tweenTarget[propertyName] = initialProperties[propertyName];
			}
			enableButtons(ACTION_PLAY);
		}

		private function enableButtons(...buttonsToEnable):void
		{
			for (var buttonID:String in buttons)
			{
				if (buttonsToEnable.indexOf(buttonID) >= 0)
				{
					buttons[buttonID].enable();
				}
				else
				{
					buttons[buttonID].disable();
				}
			}
		}

		private function createContainer(parentContainer:Sprite, setup:TweenTestSetupVO, gameSize:GameSizeVO):void
		{
			container = new Sprite();
			parentContainer.addChild(container);
			container.y = gameSize.getHeight() * setup.getY();
		}

		private function createTweenName(parentMediatorName:String, titleLayout:TestTitleLayoutVO, setup:TweenTestSetupVO, gameSize:GameSizeVO):void
		{
			var tfHeight:int = gameSize.getHeight() * titleLayout.getTextHeight();
			tweenName = new TextField(gameSize.getWidth() * titleLayout.getTextWidth(), gameSize.getHeight() * titleLayout.getTextHeight(),
										LocalizationHelpers.getLocalizedText(parentMediatorName, setup.getTweenNameTextID()),
										Constants.APPLICATION_FONT_BOLD, tfHeight * 0.25, 0xFFFFFF, true);
			tweenName.x = gameSize.getWidth() * titleLayout.getX();
			container.addChild(tweenName);
		}

		private function createButtons(buttonLayout:TestButtonLayoutVO, buttonTexturesMap:Dictionary, gameSize:GameSizeVO):void
		{
			var buttonVOs:Vector.<TestButtonVO> = buttonLayout.getButtons(),
				buttonID:String,
				buttonView:TestButtonView,
				buttonTexturesTriplet:Vector.<Texture>;

			buttons = new Dictionary();
			for (var i:int=0; i<buttonVOs.length; i++)
			{
				buttonID = buttonVOs[i].getButtonID();
				buttonTexturesTriplet = buttonTexturesMap[buttonID];
				buttonView = new TestButtonView(mediatorName, buttonID);
				buttonView.createButton(container, buttonTexturesTriplet[0], buttonTexturesTriplet[1], gameSize.getWidth() * buttonVOs[i].getX(), 0);
				buttons[buttonID] = buttonView;
			}
		}
	}
}
