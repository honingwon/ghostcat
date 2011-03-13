package ghostcat.game.layer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	
	import ghostcat.display.bitmap.IBitmapDataDrawer;
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;

	public class BitmapGameLayer extends GameLayerBase
	{
		public var screen:Bitmap;
		public function BitmapGameLayer(width:Number,height:Number)
		{
			super();
			
			this.isBitmapEngine = true;
			this.screen = new Bitmap(new BitmapData(width,height,false));
			this.addChild(this.screen);
		}
		
		
		protected override function tickHandler(event:TickEvent):void
		{
			super.tickHandler(event);
			
			this.screen.bitmapData.fillRect(this.screen.bitmapData.rect,0xFFFFFF);
			var l:int = childrenInScreen.length;
			for (var i:int = 0;i < l;i++)
			{
				var child:* = childrenInScreen[i];
				if (child is IBitmapDataDrawer)
					IBitmapDataDrawer(child).drawToBitmapData(this.screen.bitmapData,new Point());
			}
		}
		
	}
}