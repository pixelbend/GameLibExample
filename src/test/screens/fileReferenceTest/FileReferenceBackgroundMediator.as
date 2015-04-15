package test.screens.fileReferenceTest
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.controller.fileReference.vo.RetrieveFileReferenceContentNotificationVO;
	import com.pixelBender.helpers.FileReferenceHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IDispose;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import constants.Constants;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.JPEGEncoderOptions;
	import flash.display.PNGEncoderOptions;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import starling.display.Sprite;
	import starling.text.TextField;

	public class FileReferenceBackgroundMediator extends Mediator implements IDispose
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const BACKGROUND_MEDIATOR_NAME		:String = "backgroundMediator";
		public static const BACKGROUND_CREATED				:String = "backgroundCreated";
		public static const FILE_NAME						:String = "background";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Reference to the parent screen name
		 */
		private var screenName								:String;

		/**
		 * Screen container
		 */
		private var screen									:Sprite;

		/**
		 * Created background
		 */
		private var background								:Sprite;

		/**
		 * The debug output
		 */
		private var debugText								:TextField;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function FileReferenceBackgroundMediator(screenName:String, screen:Sprite)
		{
			super(screenName + BACKGROUND_MEDIATOR_NAME);
			this.screenName = screenName;
			this.screen = screen;
		}

		//==============================================================================================================
		//
		//==============================================================================================================

		public function initialize(gameSize:GameSizeVO, vectorBackground:IBitmapDrawable):Boolean
		{
			// Internals
			var byteArray:ByteArray = new ByteArray(),
				time:int = getTimer();
			// Debug text
			debugText = new TextField(gameSize.getWidth(), (gameSize.getHeight() * 0.25), "", "Verdana", 20, 0xFFFFFF);
			debugText.y = gameSize.getHeight() - debugText.height;
			screen.addChild(debugText);
			// Check if we already have a image saved to storage
			if (!FileReferenceHelpers.retrieveFileReferenceExists(mediatorName, FILE_NAME))
			{
				var newTime:int,
					matrix:Matrix = new Matrix(),
					bitmapData:BitmapData;
				// Draw bitmap out of background
				var tempTime:int = getTimer();
				bitmapData = new BitmapData(gameSize.getWidth(), gameSize.getHeight(), true, 0x00000000);
				matrix.scale(gameSize.getScale(), gameSize.getScale());
				matrix.translate(((gameSize.getWidth() - Constants.WIDTH * gameSize.getScale()) >> 1), 0);
				bitmapData.draw(vectorBackground, matrix, null, null, null, true);
				// Create background
				background = StarlingHelpers.createTextureSpriteBackground(bitmapData, bitmapData.width, bitmapData.height);
				screen.addChildAt(background, 0);
				Logger.debug("Normal vector draw + creating textures took:" + (getTimer()-tempTime));
				// Save to file
				bitmapData.encode(bitmapData.rect, new PNGEncoderOptions(true), byteArray);
				FileReferenceHelpers.addFileReference(mediatorName, FILE_NAME, byteArray,
														GameConstants.ASSET_FILE_REFERENCE_TYPE_IMAGE, new Bitmap(bitmapData));
				newTime = getTimer();
				Logger.debug("Saving file to disk. Time:", (newTime - time));
				debugText.text = "Background was not in file system. Will be transformed in Bitmap from vector form and saved to file disk. " +
									"The entire process took:" + (newTime - time) + "ms";
				// Done
				return true;
			}
			else
			{
				var content:Bitmap = FileReferenceHelpers.retrieveFileReferenceContent(mediatorName, FILE_NAME) as Bitmap;
				if (content != null)
				{
					var contentData:BitmapData = content.bitmapData;
					background = StarlingHelpers.createTextureSpriteBackground(contentData, contentData.width, contentData.height);
					screen.addChildAt(background, 0);
					newTime = getTimer();
					// Debug
					Logger.debug("Background bitmap data found in cache. Texture creation took:", (newTime - time));
					debugText.text = "Background Bitmap already in cache. Creating a texture out of it took:" + (newTime - time) + "ms";
					return true;
				}
				else
				{
					FileReferenceHelpers.loadFileReference(mediatorName, FILE_NAME);
					return false;
				}
			}
		}

		//==============================================================================================================
		// IMediator OVERRIDES
		//==============================================================================================================

		override public function listNotificationInterests():Array
		{
			return [GameConstants.FILE_REFERENCE_LOADED];
		}

		override public function handleNotification(notification:INotification):void
		{
			// Switch note
			switch(notification.getName() )
			{
				case GameConstants.FILE_REFERENCE_LOADED:
					var note:RetrieveFileReferenceContentNotificationVO = notification.getBody() as RetrieveFileReferenceContentNotificationVO;
					// Check this is our background
					if (note.getGroupName() == mediatorName && note.getFileName() == FILE_NAME)
					{
						handleBackgroundLoaded(note.getFileContents() as Bitmap);
					}
					break;
			}
		}

		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================

		public function dispose():void
		{
			StarlingHelpers.disposeContainer(debugText, true);
			debugText = null;
			StarlingHelpers.disposeTextureSprite(background);
			background = null;
			screenName = null;
			screen = null;
		}

		//==============================================================================================================
		// NOTIFICATION HANDLERS
		//==============================================================================================================

		private function handleBackgroundLoaded(backgroundBitmap:Bitmap):void
		{
			// Internals
			var time:int,
				newTime:int,
				decodedBitmapData:BitmapData = backgroundBitmap.bitmapData;
			// Add image to starling container
			time = getTimer();
			background = StarlingHelpers.createTextureSpriteBackground(decodedBitmapData, decodedBitmapData.width, decodedBitmapData.height);
			screen.addChildAt(background, 0);
			newTime = getTimer();
			// Debug
			Logger.debug("Background loaded from disk. Texture creation took:", (newTime - time) );
			debugText.text = "Background Bitmap in file contents. The bitmapData was loaded. Creating a texture out of it took:" + (newTime - time) + "ms";
			// Notify the game screen it's background is ready
			sendNotification(BACKGROUND_CREATED, screenName);
		}
	}
}
