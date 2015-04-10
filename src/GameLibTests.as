package
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.interfaces.IRunnable;

	import constants.Constants;
	import constants.Linkages;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;

	import starling.StarlingRootContainer;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	import test.facade.TestGameFacade;
	import test.globalView.GlobalView;

	[SWF(backgroundColor="0x888888")]
	public class GameLibTests extends Sprite implements IRunnable
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Reference to the game test.facade
		 */
		private var gameFacade																:TestGameFacade;

		/**
		 * Reference to Starling
		 */
		private var gameStarling															:Starling;

		CONFIG::debug
		{
			/**
			 * Debug view for a possible control of GameFacade core states: pause/resume/dispose
			 */
			private var debugView															:GlobalView;
		}

		//==============================================================================================================
		// EMBEDDED MEMBERS
		//==============================================================================================================

		[Embed(source="assets/generic/global/settings/logic.xml")]
		private const embeddedLogicXML														:Class;

		[Embed(source="assets/generic/global/settings/assets.xml")]
		private const embeddedAssetsXML														:Class;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function GameLibTests()
		{
			if (this.stage)
			{
				handleAddedToStage(null);
			}
			else
			{
				this.addEventListener(flash.events.Event.ADDED_TO_STAGE, handleAddedToStage, false, 0, true);
			}
		}

		//==============================================================================================================
		// IRunnable IMPLEMENTATION
		//==============================================================================================================

		public function start():void
		{
			if (gameFacade != null)
			{
				gameFacade.start();
			}
			if (gameStarling != null)
			{
				gameStarling.start();
			}
		}

		public function pause():void
		{
			if (gameFacade != null)
			{
				gameFacade.pause();
			}
			if (gameStarling != null)
			{
				gameStarling.stop();
			}
		}

		public function resume():void
		{
			if (gameFacade != null)
			{
				gameFacade.resume();
			}
			if (gameStarling != null)
			{
				gameStarling.start();
			}
		}

		public function dispose():void
		{
			if (stage != null)
			{
				stage.removeEventListener(flash.events.Event.RESIZE, handleStageResize);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeys);
			}
			CONFIG::mobile
			{
				NativeApplication.nativeApplication.removeEventListener(flash.events.Event.DEACTIVATE, handleDeactivate);
				NativeApplication.nativeApplication.removeEventListener(flash.events.Event.ACTIVATE, handleActivate);
			}
			if (gameFacade != null)
			{
				gameFacade.dispose();
				gameFacade = null;
			}
			if (debugView != null)
			{
				debugView.dispose();
				debugView = null;
			}
			if (gameStarling != null)
			{
				gameStarling.dispose();
				gameStarling = null;
			}
			System.gc();
		}

		public function testPause():void
		{
			if (gameFacade != null)
			{
				gameFacade.pause();
			}
		}

		public function testResume():void
		{
			if (gameFacade != null)
			{
				gameFacade.resume();
			}
		}

		public function testDispose():void
		{
			dispose();
			// Check the memory after app dispose
			addEventListener(flash.events.Event.ENTER_FRAME, handleFrameUpdate, false, 0, true);
		}

		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================

		private function handleAddedToStage(e:flash.events.Event):void
		{
			// Remove listener
			this.removeEventListener(flash.events.Event.ADDED_TO_STAGE, handleAddedToStage);
			init();
		}

		private function handleStageResize(e:flash.events.Event):void
		{
			Starling.current.viewPort = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			gameStarling.stage.stageWidth = stage.fullScreenWidth;
			gameStarling.stage.stageHeight = stage.fullScreenHeight;
			if (gameFacade != null)
			{
				gameFacade.handleGameResized(stage.fullScreenHeight/Constants.HEIGHT);
			}
		}

		private function handleDeactivate(event:flash.events.Event) : void
		{
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.handleKeys);
			CONFIG::mobile
			{
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
			}
			pause();
		}

		private function handleActivate(event:flash.events.Event) : void
		{
			resume();
			CONFIG::mobile
			{
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			}
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.handleKeys, false, 0, true);
		}

		private function handleKeys(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.HOME)
			{
				this.dispose();
				CONFIG::mobile
				{
					NativeApplication.nativeApplication.exit();
				}
			}
		}

		private function handleStarlingRootCreated(event:starling.events.Event):void
		{
			// Remove listener
			gameStarling.removeEventListener(starling.events.Event.ROOT_CREATED, handleStarlingRootCreated);
			// Stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			// Resize listener
			stage.addEventListener(flash.events.Event.RESIZE, handleStageResize, false, 0, true);
			// Facade
			initializeFacade();
			// Force resize on initial values
			handleStageResize(null);
		}

		private function handleGameReady():void
		{
			CONFIG::debug
			{
				// Global debug
				debugView = new GlobalView(this, StarlingRootContainer.instance, gameFacade.getApplicationSize());
			}
			// Start
			start();
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		private function init():void
		{
			// Starling
			Starling.handleLostContext = true;
			gameStarling = new Starling(StarlingRootContainer, stage, null, null, "auto", "auto");
			gameStarling.addEventListener(starling.events.Event.ROOT_CREATED, handleStarlingRootCreated);
			gameStarling.antiAliasing = 1;
			CONFIG::debug
			{
				gameStarling.showStatsAt(HAlign.RIGHT, VAlign.TOP, 2);
			}
			// Mobile stuff
			CONFIG::mobile
			{
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, handleDeactivate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, handleActivate, false, 0, true);
			}
			// Import linkages
			new Linkages();
		}

		private function initializeFacade():void
		{
			// Get test.facade
			gameFacade = TestGameFacade.getInstance() as TestGameFacade;
			// Initialize
			gameFacade.init(this, new XML(embeddedLogicXML.data), new XML(embeddedAssetsXML.data), handleGameReady,
								null, StarlingRootContainer.instance, null, Constants.LANGUAGE_ENGLISH);
			gameFacade.handleGameResized(stage.fullScreenHeight/Constants.HEIGHT);
			// Start loading assets. We will handle first screen load on our own
			gameFacade.sendNotification(GameConstants.LOAD_ASSET_QUEUE);
		}

		//==============================================================================================================
		// DEBUG ONLY
		//==============================================================================================================

		private var totalTime:int = 0;
		private var currentFrameTime:int = 0;
		public function handleFrameUpdate(e:flash.events.Event):void
		{
			var now:int = getTimer();
			totalTime += now - currentFrameTime;
			currentFrameTime = getTimer();
			if (totalTime >= 1000)
			{
				totalTime = 0;
				trace((System.totalMemory * 0.000000954).toFixed(3));
			}
		}
	}
}
