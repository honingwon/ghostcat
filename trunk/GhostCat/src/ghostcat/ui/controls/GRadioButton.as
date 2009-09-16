package ghostcat.ui.controls
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ghostcat.util.ClassFactory;
	
	/**
	 * 单选框
	 * 
	 * @author flashyiyi
	 *  
	 */
	public class GRadioButton extends GButton
	{
		[Embed(skinClass="ghostcat.skin.RadioButtonIconSkin")]
		private static const CursorGroupClass:Class;//这里不直接导入CursorGroup而用Embed中转只是为了正常生成ASDoc
		public static var defaultSkin:ClassFactory = new ClassFactory(CursorGroupClass);
		
		private var _groupName:String;
		
		/**
		 * 值
		 */
		public var value:*;
		
		public function GRadioButton(skin:*=null, replace:Boolean=true, textPos:Point=null)
		{
			if (!skin)
				skin = defaultSkin;
			
			if (!textPos)
				this.textPos = new Point(15,0);
			
			super(skin, replace);
		}
		
		/**
		 * 所属的组
		 */
		public function get groupName():String
		{
			return _groupName;
		}

		public function set groupName(v:String):void
		{
			_groupName = v;
			var g:GRadioButtonGroup = GRadioButtonGroup.getGroupByName(v);
			g.addItem(this);
		}

		public override function set selected(v:Boolean) : void
		{
			if (super.selected == v)
				return;
			
			super.selected = v;
			
			if (groupName && v)
			{
				var g:GRadioButtonGroup = GRadioButtonGroup.getGroupByName(groupName);
				g.selectedItem = this;
			}
		} 
		
		protected override function clickHandler(event:MouseEvent):void
		{
			super.clickHandler(event);
			
			this.selected = true;
		}
		
		public override function destory():void
		{
			if (groupName)
			{
				var g:GRadioButtonGroup = GRadioButtonGroup.getGroupByName(groupName);
				g.removeItem(this);
			}
		}
	}
}