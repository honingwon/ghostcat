package ghostcat.util.code
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.util.display.SearchUtil;

	public final class UICreater
	{
		public static function createBySkin(v:DisplayObject,classPath:String,skinName:String = "content"):String
		{
			var vars:String = "";
			var creates:String = "";
			var objs:Array = SearchUtil.findChildrenByClass(v,InteractiveObject);
			var importDict:Object = {"flash.display.Sprite":null};
			
			for each (var child:InteractiveObject in objs)
			{
				if (child.name && child.name.slice(0,8) != "instance")
				{
					var className:String = getQualifiedClassName(child);
					var index:int = className.indexOf("::");
					if (index != -1)
					{
						className = className.replace("::",".");
						importDict[className] = null;
						className = className.slice(index + 1);
					}
					
					vars += "public var " + child.name + ":" + className + ";"
					creates += "this." + child.name + " = " + skinName;
					var path:String = "[\"" + child.name + "\"]";
					while (child.parent != v)
					{
						child = child.parent;
						path = "[\"" + child.name + "\"]" + path;
					}
					creates += path + " as " + className + ";";
				}
			}
			var result:String = CodeCreater.pack(classPath,vars + "public function " + CodeCreater.getClassName(classPath) + "("+ skinName + ":Sprite){" + creates + "}",importDict);
			return CodeCreater.format(result);
		}
	}
}