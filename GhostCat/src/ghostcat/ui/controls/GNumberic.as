package ghostcat.ui.controls
{
	import flash.events.Event;
	
	import ghostcat.text.NumberUtil;
	import ghostcat.ui.layout.Padding;
	import ghostcat.util.easing.Circ;
	import ghostcat.util.easing.TweenUtil;
	
	/**
	 * 数值显示
	 * 
	 * 标签规则：和文本框相同
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GNumberic extends GText
	{
		/**
		 * 转换文字函数
		 */
		public var textFunction:Function;
		
		/**
		 * 缓动时间
		 */
		public var duration:int=1000;
		
		/**
		 * 附加在数字前的文字
		 * @return 
		 * 
		 */
		public var prefix:String = "";
		
		/**
		 * 附加在数字后的文字
		 * @return 
		 * 
		 */
		public var suffix:String = "";
		
		/**
		 * 缓动函数
		 */
		public var easing:Function = Circ.easeOut;
		
		/**
		 * 小数点位数
		 */
		public var fix:int = 0;
		
		public function GNumberic(skin:*=null, replace:Boolean=true, separateTextField:Boolean=false, textPadding:Padding=null)
		{
			super(skin, replace, separateTextField, textPadding);
		}
		
		/**
		 * 增加值 
		 * @param v
		 * @param tween
		 * 
		 */
		public function addValue(v : Number, tween:Boolean = true):void
		{
			setValue(data + v,tween);
		}
		
		/**
		 * 设置数值
		 * 
		 * @param v
		 * @param tween	是否缓动
		 * 
		 */
		public function setValue(v : Number, tween:Boolean = true):void
		{
			_data = v;
			
			if (_data && tween)
			{
				TweenUtil.removeTween(this,false);
				TweenUtil.to(this,duration,{displayValue:v,ease:easing,onComplete:tweenCompleteHandler})
			}
			else
			{
				tweenCompleteHandler();
			}
		
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function tweenCompleteHandler():void
		{
			displayValue = Number(_data);
		}
		
		/**
		 * 获得数据
		 * 
		 * @return 
		 * 
		 */
		public function getValue():*
		{
			return data;
		}
		/** @inheritDoc*/
		public override function set data(v : *):void
		{
			setValue(v);
		}
		
		public override function get data():*
		{
			return Number(_data);
		}
		
		private var _displayValue:Number;
		/** @inheritDoc*/
		public function get displayValue():Number
		{
			return _displayValue;
		}
		
		public function set displayValue(v:Number):void
		{
			_displayValue = v;
			
			if (textField)
			{
				if (textFunction!=null)
					textField.text = textFunction(v);
				else
					textField.text = prefix + (fix == 0) ? int(v).toString() : v.toFixed(fix) + suffix;
			}
			
			adjustContextSize();
			
			if (asTextBitmap)
				reRenderTextBitmap();
		}
	}
}