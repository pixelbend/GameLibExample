package
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.helpers.MovieClipHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IRunnable;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import constants.Constants;
	import constants.Linkages;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import starling.StarlingRootContainer;
	import starling.core.Starling;
	import starling.events.Event;
	import stats.Stats;
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
			 * The FPS/memory minimal statistics
			 */
			private var debugStats															:Stats;

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
			}
			IRunnableHelpers.dispose([gameStarling, gameFacade]);

			gameStarling = null;
			gameFacade = null;
			CONFIG::debug
			{
				if (debugView != null)
				{
					debugView.dispose();
					debugView = null;
				}
				MovieClipHelpers.removeFromParent(debugStats);
				debugStats = null;
			}
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
			if (gameFacade != null)
			{
				gameFacade.dispose();
				gameFacade = null;
			}
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		private function handleAddedToStage(e:flash.events.Event):void
		{
			// Remove listener
			this.removeEventListener(flash.events.Event.ADDED_TO_STAGE, handleAddedToStage);
			init();
		}

		private function handleStageResize(e:flash.events.Event):void
		{
			// Update starling viewport
			Starling.current.viewPort = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			// Update starling stage as well
			gameStarling.stage.stageWidth = stage.fullScreenWidth;
			gameStarling.stage.stageHeight = stage.fullScreenHeight;
			// Update debug state position
			CONFIG::debug
			{
				if (debugStats != null)
				{
					debugStats.x = stage.fullScreenWidth - debugStats.width;
				}
			}
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
			CONFIG::debug
			{
				//gameStarling.showStatsAt(HAlign.RIGHT, VAlign.TOP, gameFacade.getApplicationSize().getScale() * 1.5);
				// Stats
				var gameSize:GameSizeVO = gameFacade.getApplicationSize();
				debugStats = new Stats();
				debugStats.scaleX = debugStats.scaleY = gameSize.getScale() * 2;
				addChild(debugStats);
				debugStats.x = gameSize.getWidth() - debugStats.width;
			}
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
			// Mobile stuff
			CONFIG::mobile
			{
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
				this.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
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
	}
}
