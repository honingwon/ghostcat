package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import ghostcat.algorithm.astar.AStar;
	import ghostcat.algorithm.astar.MapModel;
	import ghostcat.manager.RootManager;
	import ghostcat.parse.DisplayParse;
	import ghostcat.parse.graphics.GraphicsFill;
	import ghostcat.parse.graphics.GraphicsRect;
	import ghostcat.ui.PopupManager;
	import ghostcat.ui.containers.GAlert;
	
	/**
	 * A* 算法演示
	 * 
	 * 这个只实现了算法，并没有专门去选择速度快的类型，也没有刻意减少函数嵌套，因此它的效率很一般。
	 * 但算法本身并没有问题，可以考虑将其解封装，选择数组而不是对象来进行运算，应该能够增加不少速度。
	 * 
	 * 当然，满足需求的话，就不需要了。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	
	[SWF(width="500",height="500")]
	public class AStarExample extends Sprite
	{
		private const MAP_WIDTH : int = 100;
		private const MAP_HEIGHT : int = 100;
		
		private var player : Sprite;
		private var map : Array;
		
		private var aStar : AStar;
		private var mapModel : MapModel;
		
		private var path : Array;
		
		public function AStarExample()
		{
			RootManager.register(this,1,1);
			
			this.mapModel = new MapModel();
			this.reset();
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(Event.ENTER_FRAME, enterframeHandler);
		}
		
		private function reset() : void
		{
			this.map = [];
			
			for (var j : int = 0; j < MAP_HEIGHT; j++)
			{
				map[j] = [];
				for (var i : int = 0; i < MAP_WIDTH; i++)
				{
					var isBlock : Boolean = Math.random() < 0.3;
					map[j][i] = isBlock;
					
					var tile : Sprite = DisplayParse.createSprite([new GraphicsFill(isBlock ? 0x000000 : 0xFFFFFF),new GraphicsRect(0,0,10,10)]);
					addChild(tile);
					tile.x = i * 5;
					tile.y = j * 5;
				}
			}
			player = DisplayParse.createSprite([new GraphicsFill(0xFF0000),new GraphicsRect(0,0,5,5)])
			addChild(player);
			
			this.mapModel.map = this.map;//创建地图数据
			this.aStar = new AStar(this.mapModel);//根据数据生成A*类
		}
		
		private function clickHandler(event : MouseEvent) : void
		{
			var findPiont : Point = new Point(int(this.mouseX/5), int(this.mouseY/5));
			var playerPoint : Point = new Point(int(this.player.x/5), int(this.player.y/5));
			
			var t:int = getTimer();
			this.path = this.aStar.find(playerPoint, findPiont);//获得行走路径
			
			if (this.path == null || this.path.length == 0)
				GAlert.show("无法到达")
			else
				GAlert.show("本次用时:"+ (getTimer() - t)+"ms")
		}
		
		private function enterframeHandler(event : Event) : void
		{
			if (this.path == null || this.path.length == 0)
				return;
			
			var note:Point = this.path.shift() as Point;
			this.player.x = note.x * 5;
			this.player.y = note.y * 5;
		}
	}
}