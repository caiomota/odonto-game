package
{
	import com.nakand.core.BaseItem;
	import com.nakand.core.BaseModal;
	import com.nakand.core.BaseScene;
	import com.nakand.core.BaseTake;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[SWF(width=1024, height=600, backgroundColor='#000000', frameRate=30)]
	
	public class OdontoGame extends Sprite
	{
		public function OdontoGame()
		{
			var mainXML:XML;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.load(new URLRequest("../script.xml"));
			
			function onComplete(evt:Event) : void
			{

				mainXML = new XML(loader.data)
				var first_scene_node:XML = mainXML..scene[0];
				var first_scene:BaseScene = new BaseScene();

				first_scene.id 				= first_scene_node.attribute('id');
				first_scene.sound 			= first_scene_node.attribute('sound_path');
				first_scene.badScene 		= first_scene_node.attribute('bad') || null;
				first_scene.regularScene	= first_scene_node.attribute('regular');
				first_scene.goodScene 		= first_scene_node.attribute('good') || null;
				
				var takes:Array = new Array();
				for each (var take:XML in first_scene_node.take ) {
					trace('loop take');
					var base_take:BaseTake = new BaseTake();
					base_take.id 		= take.attribute('id');
					base_take.image 	= take.attribute('image_path');
					base_take.sound 	= take.attribute('sound_path');
					
					var modals:Array = new Array();
					for each (var modal:XML in take.modal) {
						trace('loop modal');
						var base_modal:BaseModal = new BaseModal();
						base_modal.id 		= modal.attribute('id');
						base_modal.sound	= modal.attribute('sound_path');
						base_modal.type		= modal.attribute('type');
						
						var items:Array = new Array();
						for each (var item:XML in modal.item) {
							trace('loop item');
							var base_item:BaseItem = new BaseItem();
							base_item.image 	= item.attribute('image_path');
							base_item.sound		= item.attribute('sound_path');
							base_item.label		= item.attribute('label');
							base_item.option 	= item.attribute('option');
							base_item.points	= item.attribute('points');
							items.push(base_item);
						}
						base_modal.items = items;
						modals.push(base_modal);
					}
					base_take.modals = modals;
					takes.push(base_take);
				}
				trace(takes);
				first_scene.takes = takes;
				
				addChild(first_scene);
				
				first_scene.playIt();
			}

		}
	}
}